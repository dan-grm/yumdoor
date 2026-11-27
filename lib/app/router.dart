import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../design/token_gallery.dart';
import '../domain/models/calendar_day.dart';
import '../domain/models/session.dart';
import '../features/auth/login_screen.dart';
import '../features/cook_log/cook_log_screen.dart';
import '../features/cooking/cooking_screen.dart';
import '../features/editor/editor_screen.dart';
import '../features/home/home_screen.dart';
import '../features/planner/planner_screen.dart';
import '../features/recipe/recipe_screen.dart';
import '../features/recommendations/recommendations_screen.dart';
import '../features/search/search_location.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/shopping/shopping_screen.dart';
import 'session.dart';

part 'router.g.dart';

/// App-wide [GoRouter]. Kept alive so navigation state survives rebuilds.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final session = ValueNotifier<AsyncValue<Session?>>(const AsyncLoading());
  ref.listen(
    sessionControllerProvider,
    (_, next) => session.value = next,
    fireImmediately: true,
  );
  final router = GoRouter(
    refreshListenable: session,
    redirect: (context, state) => sessionRedirect(session.value, state.uri),
    routes: [
      tabsRoute(),
      // The search in picker mode, to choose a recipe for a day of the
      // planner. Before '/recipe/:id' is no matter; the paths differ.
      GoRoute(
        path: pickRecipePath,
        redirect: (context, state) =>
            pickDayFromUri(state.uri) == null ? planPath : null,
        builder: (context, state) => SearchScreen(
          query: searchQueryFromUri(state.uri),
          pickDay: pickDayFromUri(state.uri),
        ),
      ),
      GoRoute(
        path: settingsPath,
        builder: (context, state) => SettingsScreen(
          showSeasonal: state.uri.queryParameters['section'] == 'seasonal',
        ),
      ),
      GoRoute(
        path: recommendationsPath,
        builder: (context, state) => const RecommendationsScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: loadingPath, builder: (context, state) => const Scaffold()),
      // Before '/recipe/:id', which would take "new" for an id.
      GoRoute(
        path: newRecipeLocation,
        builder: (context, state) => const EditorScreen(),
        onExit: confirmEditorExit,
      ),
      GoRoute(
        path: '/recipe/:id',
        redirect: (context, state) =>
            int.tryParse(state.pathParameters['id']!) == null ? '/' : null,
        builder: (context, state) => RecipeScreen(
          recipeId: int.parse(state.pathParameters['id']!),
          servings: _servings(state),
        ),
        routes: [
          // A sub-route, so a link straight into cooking mode still has the
          // recipe below it to return to.
          GoRoute(
            path: 'cook',
            builder: (context, state) => CookingScreen(
              recipeId: int.parse(state.pathParameters['id']!),
              servings: _servings(state),
            ),
          ),
          GoRoute(
            path: 'cooked',
            builder: (context, state) => CookLogScreen(
              recipeId: int.parse(state.pathParameters['id']!),
              servings: _servings(state),
            ),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) =>
                EditorScreen(recipeId: int.parse(state.pathParameters['id']!)),
            onExit: confirmEditorExit,
          ),
        ],
      ),
      if (kDebugMode)
        GoRoute(
          path: '/debug/tokens',
          builder: (context, state) => const TokenGalleryScreen(),
        ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    session.dispose();
  });
  return router;
}

/// The tabs of the main navigation (Start, Suchen, Planer, Einkauf) in
/// [AppShell], each with its own navigator. Routes outside it, like the
/// recipe, cover the whole screen; back from them returns to the tab they
/// were opened from.
StatefulShellRoute tabsRoute() => StatefulShellRoute(
  builder: (context, state, shell) => AppShell(shell: shell),
  navigatorContainerBuilder: (context, shell, children) =>
      TabStack(currentIndex: shell.currentIndex, children: children),
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: homePath,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: searchPath,
          builder: (context, state) =>
              SearchScreen(query: searchQueryFromUri(state.uri)),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: planPath,
          builder: (context, state) => PlannerScreen(
            day: CalendarDay.tryParse(state.uri.queryParameters['day'] ?? ''),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: shoppingPath,
          builder: (context, state) => const ShoppingScreen(),
        ),
      ],
    ),
  ],
);

/// The `?servings=` chosen on the recipe screen or planned for a meal, `null`
/// if missing or invalid.
int? _servings(GoRouterState state) =>
    switch (int.tryParse(state.uri.queryParameters['servings'] ?? '')) {
      final servings? when servings >= 1 => servings,
      _ => null,
    };

/// Shown while the stored session is read at start.
const loadingPath = '/loading';

/// Where to go instead of [location] for this [session] state, or `null` to
/// stay: login while nobody is logged in, away from login once someone is.
@visibleForTesting
String? sessionRedirect(AsyncValue<Session?> session, Uri location) {
  final path = location.path;
  if (path.startsWith('/debug/')) return null;
  if (!session.hasValue && session.isLoading) {
    if (path == loadingPath) return null;
    return Uri(
      path: loadingPath,
      queryParameters: {'from': location.toString()},
    ).toString();
  }
  if (session.value == null) return path == '/login' ? null : '/login';
  if (path == '/login') return '/';
  if (path == loadingPath) return _localPath(location.queryParameters['from']);
  return null;
}

/// [from] if it is a path in the app, so `?from=` can't lead elsewhere.
String _localPath(String? from) =>
    from != null && from.startsWith('/') && !from.startsWith('//') ? from : '/';
