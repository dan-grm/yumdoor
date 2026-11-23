import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/repositories/shopping_repository.dart';
import 'package:yumdoor/domain/services/recipe_shopping.dart';

/// A [ShoppingRepository.addRecipe] call, as the fake received it.
typedef AddRecipeCall = ({int recipeId, double servings, int? mealPlanId});

/// [ShoppingRepository] for tests that records [addRecipe] calls. Set
/// [failure] to make it throw. The other methods aren't needed yet.
class FakeShoppingRepository implements ShoppingRepository {
  Failure? failure;

  /// Meal plan ids whose [addRecipe] throws [mealPlanFailure].
  final failMealPlanIds = <int>{};
  Failure mealPlanFailure = const ServerFailure();

  /// Called with the meal plan id of each [addRecipe] that succeeded, to let
  /// a test mark the plan as on the list.
  void Function(int mealPlanId)? onPlanAdded;

  /// The [addRecipe] calls that succeeded.
  final added = <AddRecipeCall>[];

  @override
  Future<RecipeShopping> addRecipe(
    Recipe recipe,
    double servings, {
    int? mealPlanId,
  }) async {
    if (failure case final failure?) throw failure;
    if (failMealPlanIds.contains(mealPlanId)) throw mealPlanFailure;
    added.add((
      recipeId: recipe.id,
      servings: servings,
      mealPlanId: mealPlanId,
    ));
    if (mealPlanId != null) onPlanAdded?.call(mealPlanId);
    return buildRecipeShopping(recipe, servings: servings);
  }

  @override
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) =>
      throw UnimplementedError();

  @override
  Future<void> setChecked(Set<int> ids, {required bool checked}) =>
      throw UnimplementedError();

  @override
  Future<List<Supermarket>> supermarkets() => throw UnimplementedError();

  @override
  Future<ShoppingEntry> addItem(int foodId, double amount, {int? unitId}) =>
      throw UnimplementedError();

  @override
  Future<void> deleteEntries(Iterable<ShoppingEntry> entries) =>
      throw UnimplementedError();
}
