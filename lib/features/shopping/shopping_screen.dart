import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/components/ingredient_row.dart';
import '../../design/design.dart';
import '../../domain/models/shopping.dart';
import '../../domain/services/scaling_service.dart';
import '../../domain/services/shopping_list_groups.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_as_of.dart';
import '../search/option_sheet.dart';
import 'add_item_field.dart';
import 'shopping_providers.dart';
import 'shopping_sync.dart';

/// How long the snackbar after a check-off offers to undo it.
const shoppingSnackBarDuration = Duration(seconds: 4);

/// How long a failure stays, to read why.
const shoppingFailureSnackBarDuration = Duration(seconds: 8);

/// The household's shopping list (mockup 12-einkaufsliste): open items by
/// supermarket category in the order of the chosen store, merged per food
/// and unit, and the checked-off ones in a collapsed "Erledigt" section.
/// Where a row comes from (recipes, who added it) shows only when chosen
/// with the button next to the heading ([ShoppingShowSources]). Another
/// button there, or a long press on a row, starts a selection of rows to
/// delete them together.
///
/// A tap checks a row off (or, under "Erledigt", back on), at once and
/// straight to Tandoor ([ShoppingList.setChecked]); a snackbar offers to
/// undo it. Ticking is the one change that works offline: it is kept on the
/// device and sent once the server answers again; until then the row says
/// "wird synchronisiert" and a line above the list counts the waiting rows.
/// The other changes (adding, on hand, deleting) need a connection.
///
/// While the list is in view and online, it stays in sync with the
/// household's ([ShoppingSync]): what the others tick off or add shows up
/// within seconds. Coming back to it (the tab, the app or the connection)
/// reads it again at once, as does pull to refresh.
class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  late final ShoppingSync _sync = ShoppingSync(
    poll: _poll,
    reload: _refreshQuietly,
  );
  late final AppLifecycleListener _lifecycle;
  late final StreamSubscription<bool> _network;

  /// Whether the tab is in view; hidden tabs have their tickers off
  /// ([TickerMode]).
  var _tabVisible = false;

  /// Whether the app is in front (on the web: the browser tab is visible).
  var _appVisible = true;

  /// Whether the screen was set up, so the first start doesn't read the
  /// list that is just being loaded again; later ones catch up.
  var _started = false;

  /// The rows selected to delete them together; `null` while not
  /// selecting. By food, unit and completion rather than by entry, so a row
  /// that splits when someone else ticks part of it off stays one row.
  Set<_RowKey>? _selected;

  /// Whether the selected rows are being deleted.
  var _deleting = false;

  /// Whether the "Erledigt" section is open. Its rows can only be selected
  /// while it is.
  var _showDone = false;

  @override
  void initState() {
    super.initState();
    _appVisible = _isVisible(WidgetsBinding.instance.lifecycleState);
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        _appVisible = _isVisible(state);
        _updateSync();
      },
    );
    // Another login: its rows are not the ones selected.
    ref.listenManual(shoppingListProvider, (_, list) {
      if (list.isReloading && _selected != null) {
        setState(() => _selected = null);
      }
    });
    ref.listenManual(isOfflineProvider, (wasOffline, offline) {
      final wasActive = _sync.active;
      _updateSync();
      // The server answers again after it couldn't be reached: catch up.
      if (wasOffline == true && !offline && wasActive && _sync.active) {
        _sync.catchUp();
      }
    });
    // The device's network alone can change while the server is already
    // unreachable; isOffline stays the same then. Subscribed after
    // isOffline, which hears of a change first.
    _network = ref
        .read(connectivityServiceProvider)
        .onlineChanges
        .listen((_) => _updateSync());
  }

  /// Whether changes are disabled: offline, or the list shown comes from
  /// the offline cache (a request that only timed out).
  bool get _readOnly =>
      ref.read(isOfflineProvider) ||
      ref.read(shoppingListProvider).value?.cachedAt != null;

  /// Inactive still counts: the app is in view, only without focus (a
  /// browser tab while another window has it, a system dialog).
  static bool _isVisible(AppLifecycleState? state) => switch (state) {
    null || AppLifecycleState.resumed || AppLifecycleState.inactive => true,
    AppLifecycleState.hidden ||
    AppLifecycleState.paused ||
    AppLifecycleState.detached => false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabVisible = TickerMode.valuesOf(context).enabled;
    // After this frame: providers can't change while widgets build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateSync();
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_network.cancel());
    _sync.dispose();
    super.dispose();
  }

  /// Keeps the list in sync while it is in view and the device online.
  ///
  /// Only the device's network pauses it: when merely the server can't be
  /// reached, the polls are what notices it answering again.
  void _updateSync() {
    final active =
        _tabVisible &&
        _appVisible &&
        ref.read(connectivityServiceProvider).isOnline;
    final catchUp = _started;
    _started = true;
    if (active != _sync.active) _sync.setActive(active, catchUp: catchUp);
  }

  Future<void> _poll() async {
    if (!ref.read(shoppingListProvider).hasValue) return;
    try {
      await ref.read(shoppingListProvider.notifier).poll();
    } on Failure {
      // The next poll tries again; pull to refresh says why.
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

  /// Reads the list again, keeping it on failure.
  ///
  /// A list that failed to load is tried again, as the retry button would,
  /// when [catchingUp] (back to the list) or while the server can't be
  /// reached (nothing else asks it); otherwise the failure stays on screen.
  Future<void> _refreshQuietly({bool catchingUp = true}) async {
    final list = ref.read(shoppingListProvider);
    if (!list.hasValue) {
      // Not while it loads again (the retry button), or it starts over.
      if (list.hasError &&
          !list.isLoading &&
          (catchingUp || ref.read(isOfflineProvider))) {
        _reload();
      }
      return;
    }
    try {
      await ref.read(shoppingListProvider.notifier).catchUp();
    } on Object {
      // The list stays as it was; pull to refresh says why.
    }
  }

  /// Loads what the list shows anew, after a failure.
  void _reload() {
    ref
      ..invalidate(shoppingListProvider)
      ..invalidate(shoppingSupermarketsProvider)
      ..invalidate(shoppingMeProvider);
  }

  /// For pull to refresh: a failure keeps the list and says why.
  Future<void> _refresh() async {
    final messenger = ScaffoldMessenger.of(context);
    ref.invalidate(shoppingSupermarketsProvider);
    // Unknown after a failure: worth asking again.
    if (ref.read(shoppingMeProvider).value == null) {
      ref.invalidate(shoppingMeProvider);
    }
    Object? failure;
    try {
      await ref.read(shoppingListProvider.notifier).refresh();
      _sync.didReload();
    } on Failure catch (error) {
      failure = error;
    } on Object catch (error, stack) {
      // A bug rather than the server; reported, and said like a server error.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'shopping',
        ),
      );
      failure = error;
    }
    if (failure == null) return;
    _show(
      messenger,
      (context) =>
          context.l10n.shoppingRefreshFailed(failureMessage(context, failure!)),
      failed: true,
    );
  }

  /// Checks [row] off ([checked]) or back on, with a snackbar to undo it.
  Future<void> _toggle(
    ShoppingListRow row,
    String name, {
    required bool checked,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    // Works offline, too: then it waits on the device to be sent.
    final list = ref.read(shoppingListProvider.notifier);

    Future<void> set(bool checked, {bool undoable = true}) async {
      if (undoable) {
        _show(
          messenger,
          (context) => checked
              ? context.l10n.shoppingChecked(name)
              : context.l10n.shoppingUnchecked(name),
          undo: () => unawaited(set(!checked, undoable: false)),
        );
      }
      final failure = await list.setChecked(row.entryIds, checked: checked);
      if (failure == null) return;
      _show(
        messenger,
        (context) => checked
            ? context.l10n.shoppingCheckFailed(
                name,
                failureMessage(context, failure),
              )
            : context.l10n.shoppingUncheckFailed(
                name,
                failureMessage(context, failure),
              ),
        failed: true,
      );
    }

    await set(checked);
  }

  /// Adds the typed [line] ("2 Zitronen"): Tandoor splits it into amount,
  /// unit and food. Returns whether it is on the list now.
  Future<bool> _addLine(String line) async {
    final messenger = ScaffoldMessenger.of(context);
    if (_readOnly) {
      _show(messenger, (context) => context.l10n.offlineWriteDisabled);
      return false;
    }
    final parser = ref.read(ingredientParserProvider);
    final list = ref.read(shoppingListProvider.notifier);
    Failure? failure;
    final foodId = await () async {
      try {
        final parsed = await parser.parse(line);
        if (parsed.food?.id case final id?) {
          failure = await list.addItem(
            id,
            parsed.amount,
            unitId: parsed.unit?.id,
          );
          return id;
        }
      } on Failure catch (error) {
        failure = error;
      } on Object catch (error, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'shopping',
          ),
        );
        failure = ServerFailure(cause: error);
      }
      return null;
    }();
    if (failure case final failure?) {
      _show(
        messenger,
        (context) =>
            context.l10n.shoppingAddFailed(failureMessage(context, failure)),
        failed: true,
      );
      return false;
    }
    if (foodId == null) {
      _show(
        messenger,
        (context) => context.l10n.shoppingAddUnparsed(line),
        failed: true,
      );
      return false;
    }
    _show(messenger, (context) => context.l10n.shoppingAdded(line));
    return true;
  }

  /// The actions of [row]: on hand, or delete.
  Future<void> _more(ShoppingListRow row, String name) async {
    final messenger = ScaffoldMessenger.of(context);
    if (_readOnly) {
      _show(messenger, (context) => context.l10n.offlineWriteDisabled);
      return;
    }
    final l10n = context.l10n;
    final action = await showOptionSheet<_RowAction>(
      context,
      title: name,
      hint: l10n.shoppingOnHandHint,
      options: [
        (l10n.shoppingOnHand, _RowAction.onHand),
        (l10n.shoppingDelete, _RowAction.delete),
      ],
    );
    if (action == null || !mounted) return;
    // Gone offline while choosing.
    if (_readOnly) {
      _show(messenger, (context) => context.l10n.offlineWriteDisabled);
      return;
    }
    final list = ref.read(shoppingListProvider.notifier);
    switch (action) {
      case _RowAction.onHand:
        final failure = await list.markOnHand(row.food.id, row.entryIds);
        _show(
          messenger,
          (context) => failure == null
              ? context.l10n.shoppingOnHandDone(name)
              : context.l10n.shoppingOnHandFailed(
                  name,
                  failureMessage(context, failure),
                ),
          failed: failure != null,
        );
      case _RowAction.delete:
        final entries = list.entriesOf(row.entryIds);
        final failure = await list.delete(entries);
        if (failure != null) {
          _show(
            messenger,
            (context) => context.l10n.shoppingDeleteFailed(
              name,
              failureMessage(context, failure),
            ),
            failed: true,
          );
          return;
        }
        _show(
          messenger,
          (context) => context.l10n.shoppingDeleted(name),
          undo: () => unawaited(
            _restore(
              messenger,
              entries,
              failed: (context, reason) =>
                  context.l10n.shoppingRestoreFailed(name, reason),
            ),
          ),
        );
    }
  }

  /// Puts deleted [entries] back; [failed] says why it didn't work.
  Future<void> _restore(
    ScaffoldMessengerState messenger,
    List<ShoppingEntry> entries, {
    required String Function(BuildContext context, String reason) failed,
  }) async {
    if (_readOnly) {
      _show(messenger, (context) => context.l10n.offlineWriteDisabled);
      return;
    }
    final failure = await ref
        .read(shoppingListProvider.notifier)
        .restore(entries);
    if (failure == null) return;
    _show(
      messenger,
      (context) => failed(context, failureMessage(context, failure)),
      failed: true,
    );
  }

  /// Starts selecting rows, none selected yet.
  void _startSelection() => setState(() => _selected = {});

  void _endSelection() => setState(() => _selected = null);

  /// Puts [row] into the selection or takes it out; starts a selection with
  /// it if there is none. Not while the selection is being deleted.
  void _select(ShoppingListRow row) {
    if (_deleting) return;
    final key = _keyOf(row);
    final selected = {...?_selected};
    if (!selected.remove(key)) selected.add(key);
    setState(() => _selected = selected);
  }

  /// Opens or closes "Erledigt"; closing takes its rows out of the
  /// selection, so nothing hidden is deleted.
  void _setShowDone(bool show) => setState(() {
    _showDone = show;
    if (!show) _selected?.removeWhere((key) => key.completedAt != null);
  });

  /// Deletes the selected rows for the whole household, with a snackbar to
  /// undo it, and ends the selection.
  Future<void> _deleteSelected() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_deleting) return;
    if (_readOnly) {
      _show(messenger, (context) => context.l10n.offlineWriteDisabled);
      return;
    }
    final groups = ref.read(shoppingGroupsProvider).value;
    final selected = _selected;
    if (groups == null || selected == null) return;
    final rows = _selectedRows(groups, selected, withDone: _showDone);
    if (rows.isEmpty) return;
    final list = ref.read(shoppingListProvider.notifier);
    // All entries of each row as shown, including ones merged into it since
    // it was selected.
    final entries = list.entriesOf([for (final row in rows) ...row.entryIds]);
    setState(() => _deleting = true);
    final failure = await list.delete(entries);
    if (mounted) {
      setState(() {
        _deleting = false;
        if (failure == null) _selected = null;
      });
    }
    if (failure != null) {
      _show(
        messenger,
        (context) => context.l10n.shoppingDeleteSelectedFailed(
          failureMessage(context, failure),
        ),
        failed: true,
      );
      return;
    }
    _show(
      messenger,
      (context) => context.l10n.shoppingDeletedSelected(rows.length),
      undo: () => unawaited(
        _restore(
          messenger,
          entries,
          failed: (context, reason) =>
              context.l10n.shoppingRestoreSelectedFailed(reason),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final list = ref.watch(shoppingListProvider);
    // Loading for another login: the previous one's list is not this one's.
    final groups = list.isReloading
        ? const AsyncLoading<ShoppingListGroups>()
        : ref.watch(shoppingGroupsProvider);
    // While reloading for another login, the previous one's are not this
    // one's.
    final supermarketsValue = ref.watch(shoppingSupermarketsProvider);
    final supermarkets = supermarketsValue.isReloading
        ? const <Supermarket>[]
        : supermarketsValue.value ?? const <Supermarket>[];
    final supermarket = ref.watch(shoppingSupermarketProvider);
    final showSources = ref.watch(shoppingShowSourcesProvider);
    final meValue = ref.watch(shoppingMeProvider);
    final me = meValue.isReloading ? null : meValue.value;
    final pendingIds = list.isReloading
        ? const <int>{}
        : list.value?.pendingIds ?? const <int>{};
    final selectedRows = switch ((groups.value, _selected)) {
      (final groups?, final selected?) => _selectedRows(
        groups,
        selected,
        withDone: _showDone,
      ),
      (null, final _?) => const <ShoppingListRow>[],
      (_, null) => null,
    };
    final pendingRows = switch (groups.value) {
      final groups? when pendingIds.isNotEmpty => _pendingRows(
        groups,
        pendingIds,
      ),
      _ => 0,
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: t.sizeWide),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (selectedRows case final selectedRows?)
                        _SelectionBar(
                          count: selectedRows.length,
                          deleting: _deleting,
                          onDelete: () => unawaited(_deleteSelected()),
                          onClose: _endSelection,
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: Semantics(
                                header: true,
                                child: Text(
                                  l10n.navShoppingTitle,
                                  style: t.titleL.copyWith(color: t.ink),
                                ),
                              ),
                            ),
                            // Only where there are rows they could change.
                            if (groups.value case final groups?
                                when !groups.isEmpty) ...[
                              RoundIconButton(
                                icon: Icons.checklist_rounded,
                                label: l10n.shoppingSelectMany,
                                outlined: true,
                                onPressed: _startSelection,
                              ),
                              SizedBox(width: t.space2),
                              RoundIconButton(
                                icon: Icons.menu_book_outlined,
                                label: l10n.shoppingShowSources,
                                outlined: true,
                                selected: showSources,
                                onPressed: () => ref
                                    .read(shoppingShowSourcesProvider.notifier)
                                    .set(show: !showSources),
                              ),
                            ],
                          ],
                        ),
                      if (groups.value case final groups?)
                        Text(
                          l10n.shoppingShared(groups.openCount),
                          style: t.label.copyWith(color: t.inkMuted),
                        ),
                      if (list.value?.cachedAt case final cachedAt?
                          when !list.isReloading) ...[
                        SizedBox(height: t.space1),
                        OfflineAsOf(
                          cachedAt: cachedAt,
                          now: ref.watch(clockProvider)(),
                        ),
                      ],
                      if (pendingRows > 0) ...[
                        SizedBox(height: t.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.sync_rounded,
                              size: t.caption.fontSize,
                              color: t.inkMuted,
                            ),
                            SizedBox(width: t.space1),
                            Expanded(
                              child: Text(
                                l10n.shoppingPending(pendingRows),
                                style: t.caption.copyWith(color: t.inkMuted),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: t.space3),
                      AddItemField(
                        onAdd: _addLine,
                        enabled:
                            !ref.watch(isOfflineProvider) &&
                            list.value?.cachedAt == null,
                        onDisabledTap: () => _show(
                          ScaffoldMessenger.of(context),
                          (context) => context.l10n.offlineWriteDisabled,
                        ),
                      ),
                      if (supermarkets.isNotEmpty) ...[
                        SizedBox(height: t.space2),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: PillButton(
                            label: supermarket == null
                                ? l10n.shoppingSupermarketNone
                                : l10n.shoppingSupermarket(supermarket.name),
                            icon: Icons.storefront_outlined,
                            trailingIcon: Icons.expand_more_rounded,
                            kind: PillButtonKind.secondary,
                            compact: true,
                            onPressed: () =>
                                _pickSupermarket(supermarkets, supermarket),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: t.space2),
            Expanded(
              child: switch (groups) {
                AsyncValue(:final error?) => FailureView(
                  error: error,
                  onRetry: _reload,
                ),
                AsyncValue(value: final groups?) => _ListBody(
                  groups: groups,
                  truncated: list.value?.truncated ?? false,
                  setup: _RowSetup(
                    me: me,
                    showSources: showSources,
                    pendingIds: pendingIds,
                    selected: _selected,
                    onToggle: _toggle,
                    onMore: _more,
                    onSelect: _select,
                  ),
                  showDone: _showDone,
                  onShowDone: _setShowDone,
                  onRefresh: _refresh,
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickSupermarket(
    List<Supermarket> supermarkets,
    Supermarket? selected,
  ) async {
    final l10n = context.l10n;
    // 0 stands for none: supermarket ids start at 1.
    final picked = await showOptionSheet<int>(
      context,
      title: l10n.shoppingSupermarketTitle,
      hint: l10n.shoppingSupermarketHint,
      options: [
        (l10n.shoppingSupermarketByName, 0),
        for (final supermarket in supermarkets)
          (supermarket.name, supermarket.id),
      ],
      selected: selected?.id ?? 0,
    );
    if (picked == null || !mounted) return;
    ref
        .read(shoppingSupermarketChoiceProvider.notifier)
        .set(picked == 0 ? null : picked);
  }
}

enum _RowAction { onHand, delete }

/// Whether [row] has a check state that waits to be sent.
bool _isPending(ShoppingListRow row, Set<int> pendingIds) =>
    row.entryIds.any(pendingIds.contains);

/// What tells a row from the others: open rows are one per food and unit,
/// checked ones also per completion time ([groupShoppingList]).
typedef _RowKey = ({int food, int? unit, int? completedAt});

_RowKey _keyOf(ShoppingListRow row) => (
  food: row.food.id,
  unit: row.unit?.id,
  completedAt: row.completedAt?.microsecondsSinceEpoch,
);

/// The rows of [groups] in [selected], open ones first; checked ones only
/// [withDone].
List<ShoppingListRow> _selectedRows(
  ShoppingListGroups groups,
  Set<_RowKey> selected, {
  required bool withDone,
}) => [
  for (final section in groups.sections) ...section.rows,
  if (withDone) ...groups.done,
].where((row) => selected.contains(_keyOf(row))).toList();

/// How many rows of [groups] wait to be sent.
int _pendingRows(ShoppingListGroups groups, Set<int> pendingIds) => [
  for (final section in groups.sections) ...section.rows,
  ...groups.done,
].where((row) => _isPending(row, pendingIds)).length;

/// Shows the [message] built in the context of [messenger] in place of any
/// snackbar shown before, so quick ticks don't queue up. With [undo], it
/// offers to take the change back.
void _show(
  ScaffoldMessengerState messenger,
  String Function(BuildContext context) message, {
  VoidCallback? undo,
  bool failed = false,
}) {
  if (!messenger.mounted) return;
  final context = messenger.context;
  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message(context)),
        // With an action, a snackbar would stay until it is closed.
        persist: false,
        duration: failed
            ? shoppingFailureSnackBarDuration
            : shoppingSnackBarDuration,
        action: undo == null
            ? null
            : SnackBarAction(label: context.l10n.shoppingUndo, onPressed: undo),
      ),
    );
}

typedef _More = void Function(ShoppingListRow row, String name);

typedef _Toggle = Future<void> Function(
  ShoppingListRow row,
  String name, {
  required bool checked,
});

/// What every row of the list needs besides its own data.
class _RowSetup {
  const _RowSetup({
    required this.me,
    required this.showSources,
    required this.pendingIds,
    required this.selected,
    required this.onToggle,
    required this.onMore,
    required this.onSelect,
  });

  final int? me;

  /// Whether the rows say where they come from.
  final bool showSources;

  /// The entries whose check state waits to be sent.
  final Set<int> pendingIds;

  /// The rows in the selection; `null` while not selecting.
  final Set<_RowKey>? selected;
  final _Toggle onToggle;
  final _More onMore;

  /// Puts a row into the selection or takes it out; starts a selection if
  /// there is none.
  final void Function(ShoppingListRow row) onSelect;
}

/// The sections, the empty states and the "Erledigt" section, scrolling
/// together, with pull to refresh.
class _ListBody extends StatelessWidget {
  const _ListBody({
    required this.groups,
    required this.truncated,
    required this.setup,
    required this.showDone,
    required this.onShowDone,
    required this.onRefresh,
  });

  final ShoppingListGroups groups;

  /// Whether Tandoor cut the list off, so the newest items may be missing.
  final bool truncated;
  final _RowSetup setup;

  /// Whether "Erledigt" is open; [onShowDone] opens or closes it.
  final bool showDone;
  final void Function(bool show) onShowDone;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final _ListBody(:groups, :setup, :showDone) = this;
    final done = groups.done;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.sizeWide),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space5),
            children: [
              if (truncated)
                Padding(
                  padding: EdgeInsets.only(top: t.space2),
                  child: Text(
                    l10n.shoppingTruncated(maxShoppingEntries),
                    style: t.caption.copyWith(color: t.inkMuted),
                  ),
                ),
              if (groups.isEmpty) ...[
                SizedBox(height: t.space4),
                Text(l10n.shoppingEmpty, style: t.bodyL.copyWith(color: t.ink)),
                SizedBox(height: t.space1),
                Text(
                  l10n.shoppingEmptyHint,
                  style: t.body.copyWith(color: t.inkMuted),
                ),
              ] else if (groups.sections.isEmpty) ...[
                SizedBox(height: t.space4),
                Text(
                  l10n.shoppingAllDone,
                  style: t.bodyL.copyWith(color: t.ink),
                ),
              ],
              for (final section in groups.sections) ...[
                Padding(
                  padding: EdgeInsets.only(top: t.space4, bottom: t.space2),
                  child: Semantics(
                    header: true,
                    child: Text(
                      (section.category?.name ?? l10n.shoppingUncategorized)
                          .toUpperCase(),
                      style: t.overline.copyWith(color: t.inkMuted),
                    ),
                  ),
                ),
                _RowCard(rows: section.rows, setup: setup),
              ],
              if (done.isNotEmpty) ...[
                SizedBox(height: t.space4),
                Semantics(
                  expanded: showDone,
                  child: InkWell(
                    onTap: () => onShowDone(!showDone),
                    borderRadius: BorderRadius.circular(t.radiusM),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: t.sizeTouch),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: t.space1),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.shoppingDone(done.length),
                                style: t.titleS.copyWith(color: t.inkMuted),
                              ),
                            ),
                            Icon(
                              showDone
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              color: t.inkMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (showDone) ...[
                  SizedBox(height: t.space2),
                  _RowCard(rows: done, setup: setup),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// [rows] in a card, with hairlines between them.
class _RowCard extends StatelessWidget {
  const _RowCard({required this.rows, required this.setup});

  final List<ShoppingListRow> rows;
  final _RowSetup setup;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusL),
        border: Border.all(color: t.line),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: t.space2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, row) in rows.indexed) ...[
              if (index > 0) Divider(height: 1, thickness: 1, color: t.line),
              _Row(key: ValueKey(row.entryIds.first), row: row, setup: setup),
            ],
          ],
        ),
      ),
    );
  }
}

