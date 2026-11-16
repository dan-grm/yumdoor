import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../design/components/search_field.dart';
import '../../design/design.dart';
import '../../domain/models/keyword.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import '../common/offline_disabled.dart';
import '../search/search_providers.dart';

/// Share of the screen height the picker may take.
const _maxHeightFactor = 0.8;

/// Lets the user find a keyword by name, or create one with the typed name,
/// and returns it; `null` if the sheet was closed. Keywords with an id in
/// [exclude] are already on the recipe and not offered.
Future<Keyword?> showKeywordPicker(
  BuildContext context, {
  required Set<int> exclude,
}) {
  final t = context.tokens;
  return showModalBottomSheet<Keyword>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => _KeywordPickerSheet(exclude: exclude),
  );
}

class _KeywordPickerSheet extends ConsumerStatefulWidget {
  const _KeywordPickerSheet({required this.exclude});

  final Set<int> exclude;

  @override
  ConsumerState<_KeywordPickerSheet> createState() =>
      _KeywordPickerSheetState();
}

class _KeywordPickerSheetState extends ConsumerState<_KeywordPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  var _query = '';
  var _creating = false;
  Failure? _createFailure;

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

  /// Creates the keyword [name], or finds it if it exists already, and
  /// returns it. If the field has changed since [name] was searched, only
  /// searches for what it now says, so the row shows what would be created.
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
      final keyword = await ref.read(keywordRepositoryProvider).create(name);
      if (mounted) Navigator.of(context).pop(keyword);
    } on Failure catch (failure) {
      if (mounted) {
        setState(() {
          _creating = false;
          _createFailure = failure;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final found = ref.watch(keywordSuggestionsProvider(_query));
    final suggestions = found.whenData(
      (keywords) => [
        for (final k in keywords)
          if (!widget.exclude.contains(k.id)) k,
      ],
    );
    final createFailure = _createFailure;
    // Offered once the suggestions for the typed text are in and none of
    // them has that name; Tandoor finds names ignoring case.
    final canCreate =
        _query.isNotEmpty &&
        !found.isLoading &&
        !(found.value?.any(
              (k) => k.name.toLowerCase() == _query.toLowerCase(),
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
                    l10n.keywordPickerTitle,
                    style: t.titleM.copyWith(color: t.ink),
                  ),
                ),
                SizedBox(height: t.space3),
                SearchField(
                  controller: _controller,
                  autofocus: true,
                  label: l10n.keywordPickerHint,
                  hint: l10n.keywordPickerHint,
                  clearLabel: l10n.searchClear,
                  onChanged: _onChanged,
                  onSubmitted: _search,
                ),
                SizedBox(height: t.space2),
                if (canCreate)
                  OfflineDisabled(
                    builder: (context, enabled) => _Row(
                      icon: Icons.add_rounded,
                      text: l10n.keywordPickerCreate(_query),
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
                        l10n.keywordPickerCreateFailed(
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
                        text: value[index].name,
                        onTap: _creating
                            ? null
                            : () => Navigator.of(context).pop(value[index]),
                      ),
                    ),
                    AsyncError(:final error) => SingleChildScrollView(
                      child: FailureView(
                        error: error,
                        onRetry: () =>
                            ref.invalidate(keywordSuggestionsProvider(_query)),
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

/// A suggestion, or the row that creates a keyword.
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
