import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_sort.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/models/result_page.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/services/recipe_order.dart';
import '../../domain/services/text_match.dart';
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
      // Which books a recipe is in isn't stored; nothing is known to match.
      final recipes = query.bookIds.isEmpty
          ? await _cache.all()
          : const <Recipe>[];
      if (cancel?.isCancelled ?? false) throw const CancelledFailure();
      final text = TextMatcher(query.text);
      final items = [
        for (final recipe in recipes)
          if (_matches(recipe, query, text)) recipe.summary,
      ];
      _sort(items, query);
      return ResultPage(
        items: items,
        totalCount: items.length,
        hasMore: false,
        fromCache: true,
      );
    }
  }

  /// Views are only recorded online; offline there is nothing to record
  /// them in (offline is read-only).
  @override
  Future<void> recordView(int id) => _remote.recordView(id);

  Future<void> _store(Recipe recipe) async {
    // A missing date usually means the cook log couldn't be read (see
    // TandoorRecipeRepository.lastCooked); keep the one stored before.
    if (recipe.lastCooked == null) {
      final stored = (await _cache.get(recipe.id))?.lastCooked;
      if (stored != null) recipe = recipe.copyWith(lastCooked: stored);
    }
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

/// Sorts [items], which come most recently opened first, in the order of
/// [query] ([RecipeQuery.effectiveSort]), as close to the server as the
/// stored data allows. By relevance (there is no score offline; the universal
/// search puts name matches first) and by recently viewed (opened in
/// Yumdoor) they stay as they are; equal ones too.
void _sort(List<RecipeSummary> items, RecipeQuery query) {
  if (query.effectiveSort == RecipeSort.random) {
    items.shuffle(Random());
    return;
  }
  final order = recipeOrder(query.effectiveSort);
  if (order == null) return;
  final position = {for (final (i, r) in items.indexed) r.id: i};
  items.sort((a, b) {
    final result = order(a, b);
    return result != 0 ? result : position[a.id]! - position[b.id]!;
  });
}

/// Whether [recipe] matches [query], as close to the server as the stored
/// data allows: the text against the name, the ingredients' foods and the
/// keywords (like the universal search), and foods and keywords without
/// their children.
bool _matches(Recipe recipe, RecipeQuery query, TextMatcher text) {
  final foods = recipe.foods;
  final foodIds = {for (final food in foods) food.id};
  final keywordIds = {for (final keyword in recipe.keywords) keyword.id};
  if (!text.isEmpty &&
      !text.contains(recipe.name) &&
      !foods.any(text.food) &&
      !recipe.keywords.any(text.keyword)) {
    return false;
  }
  if (!keywordIds.containsAll(query.keywordIds)) return false;
  if (!foodIds.containsAll(query.foodIds)) return false;
  if (query.anyFoodIds.isNotEmpty && !query.anyFoodIds.any(foodIds.contains)) {
    return false;
  }
  if (query.anyKeywordIds.isNotEmpty &&
      !query.anyKeywordIds.any(keywordIds.contains)) {
    return false;
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
  // The cache has no cook counts, only when it was last cooked: "never" is
  // exact, "at least n times" can only tell cooked from not cooked.
  if (query.neverCooked && recipe.lastCooked != null) return false;
  if (query.minTimesCooked != null && recipe.lastCooked == null) return false;
  if (query.createdBy case final user? when recipe.createdBy?.id != user) {
    return false;
  }
  // On hand as of when the recipe was stored, and without the substitutes
  // Tandoor also counts. Tandoor doesn't skip an ignore-shopping food that is
  // itself a recipe, which the cache can't tell.
  if (query.maxMissingFoods case final max?) {
    final missing = foods.where((f) => !f.onHand && !f.ignoreShopping);
    if (missing.length > max) return false;
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
