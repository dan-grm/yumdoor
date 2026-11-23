import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fakes/fake_shopping_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../harness.dart';

const _dinner = MealType(id: 3, name: 'Abendessen', order: 2);

/// Ofenkarotten with oil and cumin on hand and salt never bought: 3 of 5
/// ingredients are missing, 2 are at home.
final _carrots = ofenkarotten.copyWith(
  steps: [
    for (final step in ofenkarotten.steps)
      step.copyWith(
        ingredients: [
          for (final ingredient in step.ingredients)
            ingredient.copyWith(
              food: switch (ingredient.food?.name) {
                'Olivenöl' || 'Kreuzkümmel, gemahlen' =>
                  ingredient.food!.copyWith(onHand: true),
                'Salz' => ingredient.food!.copyWith(ignoreShopping: true),
                _ => ingredient.food,
              },
            ),
        ],
      ),
  ],
);

MealPlan _plan(
  int id,
  int day, {
  int? recipeId,
  String? name,
  bool onList = false,
}) => MealPlan(
  id: id,
  recipe: recipeId == null
      ? null
      : RecipeSummary(id: recipeId, name: name ?? 'Gericht $id'),
  title: recipeId == null ? 'Pizza bestellen' : '',
  servings: 4,
  fromDay: CalendarDay(2026, 11, day),
  toDay: CalendarDay(2026, 11, day),
  mealType: _dinner,
  onShoppingList: onList,
  createdBy: 1,
);

void main() {
  setUpAll(loadBundledFonts);

  /// Wednesday; the week runs from Monday the 16th to Sunday the 22nd.
  final now = DateTime(2026, 11, 18, 12);

  late FakeMealPlanRepository mealPlans;
  late FakeShoppingRepository shopping;
  late FakeConnectivityService connectivity;

  setUp(() {
    mealPlans = FakeMealPlanRepository([
      _plan(1, 16, recipeId: 7, name: 'Karotten'),
      // Already on the list, and a meal without a recipe.
      _plan(2, 17, recipeId: 7, name: 'Schon drauf', onList: true),
      _plan(3, 19, recipeId: 8, name: 'Lange Namen'),
      _plan(4, 20),
      // Next week.
      _plan(5, 24, recipeId: 7, name: 'Später'),
    ]);
    shopping = FakeShoppingRepository()
      ..onPlanAdded = (id) {
        final index = mealPlans.plans.indexWhere((plan) => plan.id == id);
        mealPlans.plans[index] = mealPlans.plans[index].copyWith(
          onShoppingList: true,
        );
      };
    connectivity = FakeConnectivityService();
  });

  Future<GoRouter> pumpPlanner(
    WidgetTester tester, {
    Iterable<Recipe>? recipes,
  }) => pumpRoutes(
    tester,
    size: const Size(390, 1200),
    location: '/plan',
    overrides: [
      ...appOverrides(
        mealPlans: mealPlans,
        shopping: shopping,
        connectivity: connectivity,
        recipes: FakeRecipeRepository(recipes ?? [_carrots, longNames]),
      ),
      clockProvider.overrideWithValue(() => now),
    ],
    routes: [tabsRoute()],
  );

  /// How many ingredients of [longNames] go on the list.
  int longNamesNeeded() => [
    for (final step in longNames.steps)
      for (final ingredient in step.ingredients)
        if (!ingredient.isHeader &&
            ingredient.food != null &&
            !ingredient.food!.onHand &&
            !ingredient.food!.ignoreShopping)
          ingredient,
  ].length;

  Finder addButton() => find.widgetWithText(TextButton, 'Alles auf die Liste');

  const allDone = 'Alles für diese Woche steht schon auf der Liste.';

  testWidgets('counts what the meals not on the list still need', (
    tester,
  ) async {
    await pumpPlanner(tester);

    expect(find.text('Einkauf für die Woche'), findsOneWidget);
    expect(
      find.text('${3 + longNamesNeeded()} Zutaten · 2 hast du schon'),
      findsOneWidget,
    );
    expect(addButton(), findsOneWidget);
    expect(find.text('Zur Liste'), findsOneWidget);
  });

  testWidgets('adds the week, skipping meals on the list and without a '
      'recipe', (tester) async {
    await pumpPlanner(tester);

    await tester.tap(addButton());
    await tester.pumpAndSettle();

    expect(shopping.added.map((call) => call.mealPlanId), [1, 3]);
    expect(shopping.added.map((call) => call.recipeId), [7, 8]);
    expect(shopping.added.map((call) => call.servings), [4, 4]);
    // Everything is on the list now.
    expect(find.text(allDone), findsOneWidget);
    expect(addButton(), findsNothing);
    expect(find.text('Zur Liste'), findsOneWidget);
  });

  testWidgets('a meal that fails is named, the others stay on the list', (
    tester,
  ) async {
    shopping.failMealPlanIds.add(3);
    await pumpPlanner(tester);

    await tester.tap(addButton());
    await tester.pumpAndSettle();

    expect(shopping.added.map((call) => call.mealPlanId), [1]);
    expect(
      find.text(
        'Nicht auf die Liste gekommen: Lange Namen. '
        'Die anderen stehen drauf.',
      ),
      findsOneWidget,
    );
    // The rest is still to add, and a retry adds only that.
    expect(addButton(), findsOneWidget);
    shopping.failMealPlanIds.clear();
    await tester.tap(addButton());
    await tester.pumpAndSettle();

    expect(shopping.added.map((call) => call.mealPlanId), [1, 3]);
    expect(find.textContaining('Nicht auf die Liste gekommen'), findsNothing);
    expect(find.text(allDone), findsOneWidget);
  });

  testWidgets('says so when every meal is on the list', (tester) async {
    mealPlans.plans
      ..clear()
      ..add(_plan(1, 16, recipeId: 7, onList: true));
    final router = await pumpPlanner(tester);

    expect(find.text(allDone), findsOneWidget);
    expect(addButton(), findsNothing);

    await tester.tap(find.text('Zur Liste'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/shopping');
  });

  testWidgets('is hidden in a week without recipes', (tester) async {
    mealPlans.plans
      ..clear()
      ..add(_plan(4, 20));
    await pumpPlanner(tester);

    expect(find.text('Einkauf für die Woche'), findsNothing);
  });

  testWidgets('says if the ingredients could not be counted', (tester) async {
    await pumpPlanner(tester, recipes: const []);

    expect(
      find.text('Die Zutaten konnten nicht gezählt werden.'),
      findsOneWidget,
    );
    expect(addButton(), findsNothing);
    expect(find.text('Zur Liste'), findsOneWidget);
  });

  testWidgets('adding is disabled offline', (tester) async {
    connectivity.isOnline = false;
    await pumpPlanner(tester);

    expect(tester.widget<TextButton>(addButton()).onPressed, isNull);
    expect(shopping.added, isEmpty);
    // The list can still be read.
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Zur Liste'))
          .onPressed,
      isNotNull,
    );
  });
}
