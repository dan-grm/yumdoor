import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/shopping.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/shopping_mapper.dart';

/// Entries and supermarkets per request page: `DefaultPagination.max_page_size`.
const _pageSize = 200;

/// How far [ShoppingListSnapshot.syncedAt] lies before the server's time of
/// the read. Tandoor stamps a response after running its query and
/// serializing up to [_pageSize] entries, which can take a while on a small
/// server; a change in between would otherwise be missed by the next
/// incremental read. Entries that come again are harmless.
const _syncMargin = Duration(minutes: 1);

/// How often [TandoorShoppingRepository.fetch] reads the list at most when
/// it changes while the pages are read.
const _attempts = 3;

/// Checking off goes through [Dio] directly: the generated
/// `ShoppingListEntryBulk` takes the ids as `JsonObject`s from a package the
/// app doesn't depend on.
class TandoorShoppingRepository implements ShoppingRepository {
  TandoorShoppingRepository(this._api, this._dio);

  final api.ApiApi _api;
  final Dio _dio;

  /// Tandoor returns at most [maxShoppingEntries] entries, the oldest
  /// (docs/TANDOOR_API.md#shopping-list); `count` is then exactly that.
  /// `updated_after` must carry a time zone, so it goes as UTC.
  ///
  /// Pages are offsets into the list ordered by id. If an entry is deleted
  /// (or a checked one ages out) between two pages, the later pages shift and
  /// an entry is skipped; a changed `count` shows that, and the read starts
  /// over. The last of [_attempts] reads is kept as it is. Not noticed: a
  /// delete and an add between two pages, or a delete in a list at the cap
  /// (its `count` stays 1000). Lists rarely have more than one page.
  ///
  /// A truncated incremental read keeps [updatedAfter] as `syncedAt`: the
  /// entries it left out are ordered by id, not by time, so moving on would
  /// lose them for good.
  @override
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) =>
      guardRequest(() async {
        for (var attempt = 1; ; attempt++) {
          final snapshot = await _read(
            updatedAfter?.toUtc(),
            strict: attempt < _attempts,
          );
          if (snapshot == null) continue;
          if (snapshot.truncated && updatedAfter != null) {
            return snapshot.copyWith(syncedAt: updatedAfter.toUtc());
          }
          return snapshot;
        }
      });

  /// One read of every page; `null` if the list changed in between, unless
  /// not [strict].
  Future<ShoppingListSnapshot?> _read(
    DateTime? updatedAfter, {
    bool strict = true,
  }) async {
    final entries = <ShoppingEntry>[];
    DateTime? serverTime;
    int? count;
    for (var page = 1; ; page++) {
      final response = requireBody(
        (await _api.apiShoppingListEntryList(
          updatedAfter: updatedAfter,
          page: page,
          pageSize: _pageSize,
        )).data,
      );
      serverTime ??= response.timestamp;
      if (count != null && response.count != count && strict) return null;
      count ??= response.count;
      entries.addAll(response.results.map((dto) => dto.toDomain()));
      if (response.next == null || response.results.isEmpty) break;
    }
    return ShoppingListSnapshot(
      entries: entries,
      syncedAt:
          (serverTime ??
                  (throw const FormatException(
                    'Shopping list without timestamp',
                  )))
              .toUtc()
              .subtract(_syncMargin),
      truncated: count >= maxShoppingEntries,
    );
  }

  /// Through the bulk endpoint: a PATCH without `checked` can clear the
  /// food's on-hand flag (docs/TANDOOR_API.md#on-hand-foods).
  @override
  Future<void> setChecked(Set<int> ids, {required bool checked}) async {
    if (ids.isEmpty) return;
    await guardRequest(
      () => _dio.post<Object?>(
        '/api/shopping-list-entry/bulk/',
        data: {'ids': ids.toList(), 'checked': checked},
      ),
    );
  }

  @override
  Future<List<Supermarket>> supermarkets() => guardRequest(() async {
    final supermarkets = <Supermarket>[];
    for (var page = 1; ; page++) {
      final response = requireBody(
        (await _api.apiSupermarketList(page: page, pageSize: _pageSize)).data,
      );
      supermarkets.addAll(response.results.map((dto) => dto.toDomain()));
      if (response.next == null || response.results.isEmpty) break;
    }
    return supermarkets;
  });
}
