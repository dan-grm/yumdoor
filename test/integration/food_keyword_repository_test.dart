@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/unit.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories repositories;

  setUp(() {
    repositories = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
  });
  tearDown(() => repositories.close());

  group('FoodRepository', () {
    test('completes a food name', () async {
      final foods = await repositories.foods.autocomplete('karot');

      final karotte = foods.singleWhere((f) => f.name == 'Karotte');
      expect(karotte.pluralName, 'Karotten');
      expect(karotte.parentId, isNotNull);
    });

    test('maps the household on-hand flag', () async {
      final foods = await repositories.foods.autocomplete('Zwiebel');

      expect(foods.singleWhere((f) => f.name == 'Zwiebel').onHand, isTrue);
    });

    test('returns at most limit foods', () async {
      expect(await repositories.foods.autocomplete('', limit: 3), hasLength(3));
    });

    test('fetches a food by id', () async {
      final karotte = (await repositories.foods.autocomplete('Karotte'))
          .singleWhere((f) => f.name == 'Karotte');

      expect(await repositories.foods.fetchFood(karotte.id), karotte);
    });
  });

  group('KeywordRepository', () {
    test('completes a keyword name', () async {
      final keywords = await repositories.keywords.autocomplete('supp');

      expect(keywords.map((k) => k.name), contains('Suppe'));
    });

    test('fetches a keyword by id', () async {
      final suppe = (await repositories.keywords.autocomplete('Suppe'))
          .singleWhere((k) => k.name == 'Suppe');

      expect(await repositories.keywords.fetchKeyword(suppe.id), suppe);
    });

    test('returns at most limit keywords', () async {
      expect(
        await repositories.keywords.autocomplete('', limit: 2),
        hasLength(2),
      );
    });
  });

  group('UnitRepository', () {
    test('completes a unit name', () async {
      final units = await repositories.units.autocomplete('E');

      expect(units.map((u) => u.name), contains('EL'));
      expect(units.map((u) => u.name), isNot(contains('g')));
    });

    test('returns at most limit units', () async {
      expect(await repositories.units.autocomplete('', limit: 3), hasLength(3));
    });
  });

  group('create', () {
    // Unique per run, so a run that was cut short doesn't get in the way.
    final tag = 'Yumdoor-Test ${DateTime.now().microsecondsSinceEpoch}';

    /// What a test created, as API paths to delete afterwards.
    final created = <String>{};
    late Dio dio;

    setUp(() {
      dio = createTandoorDio(tandoor.baseUrl, token: tandoor.token('anna'));
    });
    tearDown(() async {
      try {
        for (final path in created) {
          try {
            await dio.delete<void>(path);
          } on DioException catch (e) {
            // Keep cleaning up; report what was left behind.
            printOnFailure('Could not delete $path: $e');
          }
        }
      } finally {
        created.clear();
        dio.close();
      }
    });

    /// Creates `<prefix> Food`, `Unit` and `Keyword`, padded with [pad], and
    /// deletes them after the test.
    Future<(Food, Unit, Keyword)> createAll(
      String prefix, {
      String pad = '',
    }) async {
      final food = await repositories.foods.create('$pad$prefix Food$pad');
      created.add('/api/food/${food.id}/');
      final unit = await repositories.units.create('$pad$prefix Unit$pad');
      created.add('/api/unit/${unit.id}/');
      final keyword = await repositories.keywords.create(
        '$pad$prefix Keyword$pad',
      );
      created.add('/api/keyword/${keyword.id}/');
      return (food, unit, keyword);
    }

    test('creates a food, unit and keyword that autocomplete finds', () async {
      final (food, unit, keyword) = await createAll(tag, pad: ' ');

      expect(food.name, '$tag Food');
      expect(unit.name, '$tag Unit');
      expect(keyword.name, '$tag Keyword');
      expect(await repositories.foods.autocomplete('$tag Fo'), [food]);
      expect(await repositories.units.autocomplete('$tag Un'), [unit]);
      expect(await repositories.keywords.autocomplete('$tag Key'), [keyword]);
    });

    test('returns an existing name in another case', () async {
      final (food, unit, keyword) = await createAll(tag);

      // Should one be created after all, the tear-down deletes it too.
      final (foodAgain, unitAgain, keywordAgain) = await createAll(
        tag.toUpperCase(),
      );

      expect(foodAgain, food);
      expect(unitAgain, unit);
      expect(keywordAgain, keyword);
    });

    test('returns seeded ones by name in another case', () async {
      final karotte = (await repositories.foods.autocomplete('Karotte'))
          .singleWhere((f) => f.name == 'Karotte');
      final el = (await repositories.units.autocomplete('EL'))
          .singleWhere((u) => u.name == 'EL');
      final suppe = (await repositories.keywords.autocomplete('Suppe'))
          .singleWhere((k) => k.name == 'Suppe');

      /// Deletes [path] after the test unless it is the seeded [seededId].
      void deleteIfNew(String path, int id, int seededId) {
        if (id != seededId) created.add(path);
      }

      final food = await repositories.foods.create('karotte');
      deleteIfNew('/api/food/${food.id}/', food.id, karotte.id);
      // Foods also match the plural name.
      final plural = await repositories.foods.create('KAROTTEN');
      deleteIfNew('/api/food/${plural.id}/', plural.id, karotte.id);
      final unit = await repositories.units.create('el');
      deleteIfNew('/api/unit/${unit.id}/', unit.id, el.id);
      final keyword = await repositories.keywords.create('SUPPE');
      deleteIfNew('/api/keyword/${keyword.id}/', keyword.id, suppe.id);

      expect(food, karotte);
      expect(plural, karotte);
      expect(unit, el);
      expect(keyword, suppe);
    });
  });
}
