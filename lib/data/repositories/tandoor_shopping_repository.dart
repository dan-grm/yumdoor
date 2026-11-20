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
/// the read. Tandoor stamps a response after running its query, so a change
/// in between would otherwise be missed by the next incremental read.
const _syncMargin = Duration(seconds: 1);

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
  @override
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) =>
      guardRequest(() async {
        final entries = <ShoppingEntry>[];
        DateTime? serverTime;
        var count = 0;
        for (var page = 1; ; page++) {
          final response = requireBody(
            (await _api.apiShoppingListEntryList(
              updatedAfter: updatedAfter?.toUtc(),
              page: page,
              pageSize: _pageSize,
            )).data,
          );
          if (page == 1) {
            serverTime = response.timestamp;
            count = response.count;
          }
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
      });

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
