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

/// How long after its meal type's time a meal still counts as the next one:
/// dinner at 18:00 is still today's meal while it is being cooked and eaten.
const mealTimeGrace = Duration(hours: 2);

/// Today's meals as the start screen shows them: [next], the one to show
/// first, and the [others] in the order of [plansOnDay].
typedef TodaysMeals = ({MealPlan next, List<MealPlan> others});

/// The meals of [plans] on the day of [now], `null` if there are none.
///
/// The next meal is the first, in the order of [plansOnDay], whose meal
/// type's time is set and not more than [mealTimeGrace] past. If every timed
/// meal is past, or none has a time, it is the first meal without a time; if
/// there is none, the last meal of the day.
TodaysMeals? todaysMeals(Iterable<MealPlan> plans, DateTime now) {
  final today = plansOnDay(plans, CalendarDay.of(now));
  if (today.isEmpty) return null;
  final sinceMidnight = Duration(
    hours: now.hour,
    minutes: now.minute,
    seconds: now.second,
  );
  final next =
      today.where((plan) {
        final time = plan.mealType.time;
        return time != null && time + mealTimeGrace >= sinceMidnight;
      }).firstOrNull ??
      today.where((plan) => plan.mealType.time == null).firstOrNull ??
      today.last;
  return (
    next: next,
    others: [
      for (final plan in today)
        if (plan.id != next.id) plan,
    ],
  );
}
