import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/caching_saved_filter_repository.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/data/cache/saved_filter_cache.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';
import 'package:yumdoor/domain/models/saved_filter.dart';

import '../../../fakes/fake_saved_filter_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late CacheDatabase db;
  late SavedFilterCache cache;

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    cache = SavedFilterCache(db);
  });

  tearDown(() => db.close());

  final filters = [
    SavedFilter(
      id: 4,
      name: 'Zum Wochenende',
      query: RecipeQuery(
        text: 'Suppe',
        keywordIds: const {3},
        lastCookedBefore: DateTime(2026, 10, 2),
        sort: RecipeSort.rating,
      ),
    ),
    const SavedFilter(id: 2, name: 'Selten gekocht'),
    const SavedFilter(
      id: 9,
      name: 'Bens Kuchen',
      query: RecipeQuery(text: 'Kuchen'),
      own: false,
    ),
  ];

  group('SavedFilterCache', () {
    test('stores the list and reads it back in its order', () async {
      await cache.putAll(filters);

      expect(await cache.all(), filters);
    });

    test('replaces the list', () async {
      await cache.putAll(filters);
      await cache.putAll([filters[1]]);

      expect(await cache.all(), [filters[1]]);
    });

    test('is cleared with the recipe cache', () async {
      await cache.putAll(filters);

      await RecipeCache(db).clear();

      expect(await cache.all(), isEmpty);
    });
  });

  group('CachingSavedFilterRepository', () {
    test('stores what the server lists', () async {
      final remote = FakeSavedFilterRepository(filters);

      final listed = await CachingSavedFilterRepository(
        remote,
        cache,
      ).savedFilters();
      // Stored in the background.
      await pumpEventQueue();

      expect(await cache.all(), listed);
    });

    test('answers from the cache offline', () async {
      await cache.putAll(filters);
      final remote = FakeSavedFilterRepository()
        ..failure = const OfflineFailure();

      expect(
        await CachingSavedFilterRepository(remote, cache).savedFilters(),
        filters,
      );
    });

    test('stays offline without a stored list', () {
      final remote = FakeSavedFilterRepository()
        ..failure = const OfflineFailure();

      expect(
        CachingSavedFilterRepository(remote, cache).savedFilters(),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('passes other failures on', () async {
      await cache.putAll(filters);
      final remote = FakeSavedFilterRepository()
        ..failure = const ServerFailure();

      expect(
        CachingSavedFilterRepository(remote, cache).savedFilters(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
