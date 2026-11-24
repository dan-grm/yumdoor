import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../app/session.dart';
import '../../core/failures.dart';
import '../../domain/models/shopping.dart';
import '../../domain/repositories/shopping_check_queue.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/services/shopping_list_groups.dart';

part 'shopping_providers.g.dart';

/// The shopping list as shown: the entries with the check states set on
/// this device.
class ShoppingListView {
  const ShoppingListView({
    required this.entries,
    this.truncated = false,
    this.cachedAt,
    this.pendingIds = const {},
  });

  final List<ShoppingEntry> entries;

  /// The ids of the entries whose check state was set offline and is not
  /// sent yet (queued, [ShoppingList.sendQueued]).
  final Set<int> pendingIds;

  /// Whether Tandoor cut the list off ([ShoppingListSnapshot.truncated]), so
  /// the newest entries may be missing.
  final bool truncated;

  /// When the list was read from the server, if it comes from the offline
  /// cache ([ShoppingListSnapshot.cachedAt]); `null` for a list from the
  /// server.
  final DateTime? cachedAt;
}

/// A check state set on this device and shown over the list as read from
/// the server, until a read that started after it was saved shows it.
class _CheckChange {
  _CheckChange({required this.checked, required this.at});

  final bool checked;

  /// When it was set; stands in for the server's completion time.
  final DateTime at;

  /// How many reads had started when it was saved; `null` while it is being
  /// sent or waits in the queue. Reads started later include it.
  int? savedBeforeRead;

  PendingCheck get pending => PendingCheck(checked: checked, at: at);
}

/// The entries of the household's shopping list, with the check states set
/// on this device shown at once.
///
/// Checking off ([setChecked]) is optimistic: the rows move right away and
/// the change goes to Tandoor immediately, so the others in the household
/// see it on their next read. Changes are sent one after another, in the
/// order they were made, so an undo can't overtake the check-off it undoes.
/// A change that fails is taken back.
///
/// The local changes stay on top of what the server says until a read that
/// started after they were saved, so a read that was already running can't
/// bring back the old state.
///
/// Checking off is the one write that works offline. Offline (or on a list
/// from the offline cache), and when sending fails because the server can't
/// be reached, the state goes into the [ShoppingCheckQueue] on the device
/// instead and stays shown, marked as pending ([ShoppingListView.pendingIds]).
/// Setting an entry again replaces its pending state; going back to what the
/// server has takes it off the queue, so ticking and unticking offline sends
/// nothing. The queue is sent ([sendQueued]) as soon as the server answers
/// again: when the app is no longer offline and after each read of the
/// list. One request per wanted state, through the bulk endpoint, which
/// ignores entries deleted on the server meanwhile. A failure keeps the
/// queue for the next try. The last state sent wins, also over a change
/// someone else made meanwhile.
@Riverpod(keepAlive: true, retry: _noRetry)
class ShoppingList extends _$ShoppingList {
  late ShoppingRepository _repository;
  late ShoppingCheckQueue _queue;

  /// The list as last read from the server.
  ShoppingListSnapshot? _server;

  /// Check states set here, by entry id.
  final _changes = <int, _CheckChange>{};

  /// The check states in the [ShoppingCheckQueue], by entry id; each is
  /// also in [_changes] while it is the one shown.
  final _queued = <int, _CheckChange>{};

  /// For a queued entry, the change sent (or being sent) that the queued one
  /// replaced, if any: with it, the server has, or gets, that state rather
  /// than the one last read.
  final _queuedOver = <int, _CheckChange>{};

  /// The queued changes being sent right now, by entry id.
  final _inFlight = <int, _CheckChange>{};

  /// The read that tries the server again after a tick on a list from the
  /// offline cache, while it runs.
  Future<void>? _retrying;

  /// When the server last answered sending the queue with an error; reads
  /// don't send it again until [_retryAfterRejection] later.
  DateTime? _rejectedAt;

  /// Writes to the [ShoppingCheckQueue], in order.
  Future<void> _queueWrites = Future.value();

  /// The send of the queue that waits for its turn, if any.
  Future<void>? _queuedSend;

  /// The changes being sent, in order. Kept when the list starts over, so
  /// a change still can't overtake an earlier one.
  Future<void> _writes = Future.value();

