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
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/features/planner/planner_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_book_user_repositories.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/in_memory_local_store.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
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
  int createdBy = 1,
}) => MealPlan(
  id: id,
  recipe: recipe == null ? null : RecipeSummary(id: id + 100, name: recipe),
  title: title,
  servings: servings,
  fromDay: CalendarDay(2026, 11, day),
  toDay: CalendarDay(2026, 11, toDay ?? day),
  mealType: type,
  createdBy: createdBy,
);

void main() {
  setUpAll(loadBundledFonts);

  /// Wednesday; the week runs from Monday the 16th to Sunday the 22nd.
  final now = DateTime(2026, 11, 18, 12);

  final plans = [
    _plan(1, 16, _dinner, recipe: 'Linsen-Bolognese'),
    _plan(2, 18, _dinner, recipe: 'Ofenkarotten mit Feta'),
    _plan(3, 19, _dinner, recipe: 'Flammkuchen', createdBy: 2),
    _plan(4, 19, _lunch, recipe: 'Karotten-Ingwer-Suppe', servings: 2),
    _plan(5, 21, _dinner, title: 'Pizza bestellen'),
    _plan(6, 20, _lunch, title: 'Reste', toDay: 21),
    // Next week.
    _plan(7, 24, _breakfast, recipe: 'Porridge', servings: 1),
  ];

  late FakeMealPlanRepository repository;

  setUp(() => repository = FakeMealPlanRepository([...plans]));

  Future<GoRouter> pumpPlanner(
    WidgetTester tester, {
    String location = '/plan',
    ThemeData? theme,
    FakeUserRepository? users,
    InMemoryLocalStore? store,
    FakeConnectivityService? connectivity,
  }) => pumpRoutes(
    tester,
    // Tall enough for the whole week, whose days are taller with the add
    // buttons.
    size: const Size(390, 1200),
    location: location,
    theme: theme,
    overrides: [
      ...appOverrides(
        mealPlans: repository,
        recipes: FakeRecipeRepository([
          for (final id in [101, 102, 103, 104, 107])
            ofenkarotten.copyWith(id: id),
        ]),
        users:
            users ??
            FakeUserRepository(const [
              UserRef(id: 1, name: 'Anna'),
              UserRef(id: 2, name: 'Ben'),
            ]),
        localStore: store,
        connectivity: connectivity,
      ),
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

  testWidgets('empty days offer to plan a recipe', (tester) async {
    await pumpPlanner(tester);

    // Tuesday and Sunday have no meals.
    // Opening the picker is covered by plan_from_day_test.
    expect(find.text('Rezept planen'), findsNWidgets(2));
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

  testWidgets('opens at the week of the day in the location', (tester) async {
    final router = await pumpPlanner(tester, location: '/plan?day=2026-11-26');

    expect(find.text('23. Nov. – 29. Nov.'), findsOneWidget);
    expect(find.text('Porridge'), findsOneWidget);

    // Browsing changes the location, so the same day can be shown again.
    await tester.tap(find.byTooltip('Nächste Woche'));
    await tester.pumpAndSettle();
    expect(find.text('30. Nov. – 6. Dez.'), findsOneWidget);
    expect(router.state.uri.toString(), '/plan?day=2026-11-30');
    router.go('/plan?day=2026-11-26');
    await tester.pumpAndSettle();
    expect(find.text('23. Nov. – 29. Nov.'), findsOneWidget);

    await tester.tap(find.byTooltip('Vorherige Woche'));
    await tester.pumpAndSettle();
    expect(router.state.uri.toString(), '/plan');
    expect(find.text('Diese Woche'), findsOneWidget);
  });

  testWidgets('an invalid day in the location shows this week', (tester) async {
    await pumpPlanner(tester, location: '/plan?day=morgen');

    expect(find.text('16. Nov. – 22. Nov.'), findsOneWidget);
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

  testWidgets('pull to refresh loads the week again', (tester) async {
    await pumpPlanner(tester);
    expect(repository.listCalls, hasLength(1));

    repository.plans.add(_plan(8, 22, _dinner, recipe: 'Neues Rezept'));
    await tester.fling(
      find.text('Linsen-Bolognese'),
      const Offset(0, 300),
      1000,
    );
    await tester.pumpAndSettle();

    expect(repository.listCalls, hasLength(2));
    expect(find.text('Neues Rezept'), findsOneWidget);
  });

  group('offline', () {
    final cachedAt = DateTime(2026, 11, 17, 19, 30);

    testWidgets('shows the week as last loaded and says when', (tester) async {
      repository.cachedAt = cachedAt;
      await pumpPlanner(
        tester,
        connectivity: FakeConnectivityService(isOnline: false),
      );

      expect(find.text('Offline · Stand vom 17. Nov., 19:30'), findsOneWidget);
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
      expect(find.text('Pizza bestellen'), findsOneWidget);
      // Changes stay disabled.
      final menu = tester.widget<PopupMenuButton<Object?>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuButton &&
              widget.tooltip == 'Optionen für Linsen-Bolognese',
        ),
      );
      expect(menu.enabled, isFalse);
    });

    testWidgets('loads the week from the server once back online', (
      tester,
    ) async {
      repository.cachedAt = cachedAt;
      final connectivity = FakeConnectivityService(isOnline: false);
      await pumpPlanner(tester, connectivity: connectivity);
      expect(repository.listCalls, hasLength(1));

      repository.cachedAt = null;
      connectivity.isOnline = true;
      await tester.pumpAndSettle();

      expect(repository.listCalls, hasLength(2));
      expect(find.textContaining('Offline · Stand vom'), findsNothing);
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
    });

    testWidgets('a cached week after a timeout is read-only and retried', (
      tester,
    ) async {
      // The request timed out: the app doesn't count as offline.
      repository.cachedAt = cachedAt;
      await pumpPlanner(tester);

      expect(find.text('Offline · Stand vom 17. Nov., 19:30'), findsOneWidget);
      final menu = tester.widget<PopupMenuButton<Object?>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuButton &&
              widget.tooltip == 'Optionen für Linsen-Bolognese',
        ),
      );
      expect(menu.enabled, isFalse);

      repository.cachedAt = null;
      await tester.pump(const Duration(seconds: 15));
      await tester.pumpAndSettle();
      expect(repository.listCalls, hasLength(2));
      expect(find.textContaining('Offline · Stand vom'), findsNothing);
    });

    testWidgets('a week never loaded says it is offline', (tester) async {
      final connectivity = FakeConnectivityService(isOnline: false);
      repository.failure = const OfflineFailure();
      await pumpPlanner(tester, connectivity: connectivity);
      expect(find.text('Linsen-Bolognese'), findsNothing);

      // Tried again by itself once the connection is back.
      repository.failure = null;
      connectivity.isOnline = true;
      await tester.pumpAndSettle();
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
    });
  });

  group('household', () {
    final users = FakeUserRepository(const [
      UserRef(id: 1, name: 'Anna'),
      UserRef(id: 2, name: 'Ben'),
    ]);

    setUp(() {
      repository.plans
        ..clear()
        ..addAll([
          _plan(1, 18, _dinner, recipe: 'Eigenes Gericht'),
          _plan(2, 19, _dinner, recipe: 'Bens Gericht', createdBy: 2),
          _plan(3, 20, _dinner, recipe: 'Fremdes Gericht', createdBy: 9),
        ]);
    });

    testWidgets('says the plans are shared and names who planned', (
      tester,
    ) async {
      await pumpPlanner(tester, users: users);

      expect(find.text('Geteilt mit deinem Haushalt'), findsOneWidget);
      expect(find.text('Geplant von Ben'), findsOneWidget);
      expect(find.text('Von jemand anderem geplant'), findsOneWidget);
      // Own plans have no note.
      expect(find.textContaining('Geplant von Anna'), findsNothing);
      expect(find.text('Eigenes Gericht'), findsOneWidget);
    });

    testWidgets('"Nur meine" hides the plans of others', (tester) async {
      await pumpPlanner(tester, users: users);

      await tester.tap(find.text('Nur meine'));
      await tester.pumpAndSettle();

      expect(find.text('Eigenes Gericht'), findsOneWidget);
      expect(find.text('Bens Gericht'), findsNothing);
      expect(find.text('Fremdes Gericht'), findsNothing);

      await tester.tap(find.text('Alle'));
      await tester.pumpAndSettle();
      expect(find.text('Bens Gericht'), findsOneWidget);
    });

    testWidgets('remembers the filter on this device', (tester) async {
      final store = InMemoryLocalStore();
      await pumpPlanner(tester, users: users, store: store);
      await tester.tap(find.text('Nur meine'));
      await tester.pumpAndSettle();

      // A reload with the same storage.
      await tester.pumpWidget(const SizedBox());
      await pumpPlanner(tester, users: users, store: store);

      expect(find.text('Bens Gericht'), findsNothing);
      expect(find.text('Eigenes Gericht'), findsOneWidget);
    });

    testWidgets('shows everything without notes if users are unknown', (
      tester,
    ) async {
      await pumpPlanner(
        tester,
        users: FakeUserRepository()..failure = const ServerFailure(),
      );
      await tester.tap(find.text('Nur meine'));
      await tester.pumpAndSettle();

      expect(find.text('Bens Gericht'), findsOneWidget);
      expect(find.textContaining('Geplant von'), findsNothing);
    });
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

    testWidgets('offline in light', tags: goldenTags, (tester) async {
      repository.cachedAt = DateTime(2026, 11, 17, 19, 30);
      await pumpPlanner(
        tester,
        theme: lightTheme,
        connectivity: FakeConnectivityService(isOnline: false),
      );

      await expectLater(
        find.byType(PlannerScreen),
        matchesGoldenFile('../goldens/planner_offline_light.png'),
      );
    });
  });
}
