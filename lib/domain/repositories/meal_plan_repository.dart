import '../../core/failures.dart';
import '../models/calendar_day.dart';
import '../models/meal_plan.dart';

/// The meal plans of the current user's household. Methods throw a
/// [Failure].
abstract interface class MealPlanRepository {
  /// The plans of the current user and everyone in their household that are
  /// on at least one day from [from] to [to] (both included), sorted by first
  /// day, meal type and id.
  ///
  /// A plan that starts before [from] is included. A plan that ends more
  /// than [maxPlanDays] days after [to] is not found.
  ///
  /// When the server can't be reached, the plans of the same days as last
  /// read may come from the offline cache ([MealPlanList.cachedAt]).
  Future<MealPlanList> list(CalendarDay from, CalendarDay to);

  /// Saves [plan] as the current user's.
  Future<MealPlan> create(NewMealPlan plan);

  /// Applies [changes] to the plan with [id] and returns the saved plan.
  /// Throws [NotFoundFailure] if the household has no such plan.
  Future<MealPlan> update(int id, MealPlanChanges changes);

  /// Deletes the plan with [id], and with it its recipe and entries on the
  /// shopping list. Throws [NotFoundFailure] if the household has no such
  /// plan.
  Future<void> delete(int id);
}

/// How many days after the end of a [MealPlanRepository.list] range a plan
/// may end and still be found.
const maxPlanDays = 31;
