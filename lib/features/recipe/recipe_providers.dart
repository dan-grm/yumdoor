import 'dart:typed_data';

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

/// The bytes of the image at [url] from the offline cache, `null` if it
/// isn't stored.
@Riverpod(retry: _noRetry)
Future<Uint8List?> cachedImage(Ref ref, Uri url) =>
    ref.watch(offlineCacheProvider).image(url);

Duration? _noRetry(int retryCount, Object error) => null;
