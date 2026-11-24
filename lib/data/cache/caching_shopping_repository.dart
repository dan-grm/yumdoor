import 'dart:async';

import '../../core/failures.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/shopping.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/services/recipe_shopping.dart';
import 'shopping_cache.dart';

/// Reads the shopping list from the server and keeps it in the
/// [ShoppingCache], which answers a full read when the server can't be
/// reached ([OfflineFailure]); so do the supermarkets.
///
/// The stored list follows what the server says: full reads replace it,
/// incremental reads are merged into it, and the check-offs, added items and
/// deletions the server accepted are applied to it. Recipes added to the
/// list show up with the next read. Changes are only made online (offline
/// is read-only).
///
/// Cache writes run one after another, in the order the server answered.
/// A read that answers late doesn't undo what is stored already: a full
/// read older than the stored one is dropped, and no read touches an entry
/// changed here, or stored from a newer read, after it started.
///
/// One repository serves one session: once the cache is cleared (logout),
/// it stores nothing more.
class CachingShoppingRepository implements ShoppingRepository {
  CachingShoppingRepository(this._remote, this._cache) : _epoch = _cache.epoch;

  final ShoppingRepository _remote;
  final ShoppingCache _cache;

  /// [ShoppingCache.epoch] when this session started.
  final int _epoch;

  var _closed = false;
  Future<void> _writes = Future.value();

  /// Counts reads started and changes accepted, to order them.
  var _clock = 0;

  /// For each entry, when what is stored of it was last set: the [_clock]
  /// of a change made here, or of the start of the read it comes from.
  final _setAt = <int, int>{};

  /// When the full read the stored list comes from started.
  var _storedFullRead = -1;

  /// When the newest read stored started, so `syncedAt` doesn't go back.
  var _storedRead = -1;

  /// The ids of the entries set by something newer than [start].
  Set<int> _setSince(int start) => {
    for (final MapEntry(key: id, value: at) in _setAt.entries)
      if (at > start) id,
  };

  void _set(Iterable<int> ids, int at) {
    for (final id in ids) {
      if ((_setAt[id] ?? -1) < at) _setAt[id] = at;
    }
  }

  /// Notes that the entries with [ids] were just changed here.
  void _changed(Iterable<int> ids) => _set(ids, ++_clock);

  /// Stops storing: the session ended, and logout clears the cache.
  void close() => _closed = true;

  /// Runs [write] after the earlier ones; failures are ignored.
  void _store(Future<void> Function() write) {
    if (_closed) return;
    _writes = _writes.then((_) async {
      if (_closed) return;
      try {
        await write();
      } on Object {
        // The cache is a convenience; the next read stores the list again.
      }
    });
  }

  @override
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) async {
    final start = ++_clock;
    final ShoppingListSnapshot snapshot;
    try {
      snapshot = await _remote.fetch(updatedAfter: updatedAfter);
    } on OfflineFailure {
      // Only a full read can stand in for the list.
      if (updatedAfter != null) rethrow;
      return await _read(_cache.list) ?? (throw const OfflineFailure());
    }
    _store(() async {
      // A newer full read is stored already.
      if (start < _storedFullRead) return;
      final keep = _setSince(start);
      final newest = start > _storedRead;
      if (updatedAfter == null) {
        await _cache.putList(
          snapshot,
          keep: keep,
          keepSyncedAt: !newest,
          epoch: _epoch,
        );
      } else {
        await _cache.merge(
          snapshot,
          keep: keep,
          keepSyncedAt: !newest,
          epoch: _epoch,
        );
      }
      if (updatedAfter == null) _storedFullRead = start;
      if (newest) _storedRead = start;
      _set([for (final entry in snapshot.entries) entry.id], start);
    });
    return snapshot;
  }

  @override
  Future<void> setChecked(Set<int> ids, {required bool checked}) async {
    await _remote.setChecked(ids, checked: checked);
    _changed(ids);
    _store(() => _cache.setChecked(ids, checked: checked, epoch: _epoch));
  }

  @override
  Future<List<Supermarket>> supermarkets() async {
    final List<Supermarket> supermarkets;
    try {
      supermarkets = await _remote.supermarkets();
    } on OfflineFailure {
      return await _read(_cache.supermarkets) ?? (throw const OfflineFailure());
    }
    _store(() => _cache.putSupermarkets(supermarkets, epoch: _epoch));
    return supermarkets;
  }

  @override
  Future<RecipeShopping> addRecipe(
    Recipe recipe,
    double servings, {
    int? mealPlanId,
  }) => _remote.addRecipe(recipe, servings, mealPlanId: mealPlanId);

  @override
  Future<ShoppingEntry> addItem(
    int foodId,
    double amount, {
    int? unitId,
  }) async {
    final entry = await _remote.addItem(foodId, amount, unitId: unitId);
    _changed([entry.id]);
    _store(() => _cache.add(entry, epoch: _epoch));
    return entry;
  }

  @override
  Future<void> deleteEntries(Iterable<ShoppingEntry> entries) async {
    final list = entries.toList();
    await _remote.deleteEntries(list);
    final ids = {for (final entry in list) entry.id};
    _changed(ids);
    _store(() => _cache.remove(ids, epoch: _epoch));
  }

  Future<T?> _read<T>(Future<T?> Function() read) async {
    try {
      return await read();
    } on Object {
      return null;
    }
  }
}
