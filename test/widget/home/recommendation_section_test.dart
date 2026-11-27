import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/recommendation.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/domain/services/recommendation_provider.dart';
import 'package:yumdoor/features/home/home_screen.dart';
import 'package:yumdoor/features/recommendations/reason_text.dart';
import 'package:yumdoor/features/recommendations/recommendation_providers.dart';
import 'package:yumdoor/features/recommendations/recommendations_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/in_memory_local_store.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

/// A [RecommendationProvider] that answers with [result].
class _FakeRecommender implements RecommendationProvider {
  _FakeRecommender(this.result);

  List<Recommendation> result;
  Failure? failure;
  Completer<void>? gate;
  final contexts = <RecommendationContext>[];
  final limits = <int>[];

  @override
  String get id => 'fake';

  @override
  Future<List<Recommendation>> recommend(
    RecommendationContext context, {
    int limit = 10,
  }) async {
    contexts.add(context);
    limits.add(limit);
    if (gate case final gate?) await gate.future;
    if (failure case final failure?) throw failure;
    return result;
  }
}

RecipeSummary _recipe(int id, String name) =>
    RecipeSummary(id: id, name: name, servings: 2);

const _season = Keyword(id: 5, name: 'Herbst');
final _anna = const UserRef(id: 2, name: 'Anna', username: 'anna');

final _lentils = Recommendation(
  recipe: _recipe(31, 'Linseneintopf'),
  score: 0.9,
  reasons: [
    const RecommendationReason.highlyRated(4.5),
    // Wednesday, 18 November: 21 days ago.
    RecommendationReason.notCookedSince(DateTime(2026, 10, 28)),
    const RecommendationReason.inSeason(_season),
  ],
);
final _stew = Recommendation(
  recipe: _recipe(32, 'Kürbiscurry'),
  score: 0.7,
  reasons: [
    RecommendationReason.cookedRecentlyBy(_anna, DateTime(2026, 11, 17)),
  ],
);
final _similar = Recommendation(
  recipe: _recipe(33, 'Pilzpfanne'),
  score: 0.5,
  reasons: [RecommendationReason.similarTo(_recipe(20, 'Kürbis-Risotto'))],
);
final _free = Recommendation(
  recipe: _recipe(34, 'Quiche'),
  score: 0.4,
  reasons: const [RecommendationReason.freeText('Weil Freitag ist')],
);