  /// How many reads have started.
  var _reads = 0;

  /// The full read [_server] comes from; an older one that ends later is
  /// dropped. An edit moves it on, too.
  var _shownRead = 0;

  /// How many full reads are running.
  var _fullReads = 0;

  @override
  Future<ShoppingListView> build() async {
    _repository = ref.watch(shoppingRepositoryProvider);
    final queue = _queue = ref.watch(shoppingCheckQueueProvider);
    _server = null;
    _changes.clear();
    _queued.clear();
    _queuedOver.clear();
    // A send still waiting takes what is queued when its turn comes, but
    // the next one is this build's.
    _queuedSend = null;
    // Back online, or the server answers again: send what waits.
    ref.listen(isOfflineProvider, (_, offline) {
      if (!offline) unawaited(_sendQueuedQuietly());
    });
    final read = ++_reads;
    // Written by an earlier build of this session, maybe not yet stored.
    await _queueWrites;
    final pending = await queue.read();
    // A check-off made while this loaded is newer.
    if (identical(queue, _queue)) {
      for (final MapEntry(key: id, value: check) in pending.entries) {
        if (_changes.containsKey(id)) continue;
        final change = _CheckChange(checked: check.checked, at: check.at);
        _changes[id] = change;
        _queued[id] = change;
      }
    }
    final snapshot = await _fullRead(_repository);
    _apply(read, snapshot);
    _sendAfterRead(snapshot);
    return _view();
  }

  /// Whether check states wait to be sent, once those just set are stored.
  Future<bool> hasPending() async {
    await _queueWrites;
    return _queued.isNotEmpty;
  }

  /// Whether a check-off goes into the queue rather than to the server:
  /// offline, or the list shown comes from the offline cache.
  bool get _offline => ref.read(isOfflineProvider) || _server?.cachedAt != null;

