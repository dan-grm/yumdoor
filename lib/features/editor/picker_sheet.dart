import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderBase;

import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/search_field.dart';
import '../../design/design.dart';
import '../../domain/models/food.dart';
import '../../domain/models/keyword.dart';
import '../../domain/models/unit.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../search/search_providers.dart';
import 'editor_sheet.dart';

/// Share of the screen height the picker may take.
const _maxHeightFactor = 0.8;

/// Lets the user find a keyword by name, or create one with the typed name,
/// and returns it; `null` if the sheet was closed. Keywords with an id in
/// [exclude] are already on the recipe and not offered.
///
/// With [allowCreate] false, only existing keywords can be picked.
Future<Keyword?> showKeywordPicker(
  BuildContext context, {
  required Set<int> exclude,
  bool allowCreate = true,
}) => _showPicker(
  context,
  _PickerConfig<Keyword>(
    title: (l10n) => l10n.keywordPickerTitle,
    hint: (l10n) =>
        allowCreate ? l10n.keywordPickerHint : l10n.keywordPickerSearchHint,
    allowCreate: allowCreate,
    suggestions: keywordSuggestionsProvider.call,
    create: (ref, name) => ref.read(keywordRepositoryProvider).create(name),
    id: (keyword) => keyword.id,
    name: (keyword) => keyword.name,
    exclude: exclude,
  ),
);

/// Lets the user find a food by name, or create one, and returns it; `null`
/// if the sheet was closed.
Future<Food?> showFoodPicker(BuildContext context) => _showPicker(
  context,
  _PickerConfig<Food>(
    title: (l10n) => l10n.foodPickerTitle,
    hint: (l10n) => l10n.foodPickerHint,
    suggestions: foodSuggestionsProvider.call,
    create: (ref, name) => ref.read(foodRepositoryProvider).create(name),
    id: (food) => food.id,
    name: (food) => food.name,
  ),
);

/// Lets the user find a unit by name, or create one, and returns it; `null`
/// if the sheet was closed.
Future<Unit?> showUnitPicker(BuildContext context) => _showPicker(
  context,
  _PickerConfig<Unit>(
    title: (l10n) => l10n.unitPickerTitle,
    hint: (l10n) => l10n.unitPickerHint,
    suggestions: unitSuggestionsProvider.call,
    create: (ref, name) => ref.read(unitRepositoryProvider).create(name),
    id: (unit) => unit.id,
    name: (unit) => unit.name,
  ),
);

/// What a picker sheet finds and creates.
final class _PickerConfig<T extends Object> {
  const _PickerConfig({
    required this.title,
    required this.hint,
    required this.suggestions,
    required this.create,
    required this.id,
    required this.name,
    this.exclude = const {},
    this.allowCreate = true,
  });

  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) hint;

  /// The suggestions for the typed text.
  final ProviderBase<AsyncValue<List<T>>> Function(String query) suggestions;

  /// Creates an item with the name, or finds the one that has it.
  final Future<T> Function(WidgetRef ref, String name) create;
  final int Function(T item) id;
  final String Function(T item) name;

  /// Ids of items that aren't offered.
  final Set<int> exclude;

  /// Whether a typed name that matches nothing can be created.
  final bool allowCreate;
}

Future<T?> _showPicker<T extends Object>(
  BuildContext context,
  _PickerConfig<T> config,
) => showEditorSheet<T>(context, (context) => _PickerSheet<T>(config: config));

class _PickerSheet<T extends Object> extends ConsumerStatefulWidget {
  const _PickerSheet({required this.config});

  final _PickerConfig<T> config;