/// One merged row: the food, the amount and, if chosen, where it comes
/// from. While selecting, a tap selects it instead of checking it off; a
/// long press starts a selection with it.
class _Row extends StatelessWidget {
  const _Row({super.key, required this.row, required this.setup});

  final ShoppingListRow row;
  final _RowSetup setup;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final quantity = row.hasAmount ? Quantity.of(row.amount) : null;
    final plural = ScalingService.isPlural(quantity);
    final name = ScalingService.pickName(
      row.food.name,
      row.food.pluralName,
      plural: plural,
    );
    final unit = switch (row.unit) {
      final unit? => ScalingService.pickName(
        unit.name,
        unit.pluralName,
        plural: plural,
      ),
      null => '',
    };
    final amount = [
      if (quantity != null) format.quantity(quantity),
      unit,
    ].where((part) => part.isNotEmpty).join(' ');
    final checked = row.completedAt != null;
    final t = context.tokens;
    final selected = setup.selected?.contains(_keyOf(row));
    return Row(
      children: [
        Expanded(
          child: IngredientRow(
            name: name,
            note: setup.showSources ? _source(context) : '',
            amount: row.someWithoutAmount && amount.isNotEmpty
                ? l10n.shoppingAmountMore(amount)
                : amount,
            done: checked,
            status: _isPending(row, setup.pendingIds)
                ? l10n.shoppingSyncing
                : '',
            selected: selected,
            toggleLabel: selected == null
                ? l10n.ingredientTickOff(name)
                : l10n.shoppingSelect(name),
            onToggle: selected == null
                ? () => unawaited(setup.onToggle(row, name, checked: !checked))
                : () => setup.onSelect(row),
            onLongPress: selected == null ? () => setup.onSelect(row) : null,
          ),
        ),
        // While selecting, the row's own actions would compete with the
        // selection's.
        if (selected == null)
          IconButton(
            tooltip: l10n.shoppingActions(name),
            icon: const Icon(Icons.more_vert_rounded),
            color: t.inkMuted,
            constraints: BoxConstraints(
              minWidth: t.sizeTouch,
              minHeight: t.sizeTouch,
            ),
            onPressed: () => setup.onMore(row, name),
          ),
      ],
    );
  }

  /// "Ofenkarotten, Linsen-Bolognese", "von Lena hinzugefügt", or both.
  String _source(BuildContext context) {
    final l10n = context.l10n;
    final names = [
      for (final user in row.addedBy)
        if (user.id == setup.me)
          l10n.shoppingAddedByMe
        else if (user.name.trim().isNotEmpty)
          user.name.trim(),
    ];
    return [
      ...row.recipeNames,
      if (names.isNotEmpty) l10n.shoppingAddedBy(_joinNames(context, names)),
    ].join(', ');
  }
}

