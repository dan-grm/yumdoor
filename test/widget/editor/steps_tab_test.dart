import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/features/editor/editor_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';

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
    ]);
    units = FakeUnitRepository(const [Unit(id: 1, name: 'g')]);
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

  /// The editor of [recipeId] over its recipe screen, on the Schritte tab.
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
    await tester.tap(find.text('Schritte'));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  const step1 = 'Den Ofen auf 200 °C vorheizen.';

  Finder instructionField(String start) => find.byWidgetPredicate(
    (w) =>
        w is TextField &&
        w.maxLines != 1 &&
        (w.controller?.text.startsWith(start) ?? false),
  );

  Finder nameField() => find.byWidgetPredicate(
    (w) =>
        w is TextField &&
        w.maxLines == 1 &&
        w.decoration?.hintText == null &&
        w.controller?.text == '',
  );

  Finder durationField() => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.hintText == '0',
  );

  Future<void> save(WidgetTester tester) async {
    await tap(tester, find.text('Speichern'));
  }

  RecipeDraft saved() => recipes.saves.single.draft;

  testWidgets('shows collapsed cards with the start of the instruction', (
    tester,
  ) async {
    await pumpTab(tester);

    expect(find.text('1'), findsOneWidget);
    expect(find.text(step1), findsOneWidget);
    expect(find.text('Schritt hinzufügen'), findsOneWidget);
    // Nothing is open.
    expect(find.text('Anleitung'), findsNothing);
  });

  testWidgets('expands and collapses a card', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    expect(find.text('Anleitung'), findsOneWidget);
    expect(find.text('Zutaten in diesem Schritt'), findsOneWidget);
    expect(find.text('Mengen für 2 Portionen (Grundrezept)'), findsOneWidget);
    expect(find.text('wird als Timer angeboten'), findsOneWidget);

    await tap(tester, find.text('Schritt 1'));
    expect(find.text('Anleitung'), findsNothing);
  });

  testWidgets('edits the instruction, the name and the duration', (
    tester,
  ) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    await tester.enterText(instructionField(step1), 'Ofen vorheizen.');
    await tester.enterText(nameField(), 'Ofen');
    await tester.enterText(durationField(), '25');
    await tester.pumpAndSettle();
    await save(tester);

    final step = saved().steps[0];
    expect(step.instruction, 'Ofen vorheizen.');
    expect(step.name, 'Ofen');
    expect(step.time, const Duration(minutes: 25));
    expect(saved().steps[1].id, 2);
  });

  testWidgets('the duration takes only digits', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    await tester.enterText(durationField(), '1a2,5');
    await tester.pumpAndSettle();
    await save(tester);

    expect(saved().steps[0].time, const Duration(minutes: 125));
  });

  testWidgets('keeps an opened card and its text when another one moves', (
    tester,
  ) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    await tester.enterText(instructionField(step1), 'Ofen vorheizen.');
    await tap(tester, find.byTooltip('Aktionen für Schritt 1'));
    await tap(tester, find.text('Nach unten'));

    // It is step 2 now, still open, with its text.
    expect(find.text('Schritt 2'), findsOneWidget);
    expect(instructionField('Ofen vorheizen.'), findsOneWidget);
  });

  testWidgets('moves a step with its menu', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    await tap(tester, find.byTooltip('Aktionen für Schritt 1'));
    await tap(tester, find.text('Nach unten'));
    await save(tester);

    expect(saved().steps.map((s) => s.id), [2, 1, 3]);
  });

  testWidgets('the menu cannot move the first step up or the last down', (
    tester,
  ) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    await tap(tester, find.byTooltip('Aktionen für Schritt 1'));

    final up = tester.widget(
      find.ancestor(
        of: find.text('Nach oben'),
        matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
      ),
    ) as PopupMenuItem;
    expect(up.enabled, isFalse);
  });

  testWidgets('reorders by dragging the handle', (tester) async {
    await pumpTab(tester);

    final handle = find.byTooltip('Schritt 1 verschieben');
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump();
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    await save(tester);

    expect(saved().steps.first.id, isNot(1));
    expect(saved().steps.map((s) => s.id), unorderedEquals([1, 2, 3]));
    expect(saved().steps.indexWhere((s) => s.id == 1), greaterThan(0));
  });

  testWidgets('removes an ingredient chip from the step', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.textContaining('Karotten **schräg**'));
    expect(find.text('Karotte · 300 g'), findsOneWidget);
    expect(find.text('Olivenöl · 1 EL'), findsOneWidget);
    await tap(tester, find.byTooltip('Karotte aus diesem Schritt entfernen'));
    expect(find.text('Karotte · 300 g'), findsNothing);
    await save(tester);

    expect(saved().steps[1].ingredients.map((i) => i.id), [2, 3, 4]);
  });

  testWidgets('moves an ingredient chip to another step', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.textContaining('Karotten **schräg**'));
    await tap(
      tester,
      find.byTooltip('Karotte in einen anderen Schritt verschieben'),
    );
    await tap(tester, find.text('Nach Schritt 1'));
    await save(tester);

    expect(saved().steps[0].ingredients.map((i) => i.id), [1]);
    expect(saved().steps[1].ingredients.map((i) => i.id), [2, 3, 4]);
  });

  testWidgets('adds an ingredient to the step with "+ Zutat"', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text(step1));
    await tap(tester, find.byTooltip('Zutat zu Schritt 1 hinzufügen'));
    await tester.enterText(
      find.widgetWithText(TextField, 'z. B. 200 g Karotten, geschält'),
      '200 g Karotten',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tap(tester, find.text('Fertig'));

    expect(find.text('Karotte · 200 g'), findsOneWidget);
    await save(tester);

    expect(saved().steps[0].ingredients.single.food?.id, 1);
    expect(saved().steps[2].ingredients, hasLength(2));
  });

  testWidgets('"+ Zutat" is disabled offline', (tester) async {
    connectivity.isOnline = false;
    await pumpTab(tester);

    await tap(tester, find.text(step1));

    expect(find.byTooltip('Zutat zu Schritt 1 hinzufügen'), findsOneWidget);
    await tester.tap(find.byTooltip('Zutat zu Schritt 1 hinzufügen'));
    await tester.pumpAndSettle();
    expect(find.text('Fertig'), findsNothing);
  });

  testWidgets('adds a step and opens it', (tester) async {
    await pumpTab(tester);

    await tap(tester, find.text('Schritt hinzufügen'));

    expect(find.text('Schritt 4'), findsOneWidget);
    await tester.enterText(instructionField(''), 'Servieren.');
    await save(tester);

    expect(saved().steps, hasLength(4));
    expect(saved().steps.last.id, isNull);
    expect(saved().steps.last.instruction, 'Servieren.');
  });

  testWidgets('deletes an empty step without asking', (tester) async {
    await pumpTab(tester);
    await tap(tester, find.text('Schritt hinzufügen'));

    await tap(tester, find.byTooltip('Schritt löschen'));

    expect(find.text('Schritt 4'), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('asks before deleting a step with ingredients', (tester) async {
    await pumpTab(tester);
    await tap(tester, find.textContaining('Karotten **schräg**'));

    await tap(tester, find.byTooltip('Schritt löschen'));
    expect(find.text('Schritt 2 löschen?'), findsOneWidget);
    expect(
      find.text('Der Text und die 4 Zutaten dieses Schritts werden gelöscht.'),
      findsOneWidget,
    );

    await tap(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Abbrechen'),
      ),
    );
    expect(find.text('Schritt 2'), findsOneWidget);

    await tap(tester, find.byTooltip('Schritt löschen'));
    await tap(tester, find.widgetWithText(TextButton, 'Schritt löschen'));
    await save(tester);

    expect(saved().steps.map((s) => s.id), [1, 3]);
  });

  testWidgets('asks before deleting a step with only text', (tester) async {
    await pumpTab(tester);
    await tap(tester, find.text(step1));

    await tap(tester, find.byTooltip('Schritt löschen'));

    expect(
      find.text('Der Text und die Zutat dieses Schritts werden gelöscht.'),
      findsNothing,
    );
    expect(
      find.text('Der Text dieses Schritts wird gelöscht.'),
      findsOneWidget,
    );
  });

  testWidgets('warns when removing an ingredient changes a template', (
    tester,
  ) async {
    recipes = FakeRecipeRepository([
      ofenkarotten.copyWith(
        steps: [
          for (final step in ofenkarotten.steps)
            if (step.id == 2)
              step.copyWith(instruction: 'Erst {{ ingredients[1] }} dazu.')
            else
              step,
        ],
      ),
    ]);
    await pumpTab(tester);
    await tap(tester, find.textContaining('Erst'));

    // Removing the last one doesn't change what [1] shows.
    await tap(tester, find.byTooltip('Salz aus diesem Schritt entfernen'));
    expect(find.textContaining('nach ihrer Position'), findsNothing);

    await tap(tester, find.byTooltip('Karotte aus diesem Schritt entfernen'));
    expect(
      find.text(
        'Der Text von Schritt 2 verweist auf Zutaten nach ihrer Position '
        '(ingredients[0]). Prüfe, ob er noch passt.',
      ),
      findsOneWidget,
    );
    // The text stays as written.
    expect(instructionField('Erst {{ ingredients[1] }}'), findsOneWidget);
  });

  testWidgets('German text fits at 390 px', (tester) async {
    await pumpTab(tester, recipeId: 8);

    await tap(tester, find.text('Alles vorbereiten.'));

    expect(tester.takeException(), isNull);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('Schritte in $name', tags: goldenTags, (tester) async {
        recipes = FakeRecipeRepository([
          ofenkarotten.copyWith(
            steps: [
              for (final step in ofenkarotten.steps)
                if (step.id == 2)
                  step.copyWith(
                    ingredients: step.ingredients.take(3).toList(),
                    time: const Duration(minutes: 25),
                  )
                else
                  step,
            ],
          ),
        ]);
        await pumpTab(tester, theme: theme);
        await tap(tester, find.textContaining('Karotten **schräg**'));

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_steps_$name.png'),
        );
      });
    }
  });
}
