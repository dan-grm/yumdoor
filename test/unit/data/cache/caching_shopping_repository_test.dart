import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/caching_shopping_repository.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/data/cache/shopping_cache.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fakes/fake_shopping_repository.dart';
import '../../../fixtures/shopping.dart';

/// An entry added for a meal plan, so every field is stored once.
final _planned = ShoppingEntry(
  id: 120,
  food: const ShoppingFood(
    id: 20,
    name: 'Ei',
    pluralName: 'Eier',
    category: chilled,
  ),
  amount: 3,
  updatedAt: DateTime.utc(2026, 11, 16, 9, 30, 0, 250),
  createdBy: anna,
  source: ShoppingEntrySource(
    listRecipeId: 9,
    recipeId: 44,
    recipeName: 'Shakshuka',
    servings: 2.5,
    mealPlan: MealPlan(
      id: 31,
      recipe: const RecipeSummary(id: 44, name: 'Shakshuka'),
      servings: 2.5,
      fromDay: CalendarDay(2026, 11, 19),
      toDay: CalendarDay(2026, 11, 19),
      mealType: const MealType(
        id: 1,
        name: 'Frühstück',
        time: Duration(hours: 8),
      ),
      onShoppingList: true,
      createdBy: 1,
    ),
  ),
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late CacheDatabase db;
  late ShoppingCache cache;
  late DateTime now;
  final syncedAt = DateTime.utc(2026, 11, 18, 10, 59);

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 18, 12);
    cache = ShoppingCache(db, clock: () => now);
  });

  tearDown(() => db.close());

  ShoppingListSnapshot snapshot(List<ShoppingEntry> entries) =>
      ShoppingListSnapshot(entries: entries, syncedAt: syncedAt);

  Future<List<int>> storedIds() async => [
    for (final entry in (await cache.list())!.entries) entry.id,
  ];

  group('ShoppingCache', () {
    test('stores the list with all fields and reads it back', () async {
      final entries = [...mockupShoppingList(), _planned];
      await cache.putList(
        snapshot(entries).copyWith(truncated: true),
        epoch: cache.epoch,
      );

      final stored = await cache.list();
      expect(stored?.entries, entries);
      expect(stored?.syncedAt, syncedAt);
      expect(stored?.truncated, isTrue);
      expect(stored?.cachedAt, now);
    });

    test('has no list until one is stored', () async {
      expect(await cache.list(), isNull);
      // Changes without a list don't make one.
      await cache.add(_planned, epoch: cache.epoch);
      expect(await cache.list(), isNull);
    });

    test('replaces the list', () async {
      await cache.putList(snapshot(mockupShoppingList()), epoch: cache.epoch);
      await cache.putList(snapshot([_planned]), epoch: cache.epoch);

      expect(await storedIds(), [120]);
    });

    test('merges changed and new entries', () async {
      final list = mockupShoppingList();
      await cache.putList(snapshot(list), epoch: cache.epoch);
      final checked = list[0].copyWith(
        checked: true,
        completedAt: DateTime.utc(2026, 11, 18, 11),
      );
      final later = DateTime.utc(2026, 11, 18, 11, 59);

      await cache.merge(
        ShoppingListSnapshot(entries: [checked, _planned], syncedAt: later),
        epoch: cache.epoch,
      );

      final stored = (await cache.list())!;
      expect(stored.entries.first, checked);
      expect(stored.entries.last, _planned);
      expect(stored.entries, hasLength(list.length + 1));
      expect(stored.syncedAt, later);
    });

    test('a cut-off list gets no new entries', () async {
      await cache.putList(
        snapshot(mockupShoppingList()).copyWith(truncated: true),
        epoch: cache.epoch,
      );

      await cache.merge(snapshot([_planned]), epoch: cache.epoch);
      expect(await storedIds(), isNot(contains(120)));
    });

    test('applies check-offs, added and deleted entries', () async {
      await cache.putList(snapshot(mockupShoppingList()), epoch: cache.epoch);

      await cache.setChecked({101, 109}, checked: true, epoch: cache.epoch);
      await cache.setChecked({110}, checked: false, epoch: cache.epoch);
      await cache.add(_planned, epoch: cache.epoch);
      await cache.remove({102, 103}, epoch: cache.epoch);

      final stored = {for (final e in (await cache.list())!.entries) e.id: e};
      expect(stored[101]?.checked, isTrue);
      expect(stored[101]?.completedAt, now);
      // Checked off before: keeps when.
      expect(stored[109]?.completedAt, DateTime.utc(2026, 11, 17, 18));
      expect(stored[110]?.checked, isFalse);
      expect(stored[110]?.completedAt, isNull);
      expect(stored.keys, isNot(contains(102)));
      expect(stored.keys, isNot(contains(103)));
      expect(stored.keys.last, 120);
    });

    test('stores the supermarkets', () async {
      expect(await cache.supermarkets(), isNull);

      await cache.putSupermarkets([marketAmEck, bioladen], epoch: cache.epoch);
      expect(await cache.supermarkets(), [marketAmEck, bioladen]);
    });

    test('clearing the cache deletes list and supermarkets', () async {
      await cache.putList(snapshot(mockupShoppingList()), epoch: cache.epoch);
      await cache.putSupermarkets([marketAmEck], epoch: cache.epoch);

      await RecipeCache(db).clear();
      expect(await cache.list(), isNull);
      expect(await cache.supermarkets(), isNull);
      expect(await db.select(db.cachedShoppingEntries).get(), isEmpty);
    });

    test('stores nothing read before the cache was cleared', () async {
      final epoch = cache.epoch;
      await RecipeCache(db).clear();

      await cache.putList(snapshot(mockupShoppingList()), epoch: epoch);
      await cache.putSupermarkets([marketAmEck], epoch: epoch);
      expect(await cache.list(), isNull);
      expect(await cache.supermarkets(), isNull);
    });

    test('stores an entry that comes twice once', () async {
      final list = mockupShoppingList();
      await cache.putList(
        snapshot([...list, list[0].copyWith(amount: 9)]),
        epoch: cache.epoch,
      );

      final stored = (await cache.list())!.entries;
      expect(stored, hasLength(list.length));
      expect(stored.firstWhere((e) => e.id == list[0].id).amount, 9);
    });

    test('leaves out entries it cannot read', () async {
      await cache.putList(snapshot(mockupShoppingList()), epoch: cache.epoch);
      await db.customStatement(
        "UPDATE cached_shopping_entry SET json = '{}' WHERE id = 101",
      );

      expect(await storedIds(), isNot(contains(101)));
      expect(await storedIds(), hasLength(mockupShoppingList().length - 1));
    });
  });

  group('CachingShoppingRepository', () {
    late FakeShoppingRepository remote;
    late CachingShoppingRepository repository;

    setUp(() {
      remote = FakeShoppingRepository(
        entries: mockupShoppingList(),
        supermarketList: const [marketAmEck],
      )..now = syncedAt;
      repository = CachingShoppingRepository(remote, cache);
    });

    Future<ShoppingListSnapshot> offlineRead() {
      remote.fetchFailure = const OfflineFailure();
      return repository.fetch();
    }

    test('stores a full read and answers with it offline', () async {
      final read = await repository.fetch();
      expect(read.cachedAt, isNull);
      await pumpEventQueue();

      final offline = await offlineRead();
      expect(offline.entries, read.entries);
      expect(offline.cachedAt, now);
    });

    test('offline without a stored list fails as before', () async {
      await expectLater(offlineRead(), throwsA(isA<OfflineFailure>()));
    });

    test('an incremental read fails offline', () async {
      await repository.fetch();
      await pumpEventQueue();
      remote.fetchFailure = const OfflineFailure();

      await expectLater(
        repository.fetch(updatedAfter: syncedAt),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('other failures are not covered up', () async {
      await repository.fetch();
      await pumpEventQueue();
      remote.fetchFailure = const ServerFailure();

      await expectLater(repository.fetch(), throwsA(isA<ServerFailure>()));
    });

    test('merges incremental reads into the stored list', () async {
      await repository.fetch();
      remote.entries[0] = remote.entries[0].copyWith(
        checked: true,
        updatedAt: DateTime.utc(2026, 11, 18, 11, 30),
      );
      await repository.fetch(updatedAfter: DateTime.utc(2026, 11, 18, 11));
      await pumpEventQueue();

      expect((await offlineRead()).entries.first.checked, isTrue);
    });

    test(
      'keeps the check-offs, items and deletions the server accepted',
      () async {
        await repository.fetch();
        await repository.setChecked({101}, checked: true);
        final added = await repository.addItem(7, 1);
        await repository.deleteEntries([
          remote.entries.firstWhere((e) => e.id == 102),
        ]);
        await pumpEventQueue();

        final stored = {for (final e in (await offlineRead()).entries) e.id: e};
        expect(stored[101]?.checked, isTrue);
        expect(stored.keys, contains(added.id));
        expect(stored.keys, isNot(contains(102)));
      },
    );

    test('keeps renamed entries in their place', () async {
      await repository.fetch();
      await repository.renameEntries(
        remote.entries.where((e) => e.id == 105),
        'Schafskäse',
      );
      await pumpEventQueue();

      final stored = (await offlineRead()).entries;
      expect(stored.map((e) => e.id), [
        for (final e in mockupShoppingList()) e.id,
      ]);
      expect(stored.firstWhere((e) => e.id == 105).food.name, 'Schafskäse');
    });

    test('a check-off the server rejected is not stored', () async {
      await repository.fetch();
      remote.checkFailure = const ServerFailure();

      await expectLater(
        repository.setChecked({101}, checked: true),
        throwsA(isA<ServerFailure>()),
      );
      await pumpEventQueue();
      final stored = (await offlineRead()).entries;
      expect(stored.firstWhere((e) => e.id == 101).checked, isFalse);
    });

    test('stores the supermarkets and answers with them offline', () async {
      expect(await repository.supermarkets(), [marketAmEck]);
      await pumpEventQueue();

      remote.supermarketList = const [];
      final offline = _OfflineSupermarkets(remote);
      expect(await CachingShoppingRepository(offline, cache).supermarkets(), [
        marketAmEck,
      ]);
    });

    test(
      'a read that started before a deletion does not bring it back',
      () async {
        await repository.fetch();
        final gate = Completer<void>();
        remote.entries[1] = remote.entries[1].copyWith(
          amount: 0.7,
          updatedAt: DateTime.utc(2026, 11, 18, 11, 30),
        );
        remote.fetchGates.add(gate);
        final poll = repository.fetch(
          updatedAfter: DateTime.utc(2026, 11, 18, 11),
        );
        await repository.deleteEntries([remote.entries[1]]);
        gate.complete();
        await poll;
        await pumpEventQueue();

        final stored = (await offlineRead()).entries.map((e) => e.id);
        expect(stored, isNot(contains(102)));
      },
    );

    test('a read that started before a check-off keeps it', () async {
      final gate = Completer<void>();
      remote.fetchGates.add(gate);
      final read = repository.fetch();
      await repository.setChecked({101}, checked: true);
      gate.complete();
      await read;
      await pumpEventQueue();

      // The read had it unchecked; the cache was empty, so it stays out
      // rather than showing an old state.
      final stored = {for (final e in (await offlineRead()).entries) e.id: e};
      expect(stored[101]?.checked ?? true, isTrue);
    });

    test('an older full read keeps what a newer poll stored', () async {
      await repository.fetch();
      await pumpEventQueue();
      final older = Completer<void>();
      remote.fetchGates.add(older);
      final full = repository.fetch();
      remote.entries[0] = remote.entries[0].copyWith(
        checked: true,
        updatedAt: DateTime.utc(2026, 11, 18, 11, 30),
      );
      final later = DateTime.utc(2026, 11, 18, 11, 59);
      remote.now = later;
      await repository.fetch(updatedAfter: DateTime.utc(2026, 11, 18, 11));
      older.complete();
      await full;
      await pumpEventQueue();

      final stored = await offlineRead();
      expect(stored.entries.first.checked, isTrue);
      expect(stored.syncedAt, later);
    });

    test('an older full read that answers last is dropped', () async {
      final older = Completer<void>();
      remote.fetchGates.add(older);
      final first = repository.fetch();
      final removed = remote.entries.removeAt(0);
      await repository.fetch();
      older.complete();
      await first;
      await pumpEventQueue();

      final stored = (await offlineRead()).entries.map((e) => e.id);
      expect(stored, isNot(contains(removed.id)));
    });

    test('stores nothing once closed', () async {
      repository.close();
      await repository.fetch();
      await pumpEventQueue();

      await expectLater(offlineRead(), throwsA(isA<OfflineFailure>()));
    });

    test(
      'a read that ends after logout cleared the cache is not stored',
      () async {
        final gate = Completer<void>();
        remote.fetchGates.add(gate);
        final read = repository.fetch();
        await RecipeCache(db).clear();
        gate.complete();
        await read;
        await pumpEventQueue();

        await expectLater(offlineRead(), throwsA(isA<OfflineFailure>()));
      },
    );
  });

  test('the stored list keeps the user of each entry', () async {
    const ben = UserRef(id: 3, name: 'Ben');
    final entry = _planned.copyWith(createdBy: ben);
    await cache.putList(snapshot([entry]), epoch: cache.epoch);

    expect((await cache.list())!.entries.single.createdBy, ben);
  });
}

/// Fails the supermarkets as offline.
class _OfflineSupermarkets extends FakeShoppingRepository {
  _OfflineSupermarkets(FakeShoppingRepository inner)
    : super(entries: inner.entries);

  @override
  Future<List<Supermarket>> supermarkets() async =>
      throw const OfflineFailure();
}