  /// The entry with [id] as last read from the server, if it was there.
  ShoppingEntry? _serverEntry(int id) {
    for (final entry in _server?.entries ?? const <ShoppingEntry>[]) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  /// Sends the check states waiting in the queue, if any, one request per
  /// wanted state, after the changes sent before. Throws the [Failure] if
  /// sending fails; what wasn't sent stays in the queue.
  Future<void> sendQueued() {
    if (_queued.isEmpty) return Future.value();
    // One send waiting for its turn is enough: it takes what is queued then.
    if (_queuedSend case final waiting?) return waiting;
    final repository = _repository;
    late final Future<void> send;
    send = _writes.then((_) {
      if (identical(_queuedSend, send)) _queuedSend = null;
      return _sendQueue(repository);
    });
    _queuedSend = send;
    _writes = send.then((_) {}, onError: (Object _) {});
    return send;
  }

  /// Sends what is queued now for the session of [repository]. Each wanted
  /// state is tried even if the other fails; then the first failure is
  /// thrown.
  Future<void> _sendQueue(ShoppingRepository repository) async {
    if (!identical(repository, _repository)) return;
    final batch = Map.of(_queued);
    Object? failure;
    StackTrace? failureStack;
    for (final checked in [true, false]) {
      final group = {
        for (final MapEntry(key: id, value: change) in batch.entries)
          if (change.checked == checked) id: change,
      };
      if (group.isEmpty) continue;
      _inFlight.addAll(group);
      try {
        // Entries deleted on the server meanwhile are ignored there.
        await repository.setChecked(group.keys.toSet(), checked: checked);
      } on Object catch (error, stack) {
        failure ??= error;
        failureStack ??= stack;
        _inFlight.removeWhere((id, _) => group.containsKey(id));
        if (identical(repository, _repository)) _notSent(group);
        continue;
      }
      _inFlight.removeWhere((id, _) => group.containsKey(id));
      // Another login meanwhile: its queue is a new one.
      if (!identical(repository, _repository)) return;
      final sent = <int>[];
      for (final MapEntry(key: id, value: change) in group.entries) {
        // Reads that start from now on include it, also where it is shown
        // through a copy loaded again meanwhile.
        change.savedBeforeRead = _reads;
        final shown = _changes[id];
        if (shown != null &&
            !_queued.containsKey(id) &&
            shown.pending == change.pending) {
          shown.savedBeforeRead ??= _reads;
        }
        // Set again while this was sent: that one waits for the next send.
        // By value, as the list may have been loaded again meanwhile.
        final queued = _queued[id];
        if (queued != null && queued.pending != change.pending) continue;
        _queued.remove(id)?.savedBeforeRead = _reads;
        _queuedOver.remove(id);
        sent.add(id);
      }
      _writeQueue((queue) => queue.remove(sent));
      if (ref.mounted) _publish();
    }
    if (failure != null) Error.throwWithStackTrace(failure, failureStack!);
  }

  /// After sending [group] from the queue failed: what was set on top of it
  /// while it was sent treated it as the server's state, which it isn't.
  void _notSent(Map<int, _CheckChange> group) {
    final requeued = <int, _CheckChange>{};
    // By value: the list may have been loaded again since it was sent.
    for (final MapEntry(key: id, value: change) in group.entries) {
      if (_queuedOver[id]?.pending == change.pending) _queuedOver.remove(id);
      // Taken off the queue as the state the server gets: queued again.
      final shown = _changes[id];
      if (shown != null &&
          shown.savedBeforeRead == null &&
          shown.pending == change.pending &&
          !_queued.containsKey(id)) {
        _queued[id] = shown;
        requeued[id] = shown;
      }
    }
    for (final MapEntry(key: id, value: change) in requeued.entries) {
      final check = change.pending;
      _writeQueue((queue) => queue.put([id], check));
    }
    if (requeued.isNotEmpty && ref.mounted) _publish();
  }

  /// [sendQueued], for when nobody waits for it: a failure keeps the queue
  /// for the next try.
  Future<void> _sendQueuedQuietly() async {
    try {
      await sendQueued();
      _rejectedAt = null;
    } on OfflineFailure {
      // Tried again once the server answers a read, or back online.
    } on Failure {
      // The server answered with an error: tried again, but not after
      // every poll.
      _rejectedAt = ref.mounted ? ref.read(clockProvider)() : null;
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'shopping',
        ),
      );
    }
  }

  /// After a read: if the server answered it, it may take the queue now.
  void _sendAfterRead(ShoppingListSnapshot snapshot) {
    if (snapshot.cachedAt != null || _queued.isEmpty) return;
    if (_rejectedAt case final at?
        when ref.read(clockProvider)().difference(at) < _retryAfterRejection) {
      return;
    }
    unawaited(_sendQueuedQuietly());
  }

  /// Runs [write] on the queue after the earlier writes.
  void _writeQueue(Future<void> Function(ShoppingCheckQueue queue) write) {
    final queue = _queue;
    _queueWrites = _queueWrites
        .then((_) => write(queue))
        .then(
          (_) {},
          onError: (Object _) {
            // The list still shows it and sends it while the app runs; only
            // a restart before then would lose it.
          },
        );
  }

  /// Puts [change], just set offline, into the queue for [ids], or takes
  /// them off it where [change] is what the server has (or gets from what
  /// was sent): ticking and unticking offline sends nothing.
  void _enqueue(List<int> ids, _CheckChange change) {
    final put = <int>[];
    final removed = <int>[];
    for (final id in ids) {
      final previous = _changes[id];
      final queued = _queued.remove(id);
      final wasQueued = queued != null;
      // The change sent before (or being sent from the queue right now),
      // which the queue goes on top of.
      // By value: the list may have been loaded again since it was sent.
      final sending = wasQueued && _inFlight[id]?.pending == queued.pending;
      final over = wasQueued ? _queuedOver.remove(id) : previous;
      final base =
          (sending ? queued : over)?.checked ?? _serverEntry(id)?.checked;
      if (sending) {
        if (base == change.checked) {
          // Back to what is being sent: shown as such, nothing to queue.
          _changes[id] = queued;
          removed.add(id);
        } else {
          _changes[id] = change;
          _queued[id] = change;
          _queuedOver[id] = queued;
          put.add(id);
        }
        continue;
      }
      if (base == change.checked) {
        if (wasQueued) {
          if (over == null) {
            _changes.remove(id);
          } else {
            _changes[id] = over;
          }
          removed.add(id);
        }
      } else {
        _changes[id] = change;
        _queued[id] = change;
        if (over != null) _queuedOver[id] = over;
        put.add(id);
      }
    }
    if (removed.isNotEmpty) _writeQueue((queue) => queue.remove(removed));
    if (put.isNotEmpty) _writeQueue((queue) => queue.put(put, change.pending));
  }

  /// Reads the list again, keeping the one shown meanwhile. Throws the
  /// [Failure] if the read fails; the list then stays as it was. The list
  /// stored for offline use is no news for a list already shown: then this
  /// throws an [OfflineFailure].
  Future<void> refresh() async {
    // This build's ref: a new login starts over, and then this read is old.
    final ref = this.ref;
    final repository = _repository;
    final read = ++_reads;
    final snapshot = await _fullRead(repository);
    if (!ref.mounted || !identical(repository, _repository)) return;
    if (snapshot.cachedAt != null && _server != null) {
      throw const OfflineFailure();
    }
    _apply(read, snapshot);
    state = AsyncData(_view());
    _sendAfterRead(snapshot);
  }

  /// Sends what is waiting to be sent, the queue included, then reads the
  /// list again ([refresh]): for coming back to the list, or back online.
  /// A queue that can't be sent stays for the next try.
  Future<void> catchUp() async {
    try {
      await sendQueued();
    } on Object {
      // Kept; the read below says whether the server answers.
    }
    await _writes;
    await refresh();
  }

  /// Asks Tandoor what changed since the last read, by anyone in the
  /// household, and merges it into the list. Deleted entries don't show up
  /// this way; [refresh] now and then. Does nothing while the list is
  /// loading or read in full, which brings the changes anyway. Throws the
  /// [Failure] if the read fails; the list then stays as it was.
  Future<void> poll() async {
    final server = _server;
    if (server == null || _fullReads > 0) return;
    // The stored list may lack what changed since, deletions included.
    if (server.cachedAt != null) return refresh();
    final ref = this.ref;
    final repository = _repository;
    final read = ++_reads;
    final changes = await repository.fetch(updatedAfter: server.syncedAt);
    if (!ref.mounted || !identical(repository, _repository)) return;
    if (_merge(read, changes)) _publish();
    _sendAfterRead(changes);
  }

  /// Checks off ([checked] `true`) or unchecks the entries with [ids],
  /// showing it at once and sending it right away. Returns `null` once it is
  /// saved, or queued because the server can't be reached; the [Failure]
  /// after taking it back.
  Future<Failure?> setChecked(List<int> ids, {required bool checked}) async {
    if (ids.isEmpty) return null;
    final ref = this.ref;
    final repository = _repository;
    final change = _CheckChange(
      checked: checked,
      at: ref.read(clockProvider)(),
    );
    if (_offline) {
      _enqueue(ids, change);
      _publish();
      // Online, only the list shown is from the cache (a request timed
      // out): try the server again, which sends the queue if it answers.
      if (!ref.read(isOfflineProvider) && _queued.isNotEmpty) {
        // One try at a time, however many rows are ticked.
        _retrying ??= _resync().whenComplete(() => _retrying = null);
      }
      await _queueWrites;
      return null;
    }
    // What each entry showed before, to go back to if this fails.
    final previous = {for (final id in ids) id: _changes[id]};
    // Sent now, in place of what was queued for them.
    final unqueued = {
      for (final id in ids)
        if (_queued.remove(id) != null) id,
    };
    // To put back with them if this fails.
    final unqueuedOver = {
      for (final id in unqueued) id: ?_queuedOver.remove(id),
    };
    if (unqueued.isNotEmpty) _writeQueue((queue) => queue.remove(unqueued));
    for (final id in ids) {
      _changes[id] = change;
    }
    _publish();

    final write = _writes.then((_) => _send(repository, ids, checked));
    _writes = write.then((_) {}, onError: (Object _) {});
    Failure? failure;
    try {
      await write;
    } on Failure catch (error) {
      failure = error;
    } on Object catch (error, stack) {
      // A bug rather than the server; reported, and the change goes back.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'shopping',
        ),
      );
      failure = ServerFailure(cause: error);
    }
    if (!ref.mounted || !identical(repository, _repository)) return failure;
    if (failure != null) {
      // A state queued offline meanwhile went on top of this one, as if the
      // server had it: it didn't (or may not), so compare with what came
      // before instead.
      for (final id in ids) {
        if (!identical(_queuedOver[id], change)) continue;
        final before = unqueued.contains(id) ? unqueuedOver[id] : previous[id];
        if (before == null) {
          _queuedOver.remove(id);
        } else {
          _queuedOver[id] = before;
        }
      }
    }
    if (failure == null) {
      change.savedBeforeRead = _reads;
    } else if (failure is OfflineFailure) {
      // Not lost: queued, and sent once the server answers again. The
      // request may have arrived after all; sending it again does no harm.
      final put = [
        for (final id in ids)
          if (identical(_changes[id], change)) id,
      ];
      for (final id in put) {
        _queued[id] = change;
        final over = unqueued.contains(id) ? unqueuedOver[id] : previous[id];
        if (over != null) _queuedOver[id] = over;
      }
      if (put.isNotEmpty) {
        _writeQueue((queue) => queue.put(put, change.pending));
      }
      _publish();
      await _queueWrites;
      return null;
    } else {
      // Back to what was shown before, where no later change took over.
      final requeued = <int>[];
      for (final MapEntry(key: id, value: before) in previous.entries) {
        if (!identical(_changes[id], change)) continue;
        if (before == null) {
          _changes.remove(id);
        } else {
          _changes[id] = before;
          if (unqueued.contains(id)) {
            _queued[id] = before;
            if (unqueuedOver[id] case final over?) _queuedOver[id] = over;
            requeued.add(id);
          }
        }
      }
      for (final id in requeued) {
        final check = _queued[id]!.pending;
        _writeQueue((queue) => queue.put([id], check));
      }
      _publish();
    }
    return failure;
  }

  /// Adds [amount] (0 for none) of the food [foodId] in [unitId] by hand and
  /// shows it at once. Returns the [Failure] if it didn't work.
  Future<Failure?> addItem(int foodId, double amount, {int? unitId}) =>
      _edit((repository) async {
        final entry = await repository.addItem(foodId, amount, unitId: unitId);
        return (add: [entry], remove: const <int>{});
      });

  /// The entries of the list with these [ids], as shown.
  List<ShoppingEntry> entriesOf(Iterable<int> ids) {
    final wanted = ids.toSet();
    return [
      for (final entry in _view().entries)
        if (wanted.contains(entry.id)) entry,
    ];
  }

  /// Deletes [entries] for the whole household and takes them off the list.
  /// Returns the [Failure] if it didn't work.
  Future<Failure?> delete(List<ShoppingEntry> entries) =>
      _edit((repository) async {
        await repository.deleteEntries(entries);
        return (
          add: const <ShoppingEntry>[],
          remove: {for (final e in entries) e.id},
        );
      });

  /// Puts deleted [entries] back as items added by hand (their recipe link
  /// is gone). Returns the [Failure] if it didn't work.
  Future<Failure?> restore(List<ShoppingEntry> entries) =>
      _edit((repository) async {
        final added = <ShoppingEntry>[];
        for (final entry in entries) {
          final created = await repository.addItem(
            entry.food.id,
            entry.amount,
            unitId: entry.unit?.id,
          );
          if (!entry.checked) {
            added.add(created);
            continue;
          }
          // Back where it was: checked off.
          await repository.setChecked({created.id}, checked: true);
          final at = ref.read(clockProvider)();
          // Keeps the server's updatedAt, so a poll can tell newer states.
          added.add(created.copyWith(checked: true, completedAt: at));
        }
        return (add: added, remove: const <int>{});
      });

  /// Marks the food [foodId] on hand for the household and checks off
  /// [ids]. Returns the [Failure] if the food couldn't be marked; checking
  /// off then isn't tried.
  Future<Failure?> markOnHand(int foodId, List<int> ids) async {
    try {
      await ref.read(foodRepositoryProvider).setOnHand(foodId, onHand: true);
    } on Failure catch (error) {
      return error;
    }
    final failure = await setChecked(ids, checked: true);
    if (failure != null) {
      // Not half done: the food isn't on hand if the row stays open.
      try {
        await ref.read(foodRepositoryProvider).setOnHand(foodId, onHand: false);
      } on Object {
        // Best effort; the failure below is what the user sees.
      }
    }
    return failure;
  }

  /// Runs a write after the earlier ones, applies what it reports to the
  /// list as shown and makes reads that started before it stale.
  Future<Failure?> _edit(
    Future<({List<ShoppingEntry> add, Set<int> remove})> Function(
      ShoppingRepository repository,
    )
    write,
  ) async {
    final ref = this.ref;
    final repository = _repository;
    final done = _writes.then((_) => write(repository));
    _writes = done.then((_) {}, onError: (Object _) {});
    try {
      final (:add, :remove) = await done;
      if (!ref.mounted || !identical(repository, _repository)) return null;
      final server = _server;
      if (server == null) {
        // Still loading: what that read shows may predate this edit.
        unawaited(_resync());
      } else {
        // A poll may have brought an added entry already, maybe in a newer
        // state (checked off by someone else): that one stays.
        final added = {for (final e in add) e.id: e};
        _server = server.copyWith(
          entries: [
            for (final entry in server.entries)
              if (!remove.contains(entry.id))
                switch (added.remove(entry.id)) {
                  null => entry,
                  final mine when !mine.updatedAt.isBefore(entry.updatedAt) =>
                    mine,
                  _ => entry,
                },
            ...added.values,
          ],
        );
        for (final id in remove) {
          _changes.remove(id);
          _queuedOver.remove(id);
        }
        final unqueued = [
          for (final id in remove)
            if (_queued.remove(id) != null) id,
        ];
        if (unqueued.isNotEmpty) {
          _writeQueue((queue) => queue.remove(unqueued));
        }
        // A read that started before this edit can't bring it back.
        _shownRead = ++_reads;
        _publish();
      }
      return null;
    } on Failure catch (error) {
      // Some of it may have gone through (a delete or restore of several
      // entries): show what the server has.
      unawaited(_resync());
      return error;
    } on Object catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'shopping',
        ),
      );
      unawaited(_resync());
      return ServerFailure(cause: error);
    }
  }

  /// Reads the list again after an edit that may have half worked; a
  /// failing read leaves the list as it is.
  Future<void> _resync() async {
    try {
      await refresh();
    } on Object {
      // Pull to refresh says why.
    }
  }

  /// Sends one check-off or uncheck to Tandoor.
  Future<void> _send(
    ShoppingRepository repository,
    List<int> ids,
    bool checked,
  ) => repository.setChecked(ids.toSet(), checked: checked);

  Future<ShoppingListSnapshot> _fullRead(ShoppingRepository repository) async {
    _fullReads++;
    try {
      return await repository.fetch();
    } finally {
      _fullReads--;
    }
  }

  /// Merges the entries an incremental read found changed into the list.
  ///
  /// A read that started before the list shown ([_shownRead]: a full read
  /// or an edit) may bring back an entry deleted since, and older states:
  /// it only updates entries still on the list, where it has a newer state.
  ///
  /// Returns whether the list as shown may have changed.
  bool _merge(int read, ShoppingListSnapshot changes) {
    final server = _server;
    if (server == null) return false;
    final current = read >= _shownRead;
    final changed = {for (final entry in changes.entries) entry.id: entry};
    var differs = false;
    final entries = <ShoppingEntry>[];
    for (final entry in server.entries) {
      final update = changed.remove(entry.id);
      if (update == null ||
          update == entry ||
          (!current && !update.updatedAt.isAfter(entry.updatedAt))) {
        entries.add(entry);
      } else {
        entries.add(update);
        differs = true;
      }
    }
    // New entries, by the others or by this device elsewhere. A list cut
    // off at the cap leaves out the newest; a full read would drop them
    // again.
    if (current && !server.truncated && changed.isNotEmpty) {
      entries.addAll(changed.values);
      differs = true;
    }
    _server = server.copyWith(
      entries: entries,
      syncedAt: current ? changes.syncedAt : server.syncedAt,
    );
    // Check states this read shows as saved.
    for (final entry in changes.entries) {
      final change = _changes[entry.id];
      if (change?.savedBeforeRead case final saved? when saved < read) {
        _changes.remove(entry.id);
        differs = true;
      }
    }
    return differs;
  }

  void _apply(int read, ShoppingListSnapshot snapshot) {
    if (read < _shownRead) return;
    _shownRead = read;
    _server = snapshot;
    _changes.removeWhere(
      (_, change) =>
          change.savedBeforeRead != null && change.savedBeforeRead! < read,
    );
  }

  /// Shows the changes, unless the list is loading anew (another login).
  void _publish() {
    if (state is AsyncData) state = AsyncData(_view());
  }

  ShoppingListView _view() => ShoppingListView(
    truncated: _server?.truncated ?? false,
    cachedAt: _server?.cachedAt,
    pendingIds: Set.unmodifiable(_queued.keys.toSet()),
    entries: List.unmodifiable([
      for (final entry in _server?.entries ?? const <ShoppingEntry>[])
        switch (_changes[entry.id]) {
          null => entry,
          final change => entry.copyWith(
            checked: change.checked,
            completedAt: change.checked ? change.at : null,
            updatedAt: change.at,
          ),
        },
    ]),
  );
}

