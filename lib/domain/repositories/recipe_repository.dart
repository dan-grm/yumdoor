import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/image_upload.dart';
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
  ///
  /// When the server can't be reached, a copy stored for offline use is
  /// returned if there is one. With [allowCached] `false` it throws
  /// [OfflineFailure] instead, e.g. for the editor, which must not save an
  /// old copy over newer changes.
  Future<Recipe> fetchRecipe(int id, {bool allowCached = true});

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

  /// Deletes the recipe [id] for good, with what belongs to it on the server:
  /// its cook log entries, meal plans, book entries and shopping list
  /// entries. Throws [NotFoundFailure] if it doesn't exist or the user can't
  /// see it, [UnauthorizedFailure] if they may not delete it (Tandoor can't
  /// tell that apart from an invalid token), a [ServerFailure] if the server
  /// refuses, which it does for a recipe that another recipe uses as a step.
  Future<void> deleteRecipe(int id);

  /// Makes [image] the photo of the recipe [id], replacing the one it had,
  /// and returns its URL, the recipe's new [Recipe.image]. Tandoor scales
  /// images over 500 KB down to 1020 px wide. Throws [NotFoundFailure] if
  /// the recipe doesn't exist, [UnauthorizedFailure] if the user may not
  /// change it, a [ServerFailure] with status 413 if a proxy in front of
  /// Tandoor refuses the size.
  Future<Uri> uploadImage(int id, ImageUpload image);

  /// Removes the photo of the recipe [id]. Throws like [uploadImage].
  Future<void> removeImage(int id);
}
