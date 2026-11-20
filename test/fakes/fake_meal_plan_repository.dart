import 'dart:async';

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/repositories/meal_plan_repository.dart';

/// A [MealPlanRepository.list] call, as the fake received it.
typedef ListCall = ({CalendarDay from, CalendarDay to});

/// [MealPlanRepository] for tests, answering [list] from [plans]. Set
/// [failure] to make [list] throw it.
class FakeMealPlanRepository implements MealPlanRepository {
  FakeMealPlanRepository(this.plans);

  final List<MealPlan> plans;
  Failure? failure;

  /// The [list] calls so far.
  final listCalls = <ListCall>[];

  @override
  Future<List<MealPlan>> list(CalendarDay from, CalendarDay to) async {
    listCalls.add((from: from, to: to));
    if (failure case final failure?) throw failure;
    return [
      for (final plan in plans)
        if (!plan.toDay.isBefore(from) && !plan.fromDay.isAfter(to)) plan,
    ];
  }

  @override
  Future<MealPlan> create(NewMealPlan plan) => throw UnimplementedError();

  @override
  Future<MealPlan> update(int id, MealPlanChanges changes) =>
      throw UnimplementedError();

  @override
  Future<void> delete(int id) => throw UnimplementedError();
}