Duration? _noRetry(int retryCount, Object error) => null;

/// How long reads of the list wait before they send the queue again after
/// the server answered it with an error. Coming back online, or to the list,
/// tries at once.
const _retryAfterRejection = Duration(minutes: 1);

/// Sends check-offs left in the queue by an earlier start of the app, even
/// if the shopping list isn't opened: if there are any, it loads the
/// [ShoppingList], which sends them as soon as the server answers. The app
/// shell watches it.
@Riverpod(keepAlive: true)
Future<void> shoppingQueueReplay(Ref ref) async {
  final pending = await ref.watch(shoppingCheckQueueProvider).read();
  if (pending.isEmpty || !ref.mounted) return;
  ref.listen(shoppingListProvider, (_, _) {});
}

/// The supermarkets of the space, for the picker. The list works without
/// them, so a failure only hides the picker.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<List<Supermarket>> shoppingSupermarkets(Ref ref) =>
    ref.watch(shoppingRepositoryProvider).supermarkets();

/// The id of the current user, to tell their own items from the others';
/// `null` if the server doesn't say.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<int?> shoppingMe(Ref ref) async {
  try {
    return await ref.watch(userRepositoryProvider).currentUserId();
  } on Object {
    return null;
  }
}

const _supermarketKey = 'shopping.supermarket';

