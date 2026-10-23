import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../design/token_gallery.dart';
import '../features/home/home_screen.dart';
import '../features/recipe/recipe_screen.dart';

part 'router.g.dart';

/// App-wide [GoRouter]. Kept alive so navigation state survives rebuilds.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/recipe/:id',
        redirect: (context, state) =>
            int.tryParse(state.pathParameters['id']!) == null ? '/' : null,
        builder: (context, state) =>
            RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
      ),
      if (kDebugMode)
        GoRoute(
          path: '/debug/tokens',
          builder: (context, state) => const TokenGalleryScreen(),
        ),
    ],
  );
}
