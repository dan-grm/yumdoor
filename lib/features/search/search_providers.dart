import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/offline.dart';
import '../../app/repository_providers.dart';
import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../../domain/models/food.dart';
import '../../domain/models/keyword.dart';
import '../../domain/models/recipe_book.dart';
import '../../domain/models/recipe_match.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/user_ref.dart';
import '../../domain/services/universal_search.dart';

part 'search_providers.g.dart';

/// Recipes per request while scrolling through results.
const searchPageSize = 25;

/// How long typing has to pause before the search or a picker asks the server.
const searchDebounce = Duration(milliseconds: 300);

/// Suggestions shown in the food and keyword pickers.
const _suggestionLimit = 20;

/// The results loaded so far for a search.
class RecipeResults {
  const RecipeResults({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    this.fromCache = false,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<RecipeMatch> items;

  /// The number of results over all pages.
  final int totalCount;
  final bool hasMore;

  /// The server couldn't be reached; these are matching recipes from the
  /// offline cache.
  final bool fromCache;

  /// Whether the next page is being loaded.
  final bool loadingMore;

  /// Why the next page failed to load; [SearchResults.loadMore] retries.
  final Failure? loadMoreError;
}

/// Searches names, ingredients and keywords at once.
@riverpod
UniversalSearch universalSearch(Ref ref) => UniversalSearch(
  recipes: ref.watch(recipeRepositoryProvider),
  foods: ref.watch(foodRepositoryProvider),
  keywords: ref.watch(keywordRepositoryProvider),
);

/// Results for [query], one page at a time.
///
/// A new query is a new provider; the old one is disposed and its requests
/// cancelled, so a slow answer to an old query can't replace a newer one.
@Riverpod(retry: _noRetry)
class SearchResults extends _$SearchResults {
  late RecipeSearch _search;

  @override
  Future<RecipeResults> build(RecipeQuery query) async {
    final cancel = CancelSignal();
    ref.onDispose(cancel.cancel);
    final search = _search = ref
        .watch(universalSearchProvider)
        .start(query, pageSize: searchPageSize, cancel: cancel);
    final page = await search.next();
    if (page.fromCache) {
      // Ask the server again as soon as it may answer.
      ref.listen(isOfflineProvider, (_, offline) {
        if (!offline) ref.invalidateSelf();
      });
    }
    return RecipeResults(
      items: page.items,
      totalCount: page.totalCount,
      hasMore: page.hasMore,
      fromCache: page.fromCache,
    );
  }

  /// Appends the next page. Does nothing while one is loading or when there
  /// is none.
  Future<void> loadMore() async {
    final current = state.value;
    // While the search reloads (e.g. back online), the next page would come
    // from the new search before its first page.
    if (current == null ||
        state.isLoading ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    state = AsyncData(
      RecipeResults(
        items: current.items,
        totalCount: current.totalCount,
        hasMore: true,
        fromCache: current.fromCache,
        loadingMore: true,
      ),
    );
    final search = _search;
    try {
      final page = await search.next();
      if (!identical(search, _search) || !ref.mounted) return;
      state = AsyncData(
        RecipeResults(
          items: [...current.items, ...page.items],
          totalCount: page.totalCount,
          hasMore: page.hasMore,
          fromCache: page.fromCache,
        ),
      );
    } on Failure catch (failure) {
      if (!identical(search, _search) || !ref.mounted) return;
      if (failure is CancelledFailure) return;
      state = AsyncData(
        RecipeResults(
          items: current.items,
          totalCount: current.totalCount,
          hasMore: true,
          fromCache: current.fromCache,
          loadMoreError: failure,
        ),
      );
    }
  }
}

/// A food by id, for the label of a filter chip opened from a link.
@Riverpod(retry: _noRetry)
Future<Food> food(Ref ref, int id) =>
    ref.watch(foodRepositoryProvider).fetchFood(id);

/// A keyword by id, for the label of a filter chip opened from a link.
@Riverpod(retry: _noRetry)
Future<Keyword> keyword(Ref ref, int id) =>
    ref.watch(keywordRepositoryProvider).fetchKeyword(id);

/// Foods matching what was typed into the food picker.
@Riverpod(retry: _noRetry)
Future<List<Food>> foodSuggestions(Ref ref, String query) {
  final cancel = CancelSignal();
  ref.onDispose(cancel.cancel);
  return ref
      .watch(foodRepositoryProvider)
      .autocomplete(query, limit: _suggestionLimit, cancel: cancel);
}

/// Keywords matching what was typed into the keyword picker.
@Riverpod(retry: _noRetry)
Future<List<Keyword>> keywordSuggestions(Ref ref, String query) {
  final cancel = CancelSignal();
  ref.onDispose(cancel.cancel);
  return ref
      .watch(keywordRepositoryProvider)
      .autocomplete(query, limit: _suggestionLimit, cancel: cancel);
}

/// The user's recipe books, for the book filter and its chips.
@Riverpod(retry: _noRetry)
Future<List<RecipeBook>> recipeBooks(Ref ref) =>
    _reloadOnline(ref, ref.watch(bookRepositoryProvider).books());

/// The members of the space, for the created-by filter and its chip.
@Riverpod(retry: _noRetry)
Future<List<UserRef>> spaceUsers(Ref ref) =>
    _reloadOnline(ref, ref.watch(userRepositoryProvider).users());

/// [request], loaded again once the server can be reached if it failed
/// because it couldn't, so chips opened offline get their names back.
Future<T> _reloadOnline<T>(Ref ref, Future<T> request) async {
  try {
    return await request;
  } on OfflineFailure {
    ref.listen(isOfflineProvider, (_, offline) {
      if (!offline) ref.invalidateSelf();
    });
    rethrow;
  }
}

Duration? _noRetry(int retryCount, Object error) => null;
