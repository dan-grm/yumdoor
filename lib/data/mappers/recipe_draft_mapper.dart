import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/recipe_draft.dart';

// What a save sends, and what it leaves out on purpose, is described in
// docs/TANDOOR_API.md#recipe-writes. In short: an update is a PATCH with only
// the fields Yumdoor edits, so Tandoor keeps every other field of the recipe
// and of each existing step and ingredient as it is.

extension RecipeDraftMapper on RecipeDraft {
  /// The body for creating the recipe.
  api.Recipe toApiRecipe() => api.Recipe(
    (b) => b
      ..name = name
      ..description = description
      ..servings = servings
      ..servingsText = servingsText
      ..workingTime = workingTime.inMinutes
      ..waitingTime = waitingTime.inMinutes
      ..keywords.replace(_keywords)
      ..sourceUrl = _sourceUrl
      ..steps.replace(_steps)
      // Written in Tandoor rather than imported, as Tandoor's own editor
      // marks the recipes it creates.
      ..internal = true,
  );

  /// The body for saving over an existing recipe.
  api.PatchedRecipe toPatchedRecipe() => api.PatchedRecipe(
    (b) => b
      ..name = name
      ..description = description
      ..servings = servings
      ..servingsText = servingsText
      ..workingTime = workingTime.inMinutes
      ..waitingTime = waitingTime.inMinutes
      ..keywords.replace(_keywords)
      ..sourceUrl = _sourceUrl
      ..steps.replace(_steps),
  );

  // Empty, not left out: a PATCH leaves out what is `null`, which would keep
  // a URL that was removed.
  String get _sourceUrl => sourceUrl ?? '';

  List<api.Keyword> get _keywords => [
    for (final keyword in keywords)
      api.Keyword(
        (b) => b
          ..id = keyword.id
          ..name = keyword.name,
      ),
  ];

  List<api.Step> get _steps => [
    for (final (order, step) in steps.indexed) step._toApi(order),
  ];
}

extension on StepDraft {
  // Sub-recipe, file, header and ingredient-table settings are left out, so
  // an existing step keeps them and a new one gets Tandoor's defaults.
  api.Step _toApi(int order) => api.Step(
    (b) => b
      ..id = id
      ..name = name
      ..instruction = instruction
      ..time = time.inMinutes
      ..order = order
      ..ingredients.replace([
        for (final (order, ingredient) in ingredients.indexed)
          ingredient._toApi(order),
      ]),
  );
}

extension on IngredientDraft {
  api.Ingredient _toApi(int order) => api.Ingredient(
    (b) => b
      ..id = id
      ..food = switch (food) {
        final food? =>
          api.FoodBuilder()
            ..id = food.id
            ..name = food.name,
        null => null,
      }
      ..unit = switch (unit) {
        final unit? =>
          api.UnitBuilder()
            ..id = unit.id
            ..name = unit.name,
        null => null,
      }
      ..amount = amount
      ..noAmount = noAmount
      ..isHeader = isHeader
      ..note = note
      ..originalText = originalText
      ..order = order,
  );
}
