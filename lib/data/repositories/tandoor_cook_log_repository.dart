import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/failures.dart';
import '../../domain/models/cook_log.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/repositories/cook_log_repository.dart';
import '../api/api_failures.dart';
import '../mappers/cook_log_mapper.dart';
import '../mappers/mapping.dart';
import '../mappers/recipe_mapper.dart';
import 'current_user.dart';

/// Cook log entries per request page; the server allows up to 200.
const _pageSize = 100;

/// How many pages [TandoorCookLogRepository.lastCooked] reads at most, from
/// the newest. Older entries of the current user are not found.
const _maxPages = 3;

/// How many pages [TandoorCookLogRepository.recent] reads at most, from the
/// newest.
const _maxRecentPages = 5;

class TandoorCookLogRepository implements CookLogRepository {
  /// [storedRecipe] gives a recipe stored for offline use, if there is one,
  /// so [recent] doesn't have to fetch it. A stored copy is trusted: a
  /// recipe made private since it was stored still shows, as it was stored.
  TandoorCookLogRepository(
    this._api, {
    CurrentUser? currentUser,
    this.storedRecipe,
  }) : _currentUser = currentUser ?? CurrentUser(_api);

  final api.ApiApi _api;
  final CurrentUser _currentUser;

  /// The stored copy of a recipe, `null` if there is none. May throw.
  final Future<RecipeSummary?> Function(int id)? storedRecipe;

  @override
  Future<CookLog> create(NewCookLog entry) => guardRequest(() async {
    final response = await _api.apiCookLogCreate(cookLog: entry.toApi());
    return requireBody(response.data).toDomain();
  });

  @override
  Future<void> delete(int id) =>
      guardRequest(() => _api.apiCookLogDestroy(id: id));

  /// Tandoor 2.6.15 always sends `last_cooked: null` on recipes
  /// (docs/TANDOOR_API.md#cook-log-ratings-comments-feed), so this reads the
  /// recipe's cook log. It lists every user's entries by id, oldest first;
  /// the newest pages are searched for the current user's.
  @override
  Future<DateTime?> lastCooked(int recipeId) => guardRequest(() async {
    Future<api.PaginatedCookLogList> page(int number) async => requireBody(
      (await _api.apiCookLogList(
        recipe: recipeId,
        page: number,
        pageSize: _pageSize,
      )).data,
    );

    // Most recipes have fewer entries than one page, so page 1 usually
    // answers it. The user is looked up meanwhile.
    final user = _currentUser.id();
    final first = await page(1);
    final userId = await user;
    final lastPage = (first.count / _pageSize).ceil();
    for (var number = lastPage; number >= 1; number--) {
      if (lastPage - number >= _maxPages) break;
      final entries = number == 1 ? first : await page(number);
      DateTime? latest;
      for (final entry in entries.results) {
        final createdAt = entry.createdAt;
        if (entry.createdBy?.id != userId || createdAt == null) continue;
        if (latest == null || createdAt.isAfter(latest)) latest = createdAt;
      }
      if (latest != null) return latest;
    }
    return null;
  });

  /// The space's cook log is ordered by id, oldest first, with no other
  /// order (docs/TANDOOR_API.md#cook-log-ratings-comments-feed), so this reads
  /// pages from the end and sorts them by `created_at`. Entries that were
  /// created long ago with a newer date are missed. Only the recipes of the
  /// entries it returns are loaded, each once.
  @override
  Future<List<RecentCookLog>> recent({int limit = 20, DateTime? since}) =>
      guardRequest(() async {
        RangeError.checkNotNegative(limit, 'limit');
        if (limit == 0) return const [];
        final first = await _page(1);
        final lastPage = (first.count / _pageSize).ceil();
        // The newest pages, and page 1, which is loaded already.
        final numbers = [
          for (var n = lastPage; n > lastPage - _maxRecentPages && n > 1; n--)
            n,
          1,
        ];
        // By id: deletions between requests move entries across pages.
        final entries = <int, CookLog>{};
        final recipes = <int, RecipeSummary?>{};
        var picked = const <RecentCookLog>[];
        for (var i = 0; i < numbers.length; i++) {
          final number = numbers[i];
          final page = number == 1 ? first : await _pageIfAny(number);
          // Gone: entries were deleted since the count.
          if (page == null) continue;
          var reachedSince = false;
          for (final result in page.results) {
            final entry = result.toDomain();
            if (since != null && entry.createdAt.isBefore(since)) {
              reachedSince = true;
            } else {
              entries[entry.id] = entry;
            }
          }
          // Entries created since the count are on the page after it.
          if (number == lastPage && number > 1 && page.next != null) {
            numbers.insert(i + 1, number + 1);
            continue;
          }
          final sorted = entries.values.toList()
            ..sort(
              (a, b) => switch (b.createdAt.compareTo(a.createdAt)) {
                0 => b.id.compareTo(a.id),
                final order => order,
              },
            );
          picked = await _pick(sorted, limit, recipes);
          if (picked.length >= limit || reachedSince) break;
        }
        return picked;
      });

  /// The first [limit] of [entries] whose recipe the user can see, loading
  /// the recipes that aren't in [recipes] yet (`null` there: gone or not
  /// visible).
  Future<List<RecentCookLog>> _pick(
    List<CookLog> entries,
    int limit,
    Map<int, RecipeSummary?> recipes,
  ) async {
    while (true) {
      final picked = <RecentCookLog>[];
      final unknown = <int>{};
      var waiting = 0;
      for (final entry in entries) {
        if (picked.length + waiting >= limit) break;
        final id = entry.recipeId;
        if (!recipes.containsKey(id)) {
          unknown.add(id);
          waiting++;
        } else if (recipes[id] case final recipe?) {
          picked.add(RecentCookLog(entry: entry, recipe: recipe));
        }
      }
      if (unknown.isEmpty) return picked;
      await Future.wait([
        for (final id in unknown) _recipe(id).then((r) => recipes[id] = r),
      ]);
    }
  }

  /// The recipe [id], `null` if it is gone or the user can't see it.
  Future<RecipeSummary?> _recipe(int id) async {
    try {
      if (await storedRecipe?.call(id) case final stored?) return stored;
    } on Object {
      // The stored copy is a shortcut; ask the server.
    }
    try {
      return await guardRequest(() async {
        final response = await _api.apiRecipeRetrieve(id: id);
        return requireBody(response.data).toDomain().summary;
      });
    } on NotFoundFailure {
      return null;
    } on UnauthorizedFailure {
      // Someone else's private recipe: Tandoor lists its cook log entries
      // but answers 403 for the recipe. (The 403 also makes the app check
      // its token once, which finds it valid.)
      return null;
    } on ServerFailure {
      // One recipe the server can't send doesn't hide the others.
      return null;
    }
  }

  Future<api.PaginatedCookLogList> _page(int number) => guardRequest(() async {
    final response = await _api.apiCookLogList(
      page: number,
      pageSize: _pageSize,
    );
    return requireBody(response.data);
  });

  /// The page [number], `null` if there is no such page (any more).
  Future<api.PaginatedCookLogList?> _pageIfAny(int number) async {
    try {
      return await _page(number);
    } on NotFoundFailure {
      return null;
    }
  }
}
