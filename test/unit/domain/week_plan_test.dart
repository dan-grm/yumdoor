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
}
