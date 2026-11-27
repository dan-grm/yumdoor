import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/calendar_day.dart';
import '../../domain/models/recommendation.dart';
import '../../l10n/l10n.dart';

/// The reasons of a recommendation in the user's language, most important
/// first, as lines for [today]. A rating and the time since the recipe was
/// last cooked that follow each other make one line ("4,5 ★ · 3 Wochen nicht
/// gekocht").
List<String> reasonLines(
  BuildContext context,
  List<RecommendationReason> reasons,
  CalendarDay today,
) {
  final lines = <String>[];
  RecommendationReason? previous;
  for (final reason in reasons) {
    final text = _text(context, reason, today);
    if (previous is HighlyRated && reason is NotCookedSince) {
      lines[lines.length - 1] = '${lines.last} · $text';
    } else {
      lines.add(text);
    }
    previous = reason;
  }
  return lines;
}

String _text(
  BuildContext context,
  RecommendationReason reason,
  CalendarDay today,
) {
  final l10n = context.l10n;
  final locale = Localizations.localeOf(context).toLanguageTag();
  int daysSince(DateTime date) =>
      today.differenceInDays(CalendarDay.of(date.toLocal())).clamp(0, 36500);
  String name(String name, String username) =>
      name.isNotEmpty ? name : username;
  return switch (reason) {
    HighlyRated(:final rating) => l10n.reasonHighlyRated(
      (NumberFormat.decimalPattern(
        locale,
      )..maximumFractionDigits = 1).format(rating),
    ),
    NotCookedSince(:final date) => switch (daysSince(date)) {
      final days when days < 14 => l10n.reasonNotCookedDays(days),
      final days when days < 70 => l10n.reasonNotCookedWeeks(days ~/ 7),
      final days => l10n.reasonNotCookedMonths(days ~/ 30),
    },
    InSeason() => l10n.reasonInSeason(
      DateFormat.MMMM(locale).format(DateTime(2000, today.month)),
    ),
    CookedRecentlyBy(:final user, :final date) => switch (daysSince(date)) {
      final days when days < 7 => l10n.reasonCookedByDays(
        name(user.name, user.username),
        days,
      ),
      final days => l10n.reasonCookedByWeeks(
        name(user.name, user.username),
        days ~/ 7,
      ),
    },
    SimilarTo(:final recipe) => l10n.reasonSimilarTo(recipe.name),
    FreeTextReason(:final text) => text,
  };
}

/// A line from [reasonLines] in the ambient text style, with the star
/// drawn as an icon because Nunito has no ★. Read aloud as written.
class ReasonText extends StatelessWidget {
  const ReasonText(this.text, {super.key, this.maxLines, this.overflow});

  final String text;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;
    final parts = text.split('★');
    return Text.rich(
      TextSpan(
        children: [
          for (final (i, part) in parts.indexed) ...[
            if (i > 0)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.star_rounded,
                  size: style.fontSize,
                  color: style.color,
                ),
              ),
            TextSpan(text: part),
          ],
        ],
      ),
      semanticsLabel: text,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