/// The id of the supermarket whose order the list follows, remembered on
/// this device for the server it was chosen on (as `<id> <server>`: ids of
/// another server mean other stores); `null` for none (categories by name).
@Riverpod(keepAlive: true)
class ShoppingSupermarketChoice extends _$ShoppingSupermarketChoice {
  @override
  int? build() {
    final server =
        '${ref.watch(sessionControllerProvider).value?.serverUrl ?? ''}';
    final stored = ref.watch(localStoreProvider).read(_supermarketKey) ?? '';
    return switch (stored.split(' ')) {
      [final id, final storedServer] when storedServer == server =>
        int.tryParse(id),
      _ => null,
    };
  }

  void set(int? id) {
    state = id;
    final store = ref.read(localStoreProvider);
    if (id == null) {
      store.delete(_supermarketKey);
    } else {
      final server = ref.read(sessionControllerProvider).value?.serverUrl;
      store.write(_supermarketKey, '$id ${server ?? ''}');
    }
  }
}

/// The chosen supermarket, if the space still has it.
@riverpod
Supermarket? shoppingSupermarket(Ref ref) {
  final id = ref.watch(shoppingSupermarketChoiceProvider);
  if (id == null) return null;
  final supermarkets = ref.watch(shoppingSupermarketsProvider).value;
  for (final supermarket in supermarkets ?? const <Supermarket>[]) {
    if (supermarket.id == id) return supermarket;
  }
  return null;
}

/// The list arranged for the chosen supermarket ([groupShoppingList]).
/// With a supermarket chosen, it waits for the supermarkets, so the sections
/// don't change order once they arrive; if they fail, by name.
@riverpod
AsyncValue<ShoppingListGroups> shoppingGroups(Ref ref) {
  final list = ref.watch(shoppingListProvider);
  if (list.hasError) {
    return AsyncError(list.error!, list.stackTrace ?? StackTrace.empty);
  }
  final supermarkets = ref.watch(shoppingSupermarketsProvider);
  if (ref.watch(shoppingSupermarketChoiceProvider) != null &&
      !supermarkets.hasValue &&
      !supermarkets.hasError) {
    return const AsyncLoading();
  }
  final store = ref.watch(shoppingSupermarketProvider);
  return list.whenData((view) => groupShoppingList(view.entries, store: store));
}
