import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';
import 'package:yumdoor/features/search/search_location.dart';
import 'package:yumdoor/features/search/search_screen.dart';

import '../fakes/fake_connectivity_service.dart';
import '../fakes/fake_food_keyword_repositories.dart';
import '../fakes/fake_offline_cache.dart';
import '../fakes/fake_recipe_repository.dart';
import '../fixtures/recipes.dart';
import 'harness.dart';

const _banner =
    'Du bist offline. Rezepte, die du schon geöffnet hast, kannst du weiter '
    'ansehen.';
const _writeDisabled =
    'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, geht '
    'es weiter.';

void main() {
  late FakeConnectivityService connectivity;
  late FakeOfflineCache offlineCache;
  late FakeRecipeRepository recipes;

  setUp(() {
    connectivity = FakeConnectivityService(isOnline: false);
    offlineCache = FakeOfflineCache();
    recipes = FakeRecipeRepository([ofenkarotten]);
  });

  Future<GoRouter> pump(WidgetTester tester, String location) => pumpRoutes(
    tester,
    location: location,
    overrides: [
      connectivityServiceProvider.overrideWithValue(connectivity),
      offlineCacheProvider.overrideWithValue(offlineCache),
      recipeRepositoryProvider.overrideWithValue(recipes),
      foodRepositoryProvider.overrideWithValue(FakeFoodRepository()),
      keywordRepositoryProvider.overrideWithValue(FakeKeywordRepository()),
    ],
    routes: [
      GoRoute(
        path: searchPath,
        builder: (context, state) =>
            SearchScreen(query: searchQueryFromUri(state.uri)),
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) =>
            RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
      ),
    ],
  );

  group('recipe screen offline', () {
    testWidgets('shows the banner and explains the disabled actions', (
      tester,
    ) async {
      await pump(tester, '/recipe/${ofenkarotten.id}');

      expect(find.text(_banner), findsOneWidget);
      expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
      // Visible, disabled, and each one says why.
      for (final label in ['Planen', 'Einkaufen', 'Bearbeiten']) {
        final button = find.ancestor(
          of: find.text(label),
          matching: find.byType(TextButton),
        );
        expect(tester.widget<TextButton>(button).onPressed, isNull);
      }
      expect(find.byTooltip(_writeDisabled), findsNWidgets(3));
      expect(find.text(_writeDisabled), findsOneWidget);
      expect(find.textContaining('kommen bald'), findsNothing);

      await tester.tap(find.text('Planen'));
      await tester.pump(const Duration(seconds: 1));
      // The caption and the tooltip.
      expect(find.text(_writeDisabled), findsNWidgets(2));
    });

    testWidgets('drops the banner when the network comes back', (tester) async {
      await pump(tester, '/recipe/${ofenkarotten.id}');

      connectivity.isOnline = true;
      await tester.pump();

      expect(find.text(_banner), findsNothing);
      expect(find.byTooltip(_writeDisabled), findsNothing);
      expect(
        find.text('Planen, Einkaufen und Bearbeiten kommen bald.'),
        findsOneWidget,
      );
    });

    testWidgets('shows the image from the offline cache', (tester) async {
      final url = Uri.parse('https://tandoor.example.com/media/k.jpg');
      recipes.recipes[ofenkarotten.id] = ofenkarotten.copyWith(image: url);
      offlineCache.images[url] = Uint8List.fromList([1, 2, 3]);

      await pump(tester, '/recipe/${ofenkarotten.id}');

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<MemoryImage>());
      expect((image.image as MemoryImage).bytes, [1, 2, 3]);
    });
  });

  testWidgets('search says when results come from the offline cache', (
    tester,
  ) async {
    recipes.fromCache = true;

    await pump(tester, searchPath);

    expect(find.text(_banner), findsOneWidget);
    expect(
      find.text(
        'Offline: Gesucht wird nur in Rezepten, die du schon geöffnet hast, '
        'und nur im Namen.',
      ),
      findsOneWidget,
    );
    expect(find.text('1 Rezept'), findsOneWidget);
  });

  testWidgets('no banner while online', (tester) async {
    connectivity.isOnline = true;

    await pump(tester, '/recipe/${ofenkarotten.id}');

    expect(find.text(_banner), findsNothing);
  });
}
