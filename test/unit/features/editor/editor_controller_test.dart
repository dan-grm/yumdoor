import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/image_upload.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/stored_draft.dart';
import 'package:yumdoor/domain/repositories/draft_store.dart';
import 'package:yumdoor/domain/services/recipe_draft_validation.dart';
import 'package:yumdoor/features/editor/editor_controller.dart';

import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/fake_draft_store.dart';
import '../../../fakes/fake_ingredient_parser.dart';
import '../../../fakes/fake_recipe_repository.dart';
import '../../../fixtures/recipes.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeConnectivityService connectivity;
  late FakeDraftStore drafts;
  late FakeIngredientParser parser;
  late ProviderContainer container;

  ProviderContainer containerWith(FakeRecipeRepository recipes) {
    final container = ProviderContainer(
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        connectivityServiceProvider.overrideWithValue(connectivity),
        draftStoreProvider.overrideWithValue(drafts),
        ingredientParserProvider.overrideWithValue(parser),
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 16, 18, 30)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    connectivity = FakeConnectivityService();
    drafts = FakeDraftStore();
    parser = FakeIngredientParser({
      '200 g Karotten': const ParsedIngredient(
        originalText: '200 g Karotten',
        food: NamedRef(id: 1, name: 'Karotte'),
        unit: NamedRef(id: 9, name: 'g'),
        amount: 200,
      ),
    });
    container = containerWith(recipes);
  });

  Future<RecipeEditor> editor(int? recipeId) async {
    final provider = recipeEditorProvider(recipeId);
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
    return container.read(provider.notifier);
  }

  EditorState state(int? recipeId) =>
      container.read(recipeEditorProvider(recipeId)).requireValue;

  test('loads the recipe as a draft', () async {
    await editor(7);

    expect(state(7).draft, RecipeDraft.fromRecipe(ofenkarotten));
    expect(state(7).recipeName, 'Ofenkarotten mit Feta');
    expect(state(7).recipeId, 7);
  });

  test('a new recipe starts empty', () async {
    await editor(null);

    expect(state(null).draft, const RecipeDraft());
    expect(state(null).recipeName, isNull);
    expect(recipes.fetchCount, 0);
  });

  test('loading a missing recipe fails', () async {
    final provider = recipeEditorProvider(99);
    container.listen(provider, (_, _) {});

    await expectLater(
      container.read(provider.future),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('offline, the cached copy is not edited', () async {
    recipes.offline = true;
    final provider = recipeEditorProvider(7);
    container.listen(provider, (_, _) {});

    await expectLater(
      container.read(provider.future),
      throwsA(isA<OfflineFailure>()),
    );
  });

  test('an unexpected error ends the save like a failure', () async {
    container = containerWith(
      _SlowRepository(recipes, Future.value(), StateError('kaputt')),
    );
    final controller = await editor(7);

    expect(await controller.save(), isNull);

    expect(state(7).saving, isFalse);
    expect(state(7).failure, isA<ServerFailure>());
  });

  test('edits change the draft; keywords are added once', () async {
    final controller = await editor(7);

    controller
      ..edit((draft) => draft.copyWith(name: 'Ofengemüse'))
      ..addKeyword(const Keyword(id: 3, name: 'Schnell'))
      ..addKeyword(const Keyword(id: 1, name: 'Vegetarisch'))
      ..removeKeywordAt(1);

    expect(state(7).draft.name, 'Ofengemüse');
    expect(state(7).draft.keywords, const [
      NamedRef(id: 1, name: 'Vegetarisch'),
      NamedRef(id: 3, name: 'Schnell'),
    ]);
  });

  test('saves over the recipe and returns it as saved', () async {
    final controller = await editor(7);
    controller.edit((draft) => draft.copyWith(name: '  Ofengemüse '));

    final saved = await controller.save();

    expect(saved?.name, 'Ofengemüse');
    expect(recipes.saves.single.id, 7);
    // Saved without the spaces around it.
    expect(recipes.saves.single.draft.name, 'Ofengemüse');
    expect(state(7).saving, isFalse);
    expect(state(7).failure, isNull);
  });

  test('creates a new recipe', () async {
    final controller = await editor(null);
    controller.edit((draft) => draft.copyWith(name: 'Linsensuppe'));

    final saved = await controller.save();

    expect(saved?.name, 'Linsensuppe');
    expect(recipes.saves.single.id, isNull);
    expect(recipes.recipes[saved!.id]?.name, 'Linsensuppe');
  });

  test('a draft with problems is not saved; they are shown', () async {
    final controller = await editor(null);
    expect(state(null).showProblems, isFalse);

    expect(await controller.save(), isNull);

    expect(recipes.saves, isEmpty);
    expect(state(null).showProblems, isTrue);
    expect(state(null).problems, {DraftField.name: DraftProblem.missing});
  });

  test('a failed save keeps the edits and says why', () async {
    final controller = await editor(7);
    controller.edit((draft) => draft.copyWith(name: 'Ofengemüse'));
    recipes.failure = const UnauthorizedFailure();

    expect(await controller.save(), isNull);

    expect(state(7).failure, isA<UnauthorizedFailure>());
    expect(state(7).saving, isFalse);
    expect(state(7).draft.name, 'Ofengemüse');

    // Trying again clears the failure.
    recipes.failure = null;
    expect(await controller.save(), isNotNull);
    expect(state(7).failure, isNull);
  });

  test('while saving, edits and a second save are ignored', () async {
    final gate = Completer<void>();
    container = containerWith(_SlowRepository(recipes, gate.future));
    final controller = await editor(7);

    final first = controller.save();
    expect(state(7).saving, isTrue);
    controller.edit((draft) => draft.copyWith(name: 'Zu spät'));
    expect(await controller.save(), isNull);
    gate.complete();

    expect(await first, isNotNull);
    expect(recipes.saves, hasLength(1));
    expect(state(7).draft.name, 'Ofenkarotten mit Feta');
  });

  group('deleting', () {
    test(
      'deletes the recipe, its draft and leaves the editor locked',
      () async {
        final controller = await editor(7);
        controller.edit((draft) => draft.copyWith(name: 'Ofengemüse'));
        await controller.flushDraft();
        await drafts.save(
          7,
          StoredDraft(
            draft: RecipeDraft.fromRecipe(ofenkarotten),
            savedAt: DateTime(2026, 11, 16),
          ),
        );

        expect(await controller.deleteRecipe(), isNull);

        expect(recipes.deletions, [7]);
        expect(recipes.recipes, isEmpty);
        expect(await drafts.load(7), isNull);
        expect(state(7).deleted, isTrue);
        expect(state(7).saving, isTrue);
      },
    );

    test('a recipe the server lacks already counts as deleted', () async {
      final controller = await editor(7);
      recipes.recipes.remove(7);

      expect(await controller.deleteRecipe(), isNull);

      expect(state(7).deleted, isTrue);
    });

    test('a refusal is returned and the editor stays usable', () async {
      final controller = await editor(7);
      controller.edit((draft) => draft.copyWith(name: 'Ofengemüse'));
      recipes.failure = const UnauthorizedFailure();

      expect(await controller.deleteRecipe(), isA<UnauthorizedFailure>());

      expect(state(7).deleted, isFalse);
      expect(state(7).saving, isFalse);
      expect(state(7).draft.name, 'Ofengemüse');
      expect(recipes.recipes, isNotEmpty);
    });

    test('does nothing for a new recipe', () async {
      final controller = await editor(null);

      expect(await controller.deleteRecipe(), isNull);

      expect(recipes.deletions, isEmpty);
      expect(state(null).deleted, isFalse);
    });
  });

  group('ingredients', () {
    List<List<IngredientDraft>> ingredients(int? recipeId) => [
      for (final step in state(recipeId).draft.steps) step.ingredients,
    ];

    final karotten = const IngredientDraft(
      food: NamedRef(id: 1, name: 'Karotte'),
      unit: NamedRef(id: 9, name: 'g'),
      amount: 200,
      originalText: '200 g Karotten',
    );

    test('adds a parsed line to the last step', () async {
      final controller = await editor(7);
      final before = ingredients(7);

      expect(await controller.addLine('200 g Karotten'), karotten);

      expect(parser.parsed, ['200 g Karotten']);
      expect(ingredients(7), [
        before[0],
        before[1],
        [...before[2], karotten],
      ]);
    });

    test('adds a line to the given step', () async {
      final controller = await editor(7);

      await controller.addLine('200 g Karotten', step: 0);

      expect(ingredients(7)[0], [karotten]);
    });

    test('a line that does not parse is added as a note', () async {
      final controller = await editor(null);

      final added = await controller.addLine('etwas Grünes ');

      expect(
        added,
        const IngredientDraft(
          note: 'etwas Grünes',
          originalText: 'etwas Grünes ',
        ),
      );
      // A new recipe gets a step for it.
      expect(ingredients(null), [
        [added],
      ]);
    });

    test('a blank line adds nothing and is not sent', () async {
      final controller = await editor(7);
      final before = state(7).draft;

      expect(await controller.addLine('   '), isNull);

      expect(parser.parsed, isEmpty);
      expect(state(7).draft, before);
    });

    test('a failed parse adds nothing and throws', () async {
      final controller = await editor(7);
      final before = state(7).draft;
      parser.failure = const OfflineFailure();

      await expectLater(
        controller.addLine('200 g Karotten'),
        throwsA(isA<OfflineFailure>()),
      );

      expect(state(7).draft, before);
    });

    test('adds a header, edits, moves and removes rows', () async {
      final controller = await editor(7);
      final step = ingredients(7)[1];
      final [karotte, oel, kuemmel, salz] = step;

      controller.addHeader('Für die Gewürze', step: 1);
      final header = IngredientDraft.header('Für die Gewürze');
      expect(ingredients(7)[1], [karotte, oel, kuemmel, salz, header]);

      controller.moveIngredient(1, 4, -1);
      expect(ingredients(7)[1], [karotte, oel, kuemmel, header, salz]);

      controller.updateIngredient(1, 0, karotte.copyWith(amount: 400));
      expect(ingredients(7)[1].first.amount, 400);

      controller.removeIngredient(1, 1);
      expect(ingredients(7)[1], [
        karotte.copyWith(amount: 400),
        kuemmel,
        header,
        salz,
      ]);

      // A blank header adds nothing.
      controller.addHeader('  ', step: 1);
      expect(ingredients(7)[1], hasLength(4));
    });

    test('ingredient changes are saved with the recipe', () async {
      final controller = await editor(7);

      await controller.addLine('200 g Karotten');
      controller.removeIngredient(1, 3);
      await controller.save();

      final saved = recipes.saves.single.draft;
      expect(saved.steps[1].ingredients, hasLength(3));
      expect(saved.steps[2].ingredients.last, karotten);
    });

    test('a save first adds the lines typed into entries', () async {
      final controller = await editor(7);
      final remove = controller.addPendingLine(
        () async => await controller.addLine('200 g Karotten') != null,
      );

      expect(await controller.save(), isNotNull);
      expect(recipes.saves.single.draft.steps[2].ingredients.last, karotten);

      // Unregistered, it isn't asked again.
      remove();
      await controller.save();
      expect(parser.parsed, hasLength(1));
    });

    test('a line that cannot be added stops the save', () async {
      final controller = await editor(7);
      controller.addPendingLine(() async => false);

      expect(await controller.save(), isNull);
      expect(recipes.saves, isEmpty);
      expect(state(7).saving, isFalse);
    });
  });

  group('steps', () {
    List<int?> ids() => [for (final s in state(7).draft.steps) s.id];

    test('adds a step', () async {
      final controller = await editor(7);

      controller.addStep();

      expect(ids(), [1, 2, 3, null]);
    });

    test('deletes a step', () async {
      final controller = await editor(7);

      controller.removeStep(1);

      expect(ids(), [1, 3]);
    });

    test('moves steps by an offset and to a place', () async {
      final controller = await editor(7);

      controller.moveStep(2, -1);
      expect(ids(), [1, 3, 2]);
      controller.moveStep(0, -1);
      expect(ids(), [1, 3, 2]);
      controller.reorderStep(0, 2);
      expect(ids(), [3, 2, 1]);
    });

    test('sets instruction, name and whole minutes of the duration', () async {
      final controller = await editor(7);

      controller
        ..setStepInstruction(0, 'Vorheizen.')
        ..setStepName(0, 'Ofen')
        ..setStepTime(0, const Duration(minutes: 25, seconds: 40));

      final step = state(7).draft.steps[0];
      expect(step.instruction, 'Vorheizen.');
      expect(step.name, 'Ofen');
      expect(step.time, const Duration(minutes: 25));
      controller.setStepTime(0, Duration.zero);
      expect(state(7).draft.steps[0].time, Duration.zero);
    });

    test('moves an ingredient between steps', () async {
      final controller = await editor(7);

      controller.moveIngredientToStep(1, 0, 0);

      final steps = state(7).draft.steps;
      expect(steps[0].ingredients.map((i) => i.id), [1]);
      expect(steps[1].ingredients.map((i) => i.id), [2, 3, 4]);
    });

    test('edits are saved in the new order', () async {
      final controller = await editor(7);

      controller
        ..moveStep(0, 1)
        ..addStep();
      await controller.save();

      expect(recipes.saves.single.draft.steps.map((s) => s.id), [
        2,
        1,
        3,
        null,
      ]);
    });
  });

  group('image', () {
    final photo = ImageUpload(
      bytes: Uint8List.fromList([0xFF, 0xD8, 0xFF]),
      fileName: 'karotten.jpg',
      mimeType: 'image/jpeg',
    );
    final saved = Uri.parse('https://example.com/media/recipes/a_7.jpg');

    setUp(() {
      recipes = FakeRecipeRepository([ofenkarotten.copyWith(image: saved)]);
      container = containerWith(recipes);
    });

    test('starts with the saved image', () async {
      await editor(7);

      expect(state(7).savedImage, saved);
      expect(state(7).hasImage, isTrue);
      expect(state(7).newImage, isNull);
    });

    test('a chosen image is uploaded after the recipe is saved', () async {
      final edit = await editor(7);
      edit.setImage(photo);
      expect(state(7).newImage, photo);

      final recipe = await edit.save();

      expect(recipes.saves.single.id, 7);
      expect(recipes.imageChanges.single, (id: 7, image: photo));
      expect(recipe!.image, FakeRecipeRepository.imageUrl(7, 1));
      expect(state(7).savedImage, recipe.image);
      expect(state(7).newImage, isNull);
      expect(state(7).imageFailure, isNull);
    });

    test('a new recipe gets its image right after it is created', () async {
      final edit = await editor(null);
      edit
        ..edit((d) => d.copyWith(name: 'Brot', servings: 1))
        ..setImage(photo);

      final recipe = await edit.save();

      expect(recipes.saves.single.id, isNull);
      expect(recipes.imageChanges.single.id, recipe!.id);
      expect(recipe.image, isNotNull);
    });

    test('a photo chosen after removing the saved one replaces it', () async {
      final edit = await editor(7);
      edit
        ..removeImage()
        ..setImage(photo);

      await edit.save();

      expect(recipes.imageChanges.single, (id: 7, image: photo));
    });

    test('removing the saved image removes it on save', () async {
      final edit = await editor(7);
      edit.removeImage();
      expect(state(7).hasImage, isFalse);
      expect(state(7).removeImage, isTrue);

      final recipe = await edit.save();

      expect(recipes.imageChanges.single, (id: 7, image: null));
      expect(recipe!.image, isNull);
    });

    test(
      'Entfernen after choosing an image goes back to the saved one',
      () async {
        final edit = await editor(7);
        edit
          ..setImage(photo)
          ..removeImage();
        expect(state(7).newImage, isNull);
        expect(state(7).removeImage, isFalse);
        expect(state(7).hasImage, isTrue);

        // A second time removes the saved one.
        edit.removeImage();
        expect(state(7).hasImage, isFalse);
        // Choosing a photo and dropping it again keeps that removal.
        edit.setImage(photo);
        expect(state(7).hasImage, isTrue);
        edit.removeImage();
        expect(state(7).removeImage, isTrue);
        expect(state(7).hasImage, isFalse);
      },
    );

    test('without changes no image request is made', () async {
      final edit = await editor(7);

      await edit.save();

      expect(recipes.imageChanges, isEmpty);
    });

    test('a failed upload keeps the saved recipe and says so', () async {
      final edit = await editor(7);
      edit
        ..edit((d) => d.copyWith(name: 'Ofengemüse'))
        ..setImage(photo);
      recipes.imageFailure = const ServerFailure(statusCode: 413);

      final recipe = await edit.save();

      expect(recipe!.name, 'Ofengemüse');
      expect(recipe.image, saved);
      expect(recipes.recipes[7]!.name, 'Ofengemüse');
      expect(state(7).saving, isFalse);
      expect(state(7).failure, isNull);
      expect(
        state(7).imageFailure,
        isA<ServerFailure>().having((f) => f.statusCode, 'status', 413),
      );
      // Dropped: saving again would save the recipe again, not just the
      // photo.
      expect(state(7).newImage, isNull);

      // The next save that works says nothing about the photo.
      recipes.imageFailure = null;
      await edit.save();
      expect(state(7).imageFailure, isNull);
    });

    test('a failed recipe save uploads nothing', () async {
      final edit = await editor(7);
      edit.setImage(photo);
      recipes.failure = const OfflineFailure();

      expect(await edit.save(), isNull);

      expect(recipes.imageChanges, isEmpty);
      expect(state(7).failure, isA<OfflineFailure>());
      expect(state(7).newImage, photo);
    });

    test('the image cannot change while saving', () async {
      final gate = Completer<void>();
      container = containerWith(_SlowRepository(recipes, gate.future));
      final edit = await editor(7);

      final save = edit.save();
      edit
        ..setImage(photo)
        ..removeImage();
      expect(state(7).newImage, isNull);
      expect(state(7).removeImage, isFalse);
      gate.complete();
      await save;
    });
  });

  group('unsaved changes', () {
    final savedAt = DateTime(2026, 11, 16, 18, 30);
    final photo = ImageUpload(
      bytes: Uint8List.fromList([1, 2, 3]),
      fileName: 'a.png',
      mimeType: 'image/png',
    );
    StoredDraft storedNamed(String name) => StoredDraft(
      draft: RecipeDraft.fromRecipe(ofenkarotten).copyWith(name: name),
      savedAt: savedAt,
    );

    test('a loaded recipe has no changes', () async {
      await editor(7);
      expect(state(7).isDirty, isFalse);
      await editor(null);
      expect(state(null).isDirty, isFalse);
    });

    test('an edit is a change until it is undone', () async {
      final edit = await editor(7);

      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
      expect(state(7).isDirty, isTrue);
      edit.edit((d) => d.copyWith(name: ofenkarotten.name));
      expect(state(7).isDirty, isFalse);

      edit.addStep();
      expect(state(7).isDirty, isTrue);
      edit.removeStep(ofenkarotten.steps.length);
      expect(state(7).isDirty, isFalse);
    });

    test('a new or removed photo is a change', () async {
      recipes = FakeRecipeRepository([
        ofenkarotten.copyWith(image: Uri.parse('https://e.com/a.jpg')),
      ]);
      container = containerWith(recipes);
      final edit = await editor(7);

      edit.setImage(photo);
      expect(state(7).isDirty, isTrue);
      edit.removeImage();
      expect(state(7).isDirty, isFalse);
      edit.removeImage();
      expect(state(7).isDirty, isTrue);
    });

    test('stores the changes as draft; undone, deletes it', () async {
      final edit = await editor(7);

      edit
        ..edit((d) => d.copyWith(name: 'Ofengemüse'))
        ..setImage(photo);
      await edit.flushDraft();
      final stored = drafts.drafts[7]!;
      expect(stored.draft.name, 'Ofengemüse');
      expect(stored.newImage, photo);
      expect(stored.savedAt, savedAt);

      edit
        ..edit((d) => d.copyWith(name: ofenkarotten.name))
        ..removeImage();
      await edit.flushDraft();
      expect(drafts.drafts, isEmpty);
    });

    test('stores the draft after a delay', () async {
      final edit = await editor(null);
      edit.edit((d) => d.copyWith(name: 'Linsensuppe'));
      expect(drafts.drafts, isEmpty);

      await Future<void>.delayed(
        RecipeEditor.draftDelay + const Duration(milliseconds: 50),
      );
      expect(drafts.drafts[null]!.draft.name, 'Linsensuppe');
    });

    test('a successful save deletes the draft', () async {
      final edit = await editor(7);
      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
      await edit.flushDraft();

      await edit.save();

      expect(drafts.drafts, isEmpty);
      expect(state(7).isDirty, isFalse);
      // Nothing is stored afterwards either.
      await edit.flushDraft();
      expect(drafts.drafts, isEmpty);
    });

    test('a failed save keeps the draft', () async {
      final edit = await editor(7);
      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
      recipes.failure = const OfflineFailure();

      await edit.save();
      await edit.flushDraft();

      expect(drafts.drafts[7]!.draft.name, 'Ofengemüse');
      expect(state(7).isDirty, isTrue);
    });

    test('offers a draft with changes and restores it', () async {
      drafts.drafts[7] = StoredDraft(
        draft: RecipeDraft.fromRecipe(ofenkarotten)
            .copyWith(name: 'Ofengemüse'),
        newImage: photo,
        savedAt: savedAt,
      );
      final edit = await editor(7);

      expect(state(7).offeredDraft, isNotNull);
      expect(state(7).draft.name, ofenkarotten.name);
      expect(state(7).offeredDraftIsStale, isFalse);
      // Not overwritten while it is offered.
      await edit.flushDraft();
      expect(drafts.drafts[7]!.draft.name, 'Ofengemüse');

      edit.restoreDraft();
      expect(state(7).offeredDraft, isNull);
      expect(state(7).draft.name, 'Ofengemüse');
      expect(state(7).newImage, photo);
      expect(state(7).isDirty, isTrue);
    });

    test('a discarded draft is deleted', () async {
      drafts.drafts[7] = storedNamed('Ofengemüse');
      final edit = await editor(7);

      edit.discardDraft();
      await pumpEventQueue();

      expect(state(7).offeredDraft, isNull);
      expect(state(7).draft.name, ofenkarotten.name);
      expect(drafts.drafts, isEmpty);
    });

    test('a draft older than the recipe on the server is stale', () async {
      recipes = FakeRecipeRepository([
        ofenkarotten.copyWith(updatedAt: savedAt.add(const Duration(hours: 1))),
      ]);
      container = containerWith(recipes);
      drafts.drafts[7] = storedNamed('Ofengemüse');
      await editor(7);

      expect(state(7).offeredDraftIsStale, isTrue);
    });

    test(
      'a draft from the recipe as it is on the server is not stale',
      () async {
        final updatedAt = DateTime.utc(2026, 11, 16, 9, 15, 30, 123, 456);
        recipes = FakeRecipeRepository([
          ofenkarotten.copyWith(updatedAt: updatedAt),
        ]);
        container = containerWith(recipes);
        final edit = await editor(7);
        edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
        await edit.flushDraft();
        // Typed after a change on the server: still the version it started
        // from.
        expect(drafts.drafts[7]!.baseUpdatedAt, updatedAt);
        container.dispose();

        container = containerWith(recipes);
        await editor(7);
        expect(state(7).offeredDraft, isNotNull);
        expect(state(7).offeredDraftIsStale, isFalse);

        recipes.recipes[7] = ofenkarotten.copyWith(
          updatedAt: updatedAt.add(const Duration(minutes: 5)),
        );
        container = containerWith(recipes);
        await editor(7);
        expect(state(7).offeredDraftIsStale, isTrue);
      },
    );

    test('a restored draft keeps the version it started from', () async {
      final updatedAt = DateTime.utc(2026, 11, 16, 9);
      recipes = FakeRecipeRepository([
        ofenkarotten.copyWith(updatedAt: updatedAt),
      ]);
      container = containerWith(recipes);
      drafts.drafts[7] = storedNamed('Ofengemüse');
      final edit = await editor(7);

      edit
        ..restoreDraft()
        ..edit((d) => d.copyWith(description: 'Neu'));
      await edit.flushDraft();

      expect(drafts.drafts[7]!.baseUpdatedAt, isNull);
    });

    test('a photo is written once, not with every change', () async {
      final edit = await editor(7);

      edit.setImage(photo);
      await edit.flushDraft();
      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
      await edit.flushDraft();
      edit.edit((d) => d.copyWith(name: 'Ofengemüse 2'));
      await edit.flushDraft();

      expect(drafts.imageWrites, 1);
      expect(drafts.drafts[7]!.newImage, photo);
      expect(drafts.drafts[7]!.draft.name, 'Ofengemüse 2');
    });

    test('a draft without changes is deleted, not offered', () async {
      drafts.drafts[7] = storedNamed(ofenkarotten.name);
      await editor(7);
      await pumpEventQueue();

      expect(state(7).offeredDraft, isNull);
      expect(drafts.drafts, isEmpty);
    });

    test('discardChanges deletes the draft', () async {
      final edit = await editor(7);
      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
      await edit.flushDraft();

      await edit.discardChanges();
      await edit.flushDraft();

      expect(drafts.drafts, isEmpty);
    });

    test('closing the editor stores a waiting change', () async {
      final edit = await editor(7);
      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));

      container.dispose();
      await pumpEventQueue();

      expect(drafts.drafts[7]!.draft.name, 'Ofengemüse');
    });

    test('a draft that cannot be read does not keep the editor shut', () async {
      container = ProviderContainer(
        overrides: [
          recipeRepositoryProvider.overrideWithValue(recipes),
          connectivityServiceProvider.overrideWithValue(connectivity),
          draftStoreProvider.overrideWithValue(_BrokenDraftStore()),
          clockProvider.overrideWithValue(() => savedAt),
        ],
      );
      addTearDown(container.dispose);
      final edit = await editor(7);

      expect(state(7).offeredDraft, isNull);
      edit.edit((d) => d.copyWith(name: 'Ofengemüse'));
      await edit.flushDraft();
      expect(state(7).draft.name, 'Ofengemüse');
    });
  });
}

/// Fails at everything.
class _BrokenDraftStore implements DraftStore {
  @override
  Future<StoredDraft?> load(int? recipeId) => Future.error(StateError('db'));

  @override
  Future<void> save(
    int? recipeId,
    StoredDraft draft, {
    bool imageChanged = true,
  }) => Future.error(StateError('db'));

  @override
  Future<void> delete(int? recipeId) => Future.error(StateError('db'));

  @override
  Future<void> clear() => Future.error(StateError('db'));
}

/// Saves through [_inner] once [_gate] completes, or throws [_error].
class _SlowRepository extends FakeRecipeRepository {
  _SlowRepository(this._inner, this._gate, [this._error]) : super(const []);

  final FakeRecipeRepository _inner;
  final Future<void> _gate;
  final Error? _error;

  @override
  Future<Recipe> fetchRecipe(int id, {bool allowCached = true}) =>
      _inner.fetchRecipe(id, allowCached: allowCached);

  @override
  Future<Recipe> updateRecipe(int id, RecipeDraft draft) async {
    await _gate;
    if (_error case final error?) throw error;
    return _inner.updateRecipe(id, draft);
  }
}
