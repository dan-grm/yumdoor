@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/shopping.dart';

import '../../tool/seed/data.dart';
import 'seeded_tandoor.dart';

// Other test files run at the same time and may change entries of meal plans
// on the shopping list, so the checks on what changed look only at the items
// added by hand.
void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    ben = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('ben')),
    );
  });
  tearDown(() {
    anna.close();
    ben.close();
  });

  /// The entry Anna sees for the item [food] added by hand.
  Future<ShoppingEntry> looseEntry(String food) async =>
      (await anna.shopping.fetch()).entries.singleWhere(
        (e) => e.source == null && e.food.name == food,
      );

  test("Anna sees the household's list, Ben's entries included", () async {
    final list = await anna.shopping.fetch();

    expect(list.truncated, isFalse);
    final loose = list.entries.where((e) => e.source == null);
    expect(
      [for (final e in loose) (e.food.name, e.amount, e.unit?.name)],
      unorderedEquals([
        for (final (food, amount, unit, _) in seedLooseShopping)
          (food, amount.toDouble(), unit),
      ]),
    );
    final oats = loose.singleWhere((e) => e.food.name == 'Haferflocken');
    expect(oats.createdBy.name, 'Ben');
    expect(oats.food.category?.name, 'Trockenwaren');
    expect(
      loose.singleWhere((e) => e.food.name == 'Küchenrolle').food.category,
      isNull,
    );
    expect(loose.singleWhere((e) => e.food.name == 'Milch').checked, isTrue);

    // Entries for Ben's meal plans, with their recipe and plan.
    final dal = list.entries.where(
      (e) => e.source?.recipeName == 'Linsen-Dal mit Karotten',
    );
    expect(dal, isNotEmpty);
    expect({for (final e in dal) e.createdBy.name}, {'Ben'});
    final source = dal.first.source!;
    expect(source.servings, 4);
    expect(source.mealPlan?.label, 'Linsen-Dal mit Karotten');
    expect(source.mealPlan?.onShoppingList, isTrue);
    // Ben sees the same items.
    expect(
      {
        for (final e in (await ben.shopping.fetch()).entries)
          if (e.source == null) e.id,
      },
      {for (final e in loose) e.id},
    );
  });

  test('checks entries off and on again in bulk', () async {
    final oats = await looseEntry('Haferflocken');
    final lemon = await looseEntry('Zitrone');
    final ids = {oats.id, lemon.id};
    expect(oats.checked || lemon.checked, isFalse);

    try {
      // Anna checks off an entry of Ben's, too.
      await anna.shopping.setChecked(ids, checked: true);
      final checked = (await ben.shopping.fetch()).entries.where(
        (e) => ids.contains(e.id),
      );
      expect([for (final e in checked) e.checked], [true, true]);
      expect([for (final e in checked) e.completedAt], everyElement(isNotNull));
    } finally {
      await anna.shopping.setChecked(ids, checked: false);
    }

    final unchecked = (await anna.shopping.fetch()).entries.where(
      (e) => ids.contains(e.id),
    );
    expect([for (final e in unchecked) e.checked], [false, false]);
    expect([for (final e in unchecked) e.completedAt], [null, null]);
  });

  test('updatedAfter returns only what changed since, by anyone', () async {
    final before = await anna.shopping.fetch();
    final oats = before.entries.singleWhere(
      (e) => e.source == null && e.food.name == 'Haferflocken',
    );
    try {
      // Ben checks off an entry Anna will see as changed.
      await ben.shopping.setChecked({oats.id}, checked: true);

      // Without syncedAt's margin: the server's time of the first read, so
      // the changes of the tests before are older.
      final changes = await anna.shopping.fetch(
        updatedAfter: before.syncedAt.add(const Duration(minutes: 1)),
      );

      expect(changes.entries.length, lessThan(before.entries.length));
      final loose = changes.entries.where((e) => e.source == null);
      expect([for (final e in loose) (e.id, e.checked)], [(oats.id, true)]);
      expect(changes.syncedAt.isAfter(before.syncedAt), isTrue);
    } finally {
      await ben.shopping.setChecked({oats.id}, checked: false);
    }
  });

  test('lists the supermarket with its category order', () async {
    final markets = await ben.shopping.supermarkets();
    final market = markets.singleWhere((m) => m.name == seedSupermarket);
    final list = await ben.shopping.fetch();
    final categories = {
      for (final e in list.entries)
        if (e.food.category case final category?) category.id: category.name,
    };

    // The categories in use come in the seeded order.
    expect(
      [for (final id in market.categoryIds) ?categories[id]],
      [
        for (final name in seedCategories)
          if (categories.containsValue(name)) name,
      ],
    );
    expect(market.categoryIds, hasLength(seedCategories.length));
  });

  test('sets and clears on hand for the household', () async {
    // Not in any recipe, so recipe searches running meanwhile don't notice.
    final paper = (await looseEntry('Küchenrolle')).food;

    try {
      final marked = await anna.foods.setOnHand(paper.id, onHand: true);
      expect(marked.onHand, isTrue);
      expect((await ben.foods.fetchFood(paper.id)).onHand, isTrue);

      final cleared = await ben.foods.setOnHand(paper.id, onHand: false);
      expect(cleared.onHand, isFalse);
      expect((await anna.foods.fetchFood(paper.id)).onHand, isFalse);
    } finally {
      await anna.foods.setOnHand(paper.id, onHand: false);
    }
  });
}
