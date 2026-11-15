import 'dart:convert';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
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
import '../api/extra_query_interceptor.dart';
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

  /// The saved searches of dynamic books by book id, shared by the searches
  /// and pages that need one within [_savedSearchLifetime].
  final _savedSearches =
      <int, ({DateTime loaded, Future<_SavedSearch?> search})>{};

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) async {
    final book = query.savedSearchOfBook;
    if (book == null) {
      return guardRequest(() async {
        final response = await _list(query, page, pageSize, cancel);
        return _resultPage(requireBody(response.data));
      });
    }
    final saved = await _whileWanted(_savedSearch(book), cancel);
    if (saved == null) {
      return const ResultPage(items: [], totalCount: 0, hasMore: false);
    }
    return guardRequest(() async {
      final response = await _list(
        query,
        page,
        pageSize,
        cancel,
        extraQuery: saved.mergeable,
      );
      final body = requireBody(response.data);
      final skipped =
          response.requestOptions.extra[ExtraQueryInterceptor.skippedKey];
      if (!saved.needsIds && (skipped is! List || skipped.isEmpty)) {
        return _resultPage(body);
      }
      // A parameter both send can only hold one value: this request left out
      // the saved search's, so keep what the whole saved search finds.
      final ids = await _whileWanted(
        saved.ids(() => _savedSearchIds(saved)),
        cancel,
      );
      final items = [
        for (final recipe in body.results)
          if (ids.contains(recipe.id)) recipe.toDomain(),
      ];
      final hasMore = body.next != null;
      return ResultPage(
        items: items,
        totalCount: page == 1 && !hasMore
            ? items.length
            : min(body.count, ids.length),
        hasMore: hasMore,
      );
    });
  }

  ResultPage<RecipeSummary> _resultPage(api.PaginatedRecipeOverviewList body) =>
      ResultPage(
        items: [for (final recipe in body.results) recipe.toDomain()],
        totalCount: body.count,
        hasMore: body.next != null,
      );

  /// The saved search of [bookId], `null` if it has none (any more), can't
  /// be read or the book isn't there (any more).
  Future<_SavedSearch?> _savedSearch(int bookId) {
    final now = DateTime.now();
    _savedSearches.removeWhere(
      (_, entry) => now.difference(entry.loaded) > _savedSearchLifetime,
    );
    if (_savedSearches[bookId] case final entry?) return entry.search;
    final load = _loadSavedSearch(bookId);
    _savedSearches[bookId] = (loaded: now, search: load);
    // A failed load isn't kept; the caller gets the failure from [load].
    load.catchError((Object _) {
      if (identical(_savedSearches[bookId]?.search, load)) {
        _savedSearches.remove(bookId);
      }
      return null;
    });
    return load;
  }

  /// [shared], which other searches may wait for too, or [CancelledFailure]
  /// as soon as [cancel] fires; [shared] itself goes on.
  Future<T> _whileWanted<T>(Future<T> shared, CancelSignal? cancel) {
    if (cancel == null) return shared;
    if (cancel.isCancelled) return Future.error(const CancelledFailure());
    return Future.any([
      shared,
      cancel.whenCancelled.then<T>((_) => throw const CancelledFailure()),
    ]);
  }

  Future<_SavedSearch?> _loadSavedSearch(int bookId) async {
    try {
      return await guardRequest(() async {
        final response = await _api.apiRecipeBookRetrieve(id: bookId);
        final filter = requireBody(response.data).filter;
        return filter == null ? null : _SavedSearch.parse(filter.search);
      });
    } on NotFoundFailure {
      // Deleted, or no longer shared with the user.
      return null;
    }
  }

  /// The ids of every recipe [saved] finds, by itself. Not cancelled with
  /// one search: others may be waiting for it.
  Future<Set<int>> _savedSearchIds(_SavedSearch saved) =>
      guardRequest(() async {
        final ids = <int>{};
        for (var page = 1; ; page++) {
          final response = await _api.apiRecipeList(
            page: page,
            pageSize: _idPageSize,
            extra: {ExtraQueryInterceptor.paramsKey: saved.all},
          );
          final body = requireBody(response.data);
          ids.addAll([for (final recipe in body.results) ?recipe.id]);
          if (body.next == null) return ids;
        }
      });

  Future<Response<api.PaginatedRecipeOverviewList>> _list(
    RecipeQuery query,
    int page,
    int pageSize,
    CancelSignal? cancel, {
    Map<String, Object>? extraQuery,
  }) {
    final text = query.text.trim();
    // Tandoor's default order is ours: by relevance with text, else by name.
    final sort = query.sort == null
        ? (sortOrder: null, random: null)
        : sortParams(query.effectiveSort);
    return _api.apiRecipeList(
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
      // The saved search of a dynamic book, where it doesn't clash with
      // these (ExtraQueryInterceptor).
      extra: extraQuery == null
          ? null
          : {ExtraQueryInterceptor.paramsKey: extraQuery},
    );
  }

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

  @override
  Future<void> recordView(int id) => guardRequest(() async {
    // Tandoor keeps one view per recipe and user every 5 minutes, so opening
    // a recipe again soon after doesn't add one (docs/TANDOOR_API.md).
    await _api.apiViewLogCreate(viewLog: api.ViewLog((b) => b..recipe = id));
  });

  Future<DateTime?> _lastCooked(int id) async {
    try {
      return await lastCooked?.call(id);
    } on Failure {
      return null;
    }
  }
}

