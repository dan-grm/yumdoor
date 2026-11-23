import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../domain/models/shopping.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../domain/services/shopping_list_groups.dart';

part 'shopping_providers.g.dart';

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
/// check-offs (#116) can take over later. Until then, the screen doesn't
/// offer ticking offline.
@Riverpod(keepAlive: true, retry: _noRetry)
class ShoppingList extends _$ShoppingList {
  late ShoppingRepository _repository;

  /// The entries as last read from the server.
  List<ShoppingEntry> _server = const [];

  /// Check states set here, by entry id.
  final _changes = <int, _CheckChange>{};

  /// The changes being sent, in order. Kept when the list starts over, so
  /// a change still can't overtake an earlier one.
  Future<void> _writes = Future.value();

  /// How many reads have started.
  var _reads = 0;

  /// The read [_server] comes from; an older one that ends later is
  /// dropped.
  var _shownRead = 0;

  @override
  Future<List<ShoppingEntry>> build() async {
    _repository = ref.watch(shoppingRepositoryProvider);
    _server = const [];
    _changes.clear();
    final read = ++_reads;
    final snapshot = await _repository.fetch();
    _apply(read, snapshot);
    return _view();
  }

  /// Reads the list again, keeping the one shown meanwhile. Throws the
  /// [Failure] if the read fails; the list then stays as it was.
  Future<void> refresh() async {
    // This build's ref: a new login starts over, and then this read is old.
    final ref = this.ref;
    final repository = _repository;
    final read = ++_reads;
    final snapshot = await repository.fetch();
    if (!ref.mounted || !identical(repository, _repository)) return;
    _apply(read, snapshot);
    state = AsyncData(_view());
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

  /// Sends one check-off or uncheck to Tandoor.
  Future<void> _send(
    ShoppingRepository repository,
    List<int> ids,
    bool checked,
  ) => repository.setChecked(ids.toSet(), checked: checked);

  void _apply(int read, ShoppingListSnapshot snapshot) {
    if (read < _shownRead) return;
    _shownRead = read;
    _server = snapshot.entries;
    _changes.removeWhere(
      (_, change) =>
          change.savedBeforeRead != null && change.savedBeforeRead! < read,
    );
  }

  void _publish() {
    if (state.hasValue) state = AsyncData(_view());
  }

  List<ShoppingEntry> _view() => List.unmodifiable([
    for (final entry in _server)
      switch (_changes[entry.id]) {
        null => entry,
        final change => entry.copyWith(
          checked: change.checked,
          completedAt: change.checked ? change.at : null,
          updatedAt: change.at,
        ),
      },
  ]);
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
/// this device; `null` for none (categories by name).
@Riverpod(keepAlive: true)
class ShoppingSupermarketChoice extends _$ShoppingSupermarketChoice {
  @override
  int? build() =>
      int.tryParse(ref.watch(localStoreProvider).read(_supermarketKey) ?? '');

  void set(int? id) {
    state = id;
    final store = ref.read(localStoreProvider);
    if (id == null) {
      store.delete(_supermarketKey);
    } else {
      store.write(_supermarketKey, '$id');
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
@riverpod
AsyncValue<ShoppingListGroups> shoppingGroups(Ref ref) {
  final store = ref.watch(shoppingSupermarketProvider);
  return ref
      .watch(shoppingListProvider)
      .whenData((entries) => groupShoppingList(entries, store: store));
}
