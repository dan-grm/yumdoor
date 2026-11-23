import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/caching_meal_plan_repository.dart';
import 'package:yumdoor/data/cache/meal_plan_cache.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fakes/fake_meal_plan_repository.dart';

const _dinner = MealType(
  id: 3,
  name: 'Abendessen',
  order: 2,
  color: 0xE07A5F,
  time: Duration(hours: 18, minutes: 30),
);

final _monday = CalendarDay(2026, 11, 16);
final _sunday = CalendarDay(2026, 11, 22);

final _bolognese = MealPlan(
  id: 1,
  recipe: RecipeSummary(
    id: 101,
    name: 'Linsen-Bolognese',
    image: Uri.parse('https://tandoor.example.com/media/101.jpg'),
    keywords: const [Keyword(id: 3, name: 'Pasta')],
    foods: const [Food(id: 4, name: 'Linsen', onHand: true)],
    servings: 4,
    workingTime: const Duration(minutes: 20),
    rating: 4.5,
    createdBy: const UserRef(id: 2, name: 'Ben'),
    updatedAt: DateTime.utc(2026, 11, 2, 8, 15, 30, 123),
  ),
  servings: 3.5,
  note: 'Mit **Parmesan**',
  fromDay: _monday,
  toDay: _monday,
  mealType: _dinner,
  onShoppingList: true,
  createdBy: 1,
);

final _leftovers = MealPlan(
  id: 2,
  title: 'Reste',
  servings: 2,
  fromDay: CalendarDay(2026, 11, 21),
  toDay: CalendarDay(2026, 11, 23),
  mealType: const MealType(id: 2, name: 'Mittagessen'),
  createdBy: 2,
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late CacheDatabase db;
  late MealPlanCache cache;
  late DateTime now;

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 18, 12);
    cache = MealPlanCache(db, clock: () => now);
  });

  tearDown(() => db.close());

  group('MealPlanCache', () {
    test('stores plans with all their fields and reads them back', () async {
      await cache.put(_monday, _sunday, [
        _bolognese,
        _leftovers,
      ], epoch: cache.epoch);

      final stored = await cache.get(_monday, _sunday);
      expect(stored?.plans, [_bolognese, _leftovers]);
      expect(stored?.cachedAt, now);
    });

    test('answers only for the same days', () async {
      await cache.put(_monday, _sunday, [_bolognese], epoch: cache.epoch);

      expect(await cache.get(_monday, _sunday.addDays(1)), isNull);
      expect(await cache.get(_monday.addDays(7), _sunday.addDays(7)), isNull);
    });

    test('keeps the most recently read weeks', () async {
      cache = MealPlanCache(db, maxRanges: 2, clock: () => now);
      for (var week = 0; week < 3; week++) {
        now = now.add(const Duration(minutes: 1));
        await cache.put(_monday.addDays(7 * week), _sunday.addDays(7 * week), [
          _bolognese,
        ], epoch: cache.epoch);
      }

      expect(await cache.get(_monday, _sunday), isNull);
      expect(
        await cache.get(_monday.addDays(7), _sunday.addDays(7)),
        isNotNull,
      );
      expect(
        await cache.get(_monday.addDays(14), _sunday.addDays(14)),
        isNotNull,
      );
    });

    test('stores nothing read before the cache was cleared', () async {
      final epoch = cache.epoch;
      await RecipeCache(db).clear();

      await cache.put(_monday, _sunday, [_bolognese], epoch: epoch);
      expect(await cache.get(_monday, _sunday), isNull);
    });

    test('clearing the cache deletes the plans', () async {
      await cache.put(_monday, _sunday, [_bolognese], epoch: cache.epoch);

      await RecipeCache(db).clear();
      expect(await cache.get(_monday, _sunday), isNull);
    });

    test('drops plans it cannot read instead of failing', () async {
      await cache.put(_monday, _sunday, [_bolognese], epoch: cache.epoch);
      await db.customStatement(
        "UPDATE cached_meal_plans SET json = '[{\"id\": \"x\"}]'",
      );

      expect(await cache.get(_monday, _sunday), isNull);
      expect(await db.select(db.cachedMealPlans).get(), isEmpty);
    });
  });

  group('CachingMealPlanRepository', () {
    late FakeMealPlanRepository remote;
    late List<int> storedRecipes;
    late CachingMealPlanRepository repository;

    setUp(() {
      remote = FakeMealPlanRepository([_bolognese, _leftovers]);
      storedRecipes = [];
      repository = CachingMealPlanRepository(
        remote,
        cache,
        storeRecipe: (recipe) async => storedRecipes.add(recipe.id),
      );
    });

    test('stores what the server lists', () async {
      final list = await repository.list(_monday, _sunday);
      expect(list.plans, [_bolognese, _leftovers]);
      expect(list.cachedAt, isNull);
      await pumpEventQueue();

      expect((await cache.get(_monday, _sunday))?.plans, list.plans);
    });

    test('falls back to the stored plans offline', () async {
      await repository.list(_monday, _sunday);
      await pumpEventQueue();
      final readAt = now;
      now = now.add(const Duration(hours: 2));
      remote.failure = const OfflineFailure();

      final list = await repository.list(_monday, _sunday);
      expect(list.plans, [_bolognese, _leftovers]);
      expect(list.cachedAt, readAt);
    });

    test('offline without stored plans fails as before', () async {
      remote.failure = const OfflineFailure();

      await expectLater(
        repository.list(_monday, _sunday),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('other failures are not covered up', () async {
      await repository.list(_monday, _sunday);
      await pumpEventQueue();
      remote.failure = const ServerFailure();

      await expectLater(
        repository.list(_monday, _sunday),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('stores the planned recipes for offline use', () async {
      await repository.list(_monday, _sunday);
      await pumpEventQueue();

      expect(storedRecipes, [101]);
    });

    test('a recipe that fails to store does not stop the others', () async {
      final second = _bolognese.copyWith(
        id: 3,
        recipe: const RecipeSummary(id: 102, name: 'Flammkuchen'),
      );
      remote.plans.add(second);
      repository = CachingMealPlanRepository(
        remote,
        cache,
        storeRecipe: (recipe) async {
          storedRecipes.add(recipe.id);
          if (recipe.id == 101) throw const ServerFailure();
        },
      );

      await repository.list(_monday, _sunday);
      await pumpEventQueue();
      expect(storedRecipes, [101, 102]);
    });

    test('stores nothing once closed', () async {
      repository.close();

      await repository.list(_monday, _sunday);
      await pumpEventQueue();
      expect(await cache.get(_monday, _sunday), isNull);
      expect(storedRecipes, isEmpty);
    });

    test(
      'a list that ends after logout cleared the cache is not stored',
      () async {
        final gate = Completer<void>();
        final slow = _GatedRepository(remote, gate.future);
        repository = CachingMealPlanRepository(slow, cache);

        final list = repository.list(_monday, _sunday);
        await RecipeCache(db).clear();
        gate.complete();
        await list;
        await pumpEventQueue();

        expect(await cache.get(_monday, _sunday), isNull);
      },
    );
  });
}

/// Lists only once [listGate] completes.
class _GatedRepository extends FakeMealPlanRepository {
  _GatedRepository(FakeMealPlanRepository inner, this.listGate)
    : super(inner.plans);

  final Future<void> listGate;

  @override
  Future<MealPlanList> list(CalendarDay from, CalendarDay to) async {
    await listGate;
    return super.list(from, to);
  }
}