/// Recipes per request when loading every recipe a saved search finds; the
/// most Tandoor allows for recipes.
const _idPageSize = 100;

/// How long a dynamic book's saved search, and what it finds, is reused.
const _savedSearchLifetime = Duration(minutes: 1);

/// The saved search of a dynamic book (a Tandoor `CustomFilter`): the search
/// parameters Tandoor stored as JSON, as query parameters.
///
/// Tandoor's `filter=<id>` parameter replaces every other one, so the
/// parameters are sent next to ours instead (docs/TANDOOR_API.md).
class _SavedSearch {
  _SavedSearch(this.all);

  /// The saved search as JSON, `null` if it can't be read, which Tandoor
  /// couldn't either. Only the parameters that narrow the search are kept:
  /// its order, its page and what it pins to the top don't apply.
  static _SavedSearch? parse(String json) {
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      return null;
    }
    if (decoded is! Map) return null;
    final params = <String, Object>{};
    for (final MapEntry(:key, :value) in decoded.entries) {
      if (key is! String) return null;
      if (_ignored.contains(key) || _isEmpty(value)) continue;
      final param = _queryValue(value);
      if (param == null) return null;
      params[key] = param;
    }
    // Tandoor reads `keywords` only without `keywords_or`; one name for each
    // lets a clash with ours be seen.
    for (final MapEntry(key: alias, value: name) in _aliases.entries) {
      final value = params.remove(alias);
      if (value != null) params.putIfAbsent(name, () => value);
    }
    return _SavedSearch(params);
  }

  static const _aliases = {
    'keywords': 'keywords_or',
    'foods': 'foods_or',
    'books': 'books_or',
  };

  static const _ignored = {
    'sort_order',
    'random',
    'new',
    'num_recent',
    'page',
    'page_size',
    'filter',
    'version',
  };

  /// Changes what our food and keyword parameters match, not only what the
  /// saved search's do.
  static const _global = 'include_children';

  /// Every parameter of the saved search.
  final Map<String, Object> all;

  /// The parameters that can be sent with ours.
  late final Map<String, Object> mergeable = {...all}..remove(_global);

  /// Whether the results of a request with [mergeable] have to be checked
  /// against [ids].
  bool get needsIds => all.containsKey(_global);

  Future<Set<int>>? _ids;

  /// The ids of every recipe the saved search finds, loaded with [load] the
  /// first time.
  Future<Set<int>> ids(Future<Set<int>> Function() load) {
    final ids = _ids ??= load();
    // A failed load is tried again next time.
    ids.catchError((Object _) {
      if (identical(_ids, ids)) _ids = null;
      return const <int>{};
    });
    return ids;
  }

  /// Whether Tandoor treats [value] as not given.
  static bool _isEmpty(Object? value) =>
      value == null || value == '' || (value is List && value.isEmpty);

  /// [value] as a query parameter, `null` for what Tandoor can't use
  /// either (objects).
  static Object? _queryValue(Object? value) => switch (value) {
    bool() || num() || String() => '$value',
    List() when value.every((i) => i is bool || i is num || i is String) =>
      ListParam<String>([for (final i in value) '$i'], ListFormat.multi),
    _ => null,
  };
}
