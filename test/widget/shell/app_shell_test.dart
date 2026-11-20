import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/features/search/search_providers.dart';
import 'package:yumdoor/features/search/search_screen.dart';
import 'package:yumdoor/features/shell/app_shell.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../golden.dart';
import '../fonts.dart';
import '../harness.dart';

void main() {
  setUpAll(loadBundledFonts);

  final manyRecipes = [
    for (var id = 1; id <= 30; id++) Recipe(id: id, name: 'Rezept $id'),
  ];

  Future<GoRouter> pumpShell(
    WidgetTester tester, {
    String location = '/search',
    Size size = phoneSize,
    ThemeData? theme,
  }) => pumpRoutes(
    tester,
    location: location,
    size: size,
    theme: theme,
    overrides: appOverrides(recipes: FakeRecipeRepository(manyRecipes)),
    routes: [
      tabsRoute(),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) =>
            Scaffold(body: Text('recipe ${state.pathParameters['id']}')),
      ),
    ],
  );

  /// The location on top, including pushed screens.
  String location(GoRouter router) => router.state.uri.toString();

  /// The vertical list of search results.
  Finder resultList() => find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down,
  );

  int selectedTab(WidgetTester tester) =>
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

  testWidgets('switches tabs from the bottom bar', (tester) async {
    final router = await pumpShell(tester);
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(selectedTab(tester), 0);

    await tester.tap(find.text('Planer'));
    await tester.pumpAndSettle();
    expect(location(router), '/plan');
    expect(find.text('Wochenplan'), findsOneWidget);
    expect(selectedTab(tester), 1);

    await tester.tap(find.text('Einkauf'));
    await tester.pumpAndSettle();
    expect(location(router), '/shopping');
    expect(find.text('Einkaufsliste'), findsOneWidget);
    expect(selectedTab(tester), 2);

    await tester.tap(find.text('Suchen').last);
    await tester.pumpAndSettle();
    expect(location(router), '/search');
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(selectedTab(tester), 0);
  });

  testWidgets('a tab keeps its search and scroll position', (tester) async {
    final router = await pumpShell(tester, location: '/search?q=Rezept');
    final list = resultList();
    await tester.drag(list, const Offset(0, -600));
    await tester.pumpAndSettle();
    final offset = tester.state<ScrollableState>(list).position.pixels;
    expect(offset, greaterThan(0));

    await tester.tap(find.text('Planer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Suchen').last);
    await tester.pumpAndSettle();

    expect(location(router), '/search?q=Rezept');
    expect(tester.state<ScrollableState>(resultList()).position.pixels, offset);
  });

  testWidgets('tapping the open tab goes back to its start', (tester) async {
    final router = await pumpShell(tester, location: '/search?q=Rezept');

    await tester.tap(find.text('Suchen').last);
    await tester.pumpAndSettle();

    expect(location(router), '/search');
  });

  testWidgets('typing before a tab switch stays on the new tab', (
    tester,
  ) async {
    final router = await pumpShell(tester);

    await tester.enterText(find.byType(TextField), 'Suppe');
    await tester.tap(find.text('Planer'));
    await tester.pump();
    await tester.pump(searchDebounce * 2);
    await tester.pumpAndSettle();
    expect(location(router), '/plan');
    // The hidden field can't take the keyboard focus (e.g. by Tab).
    final field = tester
        .widget<EditableText>(find.byType(EditableText, skipOffstage: false))
        .focusNode;
    field.requestFocus();
    await tester.pump();
    expect(field.hasFocus, isFalse);

    await tester.tap(find.text('Suchen').last);
    await tester.pump();
    expect(location(router), '/search');
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(location(router), '/search?q=Suppe');
  });

  testWidgets('back on another tab returns to search', (tester) async {
    final router = await pumpShell(tester, location: '/shopping');

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(location(router), '/search');
  });

  testWidgets('typing before opening a recipe keeps the recipe open', (
    tester,
  ) async {
    final router = await pumpShell(tester, location: '/search?q=Rezept');

    await tester.enterText(find.byType(TextField), 'Rezept 1');
    await tester.tap(find.text('Rezept 2'));
    await tester.pump();
    await tester.pump(searchDebounce * 2);
    await tester.pumpAndSettle();
    expect(location(router), '/recipe/2');

    router.pop();
    await tester.pumpAndSettle();
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
    expect(location(router), '/search?q=Rezept+1');
  });

  for (final (path, index, title) in [
    ('/plan', 1, 'Wochenplan'),
    ('/shopping', 2, 'Einkaufsliste'),
  ]) {
    testWidgets('a link to $path opens its tab', (tester) async {
      await pumpShell(tester, location: path);

      expect(find.text(title), findsOneWidget);
      expect(selectedTab(tester), index);
    });
  }

  testWidgets('a recipe covers the bar; back returns to its tab', (
    tester,
  ) async {
    final router = await pumpShell(tester, location: '/search?q=Rezept');

    await tester.tap(find.text('Rezept 1'));
    await tester.pumpAndSettle();
    expect(find.text('recipe 1'), findsOneWidget);
    expect(find.byType(NavigationBar).hitTestable(), findsNothing);

    router.pop();
    await tester.pumpAndSettle();
    expect(location(router), '/search?q=Rezept');
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(selectedTab(tester), 0);
  });

  testWidgets('shows a rail instead of the bar on a wide screen', (
    tester,
  ) async {
    final router = await pumpShell(tester, size: tabletSize);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsOneWidget);

    await tester.tap(find.text('Einkauf'));
    await tester.pumpAndSettle();
    expect(location(router), '/shopping');
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex,
      2,
    );
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('bar in $name', tags: goldenTags, (tester) async {
        await pumpShell(tester, location: '/plan', theme: theme);

        await expectLater(
          find.byType(AppShell),
          matchesGoldenFile('../goldens/app_shell_$name.png'),
        );
      });

      testWidgets('rail in $name', tags: goldenTags, (tester) async {
        await pumpShell(
          tester,
          location: '/shopping',
          size: tabletSize,
          theme: theme,
        );

        await expectLater(
          find.byType(AppShell),
          matchesGoldenFile('../goldens/app_shell_wide_$name.png'),
        );
      });
    }
  });
}
