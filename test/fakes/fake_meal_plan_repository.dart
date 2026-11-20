import 'dart:async';

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/repositories/meal_plan_repository.dart';

/// A [MealPlanRepository.list] call, as the fake received it.
typedef ListCall = ({CalendarDay from, CalendarDay to});

/// [MealPlanRepository] for tests, answering [list] from [plans]. Set
/// [failure] to make [list] throw it, [createFailure] for [create].
class FakeMealPlanRepository implements MealPlanRepository {
  FakeMealPlanRepository(this.plans, {this.me = 1});

  final List<MealPlan> plans;
  Failure? failure;
  Failure? createFailure;

  /// The user [create] saves plans for.
  final int me;

  /// While set, [create] waits for it before answering.
  Completer<void>? gate;

  /// The plans [create] received.
  final created = <NewMealPlan>[];

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
  Future<MealPlan> create(NewMealPlan plan) async {
    if (gate case final gate?) await gate.future;
    if (createFailure case final failure?) throw failure;
    created.add(plan);
    final saved = MealPlan(
      id: 1000 + created.length,
      recipe: plan.recipeId == null
          ? null
          : RecipeSummary(id: plan.recipeId!, name: 'Rezept ${plan.recipeId}'),
      title: plan.title,
      servings: plan.servings,
      note: plan.note,
      fromDay: plan.day,
      toDay: plan.day,
      mealType: plan.mealType,
      createdBy: me,
    );
    plans.add(saved);
    return saved;
  }

  @override
  Future<MealPlan> update(int id, MealPlanChanges changes) =>
      throw UnimplementedError();

  @override
  Future<void> delete(int id) => throw UnimplementedError();
}
