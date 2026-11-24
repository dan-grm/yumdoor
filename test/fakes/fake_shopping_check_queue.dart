import 'package:yumdoor/domain/repositories/shopping_check_queue.dart';

/// [ShoppingCheckQueue] for tests: keeps the pending states in [pending],
/// as a database on the device would across starts of the app.
class FakeShoppingCheckQueue implements ShoppingCheckQueue {
  FakeShoppingCheckQueue([Map<int, PendingCheck>? pending])
    : pending = pending ?? {};

  final Map<int, PendingCheck> pending;

  @override
  Future<Map<int, PendingCheck>> read() async => Map.of(pending);

  @override
  Future<void> put(Iterable<int> ids, PendingCheck check) async {
    for (final id in ids) {
      pending[id] = check;
    }
  }

  @override
  Future<void> remove(Iterable<int> ids) async => ids.forEach(pending.remove);
}
