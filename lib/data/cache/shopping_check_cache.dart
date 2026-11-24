import 'package:drift/drift.dart';

import '../../domain/repositories/shopping_check_queue.dart';
import 'cache_database.dart';

/// Keeps the shopping list check states still to be sent in the
/// [CacheDatabase]'s `pending_shopping_check` table, for the entries on
/// [server].
///
/// Rows of other servers are never read and are deleted when the queue is
/// read: a session that ended because the token was rejected keeps its rows
/// (`RecipeCache.clear`), and only a login to the same server sends them.
/// There, the bulk endpoint only touches entries of the household of
/// whoever logged in, so another account can't tick off foreign entries.
///
/// One cache serves one session: it notes [CacheDatabase.queueClears] when
/// it is made and changes nothing once the queue was cleared since (logout),
/// so a check-off of the session that ended can't come back. A session
/// ended by a rejected token keeps the queue, and late writes still land.
class ShoppingCheckCache implements ShoppingCheckQueue {
  ShoppingCheckCache(this._db, {required Uri server})
    : _server = server.toString(),
      _epoch = _db.queueClears;

  final CacheDatabase _db;
  final String _server;
  final int _epoch;

  bool get _cleared => _db.queueClears != _epoch;

  @override
  Future<Map<int, PendingCheck>> read() async {
    if (_cleared) return const {};
    try {
      await (_db.delete(
        _db.pendingShoppingChecks,
      )..where((r) => r.server.equals(_server).not())).go();
      final query = _db.select(_db.pendingShoppingChecks)
        ..where((r) => r.server.equals(_server));
      return {
        for (final row in await query.get())
          row.entryId: PendingCheck(
            checked: row.checked,
            at: DateTime.fromMicrosecondsSinceEpoch(row.at, isUtc: true),
          ),
      };
    } on Object {
      return const {};
    }
  }

  @override
  Future<void> put(Iterable<int> ids, PendingCheck check) {
    final list = ids.toList();
    if (list.isEmpty) return Future.value();
    return _db.transaction(() async {
      if (_cleared) return;
      await _db.batch(
        (batch) => batch.insertAllOnConflictUpdate(_db.pendingShoppingChecks, [
          for (final id in list)
            PendingShoppingChecksCompanion.insert(
              server: _server,
              entryId: id,
              checked: check.checked,
              at: check.at.microsecondsSinceEpoch,
            ),
        ]),
      );
    });
  }

  @override
  Future<void> remove(Iterable<int> ids) {
    final list = ids.toList();
    if (list.isEmpty) return Future.value();
    return _db.transaction(() async {
      if (_cleared) return;
      await (_db.delete(
        _db.pendingShoppingChecks,
      )..where((r) => r.server.equals(_server) & r.entryId.isIn(list))).go();
    });
  }
}
