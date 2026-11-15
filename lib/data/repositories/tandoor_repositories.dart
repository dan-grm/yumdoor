import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/repositories/cook_log_repository.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/keyword_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../api/image_downloader.dart';
import '../api/tandoor_dio.dart';
import '../cache/caching_recipe_repository.dart';
import '../cache/recipe_cache.dart';
import 'tandoor_cook_log_repository.dart';
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
    final apiClient = client.getApiApi();
    final cookLogs = TandoorCookLogRepository(apiClient);
    final remoteRecipes = TandoorRecipeRepository(
      apiClient,
      lastCooked: cookLogs.lastCooked,
    );
    final images = cache == null ? null : ImageDownloader();
    return TandoorRepositories._(
      dio,
      images,
      recipes: switch (cache) {
        final cache? => CachingRecipeRepository(
          remoteRecipes,
          cache,
          downloadImage: images?.download,
        ),
        null => remoteRecipes,
      },
      foods: TandoorFoodRepository(apiClient),
      keywords: TandoorKeywordRepository(apiClient),
      cookLogs: cookLogs,
    );
  }

  TandoorRepositories._(
    this._dio,
    this._images, {
    required this.recipes,
    required this.foods,
    required this.keywords,
    required this.cookLogs,
  });

  final Dio _dio;
  final ImageDownloader? _images;
  final RecipeRepository recipes;
  final FoodRepository foods;
  final KeywordRepository keywords;
  final CookLogRepository cookLogs;

  /// Cancels open requests and frees the connection pool.
  void close() {
    _dio.close(force: true);
    _images?.close();
  }
}
