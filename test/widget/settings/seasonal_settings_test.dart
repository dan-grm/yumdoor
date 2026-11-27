import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/features/recommendations/seasonal_keyword_providers.dart';
import 'package:yumdoor/features/settings/settings_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/in_memory_local_store.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeKeywordRepository keywords;
  late FakeConnectivityService connectivity;
  late InMemoryLocalStore store;

  setUpAll(loadBundledFonts);

  setUp(() {
    keywords = FakeKeywordRepository(const [
      Keyword(id: 1, name: 'Spargel'),
      Keyword(id: 2, name: 'Kürbis'),
      Keyword(id: 3, name: 'Grillen'),
    ]);
    connectivity = FakeConnectivityService();
    store = InMemoryLocalStore();
  });

  List<Override> overrides() => [
    ...appOverrides(
      tokenStore: loggedInTokenStore(),
      keywords: keywords,
      connectivity: connectivity,
      localStore: store,
    ),
    clockProvider.overrideWithValue(() => DateTime(2026, 4, 15)),
  ];

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    ThemeData? theme,
  }) async {
    await pumpRoutes(
      tester,
      location: settingsPath,
      theme: theme,
      overrides: overrides(),
      routes: [
        GoRoute(
          path: settingsPath,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
    return ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  Finder add(String month) => find.byTooltip('Stichwort für $month hinzufügen');

  Future<void> addKeyword(
    WidgetTester tester,
    String month,
    String name,
  ) async {
    await scrollTo(tester, add(month));
    await tester.tap(add(month));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), name);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name).last);
    await tester.pumpAndSettle();
  }

  testWidgets('opens scrolled to the seasonal section when asked', (
    tester,
  ) async {
    await pumpRoutes(
      tester,
      location: settingsSeasonalLocation,
      overrides: overrides(),
      routes: [
        GoRoute(
          path: settingsPath,
          builder: (context, state) => SettingsScreen(
            showSeasonal: state.uri.queryParameters['section'] == 'seasonal',
          ),
        ),
      ],
    );

    final top = tester.getTopLeft(find.text('Saisonale Vorschläge')).dy;
    expect(top, greaterThanOrEqualTo(0));
    expect(top, lessThan(400));
  });

  testWidgets('starts with the current month and is empty', (tester) async {
    final container = await pump(tester);

    await scrollTo(tester, find.text('Saisonale Vorschläge'));
    expect(find.textContaining('Passende Rezepte'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('April')).dy,
      lessThan(tester.getTopLeft(find.text('Mai')).dy),
    );
    expect(
      (await container.read(seasonalKeywordMappingProvider.future)).isEmpty,
      isTrue,
    );
  });

  testWidgets('adds and removes keywords of a month and keeps them', (
    tester,
  ) async {
    final container = await pump(tester);

    await addKeyword(tester, 'April', 'Spargel');
    expect(find.text('Spargel'), findsOneWidget);
    expect(container.read(seasonalKeywordMappingProvider).value!.forMonth(4), {
      1,
    });

    await tester.tap(find.byTooltip('Spargel aus April entfernen'));
    await tester.pumpAndSettle();
    expect(find.text('Spargel'), findsNothing);
    expect(
      container.read(seasonalKeywordMappingProvider).value!.forMonth(4),
      isEmpty,
    );

    await addKeyword(tester, 'April', 'Spargel');
    // A new session reads what was saved.
    await tester.pumpWidget(const SizedBox());
    final next = await pump(tester);
    expect(
      (await next.read(seasonalKeywordMappingProvider.future)).forMonth(4),
      {1},
    );
    await scrollTo(tester, find.text('Spargel'));
    expect(find.text('Spargel'), findsOneWidget);
  });

  testWidgets('the picker does not create keywords', (tester) async {
    await pump(tester);
    await scrollTo(tester, add('April'));
    await tester.tap(add('April'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Neu');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.textContaining('anlegen'), findsNothing);
    expect(keywords.created, isEmpty);
  });

  testWidgets('copies a month to other months', (tester) async {
    final container = await pump(tester);
    await addKeyword(tester, 'April', 'Spargel');

    await tester.tap(find.text('Für mehrere Monate übernehmen'));
    await tester.pumpAndSettle();
    expect(find.text('Stichwörter von April übernehmen'), findsOneWidget);
    await tester.tap(find.text('Mai').last);
    await tester.tap(find.text('Juni').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Übernehmen'));
    await tester.pumpAndSettle();

    final mapping = container.read(seasonalKeywordMappingProvider).value!;
    expect(mapping.forMonth(4), {1});
    expect(mapping.forMonth(5), {1});
    expect(mapping.forMonth(6), {1});
    expect(mapping.forMonth(7), isEmpty);
  });

  testWidgets('is read-only offline', (tester) async {
    connectivity.isOnline = false;
    final container = await pump(tester);
    await container
        .read(seasonalKeywordMappingProvider.notifier)
        .setMapping(
          SeasonalKeywords({
            4: [1],
          }),
        );
    await tester.pumpAndSettle();

    await scrollTo(tester, add('April'));
    await tester.tap(add('April'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);

    await tester.tap(
      find.text('Für mehrere Monate übernehmen'),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Stichwörter von April übernehmen'), findsNothing);
  });

  group('goldens', skip: goldenSkip, () {
    testWidgets('seasonal settings in light', tags: goldenTags, (tester) async {
      final container = await pump(tester, theme: lightTheme);
      await container
          .read(seasonalKeywordMappingProvider.notifier)
          .setMapping(
            SeasonalKeywords({
              4: [1],
              5: [1, 3],
              10: [2],
            }),
          );
      await tester.pumpAndSettle();
      await scrollTo(tester, find.text('Saisonale Vorschläge'));

      await expectLater(
        find.byType(SettingsScreen),
        matchesGoldenFile('../goldens/settings_seasonal_light.png'),
      );
    });
  });
}
