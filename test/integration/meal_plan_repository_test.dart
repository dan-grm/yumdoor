@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';

import '../../tool/seed/data.dart';
import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories anna;
  late TandoorRepositories ben;

  // The seed plans the week it runs in, Monday to Sunday, at the meal types'
  // times in the server's time zone (Europe/Berlin). The weekday checks below
  // hold on a device within a few hours of it, such as CI (UTC).
  late CalendarDay monday;
  late CalendarDay sunday;

  setUpAll(() async {
    // Found from the seeded goulash, so an older seed works, too.
    final repositories = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    try {
      final today = CalendarDay.today();
      final plans = (await repositories.mealPlans.list(
        today.addDays(-366),
        today.addDays(7),
      )).plans;
      final goulash = plans.lastWhere((p) => p.label == 'Rindergulasch');
      monday = goulash.fromDay.addDays(1 - goulash.fromDay.weekday);
      sunday = monday.addDays(6);
    } finally {
      repositories.close();
    }
  });

  /// Plans the test created, deleted again afterwards.
  final created = <int>[];

  setUp(() {
    anna = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    ben = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('ben')),
    );
  });
  tearDown(() async {
    for (final id in created) {
      try {
        await anna.mealPlans.delete(id);
      } on NotFoundFailure {
        // The test deleted it itself.
      }
    }
    created.clear();
    anna.close();
    ben.close();
  });

  Future<MealType> mealType(String name) async =>
      (await anna.mealTypes.list()).firstWhere((type) => type.name == name);

  test('lists the meal types of the space in order', () async {
    final types = await ben.mealTypes.list();

    expect(
      [for (final type in types) type.name],
      [
        for (final type in [
          ...seedMealTypes,
        ]..sort((a, b) => a.order.compareTo(b.order)))
          type.name,
      ],
    );
    expect(types.first.time, const Duration(hours: 8));
    expect(types.first.color, 0xe8b04a);
  });

  test('creating an existing meal type returns it', () async {
    final dinner = await mealType('Abendessen');

    // Anna created it; Tandoor alone would give Ben a second one.
    final again = await ben.mealTypes.create(' abendessen ');

    expect(again, dinner);
    expect(await ben.mealTypes.list(), hasLength(seedMealTypes.length));
  });

  test("lists this week's plans of the household", () async {
    final plans = (await anna.mealPlans.list(monday, sunday)).plans;

    expect(
      [for (final plan in plans) (plan.fromDay.weekday, plan.label)],
      unorderedEquals([
        for (final seed in seedMealPlans)
          (seed.weekday, seed.recipe ?? seed.title),
      ]),
    );
    // Ben's plans are there, too.
    expect({for (final plan in plans) plan.createdBy}, hasLength(2));
    final goulash = plans.singleWhere((p) => p.label == 'Rindergulasch');
    expect(goulash.days, 2);
    expect(goulash.servings, 6);
    expect(
      plans.where((plan) => plan.onShoppingList).map((plan) => plan.label),
      unorderedEquals([
        for (final seed in seedMealPlans)
          if (seed.shopping) seed.recipe,
      ]),
    );
    // Sorted by day, then meal type.
    for (var i = 1; i < plans.length; i++) {
      expect(plans[i].fromDay.isBefore(plans[i - 1].fromDay), isFalse);
    }
  });

  test('a plan over several days shows on each of its days', () async {
    final goulash = (await anna.mealPlans.list(
      monday,
      sunday,
    )).plans.singleWhere((p) => p.label == 'Rindergulasch');

    for (final day in [goulash.fromDay, goulash.toDay]) {
      expect(
        (await anna.mealPlans.list(day, day)).plans.map((p) => p.id),
        contains(goulash.id),
        reason: '$day',
      );
    }
    final dayBefore = goulash.fromDay.addDays(-1);
    expect(
      (await anna.mealPlans.list(dayBefore, dayBefore)).plans.map((p) => p.id),
      isNot(contains(goulash.id)),
    );
  });

  test('creates, moves, rescales and deletes a plan', () async {
    final page = await anna.recipes.search(
      const RecipeQuery(text: 'Pfannkuchen'),
    );
    final recipe = page.items.firstWhere((r) => r.name == 'Pfannkuchen');
    final breakfast = await mealType('Frühstück');
    final dinner = await mealType('Abendessen');
    final day = sunday.addDays(7);

    final plan = await anna.mealPlans.create(
      NewMealPlan(
        recipeId: recipe.id,
        servings: 3,
        note: 'Test',
        day: day,
        mealType: breakfast,
      ),
    );
    created.add(plan.id);

    expect(plan.recipe?.name, 'Pfannkuchen');
    expect(plan.fromDay, day);
    expect(plan.toDay, day);
    expect(plan.mealType, breakfast);
    expect(plan.servings, 3);
    expect(plan.note, 'Test');
    expect(plan.onShoppingList, isFalse);
    // Ben shares Anna's household.
    expect(
      (await ben.mealPlans.list(day, day)).plans.map((p) => p.id),
      contains(plan.id),
    );

    final moved = await ben.mealPlans.update(
      plan.id,
      MealPlanChanges(day: day.addDays(1), mealType: dinner),
    );
    expect(moved.fromDay, day.addDays(1));
    expect(moved.toDay, day.addDays(1));
    expect(moved.mealType, dinner);
    expect(
      (await anna.mealPlans.list(day, day)).plans.map((p) => p.id),
      isEmpty,
    );

    final rescaled = await anna.mealPlans.update(
      plan.id,
      MealPlanChanges(servings: 1.5),
    );
    expect(rescaled.servings, 1.5);
    expect(rescaled.fromDay, day.addDays(1));
    expect(rescaled.note, 'Test');

    await anna.mealPlans.delete(plan.id);
    expect(
      (await anna.mealPlans.list(day, day.addDays(1))).plans.map((p) => p.id),
      isNot(contains(plan.id)),
    );
    await expectLater(
      anna.mealPlans.update(plan.id, MealPlanChanges(servings: 2)),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('changes the note of a plan on the shopping list', () async {
    // Without `servings`, Tandoor fails with 500 for such a plan.
    final plan = (await anna.mealPlans.list(
      monday,
      sunday,
    )).plans.firstWhere((p) => p.onShoppingList);

    try {
      final changed = await anna.mealPlans.update(
        plan.id,
        MealPlanChanges(note: 'Doppelt kochen'),
      );

      expect(changed.note, 'Doppelt kochen');
      expect(changed.servings, plan.servings);
      expect(changed.fromDay, plan.fromDay);
      expect(changed.onShoppingList, isTrue);
    } finally {
      await anna.mealPlans.update(plan.id, MealPlanChanges(note: plan.note));
    }
  });

  test("another household doesn't see the plans", () async {
    final admin = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('admin')),
    );
    addTearDown(admin.close);

    expect((await admin.mealPlans.list(monday, sunday)).plans, isEmpty);
    // Meal types belong to the whole space.
    expect(await admin.mealTypes.list(), hasLength(seedMealTypes.length));
  });
}
