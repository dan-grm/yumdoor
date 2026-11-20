import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../app/repository_providers.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
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
