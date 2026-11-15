import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/saved_filter.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import 'search_providers.dart';

/// The longest name Tandoor stores for a saved search.
const savedFilterNameLength = 128;

/// Whether [filter] is the search [query] shows.
/// One that finds every recipe in the default order is never applied:
/// tapping it would change nothing.
bool isSavedFilterApplied(SavedFilter filter, RecipeQuery query) =>
    switch (filter.query) {
      const RecipeQuery() => false,
      final saved? => saved == query.copyWith(text: query.text.trim()),
      null => query.savedFilter == filter.id,
    };

/// The saved searches as chips above the results, the applied one first:
/// tapping one applies it, replacing the current search, and tapping it
/// again clears the search. Then "Suche speichern" for the current search
/// and "Verwalten" to rename and delete them. Nothing while there is nothing
/// to show.
class SavedFilterRow extends ConsumerWidget {
  const SavedFilterRow({
    super.key,
    required this.query,
    required this.onChange,
    this.current,
  });

  final RecipeQuery query;
  final void Function(RecipeQuery query) onChange;

  /// The search as it is now, with text typed since [query]; saving saves
  /// that. [query] if `null`.
  final RecipeQuery Function()? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final all = ref.watch(savedFiltersProvider).value ?? const [];
    // The one applied first, so it shows without scrolling the row.
    final filters = [
      ...all.where((f) => isSavedFilterApplied(f, query)),
      ...all.where((f) => !isSavedFilterApplied(f, query)),
    ];
    // A saved search the chips can't show can't be saved inside another.
    final canSave = !query.isEmpty && query.savedFilter == null;
    if (filters.isEmpty && !canSave) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: t.space1),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: t.space5),
        child: Row(
          spacing: t.space2,
          children: [
            for (final filter in filters)
              ChoiceFilterChip(
                label: filter.name,
                selected: isSavedFilterApplied(filter, query),
                onSelected: () => onChange(
                  isSavedFilterApplied(filter, query)
                      ? const RecipeQuery()
                      : filter.search,
                ),
              ),
            if (canSave)
              OfflineDisabled(
                builder: (context, enabled) => AddFilterChip(
                  label: l10n.searchSavedSave,
                  tooltip: l10n.searchSavedSave,
                  onPressed: enabled ? () => _save(context, ref) : null,
                ),
              ),
            if (filters.isNotEmpty)
              _TextAction(
                label: l10n.searchSavedManage,
                icon: Icons.tune_rounded,
                onPressed: () => showSavedFilterManager(context),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    // The providers outlive this row, which may be gone when the request
    // returns.
    final container = ProviderScope.containerOf(context, listen: false);
    final query = current?.call() ?? this.query;
    final name = await _askName(
      context,
      title: l10n.searchSavedSave,
      hint: l10n.searchSavedSaveHint,
    );
    if (name == null || !context.mounted) return;
    try {
      final saved = await container
          .read(savedFilterRepositoryProvider)
          .create(name, query);
      container.invalidate(savedFiltersProvider);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.searchSavedSaved(saved.name))),
      );
    } on Failure catch (failure) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.searchSavedFailed(failureMessage(context, failure)),
          ),
        ),
      );
    }
  }
}

/// The chip of an applied saved search that the other chips can't show
/// ([SavedFilter.query] is `null`), removable like the others.
List<Widget> savedFilterChips(
  BuildContext context, {
  required RecipeQuery query,
  required void Function(RecipeQuery query) onChange,
}) => [
  if (query.savedFilter case final id?)
    _AppliedSavedFilterChip(
      id: id,
      onRemove: () => onChange(query.copyWith(savedFilter: null)),
    ),
];

class _AppliedSavedFilterChip extends ConsumerWidget {
  const _AppliedSavedFilterChip({required this.id, required this.onRemove});

  final int id;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final label = switch (ref.watch(savedFiltersProvider)) {
      AsyncData(:final value) => switch (value
          .where((f) => f.id == id)
          .firstOrNull) {
        final filter? => l10n.searchSavedFilter(filter.name),
        null => l10n.searchFilterUnknown,
      },
      AsyncError() => l10n.searchFilterUnknown,
      _ => l10n.searchFilterLoading,
    };
    return SelectedFilterChip(
      label: label,
      removeLabel: l10n.searchRemoveFilter(label),
      onRemove: onRemove,
    );
  }
}