/// In place of the heading while selecting: how many rows are selected, a
/// button that deletes them and one that ends the selection.
class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    required this.count,
    required this.deleting,
    required this.onDelete,
    required this.onClose,
  });

  final int count;
  final bool deleting;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Row(
      children: [
        RoundIconButton(
          icon: Icons.close_rounded,
          label: l10n.shoppingSelectionEnd,
          outlined: true,
          // The selection stays as it is until the delete has gone through.
          onPressed: deleting ? null : onClose,
        ),
        SizedBox(width: t.space3),
        Expanded(
          child: Semantics(
            header: true,
            liveRegion: true,
            child: Text(
              l10n.shoppingSelectedCount(count),
              style: t.titleL.copyWith(color: t.ink),
            ),
          ),
        ),
        RoundIconButton(
          icon: Icons.delete_outline_rounded,
          label: l10n.shoppingDeleteSelected,
          outlined: true,
          onPressed: count > 0 && !deleting ? onDelete : null,
        ),
      ],
    );
  }
}

/// "Lena", "Lena und dir", "Tom, Lena und dir".
String _joinNames(BuildContext context, List<String> names) {
  if (names.length == 1) return names.single;
  return context.l10n.shoppingNamesAnd(
    names.sublist(0, names.length - 1).join(', '),
    names.last,
  );
}
