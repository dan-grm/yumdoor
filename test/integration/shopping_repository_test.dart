@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
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

  /// The seeded salad, read fresh: 2 servings, Olivenöl on hand, Salz and
  /// Pfeffer ignored.
  Future<Recipe> salad() async {
    final page = await anna.recipes.search(
      const RecipeQuery(text: 'Tomaten-Mozzarella-Salat'),
    );
    final summary = page.items.singleWhere(
      (r) => r.name == 'Tomaten-Mozzarella-Salat',
    );
    return anna.recipes.fetchRecipe(summary.id, allowCached: false);
  }

  test('adds a recipe for a new meal plan and removes it again', () async {
    final recipe = await salad();
    final lunch = (await anna.mealTypes.list()).firstWhere(
      (t) => t.name == 'Mittagessen',
    );
    // Far from the seeded week, so the meal plan tests don't see it.
    final plan = await anna.mealPlans.create(
      NewMealPlan(
        recipeId: recipe.id,
        servings: 4,
        day: CalendarDay.today().addDays(200),
        mealType: lunch,
      ),
    );
    try {
      expect(plan.onShoppingList, isFalse);

      final added = await anna.shopping.addRecipe(
        recipe,
        4,
        mealPlanId: plan.id,
      );

      expect(added.onHandCount, 1);
      // Ben sees them, scaled from 2 to 4 servings.
      final entries = (await ben.shopping.fetch()).entries
          .where((e) => e.source?.mealPlan?.id == plan.id)
          .toList();
      expect(
        [for (final e in entries) (e.food.name, e.amount, e.unit?.name)],
        unorderedEquals([
          ('Tomate', 8.0, 'Stück'),
          ('Mozzarella', 2.0, 'Stück'),
          ('Basilikum', 1.0, 'Bund'),
        ]),
      );
      expect(added.neededCount, entries.length);
      final source = entries.first.source!;
      expect(source.recipeId, recipe.id);
      expect(source.servings, 4);
      expect(source.mealPlan?.onShoppingList, isTrue);
      expect({for (final e in entries) e.source?.listRecipeId}, hasLength(1));
      expect(await onShoppingList(anna, plan), isTrue);

      // Deleting a few keeps the plan on the list, deleting the rest not.
      await ben.shopping.deleteEntries(entries.take(2));
      expect(await onShoppingList(anna, plan), isTrue);
      await anna.shopping.deleteEntries(entries);

      expect(
        (await anna.shopping.fetch()).entries.where(
          (e) => e.source?.mealPlan?.id == plan.id,
        ),
        isEmpty,
      );
      expect(await onShoppingList(anna, plan), isFalse);
    } finally {
      await anna.mealPlans.delete(plan.id);
    }
  });

  test('adds a recipe without a meal plan', () async {
    final recipe = await salad();
    // Entries of the salad without a plan come from this test only; other
    // test files may change other entries meanwhile.
    bool ours(ShoppingEntry e) =>
        e.source?.recipeId == recipe.id && e.source?.mealPlan == null;
    expect((await anna.shopping.fetch()).entries.where(ours), isEmpty);

    final added = await anna.shopping.addRecipe(recipe, 2);

    final entries = (await anna.shopping.fetch()).entries.where(ours).toList();
    try {
      expect(added.neededCount, 3);
      expect(
        [for (final e in entries) (e.food.name, e.amount)],
        unorderedEquals([
          ('Tomate', 4.0),
          ('Mozzarella', 1.0),
          ('Basilikum', 0.5),
        ]),
      );
      expect(entries.first.source?.recipeName, 'Tomaten-Mozzarella-Salat');
    } finally {
      await anna.shopping.deleteEntries(entries);
    }
  });

  test('adds an item by hand and deletes it', () async {
    final recipe = await salad();
    final mozzarella = recipe.steps
        .expand((s) => s.ingredients)
        .singleWhere((i) => i.food?.name == 'Mozzarella');

    final item = await ben.shopping.addItem(
      mozzarella.food!.id,
      3,
      unitId: mozzarella.unit!.id,
    );
    try {
      expect(item.source, isNull);
      expect(item.food.name, 'Mozzarella');
      expect(item.unit?.name, 'Stück');
      expect(item.amount, 3);
      expect(item.createdBy.name, 'Ben');
      expect(
        (await anna.shopping.fetch()).entries.map((e) => e.id),
        contains(item.id),
      );
      // Sending the ids leaves the food and unit as they were.
      final again = await anna.recipes.fetchRecipe(
        recipe.id,
        allowCached: false,
      );
      expect(again.steps, recipe.steps);
    } finally {
      await anna.shopping.deleteEntries([item]);
    }

    expect(
      (await anna.shopping.fetch()).entries.map((e) => e.id),
      isNot(contains(item.id)),
    );
    // Gone already: ignored.
    await anna.shopping.deleteEntries([item]);
  });
}

/// Whether [plan] is on the shopping list, as the meal plan list says.
Future<bool> onShoppingList(TandoorRepositories as, MealPlan plan) async {
  final plans = await as.mealPlans.list(plan.fromDay, plan.toDay);
  return plans.singleWhere((p) => p.id == plan.id).onShoppingList;
}