/// A small text button in the chip row, like the sort button.
class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(t.radiusM),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.sizeTouch),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: t.space2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: t.space1,
              children: [
                Icon(
                  icon,
                  size: t.label.fontSize! + t.space1,
                  color: t.inkMuted,
                ),
                Text(label, style: t.caption.copyWith(color: t.inkMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Lists the saved searches; the user's own can be renamed and deleted
/// there.
Future<void> showSavedFilterManager(BuildContext context) {
  final t = context.tokens;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => const _SavedFilterManager(),
  );
}

class _SavedFilterManager extends ConsumerWidget {
  const _SavedFilterManager();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.searchSavedManageTitle,
                style: t.titleS.copyWith(color: t.ink),
              ),
            ),
            SizedBox(height: t.space1),
            Text(
              l10n.searchSavedManageHint,
              style: t.caption.copyWith(color: t.inkMuted),
            ),
            SizedBox(height: t.space2),
            ...switch (ref.watch(savedFiltersProvider)) {
              AsyncData(:final value) when value.isEmpty => [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: t.space4),
                  child: Text(
                    l10n.searchSavedNone,
                    textAlign: TextAlign.center,
                    style: t.body.copyWith(color: t.inkMuted),
                  ),
                ),
              ],
              AsyncData(:final value) => [
                for (final filter in value) _ManagedFilter(filter: filter),
              ],
              AsyncError(:final error) => [
                FailureView(
                  error: error,
                  onRetry: () => ref.invalidate(savedFiltersProvider),
                ),
              ],
              _ => [
                Padding(
                  padding: EdgeInsets.all(t.space5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            },
          ],
        ),
      ),
    );
  }
}

class _ManagedFilter extends ConsumerWidget {
  const _ManagedFilter({required this.filter});

  final SavedFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: t.sizeTouch),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filter.name, style: t.body.copyWith(color: t.ink)),
                if (!filter.own)
                  Text(
                    l10n.searchSavedShared,
                    style: t.caption.copyWith(color: t.inkMuted),
                  ),
              ],
            ),
          ),
          if (filter.own) ...[
            OfflineDisabled(
              builder: (context, enabled) => IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: t.ink,
                tooltip: l10n.searchSavedRenameLabel(filter.name),
                onPressed: enabled ? () => _rename(context, ref) : null,
              ),
            ),
            OfflineDisabled(
              builder: (context, enabled) => IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: t.danger,
                tooltip: l10n.searchSavedDeleteLabel(filter.name),
                onPressed: enabled ? () => _delete(context, ref) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final name = await _askName(
      context,
      title: l10n.searchSavedRenameTitle,
      initial: filter.name,
    );
    if (name == null || name == filter.name || !context.mounted) return;
    final repository = ref.read(savedFilterRepositoryProvider);
    await _change(context, () => repository.rename(filter.id, name));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final t = context.tokens;
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.searchSavedDeleteTitle(filter.name)),
          content: Text(l10n.searchSavedDeleteText),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: t.danger),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.searchSavedDelete),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;
    final repository = ref.read(savedFilterRepositoryProvider);
    await _change(context, () => repository.delete(filter.id));
  }

  /// Runs [change], then reloads the list; a failure is shown as a message.
  Future<void> _change(
    BuildContext context,
    Future<void> Function() change,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    // The sheet may be closed when the request returns.
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await change();
    } on Failure catch (failure) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.searchSavedFailed(failureMessage(context, failure)),
          ),
        ),
      );
      return;
    }
    container.invalidate(savedFiltersProvider);
  }
}

/// Asks for the name of a saved search; `null` if the dialog was closed.
Future<String?> _askName(
  BuildContext context, {
  required String title,
  String? hint,
  String initial = '',
}) => showDialog<String>(
  context: context,
  builder: (context) => _NameDialog(title: title, hint: hint, initial: initial),
);

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.title, this.hint, required this.initial});

  final String title;
  final String? hint;
  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _name = TextEditingController(text: widget.initial);
  var _showEmpty = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _showEmpty = true);
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final hint = widget.hint;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hint != null) ...[
            Text(hint, style: t.body.copyWith(color: t.inkMuted)),
            SizedBox(height: t.space3),
          ],
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: savedFilterNameLength,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.searchSavedName,
              errorText: _showEmpty ? l10n.searchSavedNameEmpty : null,
            ),
            onChanged: (_) {
              if (_showEmpty) setState(() => _showEmpty = false);
            },
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.searchSavedConfirm)),
      ],
    );
  }
}
