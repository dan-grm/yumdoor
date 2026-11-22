import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/meal_type.dart';
import '../../domain/models/user_ref.dart';
import '../../domain/services/week_plan.dart';

part 'planner_providers.g.dart';

/// The plans of the household on the seven days from [start].
///
/// Failures are shown with a retry button instead of retrying on their own.
@Riverpod(retry: _noRetry)
Future<List<MealPlan>> weekPlans(Ref ref, CalendarDay start) => ref
    .watch(mealPlanRepositoryProvider)
    .list(start, start.addDays(daysInWeek - 1));

Duration? _noRetry(int retryCount, Object error) => null;

/// The meal types of the space, for the plan sheet.
///
/// Failures are shown with a retry button instead of retrying on their own.
@Riverpod(retry: _noRetry)
Future<List<MealType>> mealTypes(Ref ref) =>
    ref.watch(mealTypeRepositoryProvider).list();

/// Who is who in the planner: the current user's id and the names of the
/// space's users by id. Either is missing if the server doesn't tell; the
/// planner then shows all plans without names.
typedef PlannerPeople = ({int? me, Map<int, String> names});

@Riverpod(keepAlive: true, retry: _noRetry)
Future<PlannerPeople> plannerPeople(Ref ref) async {
  final users = ref.watch(userRepositoryProvider);
  Future<T?> orNull<T>(Future<T> future) async {
    try {
      return await future;
    } on Object {
      return null;
    }
  }

  final me = orNull(users.currentUserId());
  final list = await orNull(users.users());
  return (
    me: await me,
    names: {for (final user in list ?? <UserRef>[]) user.id: user.name.trim()},
  );
}

/// Meals being moved or deleted, by id: as they will be once saved, `null`
/// for one being deleted. The planner shows the change right away and offers
/// nothing more for these meals until it is settled, so changes of one meal
/// never overlap.
@riverpod
class PendingPlans extends _$PendingPlans {
  @override
  Map<int, MealPlan?> build() => const {};

  /// Moves [plan] so that it starts on [day], keeping its length. See
  /// [_apply].
  Future<Failure?> move(
    MealPlan plan,
    CalendarDay day, {
    required CalendarDay shown,
  }) {
    if (day == plan.fromDay) return Future.value();
    final repository = ref.read(mealPlanRepositoryProvider);
    return _apply(
      plan,
      plan.copyWith(fromDay: day, toDay: day.addDays(plan.days - 1)),
      () => repository.update(plan.id, MealPlanChanges(day: day)),
      shown: shown,
    );
  }

  /// Deletes [plan]. See [_apply].
  Future<Failure?> delete(MealPlan plan, {required CalendarDay shown}) {
    final repository = ref.read(mealPlanRepositoryProvider);
    return _apply(plan, null, () => repository.delete(plan.id), shown: shown);
  }

  /// Shows [plan] as [pending] while [save] runs. Once saved, the weeks
  /// reload, and the plan is shown as loaded when the week from [shown] (the
  /// one on screen) is back, so it doesn't jump back meanwhile. If saving
  /// fails, the plan is shown as it was and the failure is returned. Does
  /// nothing while a change of [plan] is pending.
  Future<Failure?> _apply(
    MealPlan plan,
    MealPlan? pending,
    Future<void> Function() save, {
    required CalendarDay shown,
  }) async {
    if (state.containsKey(plan.id)) return null;
    state = {...state, plan.id: pending};
    void settle() {
      if (ref.mounted) state = {...state}..remove(plan.id);
    }

    try {
      await save();
    } on Failure catch (failure) {
      settle();
      return failure;
    }
    if (!ref.mounted) return null;
    ref.invalidate(weekPlansProvider);
    try {
      await ref.read(weekPlansProvider(shown).future);
    } on Object {
      // The planner shows the failure.
    }
    settle();
    return null;
  }
}

const _onlyMineKey = 'planner.only-mine';

/// Whether the planner shows only the meals the current user planned,
/// remembered on this device.
@Riverpod(keepAlive: true)
class PlannerOnlyMine extends _$PlannerOnlyMine {
  @override
  bool build() => ref.watch(localStoreProvider).read(_onlyMineKey) == 'true';

  void set(bool value) {
    state = value;
    ref.read(localStoreProvider).write(_onlyMineKey, '$value');
  }
}

const _mealTypeKey = 'planner.meal-type';
const _addToShoppingKey = 'planner.add-to-shopping';

/// What the plan sheet chose last time on this device, to start with next
/// time: the meal type's name (`null` if none yet; a name, not an id, so it
/// also fits after logging in to another server) and whether the missing
/// ingredients went on the shopping list (`true` at first).
typedef PlanSheetDefaults = ({String? mealTypeName, bool addToShopping});

@Riverpod(keepAlive: true)
class PlanSheetChoices extends _$PlanSheetChoices {
  @override
  PlanSheetDefaults build() {
    final store = ref.watch(localStoreProvider);
    return (
      mealTypeName: store.read(_mealTypeKey),
      addToShopping: store.read(_addToShoppingKey) != 'false',
    );
  }

  /// Remembers the choices of a saved plan.
  void remember({required String mealTypeName, required bool addToShopping}) {
    state = (mealTypeName: mealTypeName, addToShopping: addToShopping);
    ref.read(localStoreProvider)
      ..write(_mealTypeKey, mealTypeName)
      ..write(_addToShoppingKey, '$addToShopping');
  }
}
