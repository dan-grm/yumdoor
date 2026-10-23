import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/api/tandoor_dio.dart';
import '../data/repositories/tandoor_repositories.dart';
import '../data/repositories/tandoor_server_repository.dart';
import '../domain/repositories/food_repository.dart';
import '../domain/repositories/keyword_repository.dart';
import '../domain/repositories/recipe_repository.dart';
import '../domain/repositories/server_repository.dart';

part 'repository_providers.g.dart';

// Repositories for features. Tests override these with fakes.

@Riverpod(keepAlive: true)
ServerRepository serverRepository(Ref ref) => TandoorServerRepository();

/// The server and token of the current session.
///
/// Login (#10) overrides this with the session; until then nobody is logged
/// in and reading it throws.
@Riverpod(keepAlive: true)
TandoorConnection tandoorConnection(Ref ref) =>
    throw StateError('Not logged in to a Tandoor server.');

@Riverpod(keepAlive: true)
TandoorRepositories _tandoorRepositories(Ref ref) {
  final repositories = TandoorRepositories(
    ref.watch(tandoorConnectionProvider),
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
