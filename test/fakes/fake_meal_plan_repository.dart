import 'dart:async';

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/repositories/meal_plan_repository.dart';

/// A [MealPlanRepository.list] call, as the fake received it.
typedef ListCall = ({CalendarDay from, CalendarDay to});

/// [MealPlanRepository] for tests, answering [list] from [plans]. Set
/// [failure] to make [list] throw it, [createFailure] for [create],
/// [updateFailure] for [update] and [deleteFailure] for [delete].
class FakeMealPlanRepository implements MealPlanRepository {
  FakeMealPlanRepository(this.plans, {this.me = 1});

  final List<MealPlan> plans;
  Failure? failure;
  Failure? createFailure;
  Failure? updateFailure;
  Failure? deleteFailure;

  /// The user [create] saves plans for.
  final int me;

  /// While set, [create], [update] and [delete] wait for it before
  /// answering.
  Completer<void>? gate;

  /// The [update] calls received, by plan id.
  final updates = <({int id, MealPlanChanges changes})>[];

  /// The ids [delete] received.
  final deleted = <int>[];

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
  Future<MealPlan> update(int id, MealPlanChanges changes) async {
    if (gate case final gate?) await gate.future;
    if (updateFailure case final failure?) throw failure;
    updates.add((id: id, changes: changes));
    final index = plans.indexWhere((plan) => plan.id == id);
    if (index < 0) throw const NotFoundFailure();
    final plan = plans[index];
    final from = changes.day ?? plan.fromDay;
    final saved = plan.copyWith(
      fromDay: from,
      toDay: from.addDays(plan.days - 1),
      mealType: changes.mealType ?? plan.mealType,
      servings: changes.servings ?? plan.servings,
      note: changes.note ?? plan.note,
    );
    plans[index] = saved;
    return saved;
  }

  @override
  Future<void> delete(int id) async {
    if (gate case final gate?) await gate.future;
    if (deleteFailure case final failure?) throw failure;
    deleted.add(id);
    plans.removeWhere((plan) => plan.id == id);
  }
}
