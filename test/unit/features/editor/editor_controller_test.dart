import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/services/recipe_draft_validation.dart';
import 'package:yumdoor/features/editor/editor_controller.dart';

import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/fake_ingredient_parser.dart';
import '../../../fakes/fake_recipe_repository.dart';
import '../../../fixtures/recipes.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeConnectivityService connectivity;
  late FakeIngredientParser parser;
  late ProviderContainer container;

  ProviderContainer containerWith(FakeRecipeRepository recipes) {
    final container = ProviderContainer(
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        connectivityServiceProvider.overrideWithValue(connectivity),
        ingredientParserProvider.overrideWithValue(parser),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    connectivity = FakeConnectivityService();
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

    test('a save waits for a line still being parsed', () async {
      final gate = Completer<void>();
      parser = _SlowParser(parser, gate.future);
      container = containerWith(recipes);
      final controller = await editor(7);

      final adding = controller.addLine('200 g Karotten');
      final saving = controller.save();
      await Future<void>.delayed(Duration.zero);
      expect(recipes.saves, isEmpty);
      gate.complete();

      expect(await adding, karotten);
      expect(await saving, isNotNull);
      expect(recipes.saves.single.draft.steps[2].ingredients.last, karotten);
    });

    test('a save goes on when a line being parsed fails', () async {
      final gate = Completer<void>();
      parser = _SlowParser(parser, gate.future)
        ..failure = const OfflineFailure();
      container = containerWith(recipes);
      final controller = await editor(7);

      final adding = controller.addLine('200 g Karotten');
      final saving = controller.save();
      gate.complete();

      await expectLater(adding, throwsA(isA<OfflineFailure>()));
      expect(await saving, isNotNull);
      expect(recipes.saves.single.draft, RecipeDraft.fromRecipe(ofenkarotten));
    });
  });
}

/// Parses like [_inner] once [_gate] completes.
class _SlowParser extends FakeIngredientParser {
  _SlowParser(this._inner, this._gate);

  final FakeIngredientParser _inner;
  final Future<void> _gate;

  @override
  Future<ParsedIngredient> parse(String line) async {
    await _gate;
    if (failure case final failure?) throw failure;
    return _inner.parse(line);
  }
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
