import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import 'cache_database.dart';

/// The meal plans of the weeks the planner showed, in the [CacheDatabase],
/// keeping the [maxRanges] most recently read. Cleared with the rest of the
/// cache (`RecipeCache.clear`).
class MealPlanCache {
  MealPlanCache(
    this._db, {
    this.maxRanges = defaultMaxRanges,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  /// About half a year of weeks; a few KB each.
  static const defaultMaxRanges = 26;

  final CacheDatabase _db;
  final int maxRanges;
  final DateTime Function() _now;

  /// The number to pass to [put] for a read that starts now.
  int get epoch => _db.clears;

  /// Stores [plans] as the plans from [from] to [to], read from the server
  /// just now, unless the cache was cleared since [epoch].
  Future<void> put(
    CalendarDay from,
    CalendarDay to,
    List<MealPlan> plans, {
    required int epoch,
  }) => _db.transaction(() async {
    if (_db.clears != epoch) return;
    await _db
        .into(_db.cachedMealPlans)
        .insertOnConflictUpdate(
          CachedMealPlansCompanion.insert(
            fromDay: '$from',
            toDay: '$to',
            json: jsonEncode([for (final plan in plans) plan.toJson()]),
            storedAt: _now().millisecondsSinceEpoch,
          ),
        );
    final table = _db.cachedMealPlans;
    final oldest = _db.selectOnly(table)
      ..addColumns([table.fromDay, table.toDay])
      ..orderBy([OrderingTerm.desc(table.storedAt)])
      ..limit(-1, offset: maxRanges);
    for (final row in await oldest.get()) {
      await _delete(row.read(table.fromDay)!, row.read(table.toDay)!);
    }
  });

  Future<void> _delete(String from, String to) => (_db.delete(
    _db.cachedMealPlans,
  )..where((r) => r.fromDay.equals(from) & r.toDay.equals(to))).go();

  /// The plans stored for exactly the days from [from] to [to], with when
  /// they were read; `null` if there are none or they can't be read (the
  /// row is then dropped).
  Future<MealPlanList?> get(CalendarDay from, CalendarDay to) async {
    final query = _db.select(_db.cachedMealPlans)
      ..where((r) => r.fromDay.equals('$from') & r.toDay.equals('$to'));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    try {
      return MealPlanList(
        plans: [
          for (final json in jsonDecode(row.json) as List<dynamic>)
            MealPlan.fromJson(json as Map<String, dynamic>),
        ],
        cachedAt: DateTime.fromMillisecondsSinceEpoch(row.storedAt),
      );
    } on Object {
      // Only if a model changed without a new cache version.
      await _delete('$from', '$to');
      return null;
    }
  }
}
