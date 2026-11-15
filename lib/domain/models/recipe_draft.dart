import 'package:freezed_annotation/freezed_annotation.dart';

import 'food.dart';
import 'ingredient.dart';
import 'keyword.dart';
import 'recipe.dart';
import 'recipe_step.dart';
import 'unit.dart';

part 'recipe_draft.freezed.dart';
part 'recipe_draft.g.dart';

/// A recipe as the editor changes it, saved with
/// `RecipeRepository.createRecipe` or `updateRecipe`.
///
/// It holds only what Yumdoor edits. Saving changes those fields and leaves
/// everything else of the recipe on the server as it was (properties,
/// nutrition, privacy, step files, sub-recipe steps, …; see
/// docs/TANDOOR_API.md#recipe-writes).
///
/// Steps and ingredients are in their order: a list's order is the one they
/// are saved in. [RecipeDraft.fromRecipe] keeps the recipe's order, which
/// comes sorted from the server.
@freezed
abstract class RecipeDraft with _$RecipeDraft {
  const factory RecipeDraft({
    @Default('') String name,
    @Default('') String description,
    @Default(1) int servings,
    @Default('') String servingsText,

    /// Whole minutes; seconds are dropped on save.
    @Default(Duration.zero) Duration workingTime,
    @Default(Duration.zero) Duration waitingTime,
    @Default([]) List<NamedRef> keywords,

    /// See [Recipe.sourceUrl]; `null` for none.
    String? sourceUrl,
    @Default([]) List<StepDraft> steps,
  }) = _RecipeDraft;

  const RecipeDraft._();

  /// [recipe] as it is, ready to be edited.
  factory RecipeDraft.fromRecipe(Recipe recipe) => RecipeDraft(
    name: recipe.name,
    description: recipe.description,
    servings: recipe.servings,
    servingsText: recipe.servingsText,
    workingTime: recipe.workingTime,
    waitingTime: recipe.waitingTime,
    keywords: [
      for (final keyword in recipe.keywords) NamedRef.keyword(keyword),
    ],
    sourceUrl: recipe.sourceUrl,
    steps: [for (final step in recipe.steps) StepDraft.fromStep(step)],
  );

  /// For keeping unsaved drafts locally.
  factory RecipeDraft.fromJson(Map<String, dynamic> json) =>
      _$RecipeDraftFromJson(json);
}

/// A step of a [RecipeDraft]. [id] is `null` for a step that isn't saved
/// yet.
@freezed
abstract class StepDraft with _$StepDraft {
  const factory StepDraft({
    int? id,
    @Default('') String name,

    /// Markdown, see [RecipeStep.instruction].
    @Default('') String instruction,

    /// An explicit duration, [Duration.zero] for none. Whole minutes.
    @Default(Duration.zero) Duration time,
    @Default([]) List<IngredientDraft> ingredients,
  }) = _StepDraft;

  factory StepDraft.fromStep(RecipeStep step) => StepDraft(
    id: step.id,
    name: step.name,
    instruction: step.instruction,
    time: step.time,
    ingredients: [
      for (final ingredient in step.ingredients)
        IngredientDraft.fromIngredient(ingredient),
    ],
  );

  factory StepDraft.fromJson(Map<String, dynamic> json) =>
      _$StepDraftFromJson(json);
}

/// An ingredient of a [StepDraft]. [id] is `null` for one that isn't saved
/// yet.
@freezed
abstract class IngredientDraft with _$IngredientDraft {
  const factory IngredientDraft({
    int? id,
    NamedRef? food,
    NamedRef? unit,

    /// See [Ingredient.amount].
    @Default(0) double amount,
    @Default(false) bool noAmount,

    /// A heading inside the list; its text is in [note].
    @Default(false) bool isHeader,
    @Default('') String note,

    /// The line as originally imported. Tandoor keeps it only when the
    /// ingredient is created; later saves don't change it.
    String? originalText,
  }) = _IngredientDraft;

  factory IngredientDraft.fromIngredient(Ingredient ingredient) =>
      IngredientDraft(
        id: ingredient.id,
        food: switch (ingredient.food) {
          final food? => NamedRef.food(food),
          null => null,
        },
        unit: switch (ingredient.unit) {
          final unit? => NamedRef.unit(unit),
          null => null,
        },
        amount: ingredient.amount,
        noAmount: ingredient.noAmount,
        isHeader: ingredient.isHeader,
        note: ingredient.note,
        originalText: ingredient.originalText,
      );

  factory IngredientDraft.fromJson(Map<String, dynamic> json) =>
      _$IngredientDraftFromJson(json);
}

/// A food, unit or keyword of a draft: an existing one by [id], or a new one
/// by [name] only.
///
/// On save, Tandoor finds one without an id by its name (ignoring case;
/// foods and units also by plural) and creates it if there is none. One with
/// an id is renamed to [name] if they differ, everywhere it is used, so
/// [name] must be its current name (docs/TANDOOR_API.md#recipe-writes).
@freezed
abstract class NamedRef with _$NamedRef {
  const factory NamedRef({int? id, required String name}) = _NamedRef;

  factory NamedRef.food(Food food) => NamedRef(id: food.id, name: food.name);

  factory NamedRef.unit(Unit unit) => NamedRef(id: unit.id, name: unit.name);

  factory NamedRef.keyword(Keyword keyword) =>
      NamedRef(id: keyword.id, name: keyword.name);

  factory NamedRef.fromJson(Map<String, dynamic> json) =>
      _$NamedRefFromJson(json);
}
