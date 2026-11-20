import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/features/planner/plan_sheet.dart';
import 'package:yumdoor/features/planner/planner_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../../fakes/fake_meal_type_repository.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fakes/fake_shopping_repository.dart';
import '../../fakes/in_memory_local_store.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

const _breakfast = MealType(id: 1, name: 'Frühstück', order: 0);
const _lunch = MealType(id: 2, name: 'Mittagessen', order: 1);
const _dinner = MealType(id: 3, name: 'Abendessen', order: 2);
const _snack = MealType(id: 4, name: 'Snack', order: 3);

/// [recipe] with [change] applied to each of its foods.
Recipe _withFoods(Recipe recipe, Food Function(Food food) change) =>
    recipe.copyWith(
      steps: [
        for (final step in recipe.steps)
          step.copyWith(
            ingredients: [
              for (final ingredient in step.ingredients)
                ingredient.copyWith(
                  food: switch (ingredient.food) {
                    final food? => change(food),
                    null => null,
                  },
                ),
            ],
          ),
      ],
    );

/// Ofenkarotten with oil and cumin on hand and salt never bought: 3 of 5
/// ingredients are missing.
final _recipe = _withFoods(
  ofenkarotten,
  (food) => switch (food.name) {
    'Olivenöl' || 'Kreuzkümmel, gemahlen' => food.copyWith(onHand: true),
    'Salz' => food.copyWith(ignoreShopping: true),
    _ => food,
  },
);

MealPlan _plan(int id, int day) => MealPlan(
  id: id,
  recipe: RecipeSummary(id: 50 + id, name: 'Geplant $id'),
  servings: 2,
  fromDay: CalendarDay(2026, 11, day),
  toDay: CalendarDay(2026, 11, day),
  mealType: _dinner,
  createdBy: 1,
);

