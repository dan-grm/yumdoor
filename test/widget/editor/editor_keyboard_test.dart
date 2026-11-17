import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:yumdoor/features/editor/ingredients_tab.dart';
import 'package:yumdoor/features/editor/steps_tab.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_draft_store.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_ingredient_parser.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fakes/fake_unload_guard.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

const _desktopSize = Size(1280, 900);

void main() {
  late FakeRecipeRepository recipes;
  late FakeIngredientParser parser;

  setUpAll(loadBundledFonts);

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    parser = FakeIngredientParser({
      '200 g Karotten': const ParsedIngredient(
        originalText: '200 g Karotten',
        food: NamedRef(id: 1, name: 'Karotte'),
        unit: NamedRef(id: 1, name: 'g'),
        amount: 200,
      ),
      '1 EL Öl': const ParsedIngredient(
        originalText: '1 EL Öl',
        food: NamedRef(id: 2, name: 'Olivenöl'),
        unit: NamedRef(id: 2, name: 'EL'),
        amount: 1,
      ),
    });
  });

  Future<void> pumpEditor(
    WidgetTester tester, {
    Size size = phoneSize,
    ThemeData? theme,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: '/recipe/7',
      size: size,
      theme: theme,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        foodRepositoryProvider.overrideWithValue(
          FakeFoodRepository(const [Food(id: 1, name: 'Karotte')]),
        ),
        unitRepositoryProvider.overrideWithValue(
          FakeUnitRepository(const [Unit(id: 1, name: 'g')]),
        ),
        ingredientParserProvider.overrideWithValue(parser),
        connectivityServiceProvider.overrideWithValue(
          FakeConnectivityService(),
        ),
        draftStoreProvider.overrideWithValue(FakeDraftStore()),
        unloadGuardProvider.overrideWithValue(FakeUnloadGuard()),
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
              onExit: confirmEditorExit,
            ),
          ],
        ),
      ],
    );
    router.push<void>('/recipe/7/edit').ignore();
    await tester.pumpAndSettle();
  }

  Future<void> chord(
    WidgetTester tester,
    LogicalKeyboardKey modifier,
    LogicalKeyboardKey key,
  ) async {
    await tester.sendKeyDownEvent(modifier);
    await tester.sendKeyEvent(key);
    await tester.sendKeyUpEvent(modifier);
    await tester.pumpAndSettle();
  }

  Finder entryField() =>
      find.widgetWithText(TextField, 'z. B. 200 g Karotten, geschält');

  /// The texts inside the focused control, e.g. its button label.
  String focusedLabel(WidgetTester tester) {
    final focused = FocusManager.instance.primaryFocus!.context!;
    final texts = <String>[];
    void visit(Element e) {
      if (e.widget case Text(:final data?)) texts.add(data);
      e.visitChildren(visit);
    }

    focused.visitChildElements(visit);
    return texts.join('|');
  }

  testWidgets('Tab goes from Abbrechen to Speichern, then to the tabs', (
    tester,
  ) async {
    await pumpEditor(tester);
    final order = <String>[];
    for (var i = 0; i < 5; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      order.add(focusedLabel(tester));
    }

    expect(order, containsAllInOrder(['Abbrechen', 'Speichern', 'Allgemein']));
    expect(order, contains('Zutaten'));
  });

  group('shortcuts', () {
    testWidgets('Ctrl+S saves', (tester) async {
      await pumpEditor(tester);

      await chord(tester, LogicalKeyboardKey.control, LogicalKeyboardKey.keyS);

      expect(recipes.saves, hasLength(1));
    });

    testWidgets('Cmd+S saves', (tester) async {
      await pumpEditor(tester);

      await chord(tester, LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS);

      expect(recipes.saves, hasLength(1));
    });

    testWidgets('Esc leaves an unchanged editor', (tester) async {
      await pumpEditor(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(EditorScreen), findsNothing);
      expect(find.byType(RecipeScreen), findsOneWidget);
    });

    testWidgets('Esc with changes asks before leaving', (tester) async {
      await pumpEditor(tester);
      await tester.enterText(
        find.widgetWithText(TextField, 'Ofenkarotten mit Feta'),
        'Ofengemüse',
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Änderungen verwerfen?'), findsOneWidget);
      expect(find.byType(EditorScreen), findsOneWidget);

      // Esc closes the dialog, and the editor stays.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Änderungen verwerfen?'), findsNothing);
      expect(find.byType(EditorScreen), findsOneWidget);
      expect(recipes.saves, isEmpty);
    });

    testWidgets('Alt+1 to Alt+3 switch the tabs', (tester) async {
      await pumpEditor(tester);

      await chord(tester, LogicalKeyboardKey.alt, LogicalKeyboardKey.digit2);
      expect(find.byType(IngredientsTab), findsOneWidget);

      await chord(tester, LogicalKeyboardKey.alt, LogicalKeyboardKey.digit3);
      expect(find.byType(StepsTab), findsOneWidget);
      expect(find.byType(IngredientsTab), findsNothing);

      await chord(tester, LogicalKeyboardKey.alt, LogicalKeyboardKey.digit1);
      expect(find.byType(StepsTab), findsNothing);
    });
  });

  testWidgets('Enter adds an ingredient and keeps the focus for the next', (
    tester,
  ) async {
    await pumpEditor(tester);
    await chord(tester, LogicalKeyboardKey.alt, LogicalKeyboardKey.digit2);
    await tester.ensureVisible(entryField());

    await tester.tap(entryField());
    await tester.enterText(entryField(), '200 g Karotten');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.enterText(entryField(), '1 EL Öl');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(parser.parsed, ['200 g Karotten', '1 EL Öl']);
    expect(tester.widget<TextField>(entryField()).focusNode!.hasFocus, isTrue);
    expect(tester.widget<TextField>(entryField()).controller!.text, isEmpty);
  });

  testWidgets('Alt+Down moves the step that has the focus', (tester) async {
    await pumpEditor(tester);
    await chord(tester, LogicalKeyboardKey.alt, LogicalKeyboardKey.digit3);
    await tester.tap(find.text('Den Ofen auf 200 °C vorheizen.'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            (w.controller?.text.startsWith('Den Ofen') ?? false),
      ),
    );
    await tester.pumpAndSettle();

    await chord(tester, LogicalKeyboardKey.alt, LogicalKeyboardKey.arrowDown);
    await chord(tester, LogicalKeyboardKey.control, LogicalKeyboardKey.keyS);

    expect(recipes.saves.single.draft.steps.map((s) => s.id), [2, 1, 3]);
  });

  group('wide layout', () {
    testWidgets('shows ingredients and steps side by side', (tester) async {
      await pumpEditor(tester, size: _desktopSize);

      expect(find.text('Schritte'), findsNothing);
      await tester.tap(find.text('Zutaten & Schritte'));
      await tester.pumpAndSettle();

      final ingredients = tester.getTopLeft(find.byType(IngredientsTab));
      final steps = tester.getTopLeft(find.byType(StepsTab));
      expect(steps.dx, greaterThan(ingredients.dx));
      expect(steps.dy, ingredients.dy);
      expect(find.byTooltip(RegExp(r'Strg/Cmd\+S')), findsOneWidget);
    });

    testWidgets('keeps the three tabs on a tablet', (tester) async {
      await pumpEditor(tester, size: tabletSize);

      expect(find.text('Schritte'), findsOneWidget);
      expect(find.text('Zutaten & Schritte'), findsNothing);
    });

    group('goldens', skip: goldenSkip, () {
      testWidgets('Zutaten und Schritte at 1280 px', tags: goldenTags, (
        tester,
      ) async {
        await pumpEditor(tester, size: _desktopSize, theme: lightTheme);
        await tester.tap(find.text('Zutaten & Schritte'));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_wide_light.png'),
        );
      });
    });
  });
}
