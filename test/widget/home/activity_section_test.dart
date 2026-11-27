import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/features/home/home_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_cook_log_repository.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

const _me = UserRef(id: 1, name: 'Ich', username: 'ich');
const _anna = UserRef(id: 2, name: 'Anna', username: 'anna');
const _ben = UserRef(id: 3, name: '', username: 'ben');

final _now = DateTime(2026, 11, 18, 16, 5);

void main() {
  setUpAll(loadBundledFonts);

  late FakeCookLogRepository cookLogs;

  void cooked(
    int id,
    int recipeId,
    String name,
    UserRef? by,
    Duration ago, {
    int? rating,
    String? comment,
  }) {
    cookLogs.recipes[recipeId] = RecipeSummary(
      id: recipeId,
      name: name,
      servings: 2,
    );
    cookLogs.entries.add(
      CookLog(
        id: id,
        recipeId: recipeId,
        rating: rating,
        comment: comment,
        createdBy: by,
        createdAt: _now.subtract(ago),
      ),
    );
  }

  setUp(() {
    cookLogs = FakeCookLogRepository();
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    FakeConnectivityService? connectivity,
    ThemeData? theme,
  }) => pumpRoutes(
    tester,
    location: '/',
    theme: theme,
    overrides: [
      ...appOverrides(
        tokenStore: loggedInTokenStore(),
        connectivity: connectivity,
        cookLogs: cookLogs,
      ),
      clockProvider.overrideWithValue(() => _now),
    ],
    routes: [
      tabsRoute(),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) =>
            Scaffold(body: Text('recipe ${state.uri}')),
      ),
    ],
  );

  Future<void> scrollToEnd(WidgetTester tester) async {
    await tester.drag(find.byType(ListView).first, const Offset(0, -2000));
    await tester.pumpAndSettle();
  }

  testWidgets('shows what others cooked, not the own entries', (tester) async {
    cooked(1, 10, 'Linsensuppe', _anna, const Duration(hours: 3), rating: 4);
    cooked(2, 11, 'Eigenes Gericht', _me, const Duration(hours: 4));
    cooked(3, 12, 'Pilzpfanne', _ben, const Duration(days: 2));
    cooked(4, 13, 'Altes Curry', _anna, const Duration(days: 20));
    await pumpHome(tester);
    await scrollToEnd(tester);

    expect(find.text('Was andere kochen'), findsOneWidget);
    expect(find.text('alle auf diesem Server'), findsOneWidget);
    expect(find.text('Anna hat Linsensuppe gekocht'), findsOneWidget);
    expect(find.text('vor 3 Std.'), findsOneWidget);
    // Without a display name the username shows.
    expect(find.text('ben hat Pilzpfanne gekocht'), findsOneWidget);
    expect(find.text('vor 2 Tagen'), findsOneWidget);
    expect(find.text('vor 2 Wochen'), findsOneWidget);
    expect(find.textContaining('Eigenes Gericht'), findsNothing);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('4 Sterne')), findsOneWidget);
  });

  testWidgets('shows at most five entries', (tester) async {
    for (var i = 0; i < 8; i++) {
      cooked(i + 1, 20 + i, 'Rezept $i', _anna, Duration(hours: i + 1));
    }
    await pumpHome(tester);
    await scrollToEnd(tester);

    expect(
      find.textContaining(RegExp(r'^Anna hat Rezept \d')),
      findsNWidgets(5),
    );
    expect(find.text('Anna hat Rezept 5 gekocht'), findsNothing);
  });

  testWidgets('a long comment is cut at two lines, as plain text', (
    tester,
  ) async {
    cooked(
      1,
      10,
      'Linsensuppe',
      _anna,
      const Duration(hours: 1),
      comment:
          '**Sehr** gut, siehe [hier](https://evil.example) <b>wirklich</b>. '
          '${'Viel zu langer Kommentar. ' * 20}',
    );
    await pumpHome(tester);
    await scrollToEnd(tester);

    final comment = find.textContaining('**Sehr** gut');
    expect(comment, findsOneWidget);
    final text = tester.widget<Text>(comment);
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.textSpan, isNull);
    expect(tester.getSize(comment).height, lessThan(80));
  });

  testWidgets('an entry opens its recipe', (tester) async {
    cooked(1, 10, 'Linsensuppe', _anna, const Duration(hours: 1));
    await pumpHome(tester);
    await scrollToEnd(tester);

    await tester.tap(find.text('Anna hat Linsensuppe gekocht'));
    await tester.pumpAndSettle();

    expect(find.text('recipe /recipe/10'), findsOneWidget);
  });

  testWidgets('pull to refresh loads the newest entries', (tester) async {
    cooked(1, 10, 'Linsensuppe', _anna, const Duration(hours: 3));
    await pumpHome(tester);
    await scrollToEnd(tester);
    expect(find.text('Anna hat Linsensuppe gekocht'), findsOneWidget);

    cooked(2, 12, 'Pilzpfanne', _ben, const Duration(hours: 1));
    await tester.drag(find.byType(ListView).first, const Offset(0, 3000));
    await tester.pumpAndSettle();
    await tester.fling(find.byType(ListView).first, const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    await scrollToEnd(tester);

    expect(find.text('ben hat Pilzpfanne gekocht'), findsOneWidget);
    expect(find.text('Anna hat Linsensuppe gekocht'), findsOneWidget);
  });

  testWidgets('says so when nobody else cooked', (tester) async {
    cooked(1, 11, 'Eigenes Gericht', _me, const Duration(hours: 4));
    await pumpHome(tester);
    await scrollToEnd(tester);

    expect(find.text('Zuletzt hat sonst niemand gekocht.'), findsOneWidget);
  });

  testWidgets('a failure shows in the section and can be retried', (
    tester,
  ) async {
    cooked(1, 10, 'Linsensuppe', _anna, const Duration(hours: 1));
    cookLogs.failure = const ServerFailure();
    await pumpHome(tester);
    await scrollToEnd(tester);

    expect(find.textContaining('Das konnte nicht geladen werden.'), findsOne);
    expect(find.byType(HomeScreen), findsOneWidget);

    cookLogs.failure = null;
    await tester.tap(find.text('Nochmal versuchen').last);
    await tester.pumpAndSettle();
    expect(find.text('Anna hat Linsensuppe gekocht'), findsOneWidget);
  });

  testWidgets('offline, the section is one line saying why', (tester) async {
    cooked(1, 10, 'Linsensuppe', _anna, const Duration(hours: 1));
    await pumpHome(
      tester,
      connectivity: FakeConnectivityService(isOnline: false),
    );
    await scrollToEnd(tester);

    expect(
      find.text('Was andere kochen, braucht eine Verbindung zum Server.'),
      findsOneWidget,
    );
    expect(find.text('Was andere kochen'), findsNothing);
    expect(find.textContaining('Linsensuppe'), findsNothing);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('start with activity in $name', tags: goldenTags, (
        tester,
      ) async {
        cooked(
          1,
          10,
          'Linsensuppe',
          _anna,
          const Duration(hours: 3),
          rating: 4,
          comment:
              'Mit etwas mehr Zitrone war sie perfekt, das nächste Mal '
              'nehme ich noch eine Zwiebel mehr und koche sie länger.',
        );
        cooked(2, 12, 'Pilzpfanne', _ben, const Duration(days: 2), rating: 5);
        cooked(3, 13, 'Kürbiscurry', _anna, const Duration(days: 9));
        await pumpHome(tester, theme: theme);
        await scrollToEnd(tester);

        await expectLater(
          find.byType(HomeScreen),
          matchesGoldenFile('../goldens/home_activity_$name.png'),
        );
      });
    }
  });
}
