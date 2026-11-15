import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/cook_log.dart';
import '../../domain/repositories/cook_log_repository.dart';
import '../api/api_failures.dart';
import '../mappers/cook_log_mapper.dart';
import '../mappers/mapping.dart';

/// Cook log entries per request page; the server allows up to 200.
const _pageSize = 100;

/// How many pages [TandoorCookLogRepository.lastCooked] reads at most, from
/// the newest. Older entries of the current user are not found.
const _maxPages = 3;

class TandoorCookLogRepository implements CookLogRepository {
  TandoorCookLogRepository(this._api);

  final api.ApiApi _api;

  /// The current user's id, read once.
  Future<int>? _userId;

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
    final user = _currentUserId();
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

  /// Shared by concurrent calls, and asked again after a failure. Its
  /// errors count as handled, so a failing page can be thrown first.
  Future<int> _currentUserId() {
    if (_userId case final id?) return id;
    final id = _userId = _readUserId();
    id.then<void>((_) {}, onError: (Object _) => _userId = null).ignore();
    id.ignore();
    return id;
  }

  // `/api/user-preference/` lists only the caller's own preferences, for
  // every user; there is no "current user" endpoint.
  Future<int> _readUserId() async {
    final response = await _api.apiUserPreferenceList();
    final user = requireBody(response.data).firstOrNull?.user;
    return requireId(user?.id, 'User');
  }
}
