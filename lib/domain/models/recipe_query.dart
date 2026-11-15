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

    /// The recipe contains at least one of these foods, or one of their child
    /// foods. Empty means no restriction.
    @Default({}) Set<int> anyFoodIds,

    /// The recipe has at least one of these keywords, or one of their child
    /// keywords. Empty means no restriction.
    @Default({}) Set<int> anyKeywordIds,

    /// The current user rated it at least this, 1 to 5. Tandoor only counts
    /// the user's own cook logs.
    int? minRating,

    /// The current user last cooked it on or before this day (the date part
    /// counts). Tandoor only counts the user's own cook logs.
    DateTime? lastCookedBefore,

    /// The current user never cooked it (no cook log of their own). Wins over
    /// [minTimesCooked].
    @Default(false) bool neverCooked,

    /// The current user cooked it at least this many times, 1 or more.
    int? minTimesCooked,

    /// At most this many of its foods are missing at home, 0 or more: `0` is
    /// "cookable now". Tandoor counts what anyone in the household has on
    /// hand, and substitutes.
    int? maxMissingFoods,

    /// The recipe is in at least one of these books. Empty means no
    /// restriction.
    @Default({}) Set<int> bookIds,

    /// The user who created the recipe.
    int? createdBy,
  }) = _RecipeQuery;

  const RecipeQuery._();

  /// Whether anything narrows the search; an empty query lists all recipes.
  bool get isEmpty =>
      text.trim().isEmpty &&
      foodIds.isEmpty &&
      keywordIds.isEmpty &&
      anyFoodIds.isEmpty &&
      anyKeywordIds.isEmpty &&
      minRating == null &&
      lastCookedBefore == null &&
      !neverCooked &&
      minTimesCooked == null &&
      maxMissingFoods == null &&
      bookIds.isEmpty &&
      createdBy == null;
}
