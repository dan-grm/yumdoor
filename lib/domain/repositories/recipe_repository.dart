import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/recipe.dart';
import '../models/recipe_draft.dart';
import '../models/recipe_query.dart';
import '../models/recipe_summary.dart';
import '../models/result_page.dart';

/// Recipes of the current space. Methods throw a [Failure].
abstract interface class RecipeRepository {
  /// Recipes matching [query], in the server's order. [page] starts at 1;
  /// [pageSize] is at most 100. [cancel] aborts the request.
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  });

  /// The recipe with its steps. Throws [NotFoundFailure] if it doesn't exist
  /// or the user can't see it.
  Future<Recipe> fetchRecipe(int id);

  /// Notes that the current user opened the recipe, for the "recently
  /// viewed" order. Only the user sees their views.
  Future<void> recordView(int id);

  /// Creates a recipe from [draft] and returns it as saved.
  Future<Recipe> createRecipe(RecipeDraft draft);

  /// Saves [draft] over the recipe [id] and returns it as saved. Only what a
  /// [RecipeDraft] holds changes; the rest of the recipe stays as it is.
  /// Steps and ingredients missing from [draft] are removed, those without
  /// an id are added. Throws [NotFoundFailure] if the recipe doesn't exist
  /// or the user can't see it, [UnauthorizedFailure] if they may not change
  /// it (Tandoor can't tell that apart from an invalid token).
  Future<Recipe> updateRecipe(int id, RecipeDraft draft);
}
