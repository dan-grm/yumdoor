import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
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
import '../search/option_sheet.dart';
import 'shopping_providers.dart';

/// How long the snackbar after a check-off offers to undo it.
const shoppingSnackBarDuration = Duration(seconds: 4);

/// How long a failure stays, to read why.
const shoppingFailureSnackBarDuration = Duration(seconds: 8);

/// The household's shopping list (mockup 12-einkaufsliste): open items by
/// supermarket category in the order of the chosen store, merged per food
/// and unit, and the checked-off ones in a collapsed "Erledigt" section.
///
/// A tap checks a row off (or, under "Erledigt", back on), at once and
/// straight to Tandoor ([ShoppingList.setChecked]); a snackbar offers to
/// undo it. Offline, ticking is disabled and says why.
///
/// The list is read again whenever the tab comes back into view, and on
/// pull to refresh.
class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  /// Whether the tab was in view at the last build; hidden tabs have their
  /// tickers off ([TickerMode]).
  bool? _visible;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final visible = TickerMode.valuesOf(context).enabled;
    // Back into view: what the planner or the others added since shows up.
    // After this frame: providers can't change while widgets build.
    if (_visible == false && visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_refreshQuietly());
      });
    }
    _visible = visible;
  }

  Future<void> _refreshQuietly() async {
    if (!ref.read(shoppingListProvider).hasValue) {
      // Failed before: try again, as the retry button would.
      if (ref.read(shoppingListProvider).hasError) {
        ref.invalidate(shoppingListProvider);
        ref.invalidate(shoppingSupermarketsProvider);
      }
      return;
    }
    try {
      await ref.read(shoppingListProvider.notifier).refresh();
    } on Object {
      // The list stays as it was; pull to refresh says why.
    }
  }

  /// For pull to refresh: a failure keeps the list and says why.
  Future<void> _refresh() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!ref.read(shoppingListProvider).hasValue) {
      ref.invalidate(shoppingListProvider);
      ref.invalidate(shoppingSupermarketsProvider);
      try {
        await ref.read(shoppingListProvider.future);
      } on Object {
        // The screen shows the failure.
      }
      return;
    }
    ref.invalidate(shoppingSupermarketsProvider);
    try {
      await ref.read(shoppingListProvider.notifier).refresh();
    } on Failure catch (failure) {
      _show(
        messenger,
        (context) => context.l10n.shoppingRefreshFailed(
          failureMessage(context, failure),
        ),
        failed: true,
      );
    }
  }

  /// Checks [row] off ([checked]) or back on, with a snackbar to undo it.
  Future<void> _toggle(
    ShoppingListRow row,
    String name, {
    required bool checked,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    if (ref.read(isOfflineProvider)) {
      _show(messenger, (context) => context.l10n.offlineWriteDisabled);
      return;
    }
    final list = ref.read(shoppingListProvider.notifier);

    Future<void> set(bool checked, {bool undoable = true}) async {
      if (undoable) {
        _show(
          messenger,
          (context) => checked
              ? context.l10n.shoppingChecked(name)
              : context.l10n.shoppingUnchecked(name),
          undo: () {
            // Gone offline meanwhile: undoing is a write like any other.
            if (ref.read(isOfflineProvider)) {
              _show(messenger, (context) => context.l10n.offlineWriteDisabled);
              return;
            }
            unawaited(set(!checked, undoable: false));
          },
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

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final groups = ref.watch(shoppingGroupsProvider);
    final supermarkets =
        ref.watch(shoppingSupermarketsProvider).value ?? const <Supermarket>[];
    final supermarket = ref.watch(shoppingSupermarketProvider);
    final me = ref.watch(shoppingMeProvider).value;

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
                      Semantics(
                        header: true,
                        child: Text(
                          l10n.navShoppingTitle,
                          style: t.titleL.copyWith(color: t.ink),
                        ),
                      ),
                      if (groups.value case final groups?)
                        Text(
                          l10n.shoppingShared(groups.openCount),
                          style: t.label.copyWith(color: t.inkMuted),
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
                AsyncValue(value: final groups?) => _ListBody(
                  groups: groups,
                  me: me,
                  onRefresh: _refresh,
                  onToggle: _toggle,
                ),
                AsyncValue(:final error?) => FailureView(
                  error: error,
                  onRetry: () {
                    ref.invalidate(shoppingListProvider);
                    ref.invalidate(shoppingSupermarketsProvider);
                  },
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

typedef _Toggle = Future<void> Function(
  ShoppingListRow row,
  String name, {
  required bool checked,
});

/// The sections, the empty states and the "Erledigt" section, scrolling
/// together, with pull to refresh.
class _ListBody extends StatefulWidget {
  const _ListBody({
    required this.groups,
    required this.me,
    required this.onRefresh,
    required this.onToggle,
  });

  final ShoppingListGroups groups;
  final int? me;
  final Future<void> Function() onRefresh;
  final _Toggle onToggle;

  @override
  State<_ListBody> createState() => _ListBodyState();
}

class _ListBodyState extends State<_ListBody> {
  var _showDone = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final _ListBody(:groups, :me, :onToggle) = widget;
    final done = groups.done;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.sizeWide),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space5),
            children: [
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
                _RowCard(rows: section.rows, me: me, onToggle: onToggle),
              ],
              if (done.isNotEmpty) ...[
                SizedBox(height: t.space4),
                Semantics(
                  expanded: _showDone,
                  child: InkWell(
                    onTap: () => setState(() => _showDone = !_showDone),
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
                              _showDone
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
                if (_showDone) ...[
                  SizedBox(height: t.space2),
                  _RowCard(rows: done, me: me, onToggle: onToggle),
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
  const _RowCard({
    required this.rows,
    required this.me,
    required this.onToggle,
  });

  final List<ShoppingListRow> rows;
  final int? me;
  final _Toggle onToggle;

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
              _Row(
                key: ValueKey(row.entryIds.first),
                row: row,
                me: me,
                onToggle: onToggle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// One merged row: the food, where it comes from and the amount.
class _Row extends StatelessWidget {
  const _Row({
    super.key,
    required this.row,
    required this.me,
    required this.onToggle,
  });

  final ShoppingListRow row;
  final int? me;
  final _Toggle onToggle;

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
    return IngredientRow(
      name: name,
      note: _source(context),
      amount: row.someWithoutAmount && amount.isNotEmpty
          ? l10n.shoppingAmountMore(amount)
          : amount,
      done: checked,
      toggleLabel: l10n.ingredientTickOff(name),
      onToggle: () => unawaited(onToggle(row, name, checked: !checked)),
    );
  }

  /// "Ofenkarotten, Linsen-Bolognese", "von Lena hinzugefügt", or both.
  String _source(BuildContext context) {
    final l10n = context.l10n;
    final names = [
      for (final user in row.addedBy)
        if (user.id == me)
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

/// "Lena", "Lena und dir", "Tom, Lena und dir".
String _joinNames(BuildContext context, List<String> names) {
  if (names.length == 1) return names.single;
  return context.l10n.shoppingNamesAnd(
    names.sublist(0, names.length - 1).join(', '),
    names.last,
  );
}
