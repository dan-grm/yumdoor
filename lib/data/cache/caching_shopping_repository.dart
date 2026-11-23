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
/// read older than the stored one is dropped, an incremental one too, and
/// neither touches entries changed here after it started.
class CachingShoppingRepository implements ShoppingRepository {
  CachingShoppingRepository(this._remote, this._cache);

  final ShoppingRepository _remote;
  final ShoppingCache _cache;

  var _closed = false;
  Future<void> _writes = Future.value();

  /// Counts reads started and changes accepted, to order them.
  var _clock = 0;

  /// When each entry was last changed here (checked off, added, deleted),
  /// as [_clock] then.
  final _changedAt = <int, int>{};

  /// When the full read the stored list comes from started.
  var _storedFullRead = -1;

  /// The ids of the entries changed here since [start].
  Set<int> _changedSince(int start) => {
    for (final MapEntry(key: id, value: at) in _changedAt.entries)
      if (at > start) id,
  };

  /// Notes that the entries with [ids] were just changed here.
  void _changed(Iterable<int> ids) {
    final at = ++_clock;
    for (final id in ids) {
      _changedAt[id] = at;
    }
  }

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
    final epoch = _cache.epoch;
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
      final keep = _changedSince(start);
      if (updatedAfter == null) {
        _storedFullRead = start;
        await _cache.putList(snapshot, keep: keep, epoch: epoch);
      } else {
        await _cache.merge(snapshot, keep: keep, epoch: epoch);
      }
    });
    return snapshot;
  }

  @override
  Future<void> setChecked(Set<int> ids, {required bool checked}) async {
    final epoch = _cache.epoch;
    await _remote.setChecked(ids, checked: checked);
    _changed(ids);
    _store(() => _cache.setChecked(ids, checked: checked, epoch: epoch));
  }

  @override
  Future<List<Supermarket>> supermarkets() async {
    final epoch = _cache.epoch;
    final List<Supermarket> supermarkets;
    try {
      supermarkets = await _remote.supermarkets();
    } on OfflineFailure {
      return await _read(_cache.supermarkets) ?? (throw const OfflineFailure());
    }
    _store(() => _cache.putSupermarkets(supermarkets, epoch: epoch));
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
    final epoch = _cache.epoch;
    final entry = await _remote.addItem(foodId, amount, unitId: unitId);
    _changed([entry.id]);
    _store(() => _cache.add(entry, epoch: epoch));
    return entry;
  }

  @override
  Future<void> deleteEntries(Iterable<ShoppingEntry> entries) async {
    final epoch = _cache.epoch;
    final list = entries.toList();
    await _remote.deleteEntries(list);
    final ids = {for (final entry in list) entry.id};
    _changed(ids);
    _store(() => _cache.remove(ids, epoch: epoch));
  }

  Future<T?> _read<T>(Future<T?> Function() read) async {
    try {
      return await read();
    } on Object {
      return null;
    }
  }
}
