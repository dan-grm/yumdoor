import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/cache/cache_database.dart';
import 'package:yumdoor/data/cache/recipe_cache.dart';
import 'package:yumdoor/domain/models/recipe.dart';

import '../../../fixtures/recipes.dart';

/// [ofenkarotten] under another [id], with an image named after it.
Recipe recipeNo(int id) => ofenkarotten.copyWith(
  id: id,
  name: 'Rezept $id',
  image: Uri.parse('https://tandoor.example.com/media/recipes/$id.jpg'),
);

void main() {
  // Every test opens its own databases, some several on one file in turn.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late CacheDatabase db;
  late DateTime now;
  late RecipeCache cache;

  setUp(() {
    db = CacheDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 10, 24, 12);
    cache = RecipeCache(db, maxRecipes: 3, clock: () => now);
  });

  tearDown(() => db.close());

  /// Moves the clock on, so every access gets its own time.
  void tick() => now = now.add(const Duration(minutes: 1));

  test('stores a recipe and reads it back unchanged', () async {
    final recipe = ofenkarotten.copyWith(
      image: Uri.parse('https://tandoor.example.com/media/k.jpg'),
      sourceUrl: Uri.parse('https://example.com/karotten'),
      lastCooked: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 9, 30, 8, 15),
    );

    await cache.put(recipe);

    expect(await cache.get(recipe.id), recipe);
    expect(await cache.get(999), isNull);
  });

  test('replaces an older copy of the same recipe', () async {
    await cache.put(ofenkarotten);
    await cache.put(ofenkarotten.copyWith(servings: 4));

    expect((await cache.get(ofenkarotten.id))!.servings, 4);
    expect(await cache.all(), hasLength(1));
  });

  test('lists recipes, most recently opened first', () async {
    for (final id in [1, 2, 3]) {
      await cache.put(recipeNo(id));
      tick();
    }
    await cache.get(1);

    expect([for (final r in await cache.all()) r.id], [1, 3, 2]);
  });

  group('LRU cap', () {
    test('drops the least recently opened recipe beyond the cap', () async {
      for (final id in [1, 2, 3, 4]) {
        await cache.put(recipeNo(id));
        tick();
      }

      expect([for (final r in await cache.all()) r.id], [4, 3, 2]);
    });

    test('counts reading a stored recipe as opening it', () async {
      for (final id in [1, 2, 3]) {
        await cache.put(recipeNo(id));
        tick();
      }
      await cache.get(1);
      tick();
      await cache.put(recipeNo(4));

      expect([for (final r in await cache.all()) r.id], [4, 1, 3]);
    });

    test('drops the images of dropped recipes', () async {
      for (final id in [1, 2, 3]) {
        await cache.put(recipeNo(id));
        await cache.putImage(recipeNo(id).image!, Uint8List.fromList([id]));
        tick();
      }
      await cache.put(recipeNo(4));

      expect(await cache.image(recipeNo(1).image!), isNull);
      expect(await cache.image(recipeNo(2).image!), [2]);
    });
  });

  group('images', () {
    test('are stored for a stored recipe', () async {
      final url = recipeNo(1).image!;
      await cache.put(recipeNo(1));

      expect(await cache.hasImage(url), isFalse);
      await cache.putImage(url, Uint8List.fromList([1, 2, 3]));

      expect(await cache.hasImage(url), isTrue);
      expect(await cache.image(url), [1, 2, 3]);
    });

    test('are not stored when no stored recipe uses them', () async {
      final url = recipeNo(1).image!;

      await cache.putImage(url, Uint8List.fromList([1]));

      expect(await cache.image(url), isNull);
    });

    test('go when the recipe gets another image', () async {
      final old = recipeNo(1).image!;
      await cache.put(recipeNo(1));
      await cache.putImage(old, Uint8List.fromList([1]));

      await cache.put(recipeNo(1).copyWith(image: null));

      expect(await cache.image(old), isNull);
    });
  });

  test('remove deletes the recipe and its image', () async {
    await cache.put(recipeNo(1));
    await cache.putImage(recipeNo(1).image!, Uint8List.fromList([1]));

    await cache.remove(1);

    expect(await cache.get(1), isNull);
    expect(await cache.image(recipeNo(1).image!), isNull);
  });

  test('clear deletes everything', () async {
    await cache.put(recipeNo(1));
    await cache.putImage(recipeNo(1).image!, Uint8List.fromList([1]));
    await cache.put(recipeNo(2));

    await cache.clear();

    expect(await cache.all(), isEmpty);
    expect(await cache.image(recipeNo(1).image!), isNull);
  });

  test('drops a row it cannot read instead of failing', () async {
    await cache.put(recipeNo(1));
    await cache.put(recipeNo(2));
    await db.customStatement(
      "UPDATE cached_recipe SET json = '{\"id\": \"not a number\"}' "
      'WHERE id = 1',
    );

    expect(await cache.get(1), isNull);
    expect([for (final r in await cache.all()) r.id], [2]);
  });

  group('a new schema version', () {
    late File file;

    setUp(() {
      final dir = Directory.systemTemp.createTempSync('yumdoor_cache_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      file = File('${dir.path}/cache.sqlite');
    });

    Future<List<Recipe>> reopenAs(int version) async {
      final next = _VersionedCacheDatabase(NativeDatabase(file), version);
      try {
        return await RecipeCache(next).all();
      } finally {
        await next.close();
      }
    }

    setUp(() async {
      final current = CacheDatabase(NativeDatabase(file));
      await RecipeCache(current).put(recipeNo(1));
      await current.close();
    });

    test('keeps the rows of the same version', () async {
      expect(await reopenAs(db.schemaVersion), hasLength(1));
    });

    test('drops the rows of an older version', () async {
      expect(await reopenAs(db.schemaVersion + 1), isEmpty);
    });

    test('drops the rows of a newer version', () async {
      // A later app version stored something, then the app was rolled back.
      final newer = _VersionedCacheDatabase(
        NativeDatabase(file),
        db.schemaVersion + 1,
      );
      await RecipeCache(newer).put(recipeNo(2));
      await newer.close();

      expect(await reopenAs(db.schemaVersion), isEmpty);
    });
  });
}

/// The cache database as a later app version would open it.
class _VersionedCacheDatabase extends CacheDatabase {
  _VersionedCacheDatabase(super.executor, this.version);

  final int version;

  @override
  int get schemaVersion => version;
}
