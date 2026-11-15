@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';

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
    final created = <String>[];
    late Dio dio;

    setUp(() {
      dio = createTandoorDio(tandoor.baseUrl, token: tandoor.token('anna'));
    });
    tearDown(() async {
      for (final path in created) {
        await dio.delete<void>(path);
      }
      created.clear();
      dio.close();
    });

    test('creates a food, unit and keyword that autocomplete finds', () async {
      final food = await repositories.foods.create(' $tag Food ');
      created.add('/api/food/${food.id}/');
      final unit = await repositories.units.create('$tag Unit');
      created.add('/api/unit/${unit.id}/');
      final keyword = await repositories.keywords.create('$tag Keyword');
      created.add('/api/keyword/${keyword.id}/');

      expect(food.name, '$tag Food');
      expect(unit.name, '$tag Unit');
      expect(keyword.name, '$tag Keyword');
      expect(await repositories.foods.autocomplete('$tag Fo'), [food]);
      expect(await repositories.units.autocomplete('$tag Un'), [unit]);
      expect(await repositories.keywords.autocomplete('$tag Key'), [keyword]);
    });

    test('returns a new name again when it exists in another case', () async {
      final food = await repositories.foods.create('$tag Food');
      created.add('/api/food/${food.id}/');
      final unit = await repositories.units.create('$tag Unit');
      created.add('/api/unit/${unit.id}/');
      final keyword = await repositories.keywords.create('$tag Keyword');
      created.add('/api/keyword/${keyword.id}/');

      final upper = tag.toUpperCase();
      expect(await repositories.foods.create('$upper FOOD'), food);
      expect(await repositories.units.create('$upper UNIT'), unit);
      expect(await repositories.keywords.create('$upper KEYWORD'), keyword);
    });

    test('returns seeded ones by name in another case', () async {
      final karotte = (await repositories.foods.autocomplete('Karotte'))
          .singleWhere((f) => f.name == 'Karotte');
      final el = (await repositories.units.autocomplete('EL'))
          .singleWhere((u) => u.name == 'EL');
      final suppe = (await repositories.keywords.autocomplete('Suppe'))
          .singleWhere((k) => k.name == 'Suppe');

      expect(await repositories.foods.create('karotte'), karotte);
      // Foods and units also match the plural name.
      expect(await repositories.foods.create('KAROTTEN'), karotte);
      expect(await repositories.units.create('el'), el);
      expect(await repositories.keywords.create('SUPPE'), suppe);
    });
  });
}
