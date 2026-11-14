import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/cook_log/cook_log_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_cook_log_repository.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeCookLogRepository cookLogs;
  late FakeConnectivityService connectivity;

  setUpAll(loadBundledFonts);

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    cookLogs = FakeCookLogRepository(now: DateTime(2026, 11, 14, 19));
    connectivity = FakeConnectivityService();
  });

  /// The cook log screen for 4 servings, pushed over the recipe screen like
  /// cooking mode does.
  Future<GoRouter> pumpCookLog(
    WidgetTester tester, {
    String location = '/recipe/7/cooked?servings=4',
    ThemeData? theme,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: '/recipe/7',
      theme: theme,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        cookLogRepositoryProvider.overrideWithValue(cookLogs),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
      routes: [
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) =>
              RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
          routes: [
            GoRoute(
              path: 'cooked',
              builder: (context, state) => CookLogScreen(
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
    router.push<void>(location).ignore();
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  TextButton saveButton(WidgetTester tester) => tester.widget<TextButton>(
    find.ancestor(
      of: find.text('Speichern'),
      matching: find.byType(TextButton),
    ),
  );

  testWidgets('shows what was cooked', (tester) async {
    await pumpCookLog(tester);

    expect(find.text('Guten Appetit!'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta · 4 Portionen'), findsOneWidget);
    expect(find.text("Wie war's?"), findsOneWidget);
    expect(find.text('Kommentar (optional)'), findsOneWidget);
    // Cook log entries are visible to the whole space.
    expect(
      find.text('Für alle in diesem Tandoor-Space sichtbar'),
      findsOneWidget,
    );
    // No photo: CookLog has no image field.
    expect(find.textContaining('Foto'), findsNothing);
  });

  testWidgets('saves the rating and comment and returns to the recipe', (
    tester,
  ) async {
    await pumpCookLog(tester);
    final fetchesBefore = recipes.fetchCount;
    // What the server answers after saving.
    recipes.recipes[7] = ofenkarotten.copyWith(
      rating: 4,
      lastCooked: DateTime(2026, 11, 14, 19),
    );

    await tap(tester, find.byTooltip('4 Sterne'));
    await tester.enterText(
      find.byType(TextField),
      'Nächstes Mal etwas mehr Honig.',
    );
    await tap(tester, find.text('Speichern'));

    final entry = cookLogs.entries.single;
    expect(entry.recipeId, 7);
    expect(entry.servings, 4);
    expect(entry.rating, 4);
    expect(entry.comment, 'Nächstes Mal etwas mehr Honig.');

    expect(find.byType(CookLogScreen), findsNothing);
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Im Kochprotokoll gespeichert'), findsOneWidget);
    // The recipe was loaded again and shows the new rating and date.
    expect(recipes.fetchCount, greaterThan(fetchesBefore));
    expect(
      find.bySemanticsLabel(
        RegExp(r'4 von 5 Sternen, zuletzt am 14\. Nov\. 2026'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('saves without rating or comment', (tester) async {
    await pumpCookLog(tester);

    await tap(tester, find.text('Speichern'));

    final entry = cookLogs.entries.single;
    expect(entry.rating, isNull);
    expect(entry.comment, isNull);
    expect(entry.servings, 4);
    expect(find.byType(RecipeScreen), findsOneWidget);
  });

  testWidgets('tapping the chosen star again takes the rating back', (
    tester,
  ) async {
    await pumpCookLog(tester);

    await tap(tester, find.byTooltip('3 Sterne'));
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    await tap(tester, find.byTooltip('3 Sterne'));
    expect(find.byIcon(Icons.star_rounded), findsNothing);
    await tap(tester, find.text('Speichern'));

    expect(cookLogs.entries.single.rating, isNull);
  });

  testWidgets('the recipe\'s own servings without ?servings=', (tester) async {
    await pumpCookLog(tester, location: '/recipe/7/cooked');

    expect(find.text('Ofenkarotten mit Feta · 2 Portionen'), findsOneWidget);
    await tap(tester, find.text('Speichern'));
    expect(cookLogs.entries.single.servings, 2);
  });

  testWidgets('a server error is shown and saving can be tried again', (
    tester,
  ) async {
    await pumpCookLog(tester);
    cookLogs.failure = const ServerFailure(statusCode: 500);

    await tap(tester, find.byTooltip('5 Sterne'));
    await tap(tester, find.text('Speichern'));

    expect(find.byType(CookLogScreen), findsOneWidget);
    expect(
      find.text('Nicht gespeichert. Der Server hat einen Fehler gemeldet.'),
      findsOneWidget,
    );
    // The rating is kept for the next try.
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));

    cookLogs.failure = null;
    await tap(tester, find.text('Speichern'));
    expect(cookLogs.entries.single.rating, 5);
    expect(find.byType(RecipeScreen), findsOneWidget);
  });

  testWidgets('can\'t save twice while saving', (tester) async {
    await pumpCookLog(tester);
    final gate = cookLogs.gate = Completer<void>();

    await tester.tap(find.text('Speichern'));
    await tester.pump();
    expect(saveButton(tester).onPressed, isNull);

    gate.complete();
    await tester.pumpAndSettle();
    expect(cookLogs.entries, hasLength(1));
  });

  testWidgets('offline, saving is disabled with an explanation', (
    tester,
  ) async {
    connectivity.isOnline = false;
    await pumpCookLog(tester);

    expect(saveButton(tester).onPressed, isNull);
    expect(
      find.text(
        'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, '
        'geht es weiter.',
      ),
      findsWidgets,
    );

    // Skipping still works, and nothing is queued.
    await tap(tester, find.text('Überspringen'));
    expect(find.byType(RecipeScreen), findsOneWidget);
    connectivity.isOnline = true;
    await tester.pumpAndSettle();
    expect(cookLogs.entries, isEmpty);
  });

  testWidgets('skipping and closing return without saving', (tester) async {
    await pumpCookLog(tester);
    await tap(tester, find.byTooltip('4 Sterne'));
    await tap(tester, find.text('Überspringen'));
    expect(find.byType(RecipeScreen), findsOneWidget);

    await pumpCookLog(tester);
    await tap(tester, find.byTooltip('Schließen, ohne zu speichern'));
    expect(find.byType(RecipeScreen), findsOneWidget);

    expect(cookLogs.entries, isEmpty);
  });

  testWidgets('opened directly, it returns to the recipe', (tester) async {
    await pumpRoutes(
      tester,
      location: '/recipe/7/cooked?servings=4',
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        cookLogRepositoryProvider.overrideWithValue(cookLogs),
      ],
      routes: [
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) => const Text('recipe screen'),
          routes: [
            GoRoute(
              path: 'cooked',
              builder: (context, state) =>
                  const CookLogScreen(recipeId: 7, servings: 4),
            ),
          ],
        ),
      ],
    );

    await tap(tester, find.text('Speichern'));

    expect(find.text('recipe screen'), findsOneWidget);
    expect(cookLogs.entries, hasLength(1));
  });

  testWidgets('a missing recipe is explained', (tester) async {
    recipes.recipes.clear();
    await pumpCookLog(tester);

    expect(find.text('Speichern'), findsNothing);
    expect(find.byTooltip('Schließen, ohne zu speichern'), findsOneWidget);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('mockup 08 in $name', tags: goldenTags, (tester) async {
        await pumpCookLog(tester, theme: theme);
        await tester.tap(find.byTooltip('4 Sterne'));
        await tester.enterText(
          find.byType(TextField),
          'Nächstes Mal etwas mehr Honig.',
        );
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(CookLogScreen),
          matchesGoldenFile('../goldens/cook_log_$name.png'),
        );
      });
    }

    testWidgets('offline in light', tags: goldenTags, (tester) async {
      connectivity.isOnline = false;
      await pumpCookLog(tester, theme: lightTheme);

      await expectLater(
        find.byType(CookLogScreen),
        matchesGoldenFile('../goldens/cook_log_offline_light.png'),
      );
    });
  });
}
