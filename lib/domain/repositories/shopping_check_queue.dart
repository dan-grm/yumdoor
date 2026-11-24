/// A check state set on the device that is still to be sent to Tandoor.
class PendingCheck {
  const PendingCheck({required this.checked, required this.at});

  /// Checked off (`true`) or back on the list.
  final bool checked;

  /// When it was set.
  final DateTime at;

  /// The same state set at the same moment, whatever time zone [at] is in.
  @override
  bool operator ==(Object other) =>
      other is PendingCheck &&
      other.checked == checked &&
      other.at.isAtSameMomentAs(at);

  @override
  int get hashCode => Object.hash(checked, at.microsecondsSinceEpoch);

  @override
  String toString() => 'PendingCheck(checked: $checked, at: $at)';
}

/// Shopping list check-offs made without a connection, kept on the device
/// until they are sent: the one write that works offline.
///
/// One state per entry: setting an entry again replaces what was pending
/// for it. The queue survives a reload or a restart of the app and belongs
/// to the session: logout deletes it with the rest of the offline cache.
abstract interface class ShoppingCheckQueue {
  /// The pending states by entry id; empty if there are none, or they can't
  /// be read.
  Future<Map<int, PendingCheck>> read();

  /// Sets the pending state of the entries with [ids] to [check].
  Future<void> put(Iterable<int> ids, PendingCheck check);

  /// Takes the entries with [ids] off the queue (sent, or no longer
  /// needed).
  Future<void> remove(Iterable<int> ids);
}
