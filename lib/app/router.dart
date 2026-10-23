import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../design/token_gallery.dart';
import '../domain/models/session.dart';
import '../features/auth/login_screen.dart';
import '../features/cooking/cooking_screen.dart';
import '../features/home/home_screen.dart';
import '../features/recipe/recipe_screen.dart';
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
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: loadingPath, builder: (context, state) => const Scaffold()),
      GoRoute(
        path: '/recipe/:id',
        redirect: (context, state) =>
            int.tryParse(state.pathParameters['id']!) == null ? '/' : null,
        builder: (context, state) =>
            RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
        routes: [
          // A sub-route, so a link straight into cooking mode still has the
          // recipe below it to return to.
          GoRoute(
            path: 'cook',
            builder: (context, state) => CookingScreen(
              recipeId: int.parse(state.pathParameters['id']!),
              servings: switch (int.tryParse(
                state.uri.queryParameters['servings'] ?? '',
              )) {
                final servings? when servings >= 1 => servings,
                _ => null,
              },
            ),
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
