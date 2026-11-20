import '../models/calendar_day.dart';
import '../models/meal_plan.dart';
import '../models/meal_type.dart';

/// The days in a week.
const daysInWeek = 7;

/// The first day of the week that holds [day], for a week that starts on
/// [firstWeekday] (1 for Monday to 7 for Sunday, like
/// [CalendarDay.weekday]).
CalendarDay startOfWeek(CalendarDay day, int firstWeekday) {
  assert(firstWeekday >= 1 && firstWeekday <= 7);
  final back = (day.weekday - firstWeekday) % daysInWeek;
  return day.addDays(-back);
}

/// The plans of [plans] that are on [day], by meal type (see
/// [compareMealTypes]) and then id. A plan of several days is on each of
/// them.
List<MealPlan> plansOnDay(Iterable<MealPlan> plans, CalendarDay day) =>
    plans.where((plan) => plan.isOn(day)).toList()..sort((a, b) {
      final byType = compareMealTypes(a.mealType, b.mealType);
      return byType != 0 ? byType : a.id.compareTo(b.id);
    });
