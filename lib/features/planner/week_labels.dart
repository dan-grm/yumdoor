import 'package:flutter/material.dart';

import '../../domain/models/calendar_day.dart';
import '../../domain/services/week_plan.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';
import '../shell/app_shell.dart';

/// The first day of the week in the locale, 1 (Monday) to 7 (Sunday), like
/// [CalendarDay.weekday].
int firstWeekdayOf(BuildContext context) {
  // 0 is Sunday, 1 Monday.
  final index = MaterialLocalizations.of(context).firstDayOfWeekIndex;
  return index == 0 ? DateTime.sunday : index;
}

/// The planner at the week of [day]: [planPath] for the week of [today], so
/// the tab keeps following the current week, else [planLocation].
String plannerLocation(
  BuildContext context,
  CalendarDay day,
  CalendarDay today,
) {
  final firstWeekday = firstWeekdayOf(context);
  final week = startOfWeek(day, firstWeekday);
  return week == startOfWeek(today, firstWeekday)
      ? planPath
      : planLocation(week);
}

/// The week from [start] as a range, "16. Nov. – 22. Nov.", with the year
/// only for days outside the year of [today].
String weekRangeLabel(
  BuildContext context,
  CalendarDay start,
  CalendarDay today,
) {
  final format = LocaleFormat.of(context);
  final now = today.atLocalTime();
  return context.l10n.planRange(
    format.dayMonthOrDate(start.atLocalTime(), now),
    format.dayMonthOrDate(start.addDays(daysInWeek - 1).atLocalTime(), now),
  );
}

/// [day] with its weekday, "Mittwoch, 25. Nov.".
String dayLabel(BuildContext context, CalendarDay day) {
  final format = LocaleFormat.of(context);
  final date = day.atLocalTime();
  return context.l10n.planDayLabel(
    format.weekdayLong(date),
    format.dayMonth(date),
  );
}
