import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/components/ingredient_row.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/features/editor/editor_screen.dart';
import 'package:yumdoor/features/editor/ingredient_entry.dart';
import 'package:yumdoor/features/editor/ingredient_sheets.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';
import 'package:yumdoor/features/search/search_providers.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_ingredient_parser.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeFoodRepository foods;
  late FakeUnitRepository units;
  late FakeIngredientParser parser;
  late FakeConnectivityService connectivity;

  setUpAll(loadBundledFonts);

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten, longNames]);
    foods = FakeFoodRepository(const [
      Food(id: 1, name: 'Karotte', pluralName: 'Karotten'),
      Food(id: 7, name: 'Karottengrün'),
    ]);
    units = FakeUnitRepository(const [
      Unit(id: 1, name: 'g'),
      Unit(id: 2, name: 'EL'),
    ]);
    parser = FakeIngredientParser({
      '200 g Karotten': const ParsedIngredient(
        originalText: '200 g Karotten',
        food: NamedRef(id: 1, name: 'Karotte'),
        unit: NamedRef(id: 1, name: 'g'),
        amount: 200,
      ),
    });
    connectivity = FakeConnectivityService();
  });

  /// The editor of [recipeId] over its recipe screen, on the Zutaten tab.
  Future<void> pumpTab(
    WidgetTester tester, {
    int recipeId = 7,
    ThemeData? theme,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: '/recipe/$recipeId',
      theme: theme,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        foodRepositoryProvider.overrideWithValue(foods),
        unitRepositoryProvider.overrideWithValue(units),
        ingredientParserProvider.overrideWithValue(parser),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
      routes: [
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
    router.push<void>('/recipe/$recipeId/edit').ignore();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zutaten'));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Finder entryField() =>
      find.widgetWithText(TextField, 'z. B. 200 g Karotten, geschält');

  /// Types [line] into the entry field and presses Enter.
  Future<void> enterLine(WidgetTester tester, String line) async {
    await tester.ensureVisible(entryField());
    await tester.enterText(entryField(), line);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  /// Types [text] into the open picker and waits for its search.
  Future<void> typeInPicker(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField).last, text);
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
  }

  /// The names of the ingredient rows, in order.
  List<String> rowNames(WidgetTester tester) => [
    for (final row in tester.widgetList<IngredientRow>(
      find.byType(IngredientRow),
    ))
      row.name,
  ];

  IngredientRow row(WidgetTester tester, String name) =>
      tester.widget<IngredientRow>(find.widgetWithText(IngredientRow, name));

  Future<void> menu(WidgetTester tester, String name, String action) async {
    await tap(tester, find.byTooltip('Aktionen für $name'));
    await tap(tester, find.text(action));
  }

  testWidgets('groups the ingredients by step, with the base servings', (
    tester,
  ) async {
    await pumpTab(tester);

    expect(find.text('Mengen für 2 Portionen (Grundrezept)'), findsOneWidget);
    expect(find.text('SCHRITT 2'), findsOneWidget);
    expect(find.text('SCHRITT 3 · ANRICHTEN'), findsOneWidget);
    expect(rowNames(tester), [
      'Karotte',
      'Olivenöl',
      'Kreuzkümmel, gemahlen',
      'Salz',
      'Feta',
      'Petersilie',
    ]);
    expect(row(tester, 'Karotte').amount, '300 g');
    expect(row(tester, 'Kreuzkümmel, gemahlen').amount, '½ TL');
    expect(row(tester, 'Salz').amount, '');
  });

  testWidgets('one step with ingredients is a flat list', (tester) async {
    recipes = FakeRecipeRepository([
      ofenkarotten.copyWith(
        steps: [
          for (final step in ofenkarotten.steps)
            if (step.id == 3) step.copyWith(ingredients: []) else step,
        ],
      ),
    ]);
    await pumpTab(tester);

    expect(find.textContaining('SCHRITT'), findsNothing);
    expect(rowNames(tester), hasLength(4));
  });

  testWidgets('adds a line that parses to the last step', (tester) async {
    await pumpTab(tester);

    await enterLine(tester, '200 g Karotten');

    expect(parser.parsed, ['200 g Karotten']);
    expect(find.text('Karotte hinzugefügt'), findsOneWidget);
    expect(rowNames(tester).last, 'Karotte');
    expect(
      tester
          .widgetList<IngredientRow>(
            find.widgetWithText(IngredientRow, 'Karotte'),
          )
          .last
          .amount,
      '200 g',
    );
    // The field is empty and keeps the focus for the next line.
    final field = tester.widget<TextField>(entryField());
    expect(field.controller!.text, isEmpty);
    expect(field.focusNode!.hasFocus, isTrue);
  });

  testWidgets('a new recipe gets its first ingredients', (tester) async {
    recipes = FakeRecipeRepository(const [Recipe(id: 9, name: 'Leer')]);
    await pumpTab(tester, recipeId: 9);

    expect(
      find.text(
        'Noch keine Zutaten. Gib unten eine Zeile ein, z. B. „200 g Karotten“.',
      ),
      findsOneWidget,
    );
    await enterLine(tester, '200 g Karotten');

    expect(rowNames(tester), ['Karotte']);
    expect(find.textContaining('Noch keine Zutaten'), findsNothing);
  });

  testWidgets('a line that does not parse is kept; a food can be picked', (
    tester,
  ) async {
    await pumpTab(tester);

    await enterLine(tester, 'etwas Grünes');

    expect(
      find.text(
        '„etwas Grünes“ nicht erkannt und als Notiz übernommen. '
        'Tipp die Zeile an, um eine Zutat zu wählen.',
      ),
      findsOneWidget,
    );
    expect(rowNames(tester).last, 'etwas Grünes');

    await tap(tester, find.text('etwas Grünes'));
    expect(find.text('Zutat bearbeiten'), findsOneWidget);
    await tap(tester, find.widgetWithText(EditorPickerField, 'Zutat'));
    await typeInPicker(tester, 'karotte');
    await tap(tester, find.text('Karottengrün'));
    await tap(tester, find.text('Übernehmen'));

    expect(rowNames(tester).last, 'Karottengrün');
    expect(row(tester, 'Karottengrün').note, 'etwas Grünes');
    // Picking an existing food creates nothing.
    expect(foods.created, isEmpty);
  });

  testWidgets('a failed parse keeps the line and says why', (tester) async {
    await pumpTab(tester);
    parser.failure = const ServerFailure(statusCode: 500);

    await enterLine(tester, '200 g Karotten');

    expect(
      find.text('Nicht hinzugefügt. Der Server hat einen Fehler gemeldet.'),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(entryField()).controller!.text,
      '200 g Karotten',
    );
    expect(rowNames(tester), hasLength(6));
  });

  testWidgets('edits amount and unit; creates a new unit', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text('Salz'));
    // "Ohne Menge" is on; turning it off allows an amount.
    await tap(tester, find.text('Ohne Menge'));
    final amount = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(amount.first, 'viel');
    await tap(tester, find.text('Übernehmen'));
    expect(find.text('Eine Zahl wie 1,5 oder ½.'), findsOneWidget);

    await tester.enterText(amount.first, '1,5');
    await tap(tester, find.widgetWithText(EditorPickerField, 'Einheit'));
    await typeInPicker(tester, 'Prise');
    await tap(tester, find.text('„Prise“ anlegen'));
    expect(units.created, ['Prise']);
    await tap(tester, find.text('Übernehmen'));

    expect(row(tester, 'Salz').amount, '1½ Prise');
  });

  testWidgets('moves and deletes rows with their menu', (tester) async {
    await pumpTab(tester);

    await menu(tester, 'Olivenöl', 'Nach oben');
    expect(rowNames(tester).take(2), ['Olivenöl', 'Karotte']);

    await menu(tester, 'Olivenöl', 'Nach unten');
    expect(rowNames(tester).take(2), ['Karotte', 'Olivenöl']);

    await menu(tester, 'Karotte', 'Löschen');
    expect(rowNames(tester).first, 'Olivenöl');
    expect(rowNames(tester), hasLength(5));
  });

  testWidgets('the first row cannot move up', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.byTooltip('Aktionen für Karotte'));

    final up = tester.widget<PopupMenuItem<Object?>>(
      find.ancestor(
        of: find.text('Nach oben'),
        matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
      ),
    );
    expect(up.enabled, isFalse);
  });

  testWidgets('adds a section header', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text('Abschnitt hinzufügen'));
    await tester.enterText(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      ),
      'Zum Servieren',
    );
    await tester.pump();
    await tap(tester, find.text('Übernehmen'));

    expect(find.text('Zum Servieren'), findsOneWidget);
    expect(find.byTooltip('Aktionen für Zum Servieren'), findsOneWidget);
  });

  testWidgets('saves the ingredients with the recipe', (tester) async {
    await pumpTab(tester);

    await enterLine(tester, '200 g Karotten');
    await menu(tester, 'Feta', 'Löschen');
    await tap(tester, find.text('Speichern'));

    final steps = recipes.saves.single.draft.steps;
    expect(
      [for (final i in steps[2].ingredients) i.food?.name],
      ['Petersilie', 'Karotte'],
    );
    expect(steps[2].ingredients.last.amount, 200);
    expect(steps[1], RecipeDraft.fromRecipe(ofenkarotten).steps[1]);
    expect(find.byType(RecipeScreen), findsOneWidget);
  });

  testWidgets('offline, lines cannot be added', (tester) async {
    await pumpTab(tester);
    connectivity.isOnline = false;
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(entryField()).enabled, isFalse);
    expect(
      tester
          .widget<IconButton>(
            find.descendant(
              of: find.byType(IngredientEntry),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('long German names fit at phone width', (tester) async {
    await pumpTab(tester, recipeId: 8);

    expect(find.text('Für den Walnusskrokant mit Ahornsirup'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('Zutaten in $name', tags: goldenTags, (tester) async {
        await pumpTab(tester, recipeId: 8, theme: theme);

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_ingredients_$name.png'),
        );
      });

      testWidgets('Zutat bearbeiten in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpTab(tester, theme: theme);
        await tap(tester, find.text('Salz'));

        // The sheet is above the screen, in the app's overlay.
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/editor_ingredient_sheet_$name.png'),
        );
      });
    }
  });
}
