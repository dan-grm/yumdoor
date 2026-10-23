import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/cooking/cooking_screen.dart';
import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

import '../../fakes/fake_recipe_repository.dart';
import '../../fakes/fake_wake_lock_service.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository repository;
  late FakeWakeLockService wakeLock;

  setUpAll(loadBundledFonts);

  setUp(() {
    repository = FakeRecipeRepository([ofenkarotten]);
    wakeLock = FakeWakeLockService();
  });

  /// Cooking mode pushed over a stand-in recipe screen, like the app does.
  Future<GoRouter> pumpCooking(
    WidgetTester tester, {
    String query = '?servings=4',
    ThemeData? theme,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: '/recipe/7',
      theme: theme,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(repository),
        wakeLockServiceProvider.overrideWithValue(wakeLock),
      ],
      routes: [
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) => const Text('recipe screen'),
          routes: [
            GoRoute(
              path: 'cook',
              builder: (context, state) => CookingScreen(
                recipeId: int.parse(state.pathParameters['id']!),
                servings: int.tryParse(
                  state.uri.queryParameters['servings'] ?? '',
                ),
              ),
            ),
          ],
        ),
      ],
    );
    unawaitedPush(router, '/recipe/7/cook$query');
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> next(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the first step and the recipe name', (tester) async {
    await pumpCooking(tester);

    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    expect(find.text('Schritt 1 von 3'), findsOneWidget);
    expect(find.text('SCHRITT 1'), findsOneWidget);
    expect(find.text('Den Ofen auf 200 °C vorheizen.'), findsOneWidget);
    // Step 1 has no ingredients.
    expect(find.text('Zutaten'), findsNothing);
  });

  testWidgets('Weiter and Zurück move between steps', (tester) async {
    await pumpCooking(tester);

    await next(tester, 'Weiter zu Schritt 2');
    expect(find.text('Schritt 2 von 3'), findsOneWidget);
    expect(find.textContaining('Karotten schräg'), findsOneWidget);

    await tester.tap(find.byTooltip('Zurück zu Schritt 1'));
    await tester.pumpAndSettle();
    expect(find.text('Schritt 1 von 3'), findsOneWidget);
  });

  testWidgets('the back button is disabled on the first step', (tester) async {
    await pumpCooking(tester);

    final back = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.chevron_left_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(back.onPressed, isNull);
  });

  testWidgets('swiping changes the step', (tester) async {
    await pumpCooking(tester);

    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Schritt 2 von 3'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Schritt 1 von 3'), findsOneWidget);
  });

  testWidgets('tapping a step dot jumps to that step', (tester) async {
    await pumpCooking(tester);

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(find.text('Schritt 3 von 3'), findsOneWidget);
  });

  testWidgets('amounts are scaled to the chosen servings, read-only', (
    tester,
  ) async {
    await pumpCooking(tester, query: '?servings=4');
    await next(tester, 'Weiter zu Schritt 2');

    expect(find.text('für 4 Portionen'), findsOneWidget);
    expect(find.text('Karotten'), findsOneWidget);
    expect(find.text('600 g'), findsOneWidget);
    expect(find.text('2 EL'), findsOneWidget);
    expect(find.text('1 TL'), findsOneWidget);
    expect(find.text('Salz'), findsOneWidget);
    // Nothing here changes the servings.
    expect(find.byTooltip('Mehr Portionen'), findsNothing);
    expect(find.byTooltip('Weniger Portionen'), findsNothing);

    await next(tester, 'Weiter zu Schritt 3');
    expect(find.text('200 g'), findsOneWidget);
    expect(find.text('½ Bund'), findsOneWidget);
  });

  testWidgets('without servings, the recipe\'s own servings are used', (
    tester,
  ) async {
    await pumpCooking(tester, query: '');
    await next(tester, 'Weiter zu Schritt 2');

    expect(find.text('für 2 Portionen'), findsOneWidget);
    expect(find.text('300 g'), findsOneWidget);
  });

  testWidgets('the last step offers Fertig, which returns to the recipe', (
    tester,
  ) async {
    await pumpCooking(tester);
    await next(tester, 'Weiter zu Schritt 2');
    await next(tester, 'Weiter zu Schritt 3');

    expect(find.text('SCHRITT 3 · LETZTER'), findsOneWidget);
    expect(find.textContaining('Weiter zu'), findsNothing);

    await next(tester, 'Fertig');
    expect(find.text('recipe screen'), findsOneWidget);
    expect(find.byType(CookingScreen), findsNothing);
  });

  testWidgets('the close button returns to the recipe', (tester) async {
    await pumpCooking(tester);

    await tester.tap(find.byTooltip('Kochmodus beenden'));
    await tester.pumpAndSettle();

    expect(find.text('recipe screen'), findsOneWidget);
  });

  group('wake lock', () {
    testWidgets('is acquired on enter and released on leave', (tester) async {
      await pumpCooking(tester);

      expect(wakeLock.status, WakeLockStatus.active);
      expect(find.byTooltip('Bildschirm bleibt an'), findsOneWidget);

      await tester.tap(find.byTooltip('Kochmodus beenden'));
      await tester.pumpAndSettle();

      expect(wakeLock.status, WakeLockStatus.inactive);
    });

    testWidgets('the toggle releases and reacquires it', (tester) async {
      await pumpCooking(tester);

      await tester.tap(find.byTooltip('Bildschirm bleibt an'));
      await tester.pumpAndSettle();
      expect(wakeLock.status, WakeLockStatus.inactive);
      expect(find.byTooltip('Bildschirm anlassen'), findsOneWidget);

      await tester.tap(find.byTooltip('Bildschirm anlassen'));
      await tester.pumpAndSettle();
      expect(wakeLock.status, WakeLockStatus.active);
    });

    testWidgets('the icon follows the platform dropping it', (tester) async {
      await pumpCooking(tester);

      wakeLock.dropByPlatform();
      await tester.pump();
      expect(find.byTooltip('Bildschirm anlassen'), findsOneWidget);

      wakeLock.resume();
      await tester.pump();
      expect(find.byTooltip('Bildschirm bleibt an'), findsOneWidget);
    });

    testWidgets('if unsupported, a hint is shown once per session', (
      tester,
    ) async {
      wakeLock = FakeWakeLockService(outcome: WakeLockStatus.unsupported);
      final router = await pumpCooking(tester);
      const hint =
          'Dein Gerät kann den Bildschirm hier nicht anlassen. Stell die '
          'automatische Sperre zum Kochen länger ein.';

      expect(find.text(hint), findsOneWidget);
      expect(find.byTooltip('Bildschirm kann nicht anbleiben'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      ScaffoldMessenger.of(tester.element(find.text('recipe screen')))
          .clearSnackBars();
      await tester.pumpAndSettle();

      unawaitedPush(router, '/recipe/7/cook?servings=4');
      await tester.pumpAndSettle();
      expect(find.text(hint), findsNothing);
    });

    testWidgets('if denied, the hint is shown too', (tester) async {
      wakeLock = FakeWakeLockService(outcome: WakeLockStatus.denied);
      await pumpCooking(tester);

      expect(
        find.textContaining('Dein Gerät kann den Bildschirm'),
        findsOneWidget,
      );
    });
  });

  testWidgets('a recipe without steps says so', (tester) async {
    repository.recipes[7] = ofenkarotten.copyWith(steps: []);
    await pumpCooking(tester);

    expect(find.text('Dieses Rezept hat keine Schritte.'), findsOneWidget);
    expect(find.byTooltip('Kochmodus beenden'), findsOneWidget);
  });

  testWidgets('long German step text fits at 390 px', (tester) async {
    repository.recipes[8] = longNames;
    await pumpRoutes(
      tester,
      location: '/cook',
      overrides: [
        recipeRepositoryProvider.overrideWithValue(repository),
        wakeLockServiceProvider.overrideWithValue(wakeLock),
      ],
      routes: [
        GoRoute(
          path: '/cook',
          builder: (context, state) =>
              const CookingScreen(recipeId: 8, servings: 12),
        ),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('für 12 Portionen'), findsOneWidget);
    expect(find.text('3.703,5 Vakuumpackungen à 500 Gramm'), findsNothing);
    expect(find.text('3.704 Vakuumpackungen à 500 Gramm'), findsOneWidget);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('step 2 at 4 servings in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpCooking(tester, theme: theme);
        await next(tester, 'Weiter zu Schritt 2');

        await expectLater(
          find.byType(CookingScreen),
          matchesGoldenFile('../goldens/cooking_step_$name.png'),
        );
      });
    }
  });
}

/// Pushes [location] without awaiting the route's result.
void unawaitedPush(GoRouter router, String location) {
  router.push<void>(location).ignore();
}
