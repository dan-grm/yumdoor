import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/components/timer_chip.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';

import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository repository;

  setUpAll(loadBundledFonts);

  setUp(() => repository = FakeRecipeRepository([ofenkarotten, longNames]));

  Future<GoRouter> pumpRecipe(
    WidgetTester tester,
    int id, {
    ThemeData? theme,
    Size size = phoneSize,
  }) => pumpRoutes(
    tester,
    location: '/recipe/$id',
    theme: theme,
    size: size,
    overrides: [recipeRepositoryProvider.overrideWithValue(repository)],
    routes: [
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) =>
            RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/recipe/:id/cook',
        builder: (context, state) => Text('cook ${state.uri}'),
      ),
    ],
  );

  Future<void> tapTooltip(WidgetTester tester, String tooltip) async {
    final button = find.byTooltip(tooltip);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  testWidgets('shows the recipe with amounts for its own servings', (
    tester,
  ) async {
    await pumpRecipe(tester, ofenkarotten.id);

    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    expect(find.text('35 Min · 4,5 ￼', findRichText: true), findsOneWidget);
    expect(find.bySemanticsLabel('35 Min, 4,5 von 5 Sternen'), findsOneWidget);
    expect(find.text('Vegetarisch'), findsOneWidget);
    expect(find.text('2 Portionen'), findsOneWidget);
    expect(find.text('Karotten'), findsOneWidget);
    expect(find.text('300 g'), findsOneWidget);
    expect(find.text('½ TL'), findsOneWidget);
    expect(find.text('¼ Bund'), findsOneWidget);
    expect(find.text('Salz'), findsOneWidget);
    expect(find.textContaining('Rezept ist für'), findsNothing);
    // Grouped by step, titled with the step's name or number.
    expect(find.text('SCHRITT 2'), findsOneWidget);
    expect(find.text('SCHRITT 3 · ANRICHTEN'), findsOneWidget);
  });

  testWidgets('the servings picker rescales the ingredients', (tester) async {
    await pumpRecipe(tester, ofenkarotten.id);

    await tapTooltip(tester, 'Mehr Portionen');
    await tapTooltip(tester, 'Mehr Portionen');

    expect(find.text('4 Portionen'), findsOneWidget);
    expect(find.text('600 g'), findsOneWidget);
    expect(find.text('2 EL'), findsOneWidget);
    expect(find.text('1 TL'), findsOneWidget);
    expect(find.text('200 g'), findsOneWidget);
    expect(find.text('½ Bund'), findsOneWidget);
    expect(
      find.text('Rezept ist für 2 Portionen, Mengen umgerechnet'),
      findsOneWidget,
    );
    expect(find.text('Kochen starten · 4 Portionen'), findsOneWidget);

    await tapTooltip(tester, 'Weniger Portionen');
    expect(find.text('3 Portionen'), findsOneWidget);
    expect(find.text('450 g'), findsOneWidget);
    expect(find.text('1½ EL'), findsOneWidget);
  });

  testWidgets('servings stop at 1, with the minus button disabled', (
    tester,
  ) async {
    await pumpRecipe(tester, ofenkarotten.id);

    await tapTooltip(tester, 'Weniger Portionen');

    expect(find.text('1 Portion'), findsOneWidget);
    expect(find.text('150 g'), findsOneWidget);
    final minus = tester.widget<IconButton>(
      find.ancestor(
        of: find.byTooltip('Weniger Portionen'),
        matching: find.byType(IconButton),
      ),
    );
    expect(minus.onPressed, isNull);
  });

  testWidgets('"Kochen starten" opens cooking mode with the servings', (
    tester,
  ) async {
    await pumpRecipe(tester, ofenkarotten.id);

    await tapTooltip(tester, 'Mehr Portionen');
    await tester.tap(find.text('Kochen starten · 3 Portionen'));
    await tester.pumpAndSettle();

    expect(find.text('cook /recipe/7/cook?servings=3'), findsOneWidget);
  });

  testWidgets('plan, shop and edit are visible but disabled', (tester) async {
    await pumpRecipe(tester, ofenkarotten.id);

    for (final label in ['Planen', 'Einkaufen', 'Bearbeiten']) {
      final button = tester.widget<TextButton>(
        find.ancestor(of: find.text(label), matching: find.byType(TextButton)),
      );
      expect(button.onPressed, isNull, reason: label);
    }
    expect(
      find.text('Planen, Einkaufen und Bearbeiten kommen bald.'),
      findsOneWidget,
    );
  });

  testWidgets('long German names fit at 390 px', (tester) async {
    await pumpRecipe(tester, longNames.id);
    await tapTooltip(tester, 'Mehr Portionen');

    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Rote Bete, vorgegart, vakuumverpackt'),
      findsOneWidget,
    );
    expect(find.text('1.543 Vakuumpackungen à 500 Gramm'), findsOneWidget);
    expect(find.text('Für den Walnusskrokant mit Ahornsirup'), findsOneWidget);
  });

  testWidgets('a missing recipe explains itself and can be retried', (
    tester,
  ) async {
    await pumpRecipe(tester, 999);

    expect(
      find.text('Dieses Rezept gibt es nicht, oder du darfst es nicht sehen.'),
      findsOneWidget,
    );

    repository.recipes[999] = ofenkarotten.copyWith(id: 999);
    await tester.tap(find.text('Nochmal versuchen'));
    await tester.pumpAndSettle();

    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
  });

  testWidgets('offline failures say so', (tester) async {
    repository.failure = const OfflineFailure();
    await pumpRecipe(tester, ofenkarotten.id);

    expect(
      find.text(
        'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the description is rendered as Markdown', (tester) async {
    repository.recipes[ofenkarotten.id] = ofenkarotten.copyWith(
      description: 'Süß und **knusprig**.\n\n- passt zu Couscous',
    );
    await pumpRecipe(tester, ofenkarotten.id);

    expect(find.text('Süß und knusprig.', findRichText: true), findsOneWidget);
    expect(find.text('passt zu Couscous', findRichText: true), findsOneWidget);
    expect(find.textContaining('**'), findsNothing);
  });

  group('layout', () {
    for (final size in [phoneSize, landscapeSize, tabletSize]) {
      testWidgets('fits at ${size.width.round()}×${size.height.round()}', (
        tester,
      ) async {
        await pumpRecipe(tester, ofenkarotten.id, size: size);

        expect(tester.takeException(), isNull);
        expect(find.text('Karotten'), findsOneWidget);
        if (size.width >= YumdoorTokens.light.sizeWide) {
          // The steps next to the ingredients, templates and all.
          expect(find.text('Zubereitung'), findsOneWidget);
          expect(
            tester.getTopLeft(find.text('Zubereitung')).dx,
            greaterThan(tester.getTopLeft(find.text('Karotten')).dx),
          );
          expect(
            find.textContaining('Karotten schräg', findRichText: true),
            findsOneWidget,
          );
        } else {
          expect(find.text('Zubereitung'), findsNothing);
        }
      });
    }

    testWidgets('wide: step templates follow the servings picker', (
      tester,
    ) async {
      repository.recipes[ofenkarotten.id] = ofenkarotten.copyWith(
        steps: [
          ofenkarotten.steps[1].copyWith(
            instruction: '{{ ingredients[0] }} schneiden.',
          ),
        ],
      );
      await pumpRecipe(tester, ofenkarotten.id, size: tabletSize);
      expect(
        find.text('300 g Karotten schneiden.', findRichText: true),
        findsOneWidget,
      );

      await tapTooltip(tester, 'Mehr Portionen');
      expect(
        find.text('450 g Karotten schneiden.', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('wide: steps are numbered; steps without text are left out', (
      tester,
    ) async {
      repository.recipes[ofenkarotten.id] = ofenkarotten.copyWith(
        steps: [
          ofenkarotten.steps[0].copyWith(instruction: ''),
          ...ofenkarotten.steps.skip(1),
        ],
      );
      await pumpRecipe(tester, ofenkarotten.id, size: tabletSize);

      expect(find.text('SCHRITT 1'), findsNothing);
      expect(find.text('SCHRITT 2'), findsWidgets);
      // A named step keeps its number, with the name below.
      expect(find.text('SCHRITT 3'), findsOneWidget);
      expect(find.text('Anrichten'), findsOneWidget);
    });

    testWidgets('wide: durations aren\'t highlighted outside cooking mode', (
      tester,
    ) async {
      await pumpRecipe(tester, ofenkarotten.id, size: tabletSize);

      // Step 2 roasts "25 Minuten"; timers start in cooking mode only.
      expect(find.textContaining('25 Minuten'), findsOneWidget);
      expect(find.byType(TimerHighlight), findsNothing);
    });

    testWidgets('wide without any step text keeps one column', (tester) async {
      repository.recipes[ofenkarotten.id] = ofenkarotten.copyWith(
        steps: [
          for (final step in ofenkarotten.steps)
            step.copyWith(instruction: '', name: ''),
        ],
      );
      await pumpRecipe(tester, ofenkarotten.id, size: tabletSize);

      expect(find.text('Zubereitung'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('long German names fit on a phone in landscape', (
      tester,
    ) async {
      await pumpRecipe(tester, longNames.id, size: landscapeSize);

      expect(tester.takeException(), isNull);
    });
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('Markdown description in $name', tags: goldenTags, (
        tester,
      ) async {
        repository.recipes[ofenkarotten.id] = ofenkarotten.copyWith(
          description:
              'Süß, salzig und *knusprig*. Nach einem Rezept von '
              '[Oma Erna](https://example.com/oma).\n\n'
              '- passt zu **Couscous**\n'
              '- schmeckt auch kalt',
        );
        await pumpRecipe(tester, ofenkarotten.id, theme: theme);

        await expectLater(
          find.byType(RecipeScreen),
          matchesGoldenFile('../goldens/recipe_description_$name.png'),
        );
      });

      testWidgets('tablet in $name', tags: goldenTags, (tester) async {
        await pumpRecipe(
          tester,
          ofenkarotten.id,
          theme: theme,
          size: tabletSize,
        );

        await expectLater(
          find.byType(RecipeScreen),
          matchesGoldenFile('../goldens/recipe_tablet_$name.png'),
        );
      });
    }
  });
}
