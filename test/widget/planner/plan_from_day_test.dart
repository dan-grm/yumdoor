import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/features/planner/plan_sheet.dart';
import 'package:yumdoor/features/planner/planner_screen.dart';
import 'package:yumdoor/features/search/search_location.dart';
import 'package:yumdoor/features/search/search_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../../fakes/fake_meal_type_repository.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../harness.dart';

const _dinner = MealType(id: 3, name: 'Abendessen', order: 2);

void main() {
  setUpAll(loadBundledFonts);

  /// Wednesday; the week runs from Monday the 16th to Sunday the 22nd.
  final now = DateTime(2026, 11, 18, 12);

  late FakeMealPlanRepository plans;
  late FakeConnectivityService connectivity;

  setUp(() {
    plans = FakeMealPlanRepository([
      MealPlan(
        id: 1,
        recipe: const RecipeSummary(id: 50, name: 'Geplantes'),
        servings: 2,
        fromDay: CalendarDay(2026, 11, 18),
        toDay: CalendarDay(2026, 11, 18),
        mealType: _dinner,
        createdBy: 1,
      ),
    ]);
    connectivity = FakeConnectivityService();
  });

  Future<GoRouter> pumpPlanner(WidgetTester tester) => pumpRoutes(
    tester,
    location: '/plan',
    overrides: [
      ...appOverrides(
        recipes: FakeRecipeRepository([ofenkarotten, longNames]),
        mealPlans: plans,
        mealTypes: FakeMealTypeRepository([_dinner]),
        connectivity: connectivity,
      ),
      clockProvider.overrideWithValue(() => now),
    ],
    routes: [
      tabsRoute(),
      GoRoute(
        path: pickRecipePath,
        builder: (context, state) => SearchScreen(
          query: searchQueryFromUri(state.uri),
          pickDay: pickDayFromUri(state.uri),
        ),
      ),
    ],
  );

  Future<void> settle(WidgetTester tester) => tester.pumpAndSettle();

  testWidgets('an empty day opens the picker; the chosen recipe is planned '
      'on that day', (tester) async {
    await pumpPlanner(tester);
    // Monday is the first empty day.
    await tester.tap(find.text('Rezept planen').first);
    await settle(tester);

    expect(find.byType(PlannerScreen), findsNothing);
    expect(find.text('Rezept für Montag, 16. Nov.'), findsOneWidget);

    await tester.tap(find.text('Ofenkarotten mit Feta'));
    await settle(tester);
    expect(find.byType(PlanSheet), findsOneWidget);
    expect(find.text('Für Mo, 16. Nov. einplanen'), findsOneWidget);

    await tester.tap(find.text('Für Mo, 16. Nov. einplanen'));
    await settle(tester);

    expect(plans.created.single.day, CalendarDay(2026, 11, 16));
    expect(plans.created.single.recipeId, ofenkarotten.id);
    // Back in the planner, where the meal is now.
    expect(find.byType(SearchScreen), findsNothing);
    expect(find.byType(PlannerScreen), findsOneWidget);
    expect(find.text('Rezept ${ofenkarotten.id}'), findsOneWidget);
  });

  testWidgets('a day with meals has an add action too', (tester) async {
    await pumpPlanner(tester);
    await tester.tap(find.byTooltip('Rezept planen').first);
    await settle(tester);

    expect(find.text('Rezept für Mittwoch, 18. Nov.'), findsOneWidget);
  });

  testWidgets('cancelling the sheet stays in the picker, back returns to '
      'the planner without planning', (tester) async {
    await pumpPlanner(tester);
    await tester.tap(find.text('Rezept planen').first);
    await settle(tester);
    await tester.tap(find.text('Ofenkarotten mit Feta'));
    await settle(tester);

    // Close the sheet without saving.
    await tester.tapAt(const Offset(10, 10));
    await settle(tester);
    expect(find.byType(PlanSheet), findsNothing);
    expect(find.byType(SearchScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Zurück'));
    await settle(tester);
    expect(find.byType(PlannerScreen), findsOneWidget);
    expect(plans.created, isEmpty);
  });

  testWidgets('searching in the picker keeps the planner below', (
    tester,
  ) async {
    await pumpPlanner(tester);
    await tester.tap(find.text('Rezept planen').first);
    await settle(tester);

    await tester.enterText(find.byType(EditableText), 'Ofen');
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    expect(find.text('Rezept für Montag, 16. Nov.'), findsOneWidget);

    await tester.tap(find.byTooltip('Zurück'));
    await settle(tester);
    expect(find.byType(PlannerScreen), findsOneWidget);
  });

  testWidgets('offline, adding is disabled', (tester) async {
    connectivity.isOnline = false;
    await pumpPlanner(tester);

    await tester.tap(find.text('Rezept planen').first);
    await settle(tester);
    expect(find.byType(PlannerScreen), findsOneWidget);
    expect(find.byType(SearchScreen), findsNothing);
    // The day with a meal has no add button.
    expect(find.byTooltip('Rezept planen'), findsNothing);
  });
}
