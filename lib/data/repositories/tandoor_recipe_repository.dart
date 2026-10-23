import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_summary.dart';
import '../../domain/models/result_page.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/recipe_mapper.dart';

class TandoorRecipeRepository implements RecipeRepository {
  TandoorRecipeRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
  }) => guardRequest(() async {
    final text = query.text.trim();
    final response = await _api.apiRecipeList(
      query: text.isEmpty ? null : text,
      // `foods_and` includes child foods (`include_children` defaults to
      // true), so filtering by "Wurzelgemüse" finds carrot recipes.
      foodsAnd: query.foodIds.isEmpty ? null : BuiltList.of(query.foodIds),
      keywordsAnd: query.keywordIds.isEmpty
          ? null
          : BuiltList.of(query.keywordIds),
      page: page,
      pageSize: pageSize,
    );
    final body = requireBody(response.data);
    return ResultPage(
      items: [for (final recipe in body.results) recipe.toDomain()],
      totalCount: body.count,
      hasMore: body.next != null,
    );
  });

  @override
  Future<Recipe> fetchRecipe(int id) => guardRequest(() async {
    final response = await _api.apiRecipeRetrieve(id: id);
    return requireBody(response.data).toDomain();
  });
}
