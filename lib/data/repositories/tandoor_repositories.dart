import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/keyword_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../api/tandoor_dio.dart';
import 'tandoor_food_repository.dart';
import 'tandoor_keyword_repository.dart';
import 'tandoor_recipe_repository.dart';

/// The repositories for one logged-in [TandoorConnection], sharing one [Dio].
///
/// See [createTandoorDio] for [csrfToken] and [onUnauthorized].
class TandoorRepositories {
  factory TandoorRepositories(
    TandoorConnection connection, {
    String? Function()? csrfToken,
    void Function()? onUnauthorized,
  }) {
    final dio = createTandoorDio(
      connection.serverUrl,
      token: connection.token,
      csrfToken: csrfToken,
      onUnauthorized: onUnauthorized,
    );
    // An empty interceptor list keeps the generated auth interceptors out;
    // the Dio already has ours.
    final client = api.TandoorApi(dio: dio, interceptors: const []);
    return TandoorRepositories._(dio, client.getApiApi());
  }

  TandoorRepositories._(this._dio, api.ApiApi client)
    : recipes = TandoorRecipeRepository(client),
      foods = TandoorFoodRepository(client),
      keywords = TandoorKeywordRepository(client);

  final Dio _dio;
  final RecipeRepository recipes;
  final FoodRepository foods;
  final KeywordRepository keywords;

  /// Cancels open requests and frees the connection pool.
  void close() => _dio.close(force: true);
}