  @override
  ConsumerState<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T extends Object>
    extends ConsumerState<_PickerSheet<T>> {
  final _controller = TextEditingController();
  Timer? _debounce;
  var _query = '';
  var _creating = false;
  Failure? _createFailure;

  _PickerConfig<T> get _config => widget.config;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, () => _search(text));
    if (_createFailure != null) setState(() => _createFailure = null);
  }

  void _search(String text) {
    _debounce?.cancel();
    if (text.trim() != _query) setState(() => _query = text.trim());
  }

  /// Creates the item [name], or finds it if it exists already, and returns
  /// it. If the field has changed since [name] was searched, only searches
  /// for what it now says, so the row shows what would be created.
  Future<void> _create(String name) async {
    if (_controller.text.trim() != name) {
      _search(_controller.text);
      return;
    }
    setState(() {
      _creating = true;
      _createFailure = null;
    });
    try {
      final item = await _config.create(ref, name);
      if (mounted) Navigator.of(context).pop(item);
    } on Object catch (error) {
      // Anything else, too: a sheet stuck in `_creating` takes no taps.
      if (mounted) {
        setState(() {
          _creating = false;
          _createFailure = error is Failure
              ? error
              : ServerFailure(cause: error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final config = _config;
    final found = ref.watch(config.suggestions(_query));
    final suggestions = found.whenData(
      (items) => [
        for (final item in items)
          if (!config.exclude.contains(config.id(item))) item,
      ],
    );
    final createFailure = _createFailure;
    // Offered once the suggestions for the typed text are in and none of
    // them has that name; Tandoor finds names ignoring case.
    final canCreate =
        config.allowCreate &&
        _query.isNotEmpty &&
        !found.isLoading &&
        !(found.value?.any(
              (item) => config.name(item).toLowerCase() == _query.toLowerCase(),
            ) ??
            false);

    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: media.size.height * _maxHeightFactor,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    config.title(l10n),
                    style: t.titleM.copyWith(color: t.ink),
                  ),
                ),
                SizedBox(height: t.space3),
                SearchField(
                  controller: _controller,
                  autofocus: true,
                  label: config.hint(l10n),
                  hint: config.hint(l10n),
                  clearLabel: l10n.searchClear,
                  onChanged: _onChanged,
                  onSubmitted: _search,
                ),
                SizedBox(height: t.space2),
                if (canCreate)
                  OfflineDisabled(
                    builder: (context, enabled) => _Row(
                      icon: Icons.add_rounded,
                      text: l10n.pickerCreate(_query),
                      busy: _creating,
                      onTap: enabled && !_creating
                          ? () => _create(_query)
                          : null,
                    ),
                  ),
                if (createFailure != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: t.space2),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        l10n.pickerCreateFailed(
                          failureMessage(context, createFailure),
                        ),
                        style: t.body.copyWith(color: t.danger),
                      ),
                    ),
                  ),
                Flexible(
                  child: switch (suggestions) {
                    AsyncData(:final value) => ListView.separated(
                      shrinkWrap: true,
                      itemCount: value.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: t.line),
                      itemBuilder: (context, index) => _Row(
                        text: config.name(value[index]),
                        onTap: _creating
                            ? null
                            : () => Navigator.of(context).pop(value[index]),
                      ),
                    ),
                    AsyncError(:final error) => SingleChildScrollView(
                      child: FailureView(
                        error: error,
                        onRetry: () =>
                            ref.invalidate(config.suggestions(_query)),
                      ),
                    ),
                    _ => Padding(
                      padding: EdgeInsets.all(t.space5),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A suggestion, or the row that creates an item.
class _Row extends StatelessWidget {
  const _Row({
    required this.text,
    required this.onTap,
    this.icon,
    this.busy = false,
  });

  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final iconSize = t.bodyL.fontSize! + t.space1;
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.sizeTouch),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: t.space2,
              vertical: t.space3,
            ),
            child: Row(
              children: [
                if (busy)
                  SizedBox.square(
                    dimension: iconSize,
                    child: const CircularProgressIndicator(),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    size: iconSize,
                    color: onTap == null ? t.inkMuted : t.sage,
                  ),
                if (busy || icon != null) SizedBox(width: t.space2),
                Expanded(
                  child: Text(
                    text,
                    style: t.bodyL.copyWith(
                      color: onTap == null && !busy ? t.inkMuted : t.ink,
                      fontWeight: icon != null ? t.label.fontWeight : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
