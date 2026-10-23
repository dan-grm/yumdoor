import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_query.freezed.dart';

/// A recipe search. All parts must match.
@freezed
abstract class RecipeQuery with _$RecipeQuery {
  const factory RecipeQuery({
    /// Free text. Which fields it searches is the user's Tandoor search
    /// preference; by default only recipe names.
    @Default('') String text,

    /// The recipe contains each of these foods, or one of its child foods.
    @Default({}) Set<int> foodIds,

    /// The recipe has each of these keywords.
    @Default({}) Set<int> keywordIds,

    /// The current user rated it at least this, 1 to 5. Tandoor only counts
    /// the user's own cook logs.
    int? minRating,

    /// The current user last cooked it on or before this day (the date part
    /// counts). Tandoor only counts the user's own cook logs.
    DateTime? lastCookedBefore,
  }) = _RecipeQuery;

  const RecipeQuery._();

  /// Whether anything narrows the search; an empty query lists all recipes.
  bool get isEmpty =>
      text.trim().isEmpty &&
      foodIds.isEmpty &&
      keywordIds.isEmpty &&
      minRating == null &&
      lastCookedBefore == null;
}
