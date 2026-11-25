import '../../core/failures.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../models/shopping.dart';
import '../services/recipe_shopping.dart';

/// The shopping list of the current user's household. Methods throw a
/// [Failure].
abstract interface class ShoppingRepository {
  /// Reads the shopping list: entries of the current user and everyone in
  /// their household.
  ///
  /// With [updatedAfter] (a previous [ShoppingListSnapshot.syncedAt]), only
  /// the entries created, changed, checked or unchecked since then, by
  /// anyone in the household. Deleted entries are not reported, so read the
  /// whole list now and then.
  ///
  /// When the server can't be reached, a full read may answer with the list
  /// as last read, from the offline cache ([ShoppingListSnapshot.cachedAt]);
  /// an incremental read fails.
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter});

  /// Checks off ([checked] `true`) or unchecks the entries with [ids].
  /// Ids the household doesn't have are ignored.
  Future<void> setChecked(Set<int> ids, {required bool checked});

  /// The supermarkets of the space with their category order.
  Future<List<Supermarket>> supermarkets();

  /// Puts the ingredients of [recipe] for [servings] on the list, as
  /// [buildRecipeShopping] picks them, linked to the meal plan [mealPlanId]
  /// if given. The plan is then [MealPlan.onShoppingList].
  ///
  /// Returns what was added and how many ingredients were on hand. When
  /// there is nothing to add ([RecipeShopping.isEmpty]), nothing is created
  /// and the plan is not marked. If adding fails, the recipe is taken off the
  /// list again where the server can be reached, so a retry doesn't add it
  /// twice; read the list again before retrying.
  ///
  /// For a meal plan, pass its servings: Tandoor rescales the entries to
  /// them whenever the plan is saved. Skip plans that are
  /// [MealPlan.onShoppingList]; adding one again adds its ingredients twice.
  /// Rarely (a failed add whose cleanup failed, too) a plan is marked
  /// without entries on the list; adding it again is fine then.
  /// The on-hand flags come from [recipe], so pass a freshly read one.
  Future<RecipeShopping> addRecipe(
    Recipe recipe,
    double servings, {
    int? mealPlanId,
  });

  /// Adds [amount] (0 for none) of the food [foodId] in [unitId] (`null` for
  /// none) by hand, without a recipe.
  Future<ShoppingEntry> addItem(int foodId, double amount, {int? unitId});

  /// Renames [entries] to [name] for the whole household and returns the
  /// ones that changed, as changed. They are moved to the space's food
  /// called [name] (Tandoor matches its name or plural name, ignoring case)
  /// or, if there is none, to a new food of that name, in the supermarket
  /// category of the first entry's food. Entries of that food already stay
  /// as they are, and so do entries that are checked off (or gone) on the
  /// server by now. The foods themselves keep their names and on-hand
  /// flags, so recipes don't change.
  Future<List<ShoppingEntry>> renameEntries(
    Iterable<ShoppingEntry> entries,
    String name,
  );

  /// Deletes [entries]; ones already gone are ignored. A meal plan left
  /// without entries on the list is no longer [MealPlan.onShoppingList], so
  /// it can be added again.
  Future<void> deleteEntries(Iterable<ShoppingEntry> entries);
}
