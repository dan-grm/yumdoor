/// How search results are ordered.
///
/// Tandoor 2.6.15 can't sort by how often a recipe was cooked (its
/// `times_cooked` sort order is a server error), so that isn't offered.
enum RecipeSort {
  /// Best match for the search text first; by name without text.
  relevance,

  /// Alphabetically.
  name,

  /// Most recently cooked by the current user first, never cooked last.
  lastCooked,

  /// Best rated by the current user first, unrated last.
  rating,

  /// Most recently created first.
  newest,

  /// Most recently viewed by the current user first, never viewed last.
  recentlyViewed,

  /// A random order.
  random,
}
