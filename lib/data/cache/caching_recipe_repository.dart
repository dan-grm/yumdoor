import 'dart:async';
import 'dart:typed_data';

import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/models/result_page.dart';
import '../../domain/repositories/recipe_repository.dart';
import 'recipe_cache.dart';

/// Asks the server first and falls back to the [RecipeCache] when it can't be
/// reached ([OfflineFailure]).
///
/// Every recipe fetched is stored, with its image if [downloadImage] is
/// given. Search results are not stored; offline search goes through the
/// stored recipes instead.
class CachingRecipeRepository implements RecipeRepository {
  CachingRecipeRepository(this._remote, this._cache, {this.downloadImage});

  final RecipeRepository _remote;
  final RecipeCache _cache;

  /// The image at a URL, `null` if it shouldn't be stored. May throw.
  final Future<Uint8List?> Function(Uri url)? downloadImage;

  @override
  Future<Recipe> fetchRecipe(int id) async {
    final Recipe recipe;
    try {
      recipe = await _remote.fetchRecipe(id);
    } on OfflineFailure {
      return await _cache.get(id) ?? (throw const OfflineFailure());
    } on NotFoundFailure {
      // Deleted, or no longer shared with the user.
      await _ignoreErrors(_cache.remove(id));
      rethrow;
    }
    // In the background: the recipe is there, however slow the cache is.
    unawaited(_ignoreErrors(_store(recipe)));
    return recipe;
  }

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) async {
    try {
      return await _remote.search(
        query,
        page: page,
        pageSize: pageSize,
        cancel: cancel,
      );
    } on OfflineFailure {
      // Offline results come as one page; a later page can't fall back.
      if (page != 1) rethrow;
      final recipes = await _cache.all();
      if (cancel?.isCancelled ?? false) throw const CancelledFailure();
      final items = [
        for (final recipe in recipes)
          if (_matches(recipe, query)) recipe.summary,
      ];
      return ResultPage(
        items: items,
        totalCount: items.length,
        hasMore: false,
        fromCache: true,
      );
    }
  }

  Future<void> _store(Recipe recipe) async {
    await _cache.put(recipe);
    final url = recipe.image;
    final download = downloadImage;
    if (download == null || url == null) return;
    if (!url.isScheme('https') && !url.isScheme('http')) return;
    if (await _cache.hasImage(url)) return;
    final bytes = await download(url);
    if (bytes != null) await _cache.putImage(url, bytes);
  }
}

/// Whether [recipe] matches [query], as close to the server as the stored
/// data allows: the text against the name only, and foods without their
/// child foods.
bool _matches(Recipe recipe, RecipeQuery query) {
  final text = query.text.trim().toLowerCase();
  if (!recipe.name.toLowerCase().contains(text)) return false;
  if (query.keywordIds.isNotEmpty) {
    final keywords = {for (final keyword in recipe.keywords) keyword.id};
    if (!keywords.containsAll(query.keywordIds)) return false;
  }
  if (query.foodIds.isNotEmpty) {
    final foods = {
      for (final step in recipe.steps)
        for (final ingredient in step.ingredients) ?ingredient.food?.id,
    };
    if (!foods.containsAll(query.foodIds)) return false;
  }
  if (query.minRating case final minRating?) {
    if ((recipe.rating ?? 0) < minRating) return false;
  }
  if (query.lastCookedBefore case final before?) {
    final cooked = recipe.lastCooked;
    if (cooked == null) return false;
    final day = DateTime(before.year, before.month, before.day + 1);
    if (!cooked.isBefore(day)) return false;
  }
  return true;
}

/// The cache is a convenience: when it fails, the app works as without it.
Future<void> _ignoreErrors(Future<void> future) async {
  try {
    await future;
  } on Object {
    // Nothing to do; the next fetch tries again.
  }
}
