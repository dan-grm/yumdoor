import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/recipe_mapper.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  api.Recipe recipe(String fixture) => api.standardSerializers.deserializeWith(
    api.Recipe.serializer,
    tandoorFixture(fixture),
  )!;

  group('RecipeOverview', () {
    final page = api.standardSerializers.deserializeWith(
      api.PaginatedRecipeOverviewList.serializer,
      tandoorFixture('recipe_list.json'),
    )!;

    test('maps a list item', () {
      final summary = page.results.first.toDomain();

      expect(summary.id, 58);
      expect(summary.name, 'Apfelkuchen vom Blech');
      expect(summary.description, '');
      expect(summary.image, isNull);
      expect(summary.keywords, const [
        Keyword(id: 47, name: 'Herbst'),
        Keyword(id: 55, name: 'Backen'),
        Keyword(id: 56, name: 'Dessert'),
      ]);
      expect(summary.servings, 12);
      expect(summary.servingsText, '');
      expect(summary.workingTime, const Duration(minutes: 30));
      expect(summary.waitingTime, const Duration(minutes: 40));
      expect(summary.rating, isNull);
      expect(summary.lastCooked, isNull);
      expect(summary.createdBy, const UserRef(id: 8, name: 'Anna'));
      expect(summary.updatedAt, isNotNull);
    });

    test('maps every item of the page', () {
      expect(page.results.map((r) => r.toDomain().name), [
        'Apfelkuchen vom Blech',
        'Banana Bread',
        'Carrot Cake',
      ]);
    });
  });

  group('Recipe', () {
    test('maps steps with their own ingredients', () {
      final apfelkuchen = recipe('recipe_apfelkuchen.json').toDomain();

      expect(apfelkuchen.id, 58);
      expect(apfelkuchen.servings, 12);
      expect(apfelkuchen.sourceUrl, isNull);
      expect(apfelkuchen.keywords.map((k) => k.name), [
        'Herbst',
        'Backen',
        'Dessert',
      ]);
      expect(apfelkuchen.steps, hasLength(3));
      expect(apfelkuchen.steps.map((s) => s.ingredients.length), [6, 4, 0]);
    });

    test('keeps the raw instruction, templates included', () {
      final step = recipe('recipe_apfelkuchen.json').toDomain().steps.first;

      expect(
        step.instruction,
        'Für den Teig alles verkneten und auf einem gefetteten Blech '
        '({{ scale(30) }} × 40 cm) verteilen.',
      );
      expect(step.instruction, isNot(contains('<')));
    });

    test('maps the explicit step time in minutes', () {
      final steps = recipe('recipe_apfelkuchen.json').toDomain().steps;

      expect(steps.map((s) => s.time), [
        Duration.zero,
        Duration.zero,
        const Duration(minutes: 40),
      ]);
    });

    test('maps ingredient headers with their title in the note', () {
      final header = recipe('recipe_apfelkuchen.json')
          .toDomain()
          .steps
          .first
          .ingredients
          .first;

      expect(header.isHeader, isTrue);
      expect(header.noAmount, isTrue);
      expect(header.note, 'Für den Teig');
      expect(header.food, isNull);
      expect(header.unit, isNull);
    });

    test('maps amount, unit, food and note', () {
      final ingredients = recipe('recipe_apfelkuchen.json')
          .toDomain()
          .steps
          .first
          .ingredients;
      final butter = ingredients.singleWhere((i) => i.food?.name == 'Butter');

      expect(butter.amount, 150);
      expect(butter.unit?.name, 'g');
      expect(butter.note, 'weich');
      expect(butter.noAmount, isFalse);
      expect(butter.isHeader, isFalse);
    });

    test('maps ingredients without an amount and the food tree', () {
      final karottensuppe = recipe('recipe_karottensuppe.json').toDomain();
      final ingredients = [
        for (final step in karottensuppe.steps) ...step.ingredients,
      ];
      final salz = ingredients.singleWhere((i) => i.food?.name == 'Salz');
      final karotte = ingredients.singleWhere((i) => i.food?.name == 'Karotte');
      final zwiebel = ingredients.singleWhere((i) => i.food?.name == 'Zwiebel');

      expect(salz.noAmount, isTrue);
      expect(salz.unit, isNull);
      expect(karotte.food?.pluralName, 'Karotten');
      expect(karotte.food?.parentId, isNotNull);
      expect(karotte.amount, 600);
      expect(zwiebel.food?.onHand, isTrue);
      expect(karottensuppe.rating, 4);
    });
  });
}
