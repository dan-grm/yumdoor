import 'package:freezed_annotation/freezed_annotation.dart';

import 'keyword.dart';
import 'recipe_step.dart';
import 'recipe_summary.dart';
import 'user_ref.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

/// A recipe with its steps, as shown on the recipe screen and in cooking mode.
@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required int id,
    required String name,
    @Default('') String description,
    Uri? image,
    @Default([]) List<Keyword> keywords,

    /// The servings the ingredient amounts are for.
    @Default(1) int servings,

    /// What a serving is ("Stück", "Gläser"), empty if not set.
    @Default('') String servingsText,
    @Default(Duration.zero) Duration workingTime,
    @Default(Duration.zero) Duration waitingTime,
    @Default([]) List<RecipeStep> steps,

    /// Where the recipe was imported from, if anywhere.
    Uri? sourceUrl,

    /// The current user's average rating from their own cook log, 0 to 5.
    double? rating,

    /// When the current user last cooked it.
    DateTime? lastCooked,
    UserRef? createdBy,
    DateTime? updatedAt,
  }) = _Recipe;

  const Recipe._();

  /// For storing in the offline cache. The format follows the fields, so a
  /// change to this model or the ones it contains needs a new cache version.
  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  /// The recipe as it appears in a list.
  RecipeSummary get summary => RecipeSummary(
    id: id,
    name: name,
    description: description,
    image: image,
    keywords: keywords,
    servings: servings,
    servingsText: servingsText,
    workingTime: workingTime,
    waitingTime: waitingTime,
    rating: rating,
    lastCooked: lastCooked,
    createdBy: createdBy,
    updatedAt: updatedAt,
  );
}
