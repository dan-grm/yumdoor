import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/keyword_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../api/image_downloader.dart';
import '../api/tandoor_dio.dart';
import '../cache/caching_recipe_repository.dart';
import '../cache/recipe_cache.dart';
import 'tandoor_food_repository.dart';
import 'tandoor_keyword_repository.dart';
import 'tandoor_recipe_repository.dart';

/// The repositories for one logged-in [TandoorConnection], sharing one [Dio].
///
/// See [createTandoorDio] for [csrfToken], [onUnauthorized] and
/// [onReachable]. With a [cache], recipes fall back to it offline (see
/// [CachingRecipeRepository]).
class TandoorRepositories {
  factory TandoorRepositories(
    TandoorConnection connection, {
    String? Function()? csrfToken,
    void Function()? onUnauthorized,
    void Function(bool reachable)? onReachable,
    RecipeCache? cache,
  }) {
    final dio = createTandoorDio(
      connection.serverUrl,
      token: connection.token,
      csrfToken: csrfToken,
      onUnauthorized: onUnauthorized,
      onReachable: onReachable,
    );
    // An empty interceptor list keeps the generated auth interceptors out;
    // the Dio already has ours.
    final client = api.TandoorApi(dio: dio, interceptors: const []);
    return TandoorRepositories._(
      dio,
      client.getApiApi(),
      cache,
      cache == null ? null : ImageDownloader(),
    );
  }

  TandoorRepositories._(
    this._dio,
    api.ApiApi client,
    RecipeCache? cache,
    ImageDownloader? images,
  ) : _images = images,
      recipes = switch (cache) {
        final cache? => CachingRecipeRepository(
          TandoorRecipeRepository(client),
          cache,
          downloadImage: images?.download,
        ),
        null => TandoorRecipeRepository(client),
      },
      foods = TandoorFoodRepository(client),
      keywords = TandoorKeywordRepository(client);

  final Dio _dio;
  final ImageDownloader? _images;
  final RecipeRepository recipes;
  final FoodRepository foods;
  final KeywordRepository keywords;

  /// Cancels open requests and frees the connection pool.
  void close() {
    _dio.close(force: true);
    _images?.close();
  }
}
