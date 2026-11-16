import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/features/editor/editor_field.dart';
import 'package:yumdoor/features/editor/editor_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';
import 'package:yumdoor/features/search/search_providers.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeKeywordRepository keywords;
  late FakeConnectivityService connectivity;

  setUpAll(loadBundledFonts);

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    keywords = FakeKeywordRepository(const [
      Keyword(id: 1, name: 'Vegetarisch'),
      Keyword(id: 2, name: 'Ofen'),
      Keyword(id: 3, name: 'Schnell'),
    ]);
    connectivity = FakeConnectivityService();
  });

  /// [location] pushed over [below], like the app does.
  Future<GoRouter> pumpEditor(
    WidgetTester tester, {
    String below = '/recipe/7',
    String location = '/recipe/7/edit',
    ThemeData? theme,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: below,
      theme: theme,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        keywordRepositoryProvider.overrideWithValue(keywords),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => const Text('search'),
        ),
        GoRoute(
          path: newRecipeLocation,
          builder: (context, state) => const EditorScreen(),
        ),
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) =>
              RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => EditorScreen(
                recipeId: int.parse(state.pathParameters['id']!),
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

  Finder field(String label) => find.descendant(
    of: find.widgetWithText(EditorField, label),
    matching: find.byType(TextField),
  );

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Types [text] into the open keyword picker and waits for its search.
  Future<void> typeInPicker(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField).last, text);
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
  }

  TextButton saveButton(WidgetTester tester) => tester.widget<TextButton>(
    find.ancestor(
      of: find.text('Speichern'),
      matching: find.byType(TextButton),
    ),
  );

  testWidgets('shows the recipe in the Allgemein tab', (tester) async {
    await pumpEditor(tester);

    expect(find.text('Abbrechen'), findsOneWidget);
    expect(find.text('Bearbeiten'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsNWidgets(2));
    expect(find.text('Allgemein'), findsOneWidget);
    expect(find.text('Zutaten'), findsOneWidget);
    expect(find.text('Schritte'), findsOneWidget);
    expect(find.text('Süß, salzig und *knusprig*.'), findsOneWidget);
    expect(find.text('Vegetarisch'), findsOneWidget);
    expect(find.text('Ofen'), findsOneWidget);
    expect(tester.widget<TextField>(field('Portionen')).controller!.text, '2');
    expect(
      tester.widget<TextField>(field('Arbeitszeit (Min.)')).controller!.text,
      '15',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('edits name and keywords, saves and shows the saved recipe', (
    tester,
  ) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofenkarotten mit Ziegenkäse');
    // Remove "Ofen", add an existing keyword and a new one.
    await tap(tester, find.byTooltip('Ofen entfernen'));
    await tap(tester, find.byTooltip('Stichwort hinzufügen'));
    // Keywords the recipe has aren't offered again.
    Finder inSheet(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );
    expect(inSheet('Schnell'), findsOneWidget);
    expect(inSheet('Vegetarisch'), findsNothing);
    await typeInPicker(tester, 'Schn');
    // Only offered for a name that doesn't exist yet.
    expect(find.text('„Schn“ anlegen'), findsOneWidget);
    await typeInPicker(tester, 'schnell');
    expect(find.text('„schnell“ anlegen'), findsNothing);
    await tap(tester, find.text('Schnell'));
    await tap(tester, find.byTooltip('Stichwort hinzufügen'));
    await typeInPicker(tester, 'Ofengericht');
    await tap(tester, find.text('„Ofengericht“ anlegen'));
    expect(keywords.created, ['Ofengericht']);

    await tap(tester, find.text('Speichern'));

    final save = recipes.saves.single;
    expect(save.id, 7);
    expect(save.draft.name, 'Ofenkarotten mit Ziegenkäse');
    expect(save.draft.keywords, const [
      NamedRef(id: 1, name: 'Vegetarisch'),
      NamedRef(id: 3, name: 'Schnell'),
      NamedRef(id: 4, name: 'Ofengericht'),
    ]);
    // Steps stay as they were.
    expect(save.draft.steps, RecipeDraft.fromRecipe(ofenkarotten).steps);

    expect(find.byType(EditorScreen), findsNothing);
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Rezept gespeichert'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Ziegenkäse'), findsOneWidget);
    expect(find.text('Ofengericht'), findsOneWidget);
  });

  testWidgets('creates a new recipe from search', (tester) async {
    final router = await pumpEditor(
      tester,
      below: '/search',
      location: newRecipeLocation,
    );

    expect(find.text('Neues Rezept'), findsOneWidget);
    await tester.enterText(field('Name'), 'Linsensuppe');
    await tester.enterText(field('Portionen'), '4');
    await tester.enterText(field('Wartezeit (Min.)'), '30');
    await tap(tester, find.text('Speichern'));

    final save = recipes.saves.single;
    expect(save.id, isNull);
    expect(save.draft.name, 'Linsensuppe');
    expect(save.draft.servings, 4);
    expect(save.draft.waitingTime, const Duration(minutes: 30));
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Linsensuppe'), findsOneWidget);
    // The recipe took the editor's place: back leads to search.
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('search'), findsOneWidget);
  });

  testWidgets('the name is required', (tester) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), '  ');
    await tester.enterText(field('Portionen'), '');
    await tap(tester, find.text('Speichern'));

    expect(recipes.saves, isEmpty);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(find.text('Gib dem Rezept einen Namen.'), findsOneWidget);
    expect(find.text('Mindestens 1.'), findsOneWidget);
    expect(find.text('Bitte prüf die markierten Felder.'), findsOneWidget);

    // Fixing it clears the error at once.
    await tester.enterText(field('Name'), 'Karotten');
    await tester.pump();
    expect(find.text('Gib dem Rezept einen Namen.'), findsNothing);
  });

  testWidgets('a failed save keeps the edits and can be retried', (
    tester,
  ) async {
    await pumpEditor(tester);
    recipes.failure = const ServerFailure(statusCode: 500);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Speichern'));

    expect(
      find.text('Nicht gespeichert. Der Server hat einen Fehler gemeldet.'),
      findsOneWidget,
    );
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(find.text('Ofengemüse'), findsOneWidget);

    recipes.failure = null;
    await tap(tester, find.text('Nochmal versuchen'));

    expect(recipes.saves, hasLength(2));
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Ofengemüse'), findsOneWidget);
  });

  testWidgets('no permission (403) says so and keeps the edits', (
    tester,
  ) async {
    await pumpEditor(tester);
    recipes.failure = const UnauthorizedFailure();

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Speichern'));

    expect(
      find.text(
        'Nicht gespeichert: Du darfst dieses Rezept nicht ändern. '
        'Deine Änderungen sind noch da.',
      ),
      findsOneWidget,
    );
    // Asking again won't help.
    expect(find.text('Nochmal versuchen'), findsNothing);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Ofengemüse',
    );
  });

  testWidgets('offline, the editor does not open a cached copy', (
    tester,
  ) async {
    connectivity.isOnline = false;
    await pumpEditor(tester);

    expect(
      find.text(
        'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.',
      ),
      findsOneWidget,
    );
    expect(find.byType(EditorField), findsNothing);
    expect(saveButton(tester).onPressed, isNull);
  });

  testWidgets('going offline disables saving and explains it', (tester) async {
    await pumpEditor(tester);
    connectivity.isOnline = false;
    await tester.pumpAndSettle();

    expect(saveButton(tester).onPressed, isNull);
    expect(
      find.byTooltip(
        'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, '
        'geht es weiter.',
      ),
      findsOneWidget,
    );
    await tester.enterText(field('Name'), 'Ofengemüse');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();
    expect(recipes.saves, isEmpty);
  });

  testWidgets('Abbrechen returns without saving', (tester) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Abbrechen'));

    expect(recipes.saves, isEmpty);
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
  });

  testWidgets('the other tabs keep the draft', (tester) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Schritte'));
    expect(find.byType(EditorField), findsNothing);
    await tap(tester, find.text('Allgemein'));

    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Ofengemüse',
    );
  });

  testWidgets('a missing recipe explains itself', (tester) async {
    await pumpEditor(tester, location: '/recipe/99/edit');

    expect(find.text('Dieses Rezept gibt es nicht mehr.'), findsOneWidget);
    expect(saveButton(tester).onPressed, isNull);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('Allgemein in $name', tags: goldenTags, (tester) async {
        await pumpEditor(tester, theme: theme);

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_general_$name.png'),
        );
      });
    }
  });
}
