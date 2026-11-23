import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../app/session.dart';
import '../../core/failures.dart';
import '../../domain/models/shopping.dart';
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
  });

  final List<ShoppingEntry> entries;

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
  /// sent. Reads started later include it.
  int? savedBeforeRead;
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
/// Sending goes through [_send], the one place a queue for offline
/// check-offs (#116) can take over later. Until then, a tap offline only
/// explains that ticking needs a connection.
@Riverpod(keepAlive: true, retry: _noRetry)
class ShoppingList extends _$ShoppingList {
  late ShoppingRepository _repository;

  /// The list as last read from the server.
  ShoppingListSnapshot? _server;

  /// Check states set here, by entry id.
  final _changes = <int, _CheckChange>{};

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
    _server = null;
    _changes.clear();
    final read = ++_reads;
    final snapshot = await _fullRead(_repository);
    _apply(read, snapshot);
    return _view();
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
  }

  /// Sends what is waiting to be sent, then reads the list again
  /// ([refresh]): for coming back to the list, or back online.
  ///
  /// The offline check-off queue (#116) hooks in here: once [_send] queues
  /// check-offs while offline and chains sending them on [_writes] when the
  /// connection is back, this read shows the list after they went through.
  Future<void> catchUp() async {
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
    final ref = this.ref;
    final repository = _repository;
    final read = ++_reads;
    final changes = await repository.fetch(updatedAfter: server.syncedAt);
    if (!ref.mounted || !identical(repository, _repository)) return;
    if (_merge(read, changes)) _publish();
  }

  /// Checks off ([checked] `true`) or unchecks the entries with [ids],
  /// showing it at once and sending it right away. Returns `null` once it is
  /// saved, or the [Failure] after taking it back.
  Future<Failure?> setChecked(List<int> ids, {required bool checked}) async {
    if (ids.isEmpty) return null;
    final ref = this.ref;
    final repository = _repository;
    final change = _CheckChange(
      checked: checked,
      at: ref.read(clockProvider)(),
    );
    // What each entry showed before, to go back to if this fails.
    final previous = {for (final id in ids) id: _changes[id]};
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
    if (failure == null) {
      change.savedBeforeRead = _reads;
    } else {
      // Back to what was shown before, where no later change took over.
      for (final MapEntry(key: id, value: before) in previous.entries) {
        if (!identical(_changes[id], change)) continue;
        if (before == null) {
          _changes.remove(id);
        } else {
          _changes[id] = before;
        }
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