void main() {
  setUpAll(loadBundledFonts);

  late _FakeRecommender recommender;
  late InMemoryLocalStore store;
  late DateTime now;

  setUp(() {
    recommender = _FakeRecommender([_lentils, _stew, _similar, _free]);
    store = InMemoryLocalStore();
    now = DateTime(2026, 11, 18, 16, 5);
  });

  Future<GoRouter> pumpHome(
    WidgetTester tester, {
    FakeConnectivityService? connectivity,
    ThemeData? theme,
    String location = '/',
    SeasonalKeywords? seasonal,
  }) async {
    if (seasonal != null) {
      store.write(
        'seasonal-keywords.${Uri.encodeComponent(testServerUrl.toString())}.1',
        seasonal.toJson(),
      );
    }
    return pumpRoutes(
      tester,
      location: location,
      theme: theme,
      overrides: [
        ...appOverrides(
          tokenStore: loggedInTokenStore(),
          connectivity: connectivity,
          localStore: store,
        ),
        recommenderProvider.overrideWithValue(recommender),
        clockProvider.overrideWithValue(() => now),
      ],
      routes: [
        tabsRoute(),
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) =>
              Scaffold(body: Text('recipe ${state.uri}')),
        ),
        GoRoute(
          path: recommendationsPath,
          builder: (context, state) => const RecommendationsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) =>
              Scaffold(body: Text('settings ${state.uri}')),
        ),
      ],
    );
  }

  Finder reason(String text) =>
      find.byWidgetPredicate((w) => w is ReasonText && w.text == text);

  final withSeason = SeasonalKeywords({
    11: [5],
  });

  testWidgets('shows cards with the first reason', (tester) async {
    await pumpHome(tester, seasonal: withSeason);

    expect(find.text('Vorschläge für dich'), findsOneWidget);
    expect(find.text('Linseneintopf'), findsOneWidget);
    expect(reason('4,5 ★ · 3 Wochen nicht gekocht'), findsOneWidget);
    expect(find.text('Kürbiscurry'), findsOneWidget);
    expect(find.text('Anna hat das gestern gekocht'), findsOneWidget);
    expect(find.text('Ähnlich wie Kürbis-Risotto'), findsOneWidget);
    expect(find.text('Weil Freitag ist'), findsOneWidget);
    // Only the first reason; the list screen has all of them.
    expect(find.text('Passt zum November'), findsNothing);
    // Today's plan is still there.
    expect(find.text('Guten Tag'), findsOneWidget);
    expect(recommender.limits.single, 20);
    expect(recommender.contexts.single.userId, 1);
  });

  testWidgets('a card opens its recipe', (tester) async {
    await pumpHome(tester, seasonal: withSeason);

    await tester.tap(find.text('Linseneintopf'));
    await tester.pumpAndSettle();

    expect(find.text('recipe /recipe/31'), findsOneWidget);
  });

  testWidgets('"Mehr" lists the suggestions with all their reasons', (
    tester,
  ) async {
    final router = await pumpHome(tester, seasonal: withSeason);

    await tester.tap(find.text('Mehr'));
    await tester.pumpAndSettle();

    expect(find.byType(RecommendationsScreen), findsOneWidget);
    expect(find.text('Vorschläge'), findsOneWidget);
    expect(find.text('Linseneintopf'), findsOneWidget);
    expect(reason('4,5 ★ · 3 Wochen nicht gekocht'), findsOneWidget);
    expect(find.text('Passt zum November'), findsOneWidget);
    expect(find.text('Quiche'), findsOneWidget);
    // Computed once, shared with the start screen.
    expect(recommender.contexts, hasLength(1));

    await tester.tap(find.text('Pilzpfanne'));
    await tester.pumpAndSettle();
    expect(find.text('recipe /recipe/33'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Zurück'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('"Mehr" shows up to twenty', (tester) async {
    recommender.result = [
      for (var i = 0; i < 20; i++)
        Recommendation(recipe: _recipe(100 + i, 'Rezept $i'), score: 0.5),
    ];
    await pumpHome(tester, seasonal: withSeason);

    // The start screen shows ten.
    expect(find.textContaining(RegExp(r'^Rezept \d+$')), findsNWidgets(10));

    await tester.tap(find.text('Mehr'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Rezept 19'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Rezept 19'), findsOneWidget);
  });

  group('seasonal hint', () {
    testWidgets('shows without a mapping and opens the settings', (
      tester,
    ) async {
      await pumpHome(tester);

      expect(find.textContaining('Sag uns in den Einstellungen'), findsOne);
      await tester.ensureVisible(find.text('Saison einrichten'));
      await tester.tap(find.text('Saison einrichten'));
      await tester.pumpAndSettle();

      expect(find.text('settings /settings?section=seasonal'), findsOne);
    });

    testWidgets('is dismissed for good', (tester) async {
      await pumpHome(tester);

      await tester.ensureVisible(find.byTooltip('Hinweis schließen'));
      await tester.tap(find.byTooltip('Hinweis schließen'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Sag uns in den Einstellungen'), findsNothing);

      // After a reload.
      await pumpHome(tester);
      expect(find.textContaining('Sag uns in den Einstellungen'), findsNothing);
      expect(find.text('Linseneintopf'), findsOneWidget);
    });

    testWidgets('does not show with a mapping', (tester) async {
      await pumpHome(tester, seasonal: withSeason);

      expect(find.textContaining('Sag uns in den Einstellungen'), findsNothing);
    });

    testWidgets('shows below the cards and without suggestions', (
      tester,
    ) async {
      recommender.result = const [];
      await pumpHome(tester);

      expect(find.text('Vorschläge für dich'), findsNothing);
      expect(find.textContaining('Sag uns in den Einstellungen'), findsOne);
    });
  });

  testWidgets('shows placeholders while loading', (tester) async {
    recommender.gate = Completer();
    await pumpHome(tester, seasonal: withSeason);

    expect(find.text('Vorschläge für dich'), findsOneWidget);
    expect(find.text('Linseneintopf'), findsNothing);
    expect(find.byType(DecoratedBox), findsWidgets);
    expect(find.text('Mehr'), findsNothing);

    recommender.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Linseneintopf'), findsOneWidget);
  });

  testWidgets('a failure shows in the section and can be retried', (
    tester,
  ) async {
    recommender.failure = const ServerFailure();
    await pumpHome(tester, seasonal: withSeason);

    expect(find.textContaining('Vorschläge konnten nicht'), findsOneWidget);
    // The rest of the start screen is fine.
    expect(find.text('Guten Tag'), findsOneWidget);
    expect(find.text('Für heute ist nichts geplant.'), findsOneWidget);

    recommender.failure = null;
    await tester.tap(find.text('Nochmal versuchen'));
    await tester.pumpAndSettle();
    expect(find.text('Linseneintopf'), findsOneWidget);
    expect(find.textContaining('Vorschläge konnten nicht'), findsNothing);
  });

  testWidgets('offline, the section is one line saying why', (tester) async {
    await pumpHome(
      tester,
      connectivity: FakeConnectivityService(isOnline: false),
      seasonal: withSeason,
    );

    expect(
      find.text('Vorschläge brauchen eine Verbindung zum Server.'),
      findsOneWidget,
    );
    expect(find.text('Vorschläge für dich'), findsNothing);
    expect(find.text('Linseneintopf'), findsNothing);
    expect(recommender.contexts, isEmpty);
  });

  testWidgets('computes once per day and again on pull to refresh', (
    tester,
  ) async {
    await pumpHome(tester, seasonal: withSeason);
    expect(recommender.contexts, hasLength(1));

    // Another tab and back.
    await tester.tap(find.text('Einkauf'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(recommender.contexts, hasLength(1));

    recommender.result = [_free];
    await tester.fling(find.byType(ListView).first, const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    expect(recommender.contexts, hasLength(2));
    expect(find.text('Linseneintopf'), findsNothing);
    expect(find.text('Quiche'), findsOneWidget);

    // The next day.
    now = DateTime(2026, 11, 19, 8);
    await tester.pump(const Duration(minutes: 1));
    await tester.pumpAndSettle();
    expect(recommender.contexts, hasLength(3));
  });

  testWidgets('words reasons by how long ago they were', (tester) async {
    // A rating on its own and a reason from a week ago.
    recommender.result = [
      Recommendation(
        recipe: _recipe(40, 'Eins'),
        score: 0.5,
        reasons: const [RecommendationReason.highlyRated(4)],
      ),
      Recommendation(
        recipe: _recipe(41, 'Zwei'),
        score: 0.4,
        reasons: [
          RecommendationReason.cookedRecentlyBy(_anna, DateTime(2026, 11, 8)),
        ],
      ),
      Recommendation(
        recipe: _recipe(42, 'Drei'),
        score: 0.3,
        reasons: [RecommendationReason.notCookedSince(DateTime(2026, 8, 1))],
      ),
    ];
    await pumpHome(tester, seasonal: withSeason);

    expect(reason('4 ★'), findsOneWidget);
    expect(find.text('Anna hat das letzte Woche gekocht'), findsOneWidget);
    expect(find.text('3 Monate nicht gekocht'), findsOneWidget);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('start with suggestions in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpHome(tester, theme: theme, seasonal: withSeason);
        await tester.drag(find.byType(ListView).first, const Offset(0, -300));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(HomeScreen),
          matchesGoldenFile('../goldens/home_suggestions_$name.png'),
        );
      });
    }

    testWidgets('start with the seasonal hint', tags: goldenTags, (
      tester,
    ) async {
      await pumpHome(tester);
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('../goldens/home_suggestions_hint_light.png'),
      );
    });

    testWidgets('all suggestions', tags: goldenTags, (tester) async {
      await pumpHome(
        tester,
        location: recommendationsPath,
        seasonal: withSeason,
      );

      await expectLater(
        find.byType(RecommendationsScreen),
        matchesGoldenFile('../goldens/recommendations_light.png'),
      );
    });
  });
}
