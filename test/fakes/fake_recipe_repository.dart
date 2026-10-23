import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/result_page.dart';
import 'package:yumdoor/domain/repositories/recipe_repository.dart';

/// [RecipeRepository] for tests, answering from [recipes]. Set [failure] to
/// make every call throw it.
class FakeRecipeRepository implements RecipeRepository {
  FakeRecipeRepository(Iterable<Recipe> recipes)
    : recipes = {for (final r in recipes) r.id: r};

  final Map<int, Recipe> recipes;
  Failure? failure;
  int fetchCount = 0;

  @override
  Future<Recipe> fetchRecipe(int id) async {
    fetchCount++;
    if (failure case final failure?) throw failure;
    return recipes[id] ?? (throw const NotFoundFailure());
  }

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
  }) => throw UnimplementedError();
}
