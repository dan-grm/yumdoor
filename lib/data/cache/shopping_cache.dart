import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/shopping.dart';
import 'cache_database.dart';

/// The shopping list as last known from the server, and the supermarkets,
/// in the [CacheDatabase]. Cleared with the rest of the cache
/// (`RecipeCache.clear`).
///
/// The entries are rows of their own, so a change to some of them (an
/// incremental read, a check-off the server accepted) doesn't rewrite the
/// list. They hold only what the server has: check states that are still to
/// be sent belong elsewhere and go on top of this list when it is read.
///
/// Every write takes the [epoch] noted before the server was asked and
/// does nothing if the cache was cleared since.
class ShoppingCache {
  ShoppingCache(this._db, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final CacheDatabase _db;
  final DateTime Function() _now;

  static const _listKey = 'shopping.list';
  static const _supermarketsKey = 'shopping.supermarkets';

  /// The number to pass to the writes for a read that starts now.
  int get epoch => _db.clears;

  /// Replaces the stored list with [snapshot], read just now. The entries
  /// with ids in [keep] (changed here since the read started) stay as
  /// stored, or missing.
  Future<void> putList(
    ShoppingListSnapshot snapshot, {
    Set<int> keep = const {},
    required int epoch,
  }) => _db.transaction(() async {
    if (_db.clears != epoch) return;
    await (_db.delete(
      _db.cachedShoppingEntries,
    )..where((r) => r.id.isNotIn(keep))).go();
    await _db.batch(
      (batch) => batch.insertAll(_db.cachedShoppingEntries, [
        for (final (position, entry) in snapshot.entries.indexed)
          if (!keep.contains(entry.id)) _row(entry, position),
      ]),
    );
    await _putInfo(syncedAt: snapshot.syncedAt, truncated: snapshot.truncated);
  });

  /// Merges the entries an incremental read ([changes]) found changed into
  /// the stored list: changed entries are replaced, new ones added at the
  /// end (unless the list was cut off, which leaves out the newest). Entries
  /// with ids in [keep] (changed here since the read started) stay as
  /// stored, or missing. Does nothing if no list is stored.
  Future<void> merge(
    ShoppingListSnapshot changes, {
    Set<int> keep = const {},
    required int epoch,
  }) => _db.transaction(() async {
    if (_db.clears != epoch) return;
    final info = await _info();
    if (info == null) return;
    var next = await _nextPosition();
    for (final entry in changes.entries) {
      if (keep.contains(entry.id)) continue;
      final updated = await _replace(entry);
      if (updated || info.truncated) continue;
      await _db.into(_db.cachedShoppingEntries).insert(_row(entry, next++));
    }
    await _putInfo(syncedAt: changes.syncedAt, truncated: info.truncated);
  });

  /// Marks the stored entries with [ids] as checked off ([checked] `true`)
  /// or not, as the server just accepted.
  Future<void> setChecked(
    Set<int> ids, {
    required bool checked,
    required int epoch,
  }) => _db.transaction(() async {
    if (_db.clears != epoch) return;
    final at = _now();
    final query = _db.select(_db.cachedShoppingEntries)
      ..where((r) => r.id.isIn(ids));
    for (final row in await query.get()) {
      final entry = _decode(row);
      if (entry == null) continue;
      await _replace(
        entry.copyWith(
          checked: checked,
          completedAt: checked ? entry.completedAt ?? at : null,
          updatedAt: at,
        ),
      );
    }
  });

  /// Adds [entry], just created, at the end of the stored list, if one is
  /// stored.
  Future<void> add(ShoppingEntry entry, {required int epoch}) =>
      _db.transaction(() async {
        if (_db.clears != epoch) return;
        if (await _info() == null) return;
        if (await _replace(entry)) return;
        await _db
            .into(_db.cachedShoppingEntries)
            .insert(_row(entry, await _nextPosition()));
      });

  /// Takes the entries with [ids], just deleted, off the stored list.
  Future<void> remove(Set<int> ids, {required int epoch}) =>
      _db.transaction(() async {
        if (_db.clears != epoch) return;
        await (_db.delete(
          _db.cachedShoppingEntries,
        )..where((r) => r.id.isIn(ids))).go();
      });

  /// The stored list, in its order, with [ShoppingListSnapshot.cachedAt]
  /// set; `null` if none is stored. Entries that can't be read are left out.
  Future<ShoppingListSnapshot?> list() async {
    final info = await _info();
    if (info == null) return null;
    final query = _db.select(_db.cachedShoppingEntries)
      ..orderBy([(r) => OrderingTerm.asc(r.position)]);
    return ShoppingListSnapshot(
      entries: [for (final row in await query.get()) ?_decode(row)],
      syncedAt: info.syncedAt,
      truncated: info.truncated,
      cachedAt: info.storedAt,
    );
  }

  /// Replaces the stored supermarkets with [supermarkets].
  Future<void> putSupermarkets(
    List<Supermarket> supermarkets, {
    required int epoch,
  }) => _db.transaction(() async {
    if (_db.clears != epoch) return;
    await _put(_supermarketsKey, [for (final s in supermarkets) s.toJson()]);
  });

  /// The stored supermarkets; `null` if none are stored or they can't be
  /// read.
  Future<List<Supermarket>?> supermarkets() async {
    final json = await _get(_supermarketsKey);
    if (json == null) return null;
    try {
      return [
        for (final item in json as List<dynamic>)
          Supermarket.fromJson(item as Map<String, dynamic>),
      ];
    } on Object {
      return null;
    }
  }

  CachedShoppingEntriesCompanion _row(ShoppingEntry entry, int position) =>
      CachedShoppingEntriesCompanion.insert(
        id: Value(entry.id),
        position: position,
        json: jsonEncode(entry.toJson()),
      );

  /// Writes [entry] over the stored one with its id; `false` if there is
  /// none.
  Future<bool> _replace(ShoppingEntry entry) async {
    final updated =
        await (_db.update(
          _db.cachedShoppingEntries,
        )..where((r) => r.id.equals(entry.id))).write(
          CachedShoppingEntriesCompanion(
            json: Value(jsonEncode(entry.toJson())),
          ),
        );
    return updated > 0;
  }

  Future<int> _nextPosition() async {
    final table = _db.cachedShoppingEntries;
    final max = table.position.max();
    final query = _db.selectOnly(table)..addColumns([max]);
    return ((await query.getSingle()).read(max) ?? -1) + 1;
  }

  /// The entry in [row], or `null` if it can't be read, which only happens
  /// if a model changed without a new cache version.
  ShoppingEntry? _decode(CachedShoppingEntryRow row) {
    try {
      return ShoppingEntry.fromJson(
        jsonDecode(row.json) as Map<String, dynamic>,
      );
    } on Object {
      return null;
    }
  }

  Future<void> _putInfo({
    required DateTime syncedAt,
    required bool truncated,
  }) => _put(_listKey, {
    'syncedAt': syncedAt.toUtc().toIso8601String(),
    'truncated': truncated,
    'storedAt': _now().toUtc().toIso8601String(),
  });

  Future<({DateTime syncedAt, bool truncated, DateTime storedAt})?>
  _info() async {
    final json = await _get(_listKey);
    try {
      return switch (json) {
        {
          'syncedAt': final String syncedAt,
          'truncated': final bool truncated,
          'storedAt': final String storedAt,
        } =>
          (
            syncedAt: DateTime.parse(syncedAt),
            truncated: truncated,
            storedAt: DateTime.parse(storedAt).toLocal(),
          ),
        _ => null,
      };
    } on FormatException {
      return null;
    }
  }

  Future<void> _put(String key, Object json) => _db
      .into(_db.cachedValues)
      .insertOnConflictUpdate(
        CachedValuesCompanion.insert(key: key, json: jsonEncode(json)),
      );

  Future<Object?> _get(String key) async {
    final query = _db.select(_db.cachedValues)..where((r) => r.key.equals(key));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    try {
      return jsonDecode(row.json);
    } on FormatException {
      return null;
    }
  }
}
