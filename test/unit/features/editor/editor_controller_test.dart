import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/services/recipe_draft_validation.dart';
import 'package:yumdoor/features/editor/editor_controller.dart';

import '../../../fakes/fake_recipe_repository.dart';
import '../../../fixtures/recipes.dart';

void main() {
  late FakeRecipeRepository recipes;
  late ProviderContainer container;

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(recipes)],
    );
    addTearDown(container.dispose);
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
    final slow = _SlowRepository(recipes, gate.future);
    container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(slow)],
    );
    addTearDown(container.dispose);
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
}

/// Saves through [_inner] once [_gate] completes.
class _SlowRepository extends FakeRecipeRepository {
  _SlowRepository(this._inner, this._gate) : super(const []);

  final FakeRecipeRepository _inner;
  final Future<void> _gate;

  @override
  Future<Recipe> fetchRecipe(int id) => _inner.fetchRecipe(id);

  @override
  Future<Recipe> updateRecipe(int id, RecipeDraft draft) async {
    await _gate;
    return _inner.updateRecipe(id, draft);
  }
}
