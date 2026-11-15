import 'package:flutter/material.dart';

import '../../design/components/filter_chips.dart';
import '../../domain/models/recipe_query.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import 'option_sheet.dart';

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
          final stars = await showOptionSheet<int>(
            context,
            title: l10n.searchRatingTitle,
            hint: l10n.searchHistoryHint,
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
          final day = await showOptionSheet<DateTime>(
            context,
            title: l10n.searchLastCookedTitle,
            hint: l10n.searchHistoryHint,
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
          final choice = await showOptionSheet<bool>(
            context,
            title: l10n.searchTimesTitle,
            hint: l10n.searchHistoryHint,
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
