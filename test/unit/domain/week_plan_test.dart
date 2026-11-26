import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/services/week_plan.dart';

MealPlan plan(
  int id,
  CalendarDay from, {
  CalendarDay? to,
  MealType type = const MealType(id: 1, name: 'Abendessen', order: 2),
}) => MealPlan(
  id: id,
  servings: 2,
  fromDay: from,
  toDay: to ?? from,
  mealType: type,
  createdBy: 1,
);

void main() {
  group('startOfWeek', () {
    // 2026-11-18 is a Wednesday.
    final wednesday = CalendarDay(2026, 11, 18);

    test('finds Monday and Sunday starts', () {
      expect(
        startOfWeek(wednesday, DateTime.monday),
        CalendarDay(2026, 11, 16),
      );
      expect(
        startOfWeek(wednesday, DateTime.sunday),
        CalendarDay(2026, 11, 15),
      );
    });

    test('keeps the first day itself and reaches into the last month', () {
      expect(
        startOfWeek(CalendarDay(2026, 11, 16), DateTime.monday),
        CalendarDay(2026, 11, 16),
      );
      expect(
        startOfWeek(CalendarDay(2026, 12, 2), DateTime.monday),
        CalendarDay(2026, 11, 30),
      );
    });

    test('a Sunday belongs to the week before when weeks start on Monday', () {
      expect(
        startOfWeek(CalendarDay(2026, 11, 22), DateTime.monday),
        CalendarDay(2026, 11, 16),
      );
    });
  });

  group('plansOnDay', () {
    final day = CalendarDay(2026, 11, 18);
    const breakfast = MealType(id: 2, name: 'Frühstück', order: 0);
    const dinner = MealType(id: 1, name: 'Abendessen', order: 2);

    test('orders by meal type, then id', () {
      final plans = [
        plan(5, day, type: dinner),
        plan(4, day, type: dinner),
        plan(9, day, type: breakfast),
      ];
      expect(plansOnDay(plans, day).map((p) => p.id), [9, 4, 5]);
    });

    test('includes plans of several days on each of them only', () {
      final plans = [plan(1, day, to: day.addDays(2))];
      expect(plansOnDay(plans, day.addDays(-1)), isEmpty);
      expect(plansOnDay(plans, day), hasLength(1));
      expect(plansOnDay(plans, day.addDays(2)), hasLength(1));
      expect(plansOnDay(plans, day.addDays(3)), isEmpty);
    });
  });

  group('todaysMeals', () {
    final day = CalendarDay(2026, 11, 18);
    const breakfast = MealType(
      id: 1,
      name: 'Frühstück',
      order: 0,
      time: Duration(hours: 8),
    );
    const lunch = MealType(
      id: 2,
      name: 'Mittagessen',
      order: 1,
      time: Duration(hours: 12, minutes: 30),
    );
    const dinner = MealType(
      id: 3,
      name: 'Abendessen',
      order: 2,
      time: Duration(hours: 18),
    );
    const snack = MealType(id: 4, name: 'Snack', order: 3);
    DateTime at(int hour, [int minute = 0]) =>
        DateTime(2026, 11, 18, hour, minute);

    test('is null without meals today', () {
      expect(todaysMeals([plan(1, day.addDays(1))], at(12)), isNull);
    });

    test('picks the next meal by its type\'s time', () {
      final plans = [
        plan(1, day, type: dinner),
        plan(2, day, type: breakfast),
        plan(3, day, type: lunch),
      ];
      final morning = todaysMeals(plans, at(7))!;
      expect(morning.next.id, 2);
      expect(morning.others.map((p) => p.id), [3, 1]);
      expect(todaysMeals(plans, at(13))!.next.id, 3);
      final afternoon = todaysMeals(plans, at(15))!;
      expect(afternoon.next.id, 1);
      expect(afternoon.others.map((p) => p.id), [2, 3]);
    });

    test('goes by time, not by the order of the meal types', () {
      // Types created in Tandoor's UI all have order 0 and sort by name.
      final plans = [
        plan(1, day, type: dinner.copyWith(order: 0)),
        plan(2, day, type: breakfast.copyWith(order: 0)),
        plan(3, day, type: lunch.copyWith(order: 0)),
      ];
      expect(todaysMeals(plans, at(7))!.next.id, 2);
      expect(todaysMeals(plans, at(11))!.next.id, 3);
      expect(todaysMeals(plans, at(23))!.next.id, 1);
    });

    test('keeps a meal next for a while after its time', () {
      final plans = [plan(1, day, type: dinner)];
      expect(todaysMeals(plans, at(20))!.next.id, 1);
      final lunchOnly = [plan(2, day, type: lunch), plan(3, day, type: snack)];
      expect(todaysMeals(lunchOnly, at(14, 30))!.next.id, 2);
      expect(todaysMeals(lunchOnly, at(14, 31))!.next.id, 3);
    });

    test('without times, the first meal; all past, the last', () {
      expect(
        todaysMeals([plan(5, day, type: snack), plan(4, day)], at(9))!.next.id,
        4,
      );
      final past = [plan(1, day, type: breakfast), plan(2, day, type: lunch)];
      expect(todaysMeals(past, at(23))!.next.id, 2);
    });

    test('includes a plan of several days', () {
      final meals = todaysMeals([
        plan(1, day.addDays(-1), to: day.addDays(1)),
      ], at(12))!;
      expect(meals.next.id, 1);
      expect(meals.others, isEmpty);
    });
  });
}
