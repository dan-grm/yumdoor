import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';
import '../../domain/models/recipe.dart';

part 'home_providers.g.dart';

/// The recipe of a meal planned for today, with its ingredients, to count
/// those that are missing. Offline it comes from the cache, which keeps the
/// recipes of plans that aren't over yet.
///
/// Unlike `recipeProvider`, loading it records no view: the start screen
/// shows the recipe, it doesn't open it. Failures aren't retried; the start
/// screen then leaves the count out.
@Riverpod(retry: _noRetry)
Future<Recipe> plannedRecipe(Ref ref, int id) =>
    ref.watch(recipeRepositoryProvider).fetchRecipe(id);

Duration? _noRetry(int retryCount, Object error) => null;
