import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
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