void main() {
  setUpAll(loadBundledFonts);

  /// Wednesday; the week runs from Monday the 16th to Sunday the 22nd.
  late DateTime now;

  late FakeRecipeRepository recipes;
  late FakeMealPlanRepository plans;
  late FakeMealTypeRepository mealTypes;
  late FakeShoppingRepository shopping;
  late FakeConnectivityService connectivity;
  late InMemoryLocalStore store;

  setUp(() {
    now = DateTime(2026, 11, 18, 12);
    recipes = FakeRecipeRepository([_recipe, longNames]);
    plans = FakeMealPlanRepository([_plan(1, 16), _plan(2, 20)]);
    mealTypes = FakeMealTypeRepository([_breakfast, _lunch, _dinner, _snack]);
    shopping = FakeShoppingRepository();
    connectivity = FakeConnectivityService();
    store = InMemoryLocalStore();
  });

  Future<GoRouter> pumpRecipe(
    WidgetTester tester, {
    int id = 7,
    ThemeData? theme,
  }) => pumpRoutes(
    tester,
    location: '/recipe/$id',
    theme: theme,
    overrides: [
      ...appOverrides(
        recipes: recipes,
        mealPlans: plans,
        mealTypes: mealTypes,
        shopping: shopping,
        connectivity: connectivity,
        localStore: store,
      ),
      clockProvider.overrideWithValue(() => now),
    ],
    routes: [
      tabsRoute(),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) =>
            RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
      ),
      // A screen that opens the sheet with a day preset, as the planner will.
      GoRoute(
        path: '/preset',
        builder: (context, state) => Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showPlanSheet(
                context,
                recipeId: 7,
                recipeName: 'Ofenkarotten mit Feta',
                servings: 4,
                day: CalendarDay(2026, 11, 21),
              ),
              child: const Text('preset'),
            ),
          ),
        ),
      ),
    ],
  );

  Finder inSheet(Finder finder) =>
      find.descendant(of: find.byType(PlanSheet), matching: finder);

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openSheet(WidgetTester tester, {int id = 7}) async {
    await pumpRecipe(tester, id: id);
    await tap(tester, find.text('Planen'));
    expect(find.byType(PlanSheet), findsOneWidget);
  }

  SwitchListTile shoppingSwitch(WidgetTester tester) =>
      tester.widget(inSheet(find.byType(SwitchListTile)));

  ButtonStyleButton submit(WidgetTester tester, String label) => tester.widget(
    find.ancestor(
      of: inSheet(find.text(label)),
      matching: find.bySubtype<ButtonStyleButton>(),
    ),
  );

  void expectSelected(WidgetTester tester, Finder finder) =>
      expect(tester.getSemantics(finder), isSemantics(isSelected: true));

  testWidgets('starts with today, the first meal, the recipe\'s servings and '
      'what\'s missing', (tester) async {
    await openSheet(tester);

    expect(inSheet(find.text('Einplanen')), findsOneWidget);
    expect(inSheet(find.text('Ofenkarotten mit Feta')), findsOneWidget);
    expect(inSheet(find.text('16. Nov. – 22. Nov.')), findsOneWidget);
    expectSelected(tester, inSheet(find.text('18')));
    expect(
      tester.getSemantics(inSheet(find.text('20'))).label,
      'Freitag, 20. Nov., schon etwas geplant',
    );
    expect(
      tester.getSemantics(inSheet(find.text('19'))),
      isSemantics(label: 'Donnerstag, 19. Nov.', hasTapAction: true),
    );
    expectSelected(tester, inSheet(find.text('Frühstück')));
    expect(inSheet(find.text('2')), findsOneWidget);
    expect(inSheet(find.text('3 von 5 Zutaten fehlen noch')), findsOneWidget);
    expect(shoppingSwitch(tester).value, isTrue);
    expect(inSheet(find.text('Geteilt mit deinem Haushalt')), findsOneWidget);
    expect(inSheet(find.text('Für heute einplanen')), findsOneWidget);
  });

  testWidgets('starts with the servings chosen on the recipe screen', (
    tester,
  ) async {
    await pumpRecipe(tester);
    await tap(tester, find.byTooltip('Mehr Portionen'));
    await tap(tester, find.text('Planen'));

    expect(inSheet(find.text('3')), findsOneWidget);
  });

  testWidgets('plans for the chosen day and meal and adds what\'s missing', (
    tester,
  ) async {
    final router = await pumpRecipe(tester);
    await tap(tester, find.text('Planen'));

    await tap(tester, inSheet(find.text('20')));
    await tap(tester, inSheet(find.text('Abendessen')));
    await tap(tester, inSheet(find.byTooltip('Mehr Portionen')));
    await tap(tester, inSheet(find.text('Für Freitag einplanen')));

    final plan = plans.created.single;
    expect(plan.recipeId, 7);
    expect(plan.day, CalendarDay(2026, 11, 20));
    expect(plan.mealType, _dinner);
    expect(plan.servings, 3);
    expect(shopping.added.single, (recipeId: 7, servings: 3, mealPlanId: 1001));
    expect(find.byType(PlanSheet), findsNothing);
    expect(
      find.text(
        'Für Freitag, 20. Nov. eingeplant, Fehlendes steht auf der '
        'Einkaufsliste.',
      ),
      findsOneWidget,
    );

    await tap(tester, find.text('Zum Plan'));
    // The current week: the tab keeps following today.
    expect(router.state.uri.toString(), '/plan');
    expect(find.byType(PlannerScreen), findsOneWidget);
    expect(find.text('16. Nov. – 22. Nov.'), findsOneWidget);
    expect(find.text('Rezept 7'), findsOneWidget);
  });

  testWidgets('plans without shopping, and remembers both choices', (
    tester,
  ) async {
    await openSheet(tester);
    await tap(tester, inSheet(find.text('Snack')));
    await tap(tester, inSheet(find.byType(SwitchListTile)));
    await tap(tester, inSheet(find.text('Für heute einplanen')));

    expect(plans.created.single.mealType, _snack);
    expect(shopping.added, isEmpty);
    expect(find.text('Für Mittwoch, 18. Nov. eingeplant.'), findsOneWidget);

    await tap(tester, find.text('Planen'));
    expectSelected(tester, inSheet(find.text('Snack')));
    expect(shoppingSwitch(tester).value, isFalse);
  });

  testWidgets('with everything on hand, there is nothing to add', (
    tester,
  ) async {
    recipes.recipes[7] = _withFoods(
      ofenkarotten,
      (food) => food.copyWith(onHand: true),
    );
    await openSheet(tester);

    expect(inSheet(find.text('Alle Zutaten sind schon da.')), findsOneWidget);
    expect(shoppingSwitch(tester).onChanged, isNull);
    expect(shoppingSwitch(tester).value, isFalse);

    await tap(tester, inSheet(find.text('Für heute einplanen')));
    expect(plans.created, hasLength(1));
    expect(shopping.added, isEmpty);
    expect(find.text('Für Mittwoch, 18. Nov. eingeplant.'), findsOneWidget);
  });

  testWidgets('adds what is missing according to the recipe read at save', (
    tester,
  ) async {
    await openSheet(tester);
    recipes.recipes[7] = _withFoods(
      ofenkarotten,
      (food) => food.copyWith(onHand: true),
    );

    await tap(tester, inSheet(find.text('Für heute einplanen')));

    expect(shopping.added, hasLength(1));
    // Nothing was missing any more, so nothing went on the list.
    expect(find.text('Für Mittwoch, 18. Nov. eingeplant.'), findsOneWidget);
  });

  testWidgets('a sheet dragged away while saving still reports', (
    tester,
  ) async {
    final gate = plans.gate = Completer<void>();
    await openSheet(tester);
    await tester.tap(inSheet(find.text('Für heute einplanen')));
    await tester.pump();

    await tester.fling(
      inSheet(find.text('Einplanen')),
      const Offset(0, 600),
      2000,
    );
    await tester.pumpAndSettle();
    expect(find.byType(PlanSheet), findsNothing);

    gate.complete();
    await tester.pumpAndSettle();
    expect(plans.created, hasLength(1));
    expect(shopping.added, hasLength(1));
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(
      find.text(
        'Für Mittwoch, 18. Nov. eingeplant, Fehlendes steht auf der '
        'Einkaufsliste.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a save failing after the sheet was dragged away says so', (
    tester,
  ) async {
    final gate = plans.gate = Completer<void>();
    plans.createFailure = const ServerFailure();
    await openSheet(tester);
    await tester.tap(inSheet(find.text('Für heute einplanen')));
    await tester.pump();
    await tester.fling(
      inSheet(find.text('Einplanen')),
      const Offset(0, 600),
      2000,
    );
    await tester.pumpAndSettle();

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.textContaining('Nicht eingeplant.'), findsOneWidget);
    expect(find.byType(RecipeScreen), findsOneWidget);
  });

  testWidgets('remembers the meal type by name', (tester) async {
    store.write('planner.meal-type', 'abendessen');
    await openSheet(tester);

    expectSelected(tester, inSheet(find.text('Abendessen')));
  });

  testWidgets('a recipe counted in pieces says so', (tester) async {
    recipes.recipes[7] = _recipe.copyWith(servings: 12, servingsText: 'Stück');
    await openSheet(tester);

    expect(inSheet(find.text('12 Stück')), findsOneWidget);
  });

  testWidgets('browses the weeks, keeping the weekday', (tester) async {
    final router = await pumpRecipe(tester);
    await tap(tester, find.text('Planen'));

    await tap(tester, inSheet(find.byTooltip('Nächste Woche')));
    expect(inSheet(find.text('23. Nov. – 29. Nov.')), findsOneWidget);
    expectSelected(tester, inSheet(find.text('25')));
    await tap(tester, inSheet(find.text('Für Mi, 25. Nov. einplanen')));

    expect(plans.created.single.day, CalendarDay(2026, 11, 25));
    await tap(tester, find.text('Zum Plan'));
    expect(router.state.uri.toString(), '/plan?day=2026-11-23');
    expect(find.text('23. Nov. – 29. Nov.'), findsOneWidget);
  });

  testWidgets('a preset day is chosen', (tester) async {
    final router = await pumpRecipe(tester);
    router.go('/preset');
    await tester.pumpAndSettle();
    await tap(tester, find.text('preset'));

    expectSelected(tester, inSheet(find.text('21')));
    expect(inSheet(find.text('4')), findsOneWidget);
    expect(inSheet(find.text('Für Samstag einplanen')), findsOneWidget);
  });

  testWidgets('a space without meal types gets its first one', (tester) async {
    mealTypes.types.clear();
    await openSheet(tester);

    expect(
      inSheet(find.textContaining('noch keine Mahlzeiten')),
      findsOneWidget,
    );
    expect(submit(tester, 'Für heute einplanen').onPressed, isNull);

    await tester.enterText(inSheet(find.byType(TextField)), ' Abendessen ');
    await tester.pump();
    await tap(tester, inSheet(find.text('Mahlzeit anlegen')));

    expect(mealTypes.types.single.name, 'Abendessen');
    expectSelected(tester, inSheet(find.text('Abendessen')));
    await tap(tester, inSheet(find.text('Für heute einplanen')));
    expect(plans.created.single.mealType.name, 'Abendessen');
  });

  testWidgets('a failed meal type load can be retried', (tester) async {
    mealTypes.failure = const ServerFailure();
    await openSheet(tester);

    expect(submit(tester, 'Für heute einplanen').onPressed, isNull);
    mealTypes.failure = null;
    await tap(tester, inSheet(find.text('Nochmal versuchen')));

    expect(inSheet(find.text('Frühstück')), findsOneWidget);
  });

  testWidgets('a failed save keeps the sheet open to retry', (tester) async {
    plans.createFailure = const ServerFailure();
    await openSheet(tester);

    await tap(tester, inSheet(find.text('Für heute einplanen')));
    expect(find.byType(PlanSheet), findsOneWidget);
    expect(inSheet(find.textContaining('Nicht eingeplant.')), findsOneWidget);
    expect(shopping.added, isEmpty);

    plans.createFailure = null;
    await tap(tester, inSheet(find.text('Für heute einplanen')));
    expect(find.byType(PlanSheet), findsNothing);
    expect(plans.created, hasLength(1));
    expect(shopping.added, hasLength(1));
  });

  testWidgets('if the shopping list fails, the plan stays and says so', (
    tester,
  ) async {
    shopping.failure = const OfflineFailure();
    await openSheet(tester);

    await tap(tester, inSheet(find.text('Für heute einplanen')));

    expect(plans.created, hasLength(1));
    expect(find.byType(PlanSheet), findsNothing);
    expect(
      find.text(
        'Für Mittwoch, 18. Nov. eingeplant, aber nicht auf die Einkaufsliste '
        'gesetzt. Der Server ist gerade nicht erreichbar. Prüf deine '
        'Verbindung.',
      ),
      findsOneWidget,
    );
  });

  group('offline', () {
    testWidgets('"Planen" is disabled', (tester) async {
      connectivity.isOnline = false;
      await pumpRecipe(tester);

      final button = tester.widget<ButtonStyleButton>(
        find.ancestor(
          of: find.text('Planen'),
          matching: find.bySubtype<ButtonStyleButton>(),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('saving is disabled with an explanation', (tester) async {
      await openSheet(tester);
      connectivity.isOnline = false;
      await tester.pumpAndSettle();

      expect(submit(tester, 'Für heute einplanen').onPressed, isNull);
      expect(
        inSheet(find.textContaining('Offline kannst du nichts ändern.')),
        findsOneWidget,
      );
      expect(plans.created, isEmpty);
    });
  });

  testWidgets('long German names fit at 390 px', (tester) async {
    mealTypes.types.add(
      const MealType(id: 9, name: 'Zweites Frühstück am Vormittag', order: 9),
    );
    await openSheet(tester, id: longNames.id);

    expect(tester.takeException(), isNull);
    expect(
      inSheet(find.text('Zweites Frühstück am Vormittag')),
      findsOneWidget,
    );
  });

  testWidgets('fits with large text and a week over New Year', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    now = DateTime(2026, 12, 30, 12);
    await openSheet(tester);

    expect(tester.takeException(), isNull);
    expect(inSheet(find.text('28. Dez. – 3. Jan. 2027')), findsOneWidget);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('mockup 11 in $name', tags: goldenTags, (tester) async {
        store.write('planner.meal-type', 'Abendessen');
        await pumpRecipe(tester, theme: theme);
        await tap(tester, find.text('Planen'));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/plan_sheet_$name.png'),
        );
      });
    }
  });
}
