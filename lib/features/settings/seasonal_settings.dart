import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/platform_providers.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../common/offline_disabled.dart';
import '../editor/editor_sheet.dart';
import '../editor/picker_sheet.dart';
import '../recommendations/seasonal_keyword_providers.dart';
import '../search/search_providers.dart';

/// The content of the settings section "Saisonale Vorschläge": a row per
/// month, starting with the current one, with its keywords as chips.
///
/// Picking keywords needs the server, so offline the chips stay visible but
/// can't be changed.
class SeasonalSettings extends ConsumerWidget {
  const SeasonalSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final mapping = ref.watch(seasonalKeywordMappingProvider).value;
    final current = ref.watch(clockProvider)().month;
    final locale = Localizations.localeOf(context).toLanguageTag();
    String monthName(int month) =>
        DateFormat.MMMM(locale).format(DateTime(2000, month));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsSeasonalBody,
          style: t.body.copyWith(color: t.inkMuted),
        ),
        if (mapping != null)
          for (var i = 0; i < 12; i++)
            _MonthRow(
              month: (current - 1 + i) % 12 + 1,
              monthName: monthName((current - 1 + i) % 12 + 1),
              isCurrent: i == 0,
              keywordIds: mapping.forMonth((current - 1 + i) % 12 + 1),
              monthNames: monthName,
            ),
      ],
    );
  }
}

class _MonthRow extends ConsumerWidget {
  const _MonthRow({
    required this.month,
    required this.monthName,
    required this.isCurrent,
    required this.keywordIds,
    required this.monthNames,
  });

  final int month;
  final String monthName;
  final bool isCurrent;
  final Set<int> keywordIds;
  final String Function(int month) monthNames;

  Future<void> _set(WidgetRef ref, Iterable<int> ids) async {
    final mapping = await ref.read(seasonalKeywordMappingProvider.future);
    await ref
        .read(seasonalKeywordMappingProvider.notifier)
        .setMapping(mapping.withMonth(month, ids));
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final keyword = await showKeywordPicker(
      context,
      exclude: keywordIds,
      allowCreate: false,
    );
    if (keyword != null) await _set(ref, {...keywordIds, keyword.id});
  }

  Future<void> _copy(BuildContext context, WidgetRef ref) async {
    final months = await showEditorSheet<Set<int>>(
      context,
      (context) => _CopySheet(
        month: month,
        monthName: monthName,
        monthNames: monthNames,
      ),
    );
    if (months == null || months.isEmpty) return;
    var mapping = await ref.read(seasonalKeywordMappingProvider.future);
    for (final target in months) {
      mapping = mapping.withMonth(target, keywordIds);
    }
    await ref.read(seasonalKeywordMappingProvider.notifier).setMapping(mapping);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final ids = keywordIds.toList()..sort();
    return Padding(
      padding: EdgeInsets.only(top: t.space4),
      child: OfflineDisabled(
        builder: (context, enabled) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                monthName,
                style: t.label.copyWith(color: isCurrent ? t.sage : t.ink),
              ),
            ),
            SizedBox(height: t.space2),
            Wrap(
              spacing: t.space2,
              runSpacing: t.space2,
              children: [
                for (final id in ids)
                  _KeywordChip(
                    id: id,
                    monthName: monthName,
                    onRemove: enabled
                        ? () => unawaited(
                            _set(ref, [
                              for (final other in ids)
                                if (other != id) other,
                            ]),
                          )
                        : null,
                  ),
                AddFilterChip(
                  label: l10n.editorAddKeyword,
                  tooltip: l10n.settingsSeasonalAdd(monthName),
                  onPressed: enabled
                      ? () => unawaited(_add(context, ref))
                      : null,
                ),
              ],
            ),
            if (ids.isNotEmpty) ...[
              SizedBox(height: t.space2),
              PillButton(
                label: l10n.settingsSeasonalCopy,
                kind: PillButtonKind.secondary,
                compact: true,
                onPressed: enabled
                    ? () => unawaited(_copy(context, ref))
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A keyword of a month; its name is fetched by id, as only ids are kept.
class _KeywordChip extends ConsumerWidget {
  const _KeywordChip({
    required this.id,
    required this.monthName,
    required this.onRemove,
  });

  final int id;
  final String monthName;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(keywordProvider(id)).value?.name ?? '#$id';
    return SelectedFilterChip(
      label: name,
      removeLabel: context.l10n.settingsSeasonalRemove(name, monthName),
      onRemove: onRemove,
    );
  }
}

/// Which months to copy a month's keywords to; pops the chosen months.
class _CopySheet extends StatefulWidget {
  const _CopySheet({
    required this.month,
    required this.monthName,
    required this.monthNames,
  });

  final int month;
  final String monthName;
  final String Function(int month) monthNames;

  @override
  State<_CopySheet> createState() => _CopySheetState();
}

class _CopySheetState extends State<_CopySheet> {
  final _chosen = <int>{};

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    return EditorSheetFrame(
      title: l10n.settingsSeasonalCopyTitle(widget.monthName),
      children: [
        Text(
          l10n.settingsSeasonalCopyBody,
          style: t.body.copyWith(color: t.inkMuted),
        ),
        Wrap(
          spacing: t.space2,
          runSpacing: t.space2,
          children: [
            for (var m = 1; m <= 12; m++)
              if (m != widget.month)
                ChoiceFilterChip(
                  label: widget.monthNames(m),
                  selected: _chosen.contains(m),
                  onSelected: () => setState(
                    () => _chosen.contains(m)
                        ? _chosen.remove(m)
                        : _chosen.add(m),
                  ),
                ),
          ],
        ),
        PillButton(
          label: l10n.settingsSeasonalCopyApply,
          onPressed: _chosen.isEmpty
              ? null
              : () => Navigator.of(context).pop({..._chosen}),
        ),
      ],
    );
  }
}
