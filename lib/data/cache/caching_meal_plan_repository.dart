import 'dart:async';

import '../../core/failures.dart';
import '../../domain/models/calendar_day.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import 'meal_plan_cache.dart';

/// Lists meal plans from the server and keeps each list in the
/// [MealPlanCache], which answers for the same days when the server can't
/// be reached ([OfflineFailure]). Changes are only made online (offline is
/// read-only); the planner reads the week again after each, which stores
/// it anew.
///
/// After each list from the server, [storeRecipe] is called in the
/// background for the recipe of each plan that isn't over yet, so the
/// planned recipes open offline too. Past weeks store none: they would only
/// push the recipes the user opened out of the cache.
class CachingMealPlanRepository implements MealPlanRepository {
  CachingMealPlanRepository(
    this._remote,
    this._cache, {
    this.storeRecipe,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now,
       _epoch = _cache.epoch;

  final MealPlanRepository _remote;
  final MealPlanCache _cache;
  final DateTime Function() _now;

  /// [MealPlanCache.epoch] when this session started: once logout cleared
  /// the cache, nothing more is stored.
  final int _epoch;

  /// Stores a planned recipe for offline use and returns once it is stored.
  /// May throw.
  final Future<void> Function(RecipeSummary recipe)? storeRecipe;

  var _closed = false;

  /// Counts the lists started, to order them.
  var _clock = 0;

  /// For each range stored, when the list stored for it started; an older
  /// list that answers later is not stored over it.
  final _storedRead = <String, int>{};

  Future<void> _writes = Future.value();

  /// Stops storing: the session ended, and logout clears the cache.
  void close() => _closed = true;

  @override
  Future<MealPlanList> list(CalendarDay from, CalendarDay to) async {
    final start = ++_clock;
    final MealPlanList list;
    try {
      list = await _remote.list(from, to);
    } on OfflineFailure {
      return await _readCache(from, to) ?? (throw const OfflineFailure());
    }
    if (!_closed) {
      final key = '$from $to';
      _writes = _writes.then((_) async {
        if (_closed || (_storedRead[key] ?? -1) > start) return;
        await _ignoreErrors(() async {
          await _cache.put(from, to, list.plans, epoch: _epoch);
          _storedRead[key] = start;
        }());
      });
      unawaited(_ignoreErrors(_storeRecipes(list.plans)));
    }
    return list;
  }

  /// One after another, so a week doesn't send a burst of requests.
  Future<void> _storeRecipes(List<MealPlan> plans) async {
    final store = storeRecipe;
    if (store == null) return;
    final today = CalendarDay.of(_now());
    final recipes = {
      for (final plan in plans)
        if (plan.recipe case final recipe? when !plan.toDay.isBefore(today))
          recipe.id: recipe,
    };
    for (final recipe in recipes.values) {
      if (_closed || _cache.epoch != _epoch) return;
      await _ignoreErrors(store(recipe));
    }
  }

  @override
  Future<MealPlan> create(NewMealPlan plan) => _remote.create(plan);

  @override
  Future<MealPlan> update(int id, MealPlanChanges changes) =>
      _remote.update(id, changes);

  @override
  Future<void> delete(int id) => _remote.delete(id);

  Future<MealPlanList?> _readCache(CalendarDay from, CalendarDay to) async {
    try {
      return await _cache.get(from, to);
    } on Object {
      return null;
    }
  }
}

/// The cache is a convenience: when it fails, the app goes on without it.
Future<void> _ignoreErrors(Future<void> future) async {
  try {
    await future;
  } on Object {
    // Ignored.
  }
}
