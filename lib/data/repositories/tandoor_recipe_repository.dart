import 'dart:convert';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../../domain/models/image_upload.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/models/result_page.dart';
import '../../domain/repositories/cook_log_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../api/api_failures.dart';
import '../api/extra_query_interceptor.dart';
import '../mappers/mapping.dart';
import '../mappers/recipe_draft_mapper.dart';
import '../mappers/recipe_mapper.dart';
import '../mappers/recipe_sort_mapper.dart';

class TandoorRecipeRepository implements RecipeRepository {
  TandoorRecipeRepository(this._api, {required this._dio, this.lastCooked});

  final api.ApiApi _api;

  /// The [Dio] behind [_api], for the image upload: the generated client
  /// takes the file as a string (docs/TANDOOR_API.md#recipe-images).
  final Dio _dio;

  /// When the current user last cooked a recipe. Tandoor 2.6.15 sends
  /// `last_cooked: null` on every recipe, so [fetchRecipe] asks this instead
  /// (see [CookLogRepository.lastCooked]).
  final Future<DateTime?> Function(int recipeId)? lastCooked;

  /// The saved searches of dynamic books and saved filters, shared by the
  /// searches and pages that need one within [_savedSearchLifetime].
  final _savedSearches =
      <_SavedSearchSource, ({DateTime loaded, Future<_SavedSearch?> search})>{};

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) async {
    final sources = [
      if (query.savedSearchOfBook case final book?) (book: true, id: book),
      if (query.savedFilter case final filter?) (book: false, id: filter),
    ];
    if (sources.isEmpty) {
      return guardRequest(() async {
        final response = await _list(query, page, pageSize, cancel);
        return _resultPage(requireBody(response.data));
      });
    }
    final saved = await _whileWanted(
      Future.wait([
        for (final source in sources)
          _savedSearch(source, firstPage: page == 1),
      ]),
      cancel,
    );
    if (saved.contains(null)) {
      return const ResultPage(items: [], totalCount: 0, hasMore: false);
    }
    final searches = saved.nonNulls.toList();
    // The first saved search's parameters go with ours; a later one's where
    // they don't clash with an earlier one's. Each one that couldn't send
    // all of its own is checked by the ids it finds.
    final extraQuery = <String, Object>{};
    final checked = <_SavedSearch>{};
    for (final search in searches) {
      // Its own parameters don't clash with each other, only with those of
      // the saved searches before it.
      final earlier = extraQuery.keys.toSet();
      for (final MapEntry(:key, :value) in search.mergeable.entries) {
        if (ExtraQueryInterceptor.clashes(key, earlier)) {
          checked.add(search);
        } else {
          extraQuery[key] = value;
        }
      }
    }
    return guardRequest(() async {
      final response = await _list(
        query,
        page,
        // Pages filtered by the ids can come back nearly empty; fewer, larger
        // ones save round trips. Always, so the pages of a search line up.
        max(pageSize, _idPageSize),
        cancel,
        extraQuery: extraQuery,
      );
      final body = requireBody(response.data);
      final skipped =
          response.requestOptions.extra[ExtraQueryInterceptor.skippedKey];
      for (final search in searches) {
        // Without the interceptor's answer, nothing of it was sent.
        if (search.needsIds ||
            skipped is! List ||
            search.mergeable.keys.any(skipped.contains)) {
          checked.add(search);
        }
      }
      if (checked.isEmpty) return _resultPage(body);
      // A parameter both send can only hold one value: this request left out
      // the saved search's, so keep what the whole saved search finds.
      final ids = (await Future.wait([
        for (final search in checked)
          _whileWanted(search.ids(() => _savedSearchIds(search)), cancel),
      ])).reduce((a, b) => a.intersection(b));
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

  /// The saved search of [source], `null` if a book has none (any more), it
  /// can't be read or isn't there (any more). For a [firstPage], only one
  /// loaded moments ago is reused: the searches of one universal search
  /// start together, a new one sees changes made since.
  Future<_SavedSearch?> _savedSearch(
    _SavedSearchSource source, {
    required bool firstPage,
  }) {
    final now = DateTime.now();
    _savedSearches.removeWhere(
      (_, entry) => now.difference(entry.loaded) > _savedSearchLifetime,
    );
    if (_savedSearches[source] case final entry?
        when !firstPage || now.difference(entry.loaded) < _sameSearch) {
      return entry.search;
    }
    final load = source.book
        ? _loadSavedSearchOfBook(source.id)
        : _loadSavedFilter(source.id);
    _savedSearches[source] = (loaded: now, search: load);
    // A failed load isn't kept; the caller gets the failure from [load].
    load.catchError((Object _) {
      if (identical(_savedSearches[source]?.search, load)) {
        _savedSearches.remove(source);
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

  Future<_SavedSearch?> _loadSavedSearchOfBook(int bookId) async {
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

  /// The saved filter [id], from the list: Tandoor answers 403 when someone
  /// it is shared with asks for it by id (docs/TANDOOR_API.md).
  Future<_SavedSearch?> _loadSavedFilter(int id) => guardRequest(() async {
    for (var page = 1; ; page++) {
      final response = await _api.apiCustomFilterList(
        page: page,
        pageSize: _idPageSize,
      );
      final body = requireBody(response.data);
      for (final filter in body.results) {
        if (filter.id == id) return _SavedSearch.parse(filter.search);
      }
      // Deleted, or no longer shared with the user.
      if (body.next == null) return null;
    }
  });

  /// The ids of every recipe [saved] finds, by itself. Not cancelled with
  /// one search: others may be waiting for it.
  Future<Set<int>> _savedSearchIds(_SavedSearch saved) =>
      guardRequest(() async {
        Future<api.PaginatedRecipeOverviewList?> load(int page) async {
          try {
            final response = await _api.apiRecipeList(
              page: page,
              pageSize: _idPageSize,
              // By name, recipes of the same name could swap pages; creation
              // times hardly ever tie.
              sortOrder: 'created_at',
              extra: {ExtraQueryInterceptor.paramsKey: saved.all},
            );
            return requireBody<api.PaginatedRecipeOverviewList>(response.data);
          } on DioException catch (e) {
            // Recipes were deleted since the first page.
            if (page > 1 && e.response?.statusCode == 404) return null;
            rethrow;
          }
        }

        final first = (await load(1))!;
        final ids = {for (final recipe in first.results) ?recipe.id};
        final pages = (first.count / _idPageSize).ceil();
        // The other pages a few at a time, to spare the server.
        for (var page = 2; page <= pages; page += _idParallelPages) {
          final bodies = await Future.wait([
            for (var p = page; p < page + _idParallelPages && p <= pages; p++)
              load(p),
          ]);
          for (final body in bodies.nonNulls) {
            ids.addAll([for (final recipe in body.results) ?recipe.id]);
          }
        }
        return ids;
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
  Future<Recipe> fetchRecipe(int id, {bool allowCached = true}) async {
    // Nothing is cached here; see CachingRecipeRepository.
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
  Future<Recipe> createRecipe(RecipeDraft draft) => guardRequest(() async {
    final response = await _api.apiRecipeCreate(recipe: draft.toApiRecipe());
    return requireBody(response.data).toDomain();
  });

  @override
  Future<Recipe> updateRecipe(int id, RecipeDraft draft) async {
    // In parallel, as in fetchRecipe.
    final cooked = _lastCooked(id);
    // A PATCH, so the fields a draft doesn't hold stay as they are
    // (docs/TANDOOR_API.md#recipe-writes). The response is the recipe as
    // saved, like a fetch.
    final recipe = await guardRequest(() async {
      final response = await _api.apiRecipePartialUpdate(
        id: id,
        patchedRecipe: draft.toPatchedRecipe(),
      );
      return requireBody(response.data).toDomain();
    });
    if (recipe.lastCooked != null) return recipe;
    return recipe.copyWith(lastCooked: await cooked);
  }

  @override
  Future<Uri> uploadImage(int id, ImageUpload image) async {
    final path = await _putImage(
      id,
      FormData.fromMap({
        'image': MultipartFile.fromBytes(
          image.bytes,
          filename: image.fileName,
          contentType: DioMediaType.parse(image.mimeType),
        ),
      }),
      upload: true,
    );
    if (path == null) throw const ServerFailure(cause: 'No image path');
    // Relative to the server's origin (`/media/recipes/…`, or wherever
    // `MEDIA_URL` puts it), like the absolute URL a fetch would give.
    return Uri.parse(_dio.options.baseUrl).resolve(path);
  }

  @override
  Future<void> removeImage(int id) async {
    // A form without `image` and `image_url` clears the image
    // (docs/TANDOOR_API.md#recipe-images).
    await _putImage(id, FormData());
  }

  /// `PUT /api/recipe/{id}/image/` with [form]; returns the path of the
  /// image the recipe has now, `null` for none.
  ///
  /// An [upload] that ends without an answer fails with
  /// [UploadInterruptedFailure]: a proxy refusing the size often resets the
  /// connection instead of answering 413 (docs/TANDOOR_API.md#recipe-images).
  Future<String?> _putImage(
    int id,
    FormData form, {
    bool upload = false,
  }) async {
    final Response<Object?> response;
    try {
      response = await _dio.put<Object?>(
        '/api/recipe/$id/image/',
        data: form,
        options: Options(
          // Sending a large photo over a slow connection, then Tandoor
          // scaling it, takes longer than an ordinary request may. On the
          // web this is the whole request's timeout.
          receiveTimeout: _imageTimeout,
        ),
      );
    } on DioException catch (e) {
      // A reset while sending is `connectionError` on the web, and
      // `unknown` (a SocketException) on native.
      if (upload &&
          e.response == null &&
          (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.unknown)) {
        throw const UploadInterruptedFailure();
      }
      throw failureFromDioException(e);
    }
    return switch (response.data) {
      {'image': final String? path} => path,
      final body => throw ServerFailure(cause: body),
    };
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

/// How long an image upload may take.
const _imageTimeout = Duration(minutes: 5);

/// Recipes per request when loading every recipe a saved search finds; the
/// most Tandoor allows for recipes.
const _idPageSize = 100;

/// How many of those requests run at once.
const _idParallelPages = 4;

/// How long a dynamic book's saved search, and what it finds, is reused for
/// the later pages of a search.
const _savedSearchLifetime = Duration(minutes: 1);

/// Where a saved search comes from: a dynamic book or a saved filter, by id.
typedef _SavedSearchSource = ({bool book, int id});

/// How long it is reused for first pages, which belong to one search.
const _sameSearch = Duration(seconds: 5);

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
      // JSON keys are strings.
      key as String;
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
  /// against [ids]: unless [_global] is Tandoor's default, `true`.
  bool get needsIds => all.containsKey(_global) && all[_global] != 'true';

  Future<Set<int>>? _ids;

  /// The ids of every recipe the saved search finds, loaded with [load] the
  /// first time.
  Future<Set<int>> ids(Future<Set<int>> Function() load) {
    if (_ids case final ids?) return ids;
    final ids = _ids = load();
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
  /// either. Tandoor's search page saves some lists as objects (units, as
  /// `[{"id": 3, "name": "g", …}]`); their ids are what it means.
  static Object? _queryValue(Object? value) {
    String? item(Object? item) => switch (item) {
      bool() || num() || String() => '$item',
      {'id': final num id} => '$id',
      _ => null,
    };
    return switch (value) {
      List() => switch ([for (final i in value) item(i)]) {
        final items when !items.contains(null) => ListParam<String>(
          items.cast(),
          ListFormat.multi,
        ),
        _ => null,
      },
      _ => item(value),
    };
  }
}
