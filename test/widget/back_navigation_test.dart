import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/features/cook_log/cook_log_screen.dart';
import 'package:yumdoor/features/cooking/cooking_screen.dart';
import 'package:yumdoor/features/home/home_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';
import 'package:yumdoor/features/search/search_location.dart';

import '../fakes/app_overrides.dart';
import '../fakes/fake_recipe_repository.dart';
import '../fakes/fake_wake_lock_service.dart';
import '../fixtures/recipes.dart';
import 'fonts.dart';
import 'harness.dart';

/// Back, as Android's back button and, on the web, the browser's back (also
/// the swipe from the edge in the installed app) send it: it follows the
/// screens' hierarchy, not the order they were seen in (#98).
void main() {
  setUpAll(loadBundledFonts);

  Future<GoRouter> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = phoneSize;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.localesTestValue = const [Locale('de')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...appOverrides(
            tokenStore: loggedInTokenStore(),
            recipes: FakeRecipeRepository([ofenkarotten]),
          ),
          wakeLockServiceProvider.overrideWithValue(FakeWakeLockService()),
          clockProvider.overrideWithValue(() => DateTime(2026, 11, 18, 12)),
        ],
        child: const YumdoorApp(),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(YumdoorApp)))
        .read(routerProvider);
  }

  String location(GoRouter router) => router.state.uri.toString();

  Future<void> back(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> cookToTheEnd(WidgetTester tester, GoRouter router) async {
    router.go('/search');
    await tester.pumpAndSettle();
    await tap(tester, find.text('Ofenkarotten mit Feta'));
    await tap(tester, find.textContaining('Kochen starten'));
    await tap(tester, find.text('Weiter zu Schritt 2'));
    await tap(tester, find.text('Weiter zu Schritt 3'));
    await tap(tester, find.text('Fertig gekocht'));
    expect(find.byType(CookLogScreen), findsOneWidget);
  }

  testWidgets('after cooking, back leads to the recipe, then to search', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    await cookToTheEnd(tester, router);

    await back(tester);
    expect(location(router), '/recipe/7');
    expect(find.byType(CookingScreen), findsNothing);

    await back(tester);
    expect(location(router), '/search');
  });

  testWidgets('after closing the cook log, back on the recipe leads to '
      'search', (tester) async {
    final router = await pumpApp(tester);
    await cookToTheEnd(tester, router);

    await tap(tester, find.byTooltip('Schließen, ohne zu speichern'));
    expect(location(router), '/recipe/7');

    await back(tester);
    expect(location(router), '/search');
    expect(find.byType(RecipeScreen), findsNothing);
  });

  group('a screen opened from a link or after a reload', () {
    testWidgets('recipe: back leads to the start screen', (tester) async {
      final router = await pumpApp(tester);
      router.go('/recipe/7');
      await tester.pumpAndSettle();

      await back(tester);
      expect(location(router), '/');
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('cooking mode: back leads to the recipe, then to the start '
        'screen', (tester) async {
      final router = await pumpApp(tester);
      router.go('/recipe/7/cook?servings=2');
      await tester.pumpAndSettle();

      await back(tester);
      expect(router.state.uri.path, '/recipe/7');
      await back(tester);
      expect(location(router), '/');
    });

    testWidgets('settings: back leads to the start screen', (tester) async {
      final router = await pumpApp(tester);
      router.go('/settings');
      await tester.pumpAndSettle();

      await back(tester);
      expect(location(router), '/');
    });

    testWidgets('new recipe: back leads to search', (tester) async {
      final router = await pumpApp(tester);
      router.go('/recipe/new');
      await tester.pumpAndSettle();

      await back(tester);
      expect(location(router), '/search');
    });

    testWidgets('recipe picker: back leads to the planner at the day\'s '
        'week', (tester) async {
      final router = await pumpApp(tester);
      router.go(
        pickRecipeLocation(const RecipeQuery(), CalendarDay(2026, 12, 2)),
      );
      await tester.pumpAndSettle();

      await back(tester);
      expect(location(router), '/plan?day=2026-11-30');
    });

    testWidgets('recipe picker for this week: back leads to the planner', (
      tester,
    ) async {
      final router = await pumpApp(tester);
      router.go(
        pickRecipeLocation(const RecipeQuery(), CalendarDay(2026, 11, 20)),
      );
      await tester.pumpAndSettle();

      await back(tester);
      expect(location(router), '/plan');
    });
  });
}
