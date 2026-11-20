import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/data/mappers/shopping_mapper.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

import '../../../fixtures/tandoor_fixtures.dart';

void main() {
  List<api.ShoppingListEntry> recordedEntries() => api.standardSerializers
      .deserializeWith(
        api.PaginatedShoppingListEntryList.serializer,
        tandoorFixture('shopping_list_entry_list.json'),
      )!
      .results
      .toList();

  ShoppingEntry entry(String food, {double? amount}) => recordedEntries()
      .map((dto) => dto.toDomain())
      .firstWhere(
        (e) => e.food.name == food && (amount == null || e.amount == amount),
      );

  const ben = UserRef(id: 18, name: 'Ben');
  const anna = UserRef(id: 17, name: 'Anna');
  const vegetables = SupermarketCategory(id: 41, name: 'Obst & Gemüse');

  group('ShoppingEntryMapper', () {
    test('maps every recorded entry', () {
      final entries = recordedEntries().map((dto) => dto.toDomain()).toList();

      expect(entries, hasLength(26));
      expect(entries.where((e) => e.checked), hasLength(1));
      expect(entries.where((e) => e.source == null), hasLength(5));
    });

    test('maps an entry for a meal plan', () {
      final ginger = entry('Ingwer', amount: 15);

      expect(ginger.id, 1122);
      expect(
        ginger.food,
        const ShoppingFood(id: 524, name: 'Ingwer', category: vegetables),
      );
      expect(ginger.unit, const Unit(id: 126, name: 'g', pluralName: 'g'));
      expect(ginger.checked, isFalse);
      expect(ginger.completedAt, isNull);
      expect(
        ginger.updatedAt,
        DateTime.parse('2026-11-20T10:31:25.744028+01:00'),
      );
      expect(ginger.createdBy, ben);

      final source = ginger.source!;
      expect(source.listRecipeId, 17);
      expect(source.recipeId, 201);
      expect(source.recipeName, 'Linsen-Dal mit Karotten');
      expect(source.servings, 4);
      final plan = source.mealPlan!;
      expect(plan.id, 64);
      expect(plan.label, 'Linsen-Dal mit Karotten');
      expect(plan.mealType.name, 'Abendessen');
      expect(
        plan.fromDay,
        CalendarDay.of(DateTime.parse('2026-11-17T18:30:00+01:00').toLocal()),
      );
      expect(plan.onShoppingList, isTrue);
    });

    test('keeps the plural name of a food', () {
      expect(entry('Karotte', amount: 2).food.pluralName, 'Karotten');
    });

    test('maps a checked item added by hand', () {
      final milk = entry('Milch');

      expect(milk.source, isNull);
      expect(milk.checked, isTrue);
      expect(
        milk.completedAt,
        DateTime.parse('2026-11-20T10:31:26.598071+01:00'),
      );
      expect(milk.amount, 2);
      expect(milk.unit?.name, 'l');
      expect(milk.createdBy, anna);
    });

    test('maps an entry without a unit', () {
      final basil = entry('Basilikum');

      expect(basil.unit, isNull);
      expect(basil.amount, 1);
      expect(basil.food.category, vegetables);
    });

    test('maps a food without a category', () {
      final paper = entry('Küchenrolle');

      expect(paper.food.category, isNull);
      expect(paper.unit?.name, 'Stück');
      expect(paper.source, isNull);
    });

    test('fails on an entry without food or owner', () {
      final milk = recordedEntries().firstWhere((e) => e.food?.name == 'Milch');

      expect(
        () => milk.rebuild((b) => b.food = null).toDomain(),
        throwsFormatException,
      );
      expect(
        () => milk.rebuild((b) => b.createdBy = null).toDomain(),
        throwsFormatException,
      );
    });
  });

  group('SupermarketMapper', () {
    test('maps the recorded supermarket with its category order', () {
      final markets = api.standardSerializers
          .deserializeWith(
            api.PaginatedSupermarketList.serializer,
            tandoorFixture('supermarket_list.json'),
          )!
          .results
          .map((dto) => dto.toDomain())
          .toList();

      expect(markets, [
        const Supermarket(
          id: 6,
          name: 'Nachbarschaftsmarkt',
          categoryIds: [41, 42, 43, 44, 45, 46, 47, 48],
        ),
      ]);
    });

    test('sorts categories by order, then by when they were added', () {
      api.SupermarketCategoryRelation relation(
        int id,
        int category,
        int order,
      ) => api.SupermarketCategoryRelation(
        (b) => b
          ..id = id
          ..supermarket = 1
          ..order = order
          ..category.replace(
            api.SupermarketCategory(
              (c) => c
                ..id = category
                ..name = 'Category $category',
            ),
          ),
      );
      final market = api.Supermarket(
        (b) => b
          ..id = 1
          ..name = 'Markt'
          ..categoryToSupermarket.addAll([
            relation(3, 30, 1),
            relation(2, 20, 0),
            relation(1, 10, 1),
          ]),
      );

      expect(market.toDomain().categoryIds, [20, 10, 30]);
    });
  });
}
