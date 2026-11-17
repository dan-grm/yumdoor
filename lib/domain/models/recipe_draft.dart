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

  /// Whether the ingredients are shown grouped by step: when more than one
  /// step has ingredients. Otherwise they are one list (decided in M3,
  /// docs/ROADMAP.md).
  bool get groupsIngredientsByStep =>
      steps.where((step) => step.ingredients.isNotEmpty).length > 1;

  /// [ingredient] added at the end of the step at [step], or of the last step
  /// if [step] is `null` or no longer exists. A draft without steps gets an
  /// empty one for it.
  RecipeDraft addIngredient(IngredientDraft ingredient, {int? step}) {
    if (steps.isEmpty) {
      return copyWith(
        steps: [
          StepDraft(ingredients: [ingredient]),
        ],
      );
    }
    final index = step != null && step >= 0 && step < steps.length
        ? step
        : steps.length - 1;
    return _changeIngredients(index, (list) => [...list, ingredient]);
  }

  /// The ingredient at [index] of the step at [step] replaced by
  /// [ingredient].
  RecipeDraft replaceIngredient(
    int step,
    int index,
    IngredientDraft ingredient,
  ) => _changeIngredients(step, (list) => [...list]..[index] = ingredient);

  /// The draft without the ingredient at [index] of the step at [step].
  RecipeDraft removeIngredient(int step, int index) =>
      _changeIngredients(step, (list) => [...list]..removeAt(index));

  /// The ingredient at [index] of the step at [step] moved to [to] within
  /// that step; [to] is clamped to the step's list.
  RecipeDraft moveIngredient(int step, int index, int to) =>
      _changeIngredients(step, (list) {
        final target = to.clamp(0, list.length - 1);
        if (target == index) return list;
        final moved = [...list];
        moved.insert(target, moved.removeAt(index));
        return moved;
      });

  /// A new, empty step at the end.
  RecipeDraft addStep() => copyWith(steps: [...steps, const StepDraft()]);

  /// The draft without the step at [index], with its ingredients.
  RecipeDraft removeStep(int index) =>
      copyWith(steps: [...steps]..removeAt(index));

  /// The step at [index] moved to [to]; [to] is clamped to the steps.
  RecipeDraft moveStep(int index, int to) {
    final target = to.clamp(0, steps.length - 1);
    if (target == index) return this;
    final moved = [...steps];
    moved.insert(target, moved.removeAt(index));
    return copyWith(steps: moved);
  }

  /// The step at [index] changed by [change].
  RecipeDraft changeStep(
    int index,
    StepDraft Function(StepDraft step) change,
  ) => copyWith(
    steps: [for (final (i, s) in steps.indexed) i == index ? change(s) : s],
  );

  /// The ingredient at [index] of the step at [from] moved to the end of the
  /// step at [to]. Nothing changes if [from] and [to] are the same step.
  RecipeDraft moveIngredientToStep(int from, int index, int to) {
    if (from == to) return this;
    final ingredient = steps[from].ingredients[index];
    return removeIngredient(
      from,
      index,
    )._changeIngredients(to, (list) => [...list, ingredient]);
  }

  RecipeDraft _changeIngredients(
    int step,
    List<IngredientDraft> Function(List<IngredientDraft> ingredients) change,
  ) => copyWith(
    steps: [
      for (final (index, s) in steps.indexed)
        index == step ? s.copyWith(ingredients: change(s.ingredients)) : s,
    ],
  );
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

  /// A section header ("Für den Teig") with [title], as Tandoor stores one:
  /// the title as note, no food, unit or amount
  /// (docs/TANDOOR_API.md#recipe-detail-and-step-text).
  factory IngredientDraft.header(String title) =>
      IngredientDraft(isHeader: true, noAmount: true, note: title.trim());

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
