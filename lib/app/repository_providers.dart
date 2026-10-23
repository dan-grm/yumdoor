import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/api/tandoor_dio.dart';
import '../data/repositories/tandoor_auth_repository.dart';
import '../data/repositories/tandoor_repositories.dart';
import '../data/repositories/tandoor_server_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/food_repository.dart';
import '../domain/repositories/keyword_repository.dart';
import '../domain/repositories/recipe_repository.dart';
import '../domain/repositories/server_repository.dart';
import 'platform_providers.dart';
import 'session.dart';

part 'repository_providers.g.dart';

// Repositories for features. Tests override these with fakes.

@Riverpod(keepAlive: true)
ServerRepository serverRepository(Ref ref) => TandoorServerRepository();

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    TandoorAuthRepository(csrfToken: ref.watch(csrfTokenSourceProvider).read);

/// The server and token of the current session.
///
/// Reading it throws while nobody is logged in; the router keeps every screen
/// that needs it behind login.
@Riverpod(keepAlive: true)
TandoorConnection tandoorConnection(Ref ref) {
  final session = ref.watch(sessionControllerProvider).value;
  if (session == null) {
    throw StateError('Not logged in to a Tandoor server.');
  }
  return TandoorConnection(session.serverUrl, session.token);
}

@Riverpod(keepAlive: true)
TandoorRepositories _tandoorRepositories(Ref ref) {
  final repositories = TandoorRepositories(
    ref.watch(tandoorConnectionProvider),
    csrfToken: ref.watch(csrfTokenSourceProvider).read,
    onUnauthorized: () {
      if (ref.mounted) {
        ref.read(sessionControllerProvider.notifier).checkToken();
      }
    },
  );
  ref.onDispose(repositories.close);
  return repositories;
}

@Riverpod(keepAlive: true)
RecipeRepository recipeRepository(Ref ref) =>
    ref.watch(_tandoorRepositoriesProvider).recipes;

@Riverpod(keepAlive: true)
FoodRepository foodRepository(Ref ref) =>
    ref.watch(_tandoorRepositoriesProvider).foods;

@Riverpod(keepAlive: true)
KeywordRepository keywordRepository(Ref ref) =>
    ref.watch(_tandoorRepositoriesProvider).keywords;
