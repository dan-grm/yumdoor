import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/meal_type.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/meal_plan_mapper.dart';

/// Meal plans per request page: `DefaultPagination.max_page_size`.
const _pageSize = 200;

/// Days that cover any difference between two time zones.
const _timeZoneDays = 2;

/// Writes go through [Dio] directly: Tandoor needs the meal type as a plain
/// id (see [NewMealPlanMapper.toJson]), which the generated client can't
/// send.
class TandoorMealPlanRepository implements MealPlanRepository {
  TandoorMealPlanRepository(this._api, this._dio);

  final api.ApiApi _api;
  final Dio _dio;

  /// Tandoor filters by the server's calendar day of a plan's **last** day
  /// only (docs/TANDOOR_API.md#meal-plans). The query reaches
  /// [_timeZoneDays] further on both sides for the difference between the
  /// device's and the server's time zone (up to 26 hours), and [maxPlanDays]
  /// further for plans that end after the range; the rest is filtered here.
  @override
  Future<List<MealPlan>> list(CalendarDay from, CalendarDay to) =>
      guardRequest(() async {
        final plans = <MealPlan>[];
        for (var page = 1; ; page++) {
          final response = requireBody(
            (await _api.apiMealPlanList(
              fromDate: from.addDays(-_timeZoneDays).toString(),
              toDate: to.addDays(maxPlanDays + _timeZoneDays).toString(),
              page: page,
              pageSize: _pageSize,
            )).data,
          );
          for (final dto in response.results) {
            final plan = dto.toDomain();
            if (!plan.toDay.isBefore(from) && !plan.fromDay.isAfter(to)) {
              plans.add(plan);
            }
          }
          if (response.next == null || response.results.isEmpty) break;
        }
        return plans..sort(_compare);
      });

  static int _compare(MealPlan a, MealPlan b) {
    final byDay = a.fromDay.compareTo(b.fromDay);
    if (byDay != 0) return byDay;
    final byType = compareMealTypes(a.mealType, b.mealType);
    if (byType != 0) return byType;
    return a.id.compareTo(b.id);
  }

  /// On create, Tandoor moves a datetime that is exactly midnight in the
  /// server's time zone to the meal type's time on the server's day
  /// (docs/TANDOOR_API.md#meal-plans). If the device's time for the plan is
  /// such a midnight, the plan lands at another time, maybe on another day;
  /// it is then moved back. Update never changes the time. If that fails,
  /// the plan as Tandoor saved it is returned: it exists either way.
  @override
  Future<MealPlan> create(NewMealPlan plan) => guardRequest(() async {
    final body = plan.toJson();
    final response = await _dio.post<Object?>('/api/meal-plan/', data: body);
    final saved = _parse(response.data);
    final sent = DateTime.parse(body['from_date']! as String);
    if (saved.fromDate.isAtSameMomentAs(sent)) return saved.toDomain();
    try {
      final fixed = await _dio.patch<Object?>(
        '/api/meal-plan/${saved.id}/',
        data: {
          'servings': body['servings'],
          'from_date': body['from_date'],
          'to_date': body['to_date'],
        },
      );
      return _parse(fixed.data).toDomain();
    } on DioException {
      return saved.toDomain();
    } on FormatException {
      return saved.toDomain();
    }
  });

  @override
  Future<MealPlan> update(int id, MealPlanChanges changes) =>
      guardRequest(() async {
        // The new dates depend on the saved ones, which may have changed
        // since the plan was listed.
        final current = requireBody(
          (await _api.apiMealPlanRetrieve(id: id)).data,
        );
        final response = await _dio.patch<Object?>(
          '/api/meal-plan/$id/',
          data: changes.toJson(current),
        );
        return _parse(response.data).toDomain();
      });

  @override
  Future<void> delete(int id) =>
      guardRequest(() => _api.apiMealPlanDestroy(id: id));

  static api.MealPlan _parse(Object? json) {
    try {
      return requireBody(
        api.standardSerializers.deserializeWith(
          api.MealPlan.serializer,
          requireBody(json),
        ),
      );
    } on FormatException {
      rethrow;
    } on Object catch (e) {
      // built_value throws its own error types for unexpected JSON.
      throw FormatException('Unexpected meal plan: $e');
    }
  }
}
