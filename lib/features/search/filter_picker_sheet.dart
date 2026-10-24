import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/components/search_field.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../common/failure_view.dart';
import 'search_providers.dart';

/// What a [showFilterPicker] picks.
enum FilterKind { food, keyword }

/// Share of the screen height the picker may take.
const _maxHeightFactor = 0.8;

/// Lets the user find a food or keyword by name and returns its id, or `null`
/// if the sheet was closed. Ids in [exclude] are already filters and not
/// offered again.
Future<int?> showFilterPicker(
  BuildContext context, {
  required FilterKind kind,
  required Set<int> exclude,
}) {
  final t = context.tokens;
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => _FilterPickerSheet(kind: kind, exclude: exclude),
  );
}

class _FilterPickerSheet extends ConsumerStatefulWidget {
  const _FilterPickerSheet({required this.kind, required this.exclude});

  final FilterKind kind;
  final Set<int> exclude;

  @override
  ConsumerState<_FilterPickerSheet> createState() => _FilterPickerSheetState();
}

class _FilterPickerSheetState extends ConsumerState<_FilterPickerSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  var _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, () => _search(text));
  }

  void _search(String text) {
    _debounce?.cancel();
    if (text.trim() != _query) setState(() => _query = text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final food = widget.kind == FilterKind.food;
    final suggestions = food
        ? ref
              .watch(foodSuggestionsProvider(_query))
              .whenData((foods) => [for (final f in foods) (f.id, f.name)])
        : ref
              .watch(keywordSuggestionsProvider(_query))
              .whenData(
                (keywords) => [for (final k in keywords) (k.id, k.name)],
              );
    void retry() => food
        ? ref.invalidate(foodSuggestionsProvider(_query))
        : ref.invalidate(keywordSuggestionsProvider(_query));

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
                    food ? l10n.pickerFoodTitle : l10n.pickerKeywordTitle,
                    style: t.titleM.copyWith(color: t.ink),
                  ),
                ),
                SizedBox(height: t.space3),
                SearchField(
                  controller: _controller,
                  autofocus: true,
                  label: food ? l10n.pickerFoodHint : l10n.pickerKeywordHint,
                  hint: food ? l10n.pickerFoodHint : l10n.pickerKeywordHint,
                  clearLabel: l10n.searchClear,
                  onChanged: _onChanged,
                  onSubmitted: _search,
                ),
                if (food) ...[
                  SizedBox(height: t.space2),
                  Text(
                    l10n.pickerFoodNote,
                    style: t.caption.copyWith(color: t.inkMuted),
                  ),
                ],
                SizedBox(height: t.space2),
                Flexible(
                  child: switch (suggestions) {
                    AsyncData(:final value) => _SuggestionList(
                      suggestions: [
                        for (final suggestion in value)
                          if (!widget.exclude.contains(suggestion.$1))
                            suggestion,
                      ],
                    ),
                    AsyncError(:final error) => SingleChildScrollView(
                      child: FailureView(error: error, onRetry: retry),
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

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.suggestions});

  /// (id, name)
  final List<(int, String)> suggestions;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    if (suggestions.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: t.space5),
        child: Text(
          context.l10n.pickerEmpty,
          textAlign: TextAlign.center,
          style: t.body.copyWith(color: t.inkMuted),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: suggestions.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: t.line),
      itemBuilder: (context, index) {
        final (id, name) = suggestions[index];
        return InkWell(
          onTap: () => Navigator.of(context).pop(id),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: t.sizeTouch),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: t.space2,
                vertical: t.space3,
              ),
              child: Text(name, style: t.bodyL.copyWith(color: t.ink)),
            ),
          ),
        );
      },
    );
  }
}
