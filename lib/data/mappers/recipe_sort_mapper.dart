import '../../domain/models/recipe_sort.dart';

/// The `sort_order` and `random` parameters of `GET /api/recipe/` for
/// [sort] (docs/TANDOOR_API.md). `null` leaves a parameter out.
///
/// Relevance sends no `sort_order`: Tandoor then ranks text matches by score
/// where the user's search preference scores them, and sorts by name
/// otherwise. An explicit `score` would be dropped without a text search.
({String? sortOrder, bool? random}) sortParams(RecipeSort sort) =>
    switch (sort) {
      RecipeSort.relevance => (sortOrder: null, random: null),
      RecipeSort.name => (sortOrder: 'name', random: null),
      RecipeSort.lastCooked => (sortOrder: '-lastcooked', random: null),
      RecipeSort.rating => (sortOrder: '-rating', random: null),
      RecipeSort.newest => (sortOrder: '-created_at', random: null),
      RecipeSort.recentlyViewed => (sortOrder: '-lastviewed', random: null),
      RecipeSort.random => (sortOrder: null, random: true),
    };
