import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/features/home/home_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

const _lunch = MealType(
  id: 2,
  name: 'Mittagessen',
  order: 1,
  time: Duration(hours: 12, minutes: 30),
);
const _dinner = MealType(
  id: 3,
  name: 'Abendessen',
  order: 2,
  time: Duration(hours: 18),
);

/// A recipe whose ingredients are all on hand.
const _risotto = Recipe(
  id: 20,
  name: 'Kürbis-Risotto',
  servings: 2,
  workingTime: Duration(minutes: 40),
  steps: [
    RecipeStep(
      id: 1,
      instruction: 'Kürbis würfeln und mit dem Reis garen.',
      ingredients: [
        Ingredient(
          id: 1,
          food: Food(id: 10, name: 'Kürbis', onHand: true),
          amount: 1,
        ),
        Ingredient(
          id: 2,
          food: Food(id: 11, name: 'Risottoreis', onHand: true),
          amount: 300,
        ),
      ],
    ),
  ],
);

RecipeSummary _summary(Recipe recipe) => RecipeSummary(
  id: recipe.id,
  name: recipe.name,
  servings: recipe.servings,
  workingTime: recipe.workingTime,
  waitingTime: recipe.waitingTime,
);

/// Wednesday, 18 November 2026.
final _today = CalendarDay(2026, 11, 18);

MealPlan _plan(
  int id,
  MealType type, {
  Recipe? recipe,
  String title = '',
  double servings = 4,
  CalendarDay? day,
}) => MealPlan(
  id: id,
  recipe: recipe == null ? null : _summary(recipe),
  title: title,
  servings: servings,
  fromDay: day ?? _today,
  toDay: day ?? _today,
  mealType: type,
  createdBy: 1,
);

