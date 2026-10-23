import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
import '../../domain/models/recipe.dart';

part 'recipe_providers.g.dart';

/// The recipe with its steps, shared by the recipe screen and cooking mode.
///
/// Failures are shown with a retry button instead of retrying on their own.
@Riverpod(retry: _noRetry)
Future<Recipe> recipe(Ref ref, int id) =>
    ref.watch(recipeRepositoryProvider).fetchRecipe(id);

Duration? _noRetry(int retryCount, Object error) => null;
