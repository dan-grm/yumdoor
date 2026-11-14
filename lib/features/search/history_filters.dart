import 'package:flutter/material.dart';

import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../domain/models/recipe_query.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';

/// How many times counts as "often cooked".
const oftenCooked = 5;

/// Highest minimum rating offered.
const _maxStars = 5;

/// How long ago "not cooked since" can reach back, as a date from [now].
DateTime _weeksAgo(DateTime now, int weeks) =>
    DateTime(now.year, now.month, now.day - 7 * weeks);

DateTime _monthsAgo(DateTime now, int months) =>
    DateTime(now.year, now.month - months, now.day);

/// The chips for the filters on the user's own cooking history: minimum
/// rating, when it was last cooked and how often. A filter that is set shows
/// as a removable chip, an unset one as a "+" chip that opens a sheet of
/// choices. Tandoor counts only the user's own cook logs, which the sheets
/// and chips say.
List<Widget> historyFilterChips(
  BuildContext context, {
  required RecipeQuery query,
  required void Function(RecipeQuery query) onChange,
}) {
  final l10n = context.l10n;
  final format = LocaleFormat.of(context);

  Widget selected(String label, RecipeQuery cleared) => SelectedFilterChip(
    label: label,
    removeLabel: l10n.searchRemoveFilter(label),
    onRemove: () => onChange(cleared),
  );

  return [
    if (query.minRating case final stars?)
      selected(l10n.searchRatingFilter(stars), query.copyWith(minRating: null))
    else
      AddFilterChip(
        label: l10n.searchAddRating,
        tooltip: l10n.searchRatingTitle,
        onPressed: () async {
          final stars = await _pick<int>(
            context,
            title: l10n.searchRatingTitle,
            options: [
              for (var stars = 1; stars <= _maxStars; stars++)
                (l10n.searchRatingOption(stars), stars),
            ],
          );
          if (stars != null) onChange(query.copyWith(minRating: stars));
        },
      ),
    if (query.lastCookedBefore case final day?)
      selected(
        l10n.searchLastCookedFilter(format.date(day)),
        query.copyWith(lastCookedBefore: null),
      )
    else
      AddFilterChip(
        label: l10n.searchAddLastCooked,
        tooltip: l10n.searchLastCookedTitle,
        onPressed: () async {
          final now = DateTime.now();
          final day = await _pick<DateTime>(
            context,
            title: l10n.searchLastCookedTitle,
            options: [
              (l10n.searchLastCookedWeeks, _weeksAgo(now, 2)),
              (l10n.searchLastCookedMonth, _monthsAgo(now, 1)),
              (l10n.searchLastCookedMonths, _monthsAgo(now, 3)),
            ],
          );
          if (day != null) onChange(query.copyWith(lastCookedBefore: day));
        },
      ),
    if (query.neverCooked)
      selected(l10n.searchTimesNeverFilter, query.copyWith(neverCooked: false))
    else if (query.minTimesCooked case final times?)
      selected(
        l10n.searchTimesMinFilter(times),
        query.copyWith(minTimesCooked: null),
      )
    else
      AddFilterChip(
        label: l10n.searchAddTimesCooked,
        tooltip: l10n.searchTimesTitle,
        onPressed: () async {
          final choice = await _pick<bool>(
            context,
            title: l10n.searchTimesTitle,
            options: [
              (l10n.searchTimesNever, true),
              (l10n.searchTimesOften, false),
            ],
          );
          if (choice == null) return;
          onChange(
            choice
                ? query.copyWith(neverCooked: true)
                : query.copyWith(minTimesCooked: oftenCooked),
          );
        },
      ),
  ];
}

Future<T?> _pick<T>(
  BuildContext context, {
  required String title,
  required List<(String, T)> options,
}) {
  final t = context.tokens;
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    backgroundColor: t.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusL)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(t.space5, 0, t.space5, t.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: t.titleS.copyWith(color: t.ink)),
            ),
            SizedBox(height: t.space1),
            Text(
              context.l10n.searchHistoryHint,
              style: t.caption.copyWith(color: t.inkMuted),
            ),
            SizedBox(height: t.space2),
            for (final (label, value) in options)
              InkWell(
                onTap: () => Navigator.of(context).pop(value),
                borderRadius: BorderRadius.circular(t.radiusM),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: t.sizeTouch),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(label, style: t.body.copyWith(color: t.ink)),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
