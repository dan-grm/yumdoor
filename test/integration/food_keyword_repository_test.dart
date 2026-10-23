@Tags(['integration'])
library;

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
}
