import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/features/planner/planner_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

const _breakfast = MealType(id: 1, name: 'Frühstück', order: 0);
const _lunch = MealType(id: 2, name: 'Mittagessen', order: 1);
const _dinner = MealType(id: 3, name: 'Abendessen', order: 2);

MealPlan _plan(
  int id,
  int day,
  MealType type, {
  String? recipe,
  String title = '',
  double servings = 4,
  int? toDay,
}) => MealPlan(
  id: id,
  recipe: recipe == null ? null : RecipeSummary(id: id + 100, name: recipe),
  title: title,
  servings: servings,
  fromDay: CalendarDay(2026, 11, day),
  toDay: CalendarDay(2026, 11, toDay ?? day),
  mealType: type,
  createdBy: 1,
);

void main() {
  setUpAll(loadBundledFonts);

  /// Wednesday; the week runs from Monday the 16th to Sunday the 22nd.
  final now = DateTime(2026, 11, 18, 12);

  final plans = [
    _plan(1, 16, _dinner, recipe: 'Linsen-Bolognese'),
    _plan(2, 18, _dinner, recipe: 'Ofenkarotten mit Feta'),
    _plan(3, 19, _dinner, recipe: 'Flammkuchen'),
    _plan(4, 19, _lunch, recipe: 'Karotten-Ingwer-Suppe', servings: 2),
    _plan(5, 21, _dinner, title: 'Pizza bestellen'),
    _plan(6, 20, _lunch, title: 'Reste', toDay: 21),
    // Next week.
    _plan(7, 24, _breakfast, recipe: 'Porridge', servings: 1),
  ];

  late FakeMealPlanRepository repository;

  setUp(() => repository = FakeMealPlanRepository(plans));

  Future<GoRouter> pumpPlanner(WidgetTester tester, {ThemeData? theme}) =>
      pumpRoutes(
        tester,
        location: '/plan',
        theme: theme,
        overrides: [
          ...appOverrides(mealPlans: repository),
          clockProvider.overrideWithValue(() => now),
        ],
        routes: [
          tabsRoute(),
          GoRoute(
            path: '/recipe/:id',
            builder: (context, state) =>
                Scaffold(body: Text('recipe ${state.pathParameters['id']}')),
          ),
        ],
      );

  testWidgets('shows the week with its meals by day', (tester) async {
    await pumpPlanner(tester);

    expect(find.text('16. Nov. – 22. Nov.'), findsOneWidget);
    expect(find.text('Diese Woche'), findsOneWidget);
    expect(repository.listCalls.single, (
      from: CalendarDay(2026, 11, 16),
      to: CalendarDay(2026, 11, 22),
    ));
    expect(find.text('Linsen-Bolognese'), findsOneWidget);
    expect(find.text('Abendessen · 4 Port.'), findsWidgets);
    expect(find.text('Mittagessen · 2 Port.'), findsOneWidget);
    // Next week's meal isn't shown.
    expect(find.text('Porridge'), findsNothing);
    // German weeks start on Monday.
    expect(
      tester.getTopLeft(find.text('Mo')).dy,
      lessThan(tester.getTopLeft(find.text('So')).dy),
    );
  });

  testWidgets('orders the meals of a day by meal type', (tester) async {
    await pumpPlanner(tester);

    expect(
      tester.getTopLeft(find.text('Karotten-Ingwer-Suppe')).dy,
      lessThan(tester.getTopLeft(find.text('Flammkuchen')).dy),
    );
  });

  testWidgets('empty days offer a disabled placeholder', (tester) async {
    await pumpPlanner(tester);

    // Tuesday and Sunday have no meals.
    expect(find.text('Rezept planen'), findsNWidgets(2));
    await tester.tap(find.text('Rezept planen').first);
    await tester.pumpAndSettle();
    expect(find.byType(PlannerScreen), findsOneWidget);
  });

  testWidgets('a plan without a recipe shows its title and is not tappable', (
    tester,
  ) async {
    final router = await pumpPlanner(tester);

    await tester.tap(find.text('Pizza bestellen'));
    await tester.pumpAndSettle();

    expect(find.text('Pizza bestellen'), findsOneWidget);
    expect(router.state.uri.toString(), '/plan');
  });

  testWidgets('a plan of several days is on each of them', (tester) async {
    await pumpPlanner(tester);

    expect(find.text('Reste'), findsNWidgets(2));
  });

  testWidgets('tapping a planned recipe opens it', (tester) async {
    final router = await pumpPlanner(tester);

    await tester.tap(find.text('Ofenkarotten mit Feta'));
    await tester.pumpAndSettle();

    expect(router.state.uri.toString(), '/recipe/102');
    expect(find.text('recipe 102'), findsOneWidget);
  });

  testWidgets('browses to the next and the previous week and back', (
    tester,
  ) async {
    await pumpPlanner(tester);

    await tester.tap(find.byTooltip('Nächste Woche'));
    await tester.pumpAndSettle();
    expect(find.text('23. Nov. – 29. Nov.'), findsOneWidget);
    expect(find.text('Porridge'), findsOneWidget);
    expect(find.text('Linsen-Bolognese'), findsNothing);
    expect(find.text('Diese Woche'), findsNothing);
    expect(repository.listCalls.last.from, CalendarDay(2026, 11, 23));

    await tester.tap(find.byTooltip('Vorherige Woche'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Vorherige Woche'));
    await tester.pumpAndSettle();
    expect(find.text('9. Nov. – 15. Nov.'), findsOneWidget);
    expect(
      find.text('In dieser Woche ist noch nichts geplant.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Zu dieser Woche'));
    await tester.pumpAndSettle();
    expect(find.text('16. Nov. – 22. Nov.'), findsOneWidget);
    expect(find.text('Diese Woche'), findsOneWidget);
    expect(find.text('Linsen-Bolognese'), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    repository.failure = const ServerFailure();
    await pumpPlanner(tester);

    expect(find.text('Nochmal versuchen'), findsOneWidget);
    expect(find.text('Linsen-Bolognese'), findsNothing);
    // The week buttons still work.
    expect(find.byTooltip('Nächste Woche'), findsOneWidget);

    repository.failure = null;
    await tester.tap(find.text('Nochmal versuchen'));
    await tester.pumpAndSettle();

    expect(find.text('Nochmal versuchen'), findsNothing);
    expect(find.text('Linsen-Bolognese'), findsOneWidget);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('mockup 10 in $name', tags: goldenTags, (tester) async {
        await pumpPlanner(tester, theme: theme);

        await expectLater(
          find.byType(PlannerScreen),
          matchesGoldenFile('../goldens/planner_$name.png'),
        );
      });
    }
  });
}
