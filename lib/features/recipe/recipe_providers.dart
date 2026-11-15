import 'dart:async';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/offline.dart';
import '../../app/repository_providers.dart';
import '../../core/failures.dart';
import '../../domain/models/recipe.dart';

part 'recipe_providers.g.dart';

/// The recipe with its steps, shared by the recipe screen and cooking mode.
/// Loading it records a view for the "recently viewed" search order, like
/// opening a recipe in Tandoor; if that fails, it just isn't recorded.
///
/// Failures are shown with a retry button instead of retrying on their own.
@Riverpod(retry: _noRetry)
Future<Recipe> recipe(Ref ref, int id) async {
  final repository = ref.watch(recipeRepositoryProvider);
  final recipe = await repository.fetchRecipe(id);
  // Offline is read-only; a view then simply isn't recorded.
  if (!ref.read(isOfflineProvider)) {
    unawaited(_ignoreFailure(repository.recordView(id)));
  }
  return recipe;
}

Future<void> _ignoreFailure(Future<void> request) async {
  try {
    await request;
  } on Failure {
    // A missed view only makes the order less accurate.
  }
}

/// The bytes of the image at [url] from the offline cache, `null` if it
/// isn't stored.
@Riverpod(retry: _noRetry)
Future<Uint8List?> cachedImage(Ref ref, Uri url) =>
    ref.watch(offlineCacheProvider).image(url);

Duration? _noRetry(int retryCount, Object error) => null;
