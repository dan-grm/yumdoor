import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/features/search/search_location.dart';
import 'package:yumdoor/features/search/search_providers.dart';
import 'package:yumdoor/features/search/search_screen.dart';

import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository recipes;
  final foods = FakeFoodRepository(const [
    Food(id: 1, name: 'Karotte', pluralName: 'Karotten'),
    Food(id: 2, name: 'Olivenöl'),
    Food(id: 20, name: 'Kartoffel', pluralName: 'Kartoffeln'),
  ]);
  final keywords = FakeKeywordRepository(const [
    Keyword(id: 1, name: 'Vegetarisch'),
    Keyword(id: 2, name: 'Ofen'),
  ]);

  setUp(() => recipes = FakeRecipeRepository([ofenkarotten, longNames]));

  Future<GoRouter> pumpSearch(
    WidgetTester tester, {
    String location = searchPath,
  }) => pumpRoutes(
    tester,
    location: location,
    overrides: [
      recipeRepositoryProvider.overrideWithValue(recipes),
      foodRepositoryProvider.overrideWithValue(foods),
      keywordRepositoryProvider.overrideWithValue(keywords),
    ],
    routes: [
      GoRoute(
        path: searchPath,
        builder: (context, state) =>
            SearchScreen(query: searchQueryFromUri(state.uri)),
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) => Text('recipe ${state.uri}'),
      ),
    ],
  );

  String location(GoRouter router) =>
      router.routerDelegate.currentConfiguration.uri.toString();

  Finder searchField() => find.byType(TextField);

  /// Taps a chip, scrolling the chip row to it first.
  Future<void> tapTooltip(WidgetTester tester, String tooltip) async {
    final chip = find.byTooltip(tooltip);
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
  }

  Future<void> pickFilter(
    WidgetTester tester,
    String opener,
    String pick, {
    String? type,
  }) async {
    await tapTooltip(tester, opener);
    await tester.pumpAndSettle();
    if (type != null) {
      await tester.enterText(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(TextField),
        ),
        type,
      );
      await tester.pump(searchDebounce);
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.descendant(of: find.byType(BottomSheet), matching: find.text(pick)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists all recipes without a query', (tester) async {
    await pumpSearch(tester);

    expect(find.text('Suchen'), findsOneWidget);
    expect(find.text('2 Rezepte'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    expect(find.text('35 Min · 4,5 ￼', findRichText: true), findsOneWidget);
    expect(find.textContaining('Rote-Bete-Carpaccio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('searches once typing pauses and keeps the text in the URL', (
    tester,
  ) async {
    final router = await pumpSearch(tester);

    await tester.enterText(searchField(), 'Ofe');
    await tester.pump(searchDebounce ~/ 2);
    await tester.enterText(searchField(), 'Ofen ');
    await tester.pump(searchDebounce ~/ 2);
    expect(recipes.searches, hasLength(1));

    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(recipes.searches.map((s) => s.query.text), ['', 'Ofen']);
    expect(location(router), '/search?q=Ofen');
    expect(find.text('1 Rezept'), findsOneWidget);
    expect(find.textContaining('Rote-Bete-Carpaccio'), findsNothing);
    // The field keeps what was typed, trailing space included.
    expect(tester.widget<TextField>(searchField()).controller!.text, 'Ofen ');
  });

  testWidgets('a newer search cancels the one in flight', (tester) async {
    await pumpSearch(tester);
    recipes.gate = Completer();

    await tester.enterText(searchField(), 'Ofen');
    await tester.pump(searchDebounce);
    await tester.pump();
    await tester.enterText(searchField(), 'Rote');
    await tester.pump(searchDebounce);
    await tester.pump();

    expect(recipes.searches.map((s) => s.query.text), ['', 'Ofen', 'Rote']);
    expect(recipes.searches[1].cancel!.isCancelled, isTrue);
    expect(recipes.searches[2].cancel!.isCancelled, isFalse);

    recipes.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.textContaining('Rote-Bete-Carpaccio'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsNothing);
  });

  testWidgets('adds a food filter from the picker', (tester) async {
    final router = await pumpSearch(tester);

    await pickFilter(tester, 'Zutat hinzufügen', 'Karotte', type: 'kar');

    expect(foods.queries.last, 'kar');
    expect(location(router), '/search?food=1');
    expect(find.text('1 Rezept'), findsOneWidget);
    // The chip, and the pill on the result that echoes it.
    expect(find.text('enthält Karotten'), findsNWidgets(2));
    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
  });

  testWidgets('a second food narrows the search (AND)', (tester) async {
    final router = await pumpSearch(tester, location: '/search?food=1');

    await pickFilter(tester, 'Zutat hinzufügen', 'Kartoffel', type: 'kar');

    expect(location(router), '/search?food=1&food=20');
    expect(recipes.searches.last.query.foodIds, {1, 20});
    expect(find.text('Keine Rezepte gefunden'), findsOneWidget);
    expect(
      find.text('Probier weniger Filter oder einen anderen Suchtext.'),
      findsOneWidget,
    );
  });

  testWidgets('the picker leaves out filters already chosen', (tester) async {
    await pumpSearch(tester, location: '/search?food=1');

    await tapTooltip(tester, 'Zutat hinzufügen');
    await tester.pumpAndSettle();

    final sheet = find.byType(BottomSheet);
    expect(
      find.descendant(of: sheet, matching: find.text('Karotte')),
      findsNothing,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Olivenöl')),
      findsOneWidget,
    );
  });

  testWidgets('adds a keyword filter', (tester) async {
    final router = await pumpSearch(tester);

    await pickFilter(tester, 'Stichwort hinzufügen', 'Vegetarisch');

    expect(location(router), '/search?keyword=1');
    expect(find.text('Vegetarisch'), findsOneWidget);
    expect(find.text('1 Rezept'), findsOneWidget);
  });

  testWidgets('tapping a chip removes its filter', (tester) async {
    final router = await pumpSearch(
      tester,
      location: '/search?food=1&keyword=1',
    );
    expect(find.text('1 Rezept'), findsOneWidget);

    await tapTooltip(tester, 'enthält Karotten entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search?keyword=1');
    expect(find.text('enthält Karotten'), findsNothing);

    await tapTooltip(tester, 'Vegetarisch entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');
    expect(find.text('2 Rezepte'), findsOneWidget);
  });

  testWidgets('restores text and filters from the URL', (tester) async {
    await pumpSearch(tester, location: '/search?q=Ofen&keyword=1&food=99');

    expect(tester.widget<TextField>(searchField()).controller!.text, 'Ofen');
    expect(find.text('Vegetarisch'), findsOneWidget);
    // Food 99 doesn't exist (any more).
    expect(find.text('Unbekannter Filter'), findsOneWidget);
    expect(recipes.searches.single.query.foodIds, {99});
  });

  testWidgets('loads more results while scrolling', (tester) async {
    recipes = FakeRecipeRepository([
      for (var i = 1; i <= searchPageSize + 5; i++)
        Recipe(id: 100 + i, name: 'Rezept $i'),
    ]);
    await pumpSearch(tester);
    expect(find.text('30 Rezepte'), findsOneWidget);
    expect(recipes.searches.map((s) => s.page), [1]);

    await tester.scrollUntilVisible(
      find.text('Rezept 30'),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();

    expect(recipes.searches.map((s) => s.page), [1, 2]);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('offers to retry a page that failed to load', (tester) async {
    recipes = FakeRecipeRepository([
      for (var i = 1; i <= searchPageSize + 5; i++)
        Recipe(id: 100 + i, name: 'Rezept $i'),
    ]);
    await pumpSearch(tester);
    recipes.failure = const OfflineFailure();

    final retry = find.text('Nochmal versuchen');
    await tester.scrollUntilVisible(
      retry,
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Weitere Rezepte konnten nicht geladen werden.'),
      findsOneWidget,
    );

    recipes.failure = null;
    await tester.tap(retry);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Rezept 30'),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    expect(recipes.searches.map((s) => s.page), [1, 2, 2]);
  });

  testWidgets('says so when there are no recipes at all', (tester) async {
    recipes = FakeRecipeRepository(const []);
    await pumpSearch(tester);

    expect(
      find.text('Auf deinem Tandoor-Server gibt es noch keine Rezepte.'),
      findsOneWidget,
    );
  });

  testWidgets('a failed search explains itself and can be retried', (
    tester,
  ) async {
    recipes.failure = const OfflineFailure();
    await pumpSearch(tester);

    expect(
      find.text(
        'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.',
      ),
      findsOneWidget,
    );

    recipes.failure = null;
    await tester.tap(find.text('Nochmal versuchen'));
    await tester.pumpAndSettle();
    expect(find.text('2 Rezepte'), findsOneWidget);
  });

  testWidgets('a result opens its recipe', (tester) async {
    await pumpSearch(tester, location: '/search?q=Ofen');

    await tester.tap(find.text('Ofenkarotten mit Feta'));
    await tester.pumpAndSettle();

    expect(find.text('recipe /recipe/7'), findsOneWidget);
  });
}
