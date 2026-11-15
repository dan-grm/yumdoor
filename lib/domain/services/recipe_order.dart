import '../models/recipe_sort.dart';
import '../models/recipe_summary.dart';
import 'text_match.dart';

/// Compares recipes in [sort] order by what a [RecipeSummary] carries, or
/// `null` when it carries nothing to compare by ([RecipeSort.relevance],
/// [RecipeSort.recentlyViewed] and [RecipeSort.random]).
///
/// Recipes that compare equal are in no particular order. Server results
/// carry no last-cooked date (docs/TANDOOR_API.md), so for them
/// [RecipeSort.lastCooked] finds every recipe equal.
Comparator<RecipeSummary>? recipeOrder(RecipeSort sort) => switch (sort) {
  RecipeSort.name => _byName,
  RecipeSort.rating => _byRating,
  RecipeSort.lastCooked => _byLastCooked,
  RecipeSort.newest => _byNewest,
  RecipeSort.relevance ||
  RecipeSort.recentlyViewed ||
  RecipeSort.random => null,
};

/// Case and accents ignored, roughly like Tandoor's `Lower(name)`.
int _byName(RecipeSummary a, RecipeSummary b) =>
    foldText(a.name).compareTo(foldText(b.name));

/// Best first, unrated last.
int _byRating(RecipeSummary a, RecipeSummary b) =>
    _descendingNullsLast(a.rating, b.rating);

/// Most recent first, never cooked last.
int _byLastCooked(RecipeSummary a, RecipeSummary b) =>
    _descendingNullsLast(a.lastCooked, b.lastCooked);

/// Ids grow with the creation time, which Tandoor sets on insert and doesn't
/// let clients change, and summaries don't carry it.
int _byNewest(RecipeSummary a, RecipeSummary b) => b.id.compareTo(a.id);

int _descendingNullsLast<T extends Comparable<Object>>(T? a, T? b) =>
    switch ((a, b)) {
      (null, null) => 0,
      (null, _) => 1,
      (_, null) => -1,
      (final a?, final b?) => b.compareTo(a),
    };
