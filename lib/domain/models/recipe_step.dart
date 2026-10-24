import 'package:freezed_annotation/freezed_annotation.dart';

import 'ingredient.dart';

part 'recipe_step.freezed.dart';
part 'recipe_step.g.dart';

/// A step of a recipe with its own ingredients, as shown in cooking mode.
@freezed
abstract class RecipeStep with _$RecipeStep {
  const factory RecipeStep({
    required int id,
    @Default('') String name,

    /// Markdown as written on the server. Untrusted; may contain templates such
    /// as `{{ ingredients[0] }}` or `{{ scale(100) }}`.
    @Default('') String instruction,
    @Default([]) List<Ingredient> ingredients,

    /// An explicit duration for the step, [Duration.zero] if none.
    @Default(Duration.zero) Duration time,
    @Default(0) int order,
    @Default(false) bool showAsHeader,
  }) = _RecipeStep;

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepFromJson(json);
}