void main() {
  setUpAll(loadBundledFonts);

  late FakeMealPlanRepository plans;
  late FakeRecipeRepository recipes;

  setUp(() => recipes = FakeRecipeRepository([ofenkarotten, _risotto]));
  setUp(
    () => plans = FakeMealPlanRepository([
      _plan(1, _dinner, recipe: _risotto),
      _plan(2, _lunch, recipe: ofenkarotten, servings: 2.5),
      // Tomorrow.
      _plan(3, _dinner, title: 'Pizza bestellen', day: _today.addDays(1)),
    ]),
  );

  Future<GoRouter> pumpHome(
    WidgetTester tester, {
    DateTime? now,
    ThemeData? theme,
    Size size = phoneSize,
    FakeConnectivityService? connectivity,
  }) => pumpRoutes(
    tester,
    location: '/',
    theme: theme,
    size: size,
    overrides: [
      ...appOverrides(
        mealPlans: plans,
        recipes: recipes,
        connectivity: connectivity,
      ),
      clockProvider.overrideWithValue(
        () => now ?? DateTime(2026, 11, 18, 16, 5),
      ),
    ],
    routes: [
      tabsRoute(),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) =>
            Scaffold(body: Text('recipe ${state.uri}')),
        routes: [
          GoRoute(
            path: 'cook',
            builder: (context, state) =>
                Scaffold(body: Text('cook ${state.uri}')),
          ),
        ],
      ),
      GoRoute(
        path: '/plan/pick',
        builder: (context, state) => Scaffold(body: Text('pick ${state.uri}')),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Scaffold(body: Text('settings')),
      ),
    ],
  );

  for (final (hour, greeting) in [
    (4, 'Guten Abend'),
    (5, 'Guten Morgen'),
    (10, 'Guten Morgen'),
    (11, 'Guten Tag'),
    (17, 'Guten Tag'),
    (18, 'Guten Abend'),
    (23, 'Guten Abend'),
  ]) {
    testWidgets('greets with "$greeting" at $hour o\'clock', (tester) async {
      await pumpHome(tester, now: DateTime(2026, 11, 18, hour, 30));

      expect(find.text(greeting), findsOneWidget);
      expect(find.text('Mittwoch, 18. November'), findsOneWidget);
    });
  }

  testWidgets('the profile button opens the settings', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Einstellungen'));
    await tester.pumpAndSettle();

    expect(find.text('settings'), findsOneWidget);
  });

  testWidgets('shows the next meal with its planned servings', (tester) async {
    await pumpHome(tester);

    expect(find.text('Heute · Abendessen'), findsOneWidget);
    expect(find.text('4 Portionen'), findsOneWidget);
    expect(find.text('Kürbis-Risotto'), findsOneWidget);
    expect(find.text('40 Min · alle Zutaten zu Hause'), findsOneWidget);
    // Loading it to count what is missing is no view of the recipe.
    expect(recipes.views, isEmpty);
    // The week the planner shows, so they share the offline cache.
    expect(plans.listCalls.single, (
      from: CalendarDay(2026, 11, 16),
      to: CalendarDay(2026, 11, 22),
    ));
    // Tomorrow's meal isn't shown.
    expect(find.text('Pizza bestellen'), findsNothing);
  });

  testWidgets('"Rezept ansehen" opens the recipe for the planned servings', (
    tester,
  ) async {
    final router = await pumpHome(tester);

    await tester.tap(find.text('Rezept ansehen'));
    await tester.pumpAndSettle();
    expect(find.text('recipe /recipe/20?servings=4'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(router.state.uri.toString(), '/');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('"Kochen starten" opens cooking mode for the planned servings', (
    tester,
  ) async {
    final router = await pumpHome(tester);

    await tester.tap(find.text('Kochen starten'));
    await tester.pumpAndSettle();
    expect(find.text('cook /recipe/20/cook?servings=4'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(router.state.uri.toString(), '/');
  });

  testWidgets('lists the other meals of the day, which open for theirs', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('Außerdem heute'), findsOneWidget);
    expect(find.text('Mittagessen · 3 Port.'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Kürbis-Risotto')).dy,
      lessThan(tester.getTopLeft(find.text('Ofenkarotten mit Feta')).dy),
    );

    await tester.tap(find.text('Ofenkarotten mit Feta'));
    await tester.pumpAndSettle();
    expect(find.text('recipe /recipe/7?servings=3'), findsOneWidget);
  });

  testWidgets('before lunch, lunch is next and says what is missing', (
    tester,
  ) async {
    await pumpHome(tester, now: DateTime(2026, 11, 18, 9));

    expect(find.text('Heute · Mittagessen'), findsOneWidget);
    // Whole servings, as the recipe and cooking mode take them.
    expect(find.text('3 Portionen'), findsOneWidget);
    // Ofenkarotten has six ingredients, none on hand.
    expect(find.text('35 Min · 6 Zutaten fehlen'), findsOneWidget);

    await tester.tap(find.text('Kochen starten'));
    await tester.pumpAndSettle();
    expect(find.text('cook /recipe/7/cook?servings=3'), findsOneWidget);
  });

  testWidgets('follows the clock while it stays open', (tester) async {
    var now = DateTime(2026, 11, 18, 9);
    await pumpRoutes(
      tester,
      location: '/',
      overrides: [
        ...appOverrides(mealPlans: plans, recipes: recipes),
        clockProvider.overrideWithValue(() => now),
      ],
      routes: [tabsRoute()],
    );
    expect(find.text('Guten Morgen'), findsOneWidget);
    expect(find.text('Heute · Mittagessen'), findsOneWidget);

    now = DateTime(2026, 11, 18, 16, 5);
    await tester.pump(const Duration(minutes: 1));
    await tester.pumpAndSettle();
    expect(find.text('Guten Tag'), findsOneWidget);
    expect(find.text('Heute · Abendessen'), findsOneWidget);

    // The next day, with tomorrow's plan.
    now = DateTime(2026, 11, 19, 19);
    await tester.pump(const Duration(minutes: 1));
    await tester.pumpAndSettle();
    expect(find.text('Donnerstag, 19. November'), findsOneWidget);
    expect(find.text('Pizza bestellen'), findsOneWidget);
  });

  testWidgets('counts what is missing again when it is shown again', (
    tester,
  ) async {
    await pumpHome(tester, now: DateTime(2026, 11, 18, 9));
    expect(find.text('35 Min · 6 Zutaten fehlen'), findsOneWidget);

    await tester.tap(find.text('Einkauf'));
    await tester.pumpAndSettle();
    // Bought and checked off: now on hand.
    recipes.recipes[ofenkarotten.id] = _risotto.copyWith(id: ofenkarotten.id);
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('35 Min · alle Zutaten zu Hause'), findsOneWidget);
  });

  testWidgets('loads today\'s plans again when it is shown again', (
    tester,
  ) async {
    await pumpHome(tester);
    expect(find.text('Kürbis-Risotto'), findsOneWidget);

    await tester.tap(find.text('Einkauf'));
    await tester.pumpAndSettle();
    // Changed on another device.
    plans.plans.removeAt(0);
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('Heute · Mittagessen'), findsOneWidget);
    expect(find.text('Kürbis-Risotto'), findsNothing);
  });

  testWidgets('cooking is disabled when the recipe can\'t be loaded', (
    tester,
  ) async {
    recipes.failure = const OfflineFailure();
    await pumpHome(tester);

    final button = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('Kochen starten'),
        matching: find.byType(TextButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('a meal without a recipe shows its title, without buttons', (
    tester,
  ) async {
    plans.plans
      ..clear()
      ..add(_plan(4, _dinner, title: 'Pizza bestellen', servings: 2));
    await pumpHome(tester);

    expect(find.text('Heute · Abendessen'), findsOneWidget);
    expect(find.text('Pizza bestellen'), findsOneWidget);
    expect(find.text('Rezept ansehen'), findsNothing);
    expect(find.text('Kochen starten'), findsNothing);
  });

  testWidgets('nothing planned offers to plan a recipe for today', (
    tester,
  ) async {
    plans.plans.clear();
    await pumpHome(tester);

    expect(find.text('Für heute ist nichts geplant.'), findsOneWidget);
    await tester.tap(find.text('Rezept planen'));
    await tester.pumpAndSettle();

    expect(find.text('pick /plan/pick?day=2026-11-18'), findsOneWidget);
  });

  group('offline', () {
    testWidgets('shows today from the cache and says when it was loaded', (
      tester,
    ) async {
      plans.cachedAt = DateTime(2026, 11, 18, 7, 45);
      await pumpHome(
        tester,
        connectivity: FakeConnectivityService(isOnline: false),
      );

      expect(find.text('Offline · Stand vom 18. Nov., 07:45'), findsOneWidget);
      expect(find.text('Kürbis-Risotto'), findsOneWidget);
      // Reading needs no server.
      await tester.tap(find.text('Rezept ansehen'));
      await tester.pumpAndSettle();
      expect(find.text('recipe /recipe/20?servings=4'), findsOneWidget);
    });

    testWidgets('planning is disabled when nothing is planned', (tester) async {
      plans
        ..plans.clear()
        ..cachedAt = DateTime(2026, 11, 18, 7, 45);
      await pumpHome(
        tester,
        connectivity: FakeConnectivityService(isOnline: false),
      );

      await tester.tap(find.text('Rezept planen'));
      await tester.pumpAndSettle();
      expect(find.textContaining('pick'), findsNothing);
    });

    testWidgets('a day never loaded says it is offline', (tester) async {
      plans.failure = const OfflineFailure();
      await pumpHome(
        tester,
        connectivity: FakeConnectivityService(isOnline: false),
      );

      expect(
        find.text(
          'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.',
        ),
        findsOneWidget,
      );
    });
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('mockup 02 in $name', tags: goldenTags, (tester) async {
        await pumpHome(tester, theme: theme);

        await expectLater(
          find.byType(HomeScreen),
          matchesGoldenFile('../goldens/home_$name.png'),
        );
      });

      testWidgets('nothing planned in $name', tags: goldenTags, (tester) async {
        plans.plans.clear();
        await pumpHome(tester, theme: theme);

        await expectLater(
          find.byType(HomeScreen),
          matchesGoldenFile('../goldens/home_empty_$name.png'),
        );
      });
    }

    testWidgets('wide in light', tags: goldenTags, (tester) async {
      await pumpHome(tester, theme: lightTheme, size: tabletSize);

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('../goldens/home_wide_light.png'),
      );
    });
  });
}
