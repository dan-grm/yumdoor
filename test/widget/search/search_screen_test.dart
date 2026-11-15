import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_book.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/features/search/search_location.dart';
import 'package:yumdoor/features/search/search_providers.dart';
import 'package:yumdoor/features/search/search_screen.dart';

import '../../fakes/fake_book_user_repositories.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
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

  late FakeBookRepository books;
  late FakeUserRepository users;

  setUpAll(loadBundledFonts);

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten, longNames]);
    books = FakeBookRepository(const [
      RecipeBook(id: 4, name: 'Unsere Lieblingsrezepte'),
      RecipeBook(id: 7, name: 'Backen'),
    ]);
    users = FakeUserRepository(const [
      UserRef(id: 1, name: 'Admin'),
      UserRef(id: 2, name: 'Anna'),
    ]);
  });

  Future<GoRouter> pumpSearch(
    WidgetTester tester, {
    String location = searchPath,
    ThemeData? theme,
    FakeKeywordRepository? keywordRepository,
    FakeConnectivityService? connectivity,
  }) => pumpRoutes(
    tester,
    location: location,
    theme: theme,
    overrides: [
      recipeRepositoryProvider.overrideWithValue(recipes),
      foodRepositoryProvider.overrideWithValue(foods),
      keywordRepositoryProvider.overrideWithValue(
        keywordRepository ?? keywords,
      ),
      bookRepositoryProvider.overrideWithValue(books),
      userRepositoryProvider.overrideWithValue(users),
      if (connectivity != null)
        connectivityServiceProvider.overrideWithValue(connectivity),
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

  /// The searches by name (or without text), leaving out the food and
  /// keyword searches of the universal search.
  List<SearchCall> nameSearches() => [
    for (final search in recipes.searches)
      if (search.query.anyFoodIds.isEmpty && search.query.anyKeywordIds.isEmpty)
        search,
  ];

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

    expect(nameSearches().map((s) => s.query.text), ['', 'Ofen']);
    expect(location(router), '/search?q=Ofen');
    expect(find.text('1 Rezept'), findsOneWidget);
    expect(find.textContaining('Rote-Bete-Carpaccio'), findsNothing);
    // The field keeps what was typed, trailing space included.
    expect(tester.widget<TextField>(searchField()).controller!.text, 'Ofen ');
  });

  testWidgets('finds recipes by ingredient and keyword and says why', (
    tester,
  ) async {
    await pumpSearch(tester, location: '/search?q=Oliven%C3%B6l');

    expect(find.text('1 Rezept'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    expect(find.text('enthält Olivenöl'), findsOneWidget);

    await tester.enterText(searchField(), 'vegetarisch');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();

    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    expect(find.text('Stichwort: Vegetarisch'), findsOneWidget);
    expect(find.textContaining('enthält'), findsNothing);
  });

  testWidgets('lists food alternatives and echoes a filter once', (
    tester,
  ) async {
    recipes = FakeRecipeRepository([
      const Recipe(
        id: 40,
        name: 'Gratin',
        steps: [
          RecipeStep(
            id: 1,
            ingredients: [
              Ingredient(id: 1, food: Food(id: 1, name: 'Karotte')),
              Ingredient(id: 2, food: Food(id: 20, name: 'Kartoffel')),
            ],
          ),
        ],
      ),
    ]);

    // Server results don't say which of the matching foods a recipe has.
    await pumpSearch(tester, location: '/search?q=kar');
    expect(find.text('enthält Karotten oder Kartoffeln'), findsOneWidget);

    // The food filter is one of the matching foods: named once.
    await pumpSearch(tester, location: '/search?q=Karotte&food=1');
    expect(find.text('enthält Karotten'), findsNWidgets(2)); // chip and pill
  });

  testWidgets('a name match needs no reason', (tester) async {
    await pumpSearch(tester, location: '/search?q=Ofen');

    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    // It also has the keyword "Ofen", but the name says enough.
    expect(find.text('Stichwort: Ofen'), findsNothing);
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

    final searches = nameSearches();
    expect(searches.map((s) => s.query.text), ['', 'Ofen', 'Rote']);
    expect(searches[1].cancel!.isCancelled, isTrue);
    expect(searches[2].cancel!.isCancelled, isFalse);

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

  testWidgets('adds and removes the rating filter', (tester) async {
    final router = await pumpSearch(tester);

    await tapTooltip(tester, 'Nach Bewertung filtern');
    await tester.pumpAndSettle();
    expect(
      find.text('Zählt nur deine eigenen Kochprotokolle.'),
      findsOneWidget,
    );
    await tester.tap(find.text('ab 4 Sternen'));
    await tester.pumpAndSettle();

    expect(location(router), '/search?rating=4');
    expect(recipes.searches.last.query.minRating, 4);
    expect(find.text('Von dir bewertet: ab 4 Sternen'), findsOneWidget);

    await tapTooltip(tester, 'Von dir bewertet: ab 4 Sternen entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');
    expect(find.text('Bewertung'), findsOneWidget);
  });

  testWidgets('adds and removes the last cooked filter', (tester) async {
    final router = await pumpSearch(tester);

    await tapTooltip(tester, 'Nach letztem Kochen filtern');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nicht seit 2 Wochen'));
    await tester.pumpAndSettle();

    final day = recipes.searches.last.query.lastCookedBefore!;
    final today = DateTime.now();
    expect(
      DateTime(today.year, today.month, today.day).difference(day).inDays,
      inInclusiveRange(13, 14),
    );
    expect(location(router), startsWith('/search?cooked_before='));
    expect(find.textContaining('Von dir zuletzt gekocht bis'), findsOneWidget);

    final chip = find.textContaining('Von dir zuletzt gekocht bis');
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(location(router), '/search');
    expect(recipes.searches.last.query.lastCookedBefore, isNull);
  });

  testWidgets('adds and removes the times cooked filters', (tester) async {
    final router = await pumpSearch(tester);

    await tapTooltip(tester, 'Nach Kochhäufigkeit filtern');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nie gekocht'));
    await tester.pumpAndSettle();
    expect(location(router), '/search?never=1');
    expect(recipes.searches.last.query.neverCooked, isTrue);
    expect(find.text('Von dir nie gekocht'), findsOneWidget);

    await tapTooltip(tester, 'Von dir nie gekocht entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');

    await tapTooltip(tester, 'Nach Kochhäufigkeit filtern');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oft gekocht (mind. 5-mal)'));
    await tester.pumpAndSettle();
    expect(location(router), '/search?times_min=5');
    expect(recipes.searches.last.query.minTimesCooked, 5);

    await tapTooltip(tester, 'Von dir mind. 5-mal gekocht entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');
  });

  testWidgets('says offline results can not count how often', (tester) async {
    recipes.fromCache = true;
    await pumpSearch(tester, location: '/search?times_min=5');

    expect(
      find.textContaining('Offline lässt sich nicht zählen'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('adds and removes the cookable filters', (tester) async {
    final router = await pumpSearch(tester);

    await tapTooltip(tester, 'Nach Vorrat filtern');
    await tester.pumpAndSettle();
    expect(find.textContaining('in deinem Haushalt vorrätig'), findsOneWidget);
    await tester.tap(find.text('Jetzt kochbar'));
    await tester.pumpAndSettle();
    expect(location(router), '/search?missing=0');
    expect(recipes.searches.last.query.maxMissingFoods, 0);

    await tapTooltip(tester, 'Jetzt kochbar entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');
    expect(recipes.searches.last.query.maxMissingFoods, isNull);

    await tapTooltip(tester, 'Nach Vorrat filtern');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Höchstens 1 Zutat fehlt'));
    await tester.pumpAndSettle();
    expect(location(router), '/search?missing=1');
    expect(recipes.searches.last.query.maxMissingFoods, 1);

    await tapTooltip(tester, 'Höchstens 1 Zutat fehlt entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');
  });

  testWidgets('adds books, leaving out those already chosen', (tester) async {
    final router = await pumpSearch(tester);

    await pickFilter(tester, 'Nach Kochbuch filtern', 'Backen');
    expect(location(router), '/search?book=7');
    expect(recipes.searches.last.query.bookIds, {7});
    expect(find.text('Buch: Backen'), findsOneWidget);

    await tapTooltip(tester, 'Nach Kochbuch filtern');
    await tester.pumpAndSettle();
    final sheet = find.byType(BottomSheet);
    expect(
      find.descendant(of: sheet, matching: find.text('Backen')),
      findsNothing,
    );
    await tester.tap(
      find.descendant(
        of: sheet,
        matching: find.text('Unsere Lieblingsrezepte'),
      ),
    );
    await tester.pumpAndSettle();
    expect(location(router), '/search?book=7&book=4');
    expect(recipes.searches.last.query.bookIds, {4, 7});

    await tapTooltip(tester, 'Buch: Backen entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search?book=4');
  });

  testWidgets('the book sheet says when there are no books', (tester) async {
    books = FakeBookRepository();
    // A link with a book that isn't (any longer) the user's.
    await pumpSearch(tester, location: '/search?book=4');

    await tapTooltip(tester, 'Nach Kochbuch filtern');
    await tester.pumpAndSettle();

    expect(find.text('Du hast noch keine Kochbücher.'), findsOneWidget);
  });

  testWidgets('the book sheet offers to retry a failed load', (tester) async {
    books.failure = const OfflineFailure();
    await pumpSearch(tester);

    await tapTooltip(tester, 'Nach Kochbuch filtern');
    await tester.pumpAndSettle();
    books.failure = null;
    await tester.tap(find.text('Nochmal versuchen'));
    await tester.pumpAndSettle();

    expect(find.text('Backen'), findsOneWidget);
  });

  testWidgets('says when every book is chosen already', (tester) async {
    await pumpSearch(tester, location: '/search?book=4&book=7');

    await tapTooltip(tester, 'Nach Kochbuch filtern');
    await tester.pumpAndSettle();

    expect(
      find.text('Alle deine Bücher sind schon ausgewählt.'),
      findsOneWidget,
    );
  });

  testWidgets('names book and creator chips once back online', (tester) async {
    final connectivity = FakeConnectivityService(isOnline: false);
    books.failure = const OfflineFailure();
    users.failure = const OfflineFailure();
    await pumpSearch(
      tester,
      location: '/search?book=4&created_by=2',
      connectivity: connectivity,
    );
    expect(find.text('Unbekannter Filter'), findsNWidgets(2));

    books.failure = null;
    users.failure = null;
    connectivity.isOnline = true;
    await tester.pumpAndSettle();

    expect(find.text('Buch: Unsere Lieblingsrezepte'), findsOneWidget);
    expect(find.text('Erstellt von Anna'), findsOneWidget);
  });

  testWidgets('adds and removes the creator filter', (tester) async {
    final router = await pumpSearch(tester);

    await pickFilter(tester, 'Nach Ersteller filtern', 'Anna');
    expect(location(router), '/search?created_by=2');
    expect(recipes.searches.last.query.createdBy, 2);
    expect(find.text('Erstellt von Anna'), findsOneWidget);
    // One creator at a time.
    expect(find.byTooltip('Nach Ersteller filtern'), findsNothing);

    await tapTooltip(tester, 'Erstellt von Anna entfernen');
    await tester.pumpAndSettle();
    expect(location(router), '/search');
    expect(find.byTooltip('Nach Ersteller filtern'), findsOneWidget);
  });

  testWidgets('restores book and creator chips from the URL', (tester) async {
    await pumpSearch(
      tester,
      location: '/search?missing=1&book=4&book=99&created_by=2',
    );

    expect(find.text('Höchstens 1 Zutat fehlt'), findsOneWidget);
    expect(find.text('Buch: Unsere Lieblingsrezepte'), findsOneWidget);
    // Book 99 doesn't exist (any more), or isn't shared with the user.
    expect(find.text('Unbekannter Filter'), findsOneWidget);
    expect(find.text('Erstellt von Anna'), findsOneWidget);
    expect(nameSearches().single.query.bookIds, {4, 99});
    // Filters that are set come before the "+" chips.
    expect(
      tester.getTopLeft(find.text('Erstellt von Anna')).dx,
      lessThan(tester.getTopLeft(find.byTooltip('Zutat hinzufügen')).dx),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('explains the offline cookable and book filters', (tester) async {
    recipes.fromCache = true;
    await pumpSearch(tester, location: '/search?missing=0');
    expect(
      find.textContaining('Offline zählt der Vorrat vom letzten Öffnen'),
      findsOneWidget,
    );

    recipes = FakeRecipeRepository(const [])..fromCache = true;
    await pumpSearch(tester, location: '/search?book=4&missing=0');
    expect(
      find.textContaining('Offline zählt der Vorrat vom letzten Öffnen'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Offline ist nicht bekannt, welche Rezepte in einem Buch stehen.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('restores text and filters from the URL', (tester) async {
    await pumpSearch(tester, location: '/search?q=Ofen&keyword=1&food=99');

    expect(tester.widget<TextField>(searchField()).controller!.text, 'Ofen');
    expect(find.text('Vegetarisch'), findsOneWidget);
    // Food 99 doesn't exist (any more).
    expect(find.text('Unbekannter Filter'), findsOneWidget);
    expect(nameSearches().single.query.foodIds, {99});
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

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('match reasons in $name', tags: goldenTags, (tester) async {
        const karotte = Food(id: 1, name: 'Karotte', pluralName: 'Karotten');
        Recipe withCarrots(int id, String name) => Recipe(
          id: id,
          name: name,
          workingTime: const Duration(minutes: 45),
          steps: const [
            RecipeStep(id: 1, ingredients: [Ingredient(id: 1, food: karotte)]),
          ],
        );
        recipes = FakeRecipeRepository([
          ofenkarotten,
          withCarrots(30, 'Linsen-Bolognese'),
          withCarrots(31, 'Gemüsepfanne mit Reis'),
          const Recipe(
            id: 32,
            name: 'Apfel-Möhren-Rohkost',
            keywords: [Keyword(id: 5, name: 'Karottenzeit')],
          ),
        ]);
        await pumpSearch(
          tester,
          location: '/search?q=Karotte',
          theme: theme,
          keywordRepository: FakeKeywordRepository(const [
            Keyword(id: 5, name: 'Karottenzeit'),
          ]),
        );

        await expectLater(
          find.byType(SearchScreen),
          matchesGoldenFile('../goldens/search_reasons_$name.png'),
        );
      });

      testWidgets(
        'cookable, book and creator filters in $name',
        tags: goldenTags,
        (tester) async {
          books = FakeBookRepository(const [
            RecipeBook(id: 4, name: 'Unsere Lieblingsrezepte'),
            RecipeBook(id: 7, name: 'Backen'),
            RecipeBook(id: 8, name: 'Schnelle Feierabendküche'),
          ]);
          await pumpSearch(
            tester,
            location: '/search?missing=1&book=4&created_by=2',
            theme: theme,
          );
          await tapTooltip(tester, 'Nach Kochbuch filtern');
          await tester.pumpAndSettle();
          // Back to the start of the chip row, where the set filters are.
          tester
              .state<ScrollableState>(
                find
                    .ancestor(
                      of: find.text('Erstellt von Anna'),
                      matching: find.byType(Scrollable),
                    )
                    .first,
              )
              .position
              .jumpTo(0);
          await tester.pumpAndSettle();

          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('../goldens/search_space_filters_$name.png'),
          );
        },
      );
    }
  });
}
