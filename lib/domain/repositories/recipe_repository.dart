import '../../core/failures.dart';
import '../models/recipe.dart';
import '../models/recipe_query.dart';
import '../models/recipe_summary.dart';
import '../models/result_page.dart';

/// Recipes of the current space. Methods throw a [Failure].
abstract interface class RecipeRepository {
  /// Recipes matching [query], in the server's order. [page] starts at 1;
  /// [pageSize] is at most 100.
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
  });

  /// The recipe with its steps. Throws [NotFoundFailure] if it doesn't exist
  /// or the user can't see it.
  Future<Recipe> fetchRecipe(int id);
}
