import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/models/result_page.dart';
import '../../domain/repositories/cook_log_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/recipe_mapper.dart';
import '../mappers/recipe_sort_mapper.dart';

class TandoorRecipeRepository implements RecipeRepository {
  TandoorRecipeRepository(this._api, {this.lastCooked});

  final api.ApiApi _api;

  /// When the current user last cooked a recipe. Tandoor 2.6.15 sends
  /// `last_cooked: null` on every recipe, so [fetchRecipe] asks this instead
  /// (see [CookLogRepository.lastCooked]).
  final Future<DateTime?> Function(int recipeId)? lastCooked;

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) => guardRequest(() async {
    final text = query.text.trim();
    // Tandoor's default order is ours: by relevance with text, else by name.
    final sort = query.sort == null
        ? (sortOrder: null, random: null)
        : sortParams(query.effectiveSort);
    final response = await _api.apiRecipeList(
      query: text.isEmpty ? null : text,
      // `foods_and` includes child foods (`include_children` defaults to
      // true), so filtering by "Wurzelgemüse" finds carrot recipes.
      foodsAnd: query.foodIds.isEmpty ? null : BuiltList.of(query.foodIds),
      keywordsAnd: query.keywordIds.isEmpty
          ? null
          : BuiltList.of(query.keywordIds),
      // Combined with the other parameters by AND, like all of them.
      foodsOr: query.anyFoodIds.isEmpty ? null : BuiltList.of(query.anyFoodIds),
      keywordsOr: query.anyKeywordIds.isEmpty
          ? null
          : BuiltList.of(query.anyKeywordIds),
      ratingGte: query.minRating,
      cookedonLte: switch (query.lastCookedBefore) {
        final day? => api.Date(day.year, day.month, day.day),
        null => null,
      },
      // `timescooked_lte` would leave out recipes cooked 0 times, so "never"
      // is the exact count (docs/TANDOOR_API.md).
      timescooked: query.neverCooked ? 0 : null,
      timescookedGte: query.neverCooked ? null : query.minTimesCooked,
      // An int on Tandoor, although the schema says boolean
      // (docs/TANDOOR_API.md).
      makenow: query.maxMissingFoods,
      booksOr: query.bookIds.isEmpty ? null : BuiltList.of(query.bookIds),
      createdby: query.createdBy,
      // A single key: Tandoor has no second key for ties, so recipes that
      // are equal can move between pages (docs/TANDOOR_API.md).
      sortOrder: sort.sortOrder,
      // Every page is drawn anew; the universal search drops repeats.
      random: sort.random,
      page: page,
      pageSize: pageSize,
      cancelToken: cancelTokenFor(cancel),
    );
    final body = requireBody(response.data);
    return ResultPage(
      items: [for (final recipe in body.results) recipe.toDomain()],
      totalCount: body.count,
      hasMore: body.next != null,
    );
  });

  @override
  Future<Recipe> fetchRecipe(int id) async {
    // In parallel with the recipe. It's a detail: if it fails, the recipe
    // is shown without it.
    final cooked = _lastCooked(id);
    final recipe = await guardRequest(() async {
      final response = await _api.apiRecipeRetrieve(id: id);
      return requireBody(response.data).toDomain();
    });
    if (recipe.lastCooked != null) return recipe;
    return recipe.copyWith(lastCooked: await cooked);
  }

  Future<DateTime?> _lastCooked(int id) async {
    try {
      return await lastCooked?.call(id);
    } on Failure {
      return null;
    }
  }
}
