import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_sort.dart';

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
    ///
    /// `RecipeRepository.search` only finds the recipes added to a book; the
    /// `UniversalSearch` also finds those a dynamic book's saved search
    /// finds, with [savedSearchOfBook].
    @Default({}) Set<int> bookIds,

    /// The recipe is found by the saved search of this (dynamic) book,
    /// whether or not it was added to it. Nothing matches if the book has no
    /// saved search. Set by the `UniversalSearch`, not part of a search link.
    int? savedSearchOfBook,

    /// The user who created the recipe.
    int? createdBy,

    /// The order the user chose, `null` for the default ([effectiveSort]).
    /// Doesn't narrow the search.
    RecipeSort? sort,
  }) = _RecipeQuery;

  const RecipeQuery._();

  /// The order of the results: [sort], by default relevance when there is
  /// text and name otherwise. Relevance without text is by name.
  RecipeSort get effectiveSort => switch (sort) {
    null || RecipeSort.relevance when text.trim().isEmpty => RecipeSort.name,
    null => RecipeSort.relevance,
    final sort => sort,
  };

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
      savedSearchOfBook == null &&
      createdBy == null;
}
