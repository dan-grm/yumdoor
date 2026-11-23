import 'dart:async';

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/repositories/shopping_repository.dart';
import 'package:yumdoor/domain/services/recipe_shopping.dart';

/// A [ShoppingRepository.addRecipe] call, as the fake received it.
typedef AddRecipeCall = ({int recipeId, double servings, int? mealPlanId});

/// A [ShoppingRepository.setChecked] call, as the fake received it.
typedef SetCheckedCall = ({Set<int> ids, bool checked});

/// [ShoppingRepository] for tests: a list of [entries] that [fetch] returns
/// and [setChecked] changes, and [addRecipe] calls it records. Set
/// [failure] to make [addRecipe] throw, [fetchFailure] or [checkFailure]
/// for the others. [addItem] and [deleteEntries] aren't needed yet.
class FakeShoppingRepository implements ShoppingRepository {
  FakeShoppingRepository({
    List<ShoppingEntry> entries = const [],
    this.supermarketList = const [],
  }) : entries = [...entries];

  Failure? failure;

  /// The household's list, as the server has it.
  final List<ShoppingEntry> entries;

  /// What [supermarkets] returns.
  List<Supermarket> supermarketList;

  Failure? fetchFailure;
  Failure? checkFailure;

  /// Whether [checkFailure] fails only the next [setChecked].
  bool checkFailsOnce = false;

  /// How many times [fetch] was called.
  var fetchCalls = 0;

  /// The [setChecked] calls, in order, including failed ones.
  final checkCalls = <SetCheckedCall>[];

  /// While set, [setChecked] waits for it before it answers.
  Completer<void>? checkGate;

  /// The time [setChecked] stamps entries with.
  DateTime now = DateTime.utc(2026, 11, 18, 12);

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
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) async {
    fetchCalls++;
    if (fetchFailure case final failure?) throw failure;
    return ShoppingListSnapshot(entries: [...entries], syncedAt: now);
  }

  @override
  Future<void> setChecked(Set<int> ids, {required bool checked}) async {
    checkCalls.add((ids: ids, checked: checked));
    if (checkGate case final gate?) await gate.future;
    if (checkFailure case final failure?) {
      if (checkFailsOnce) checkFailure = null;
      throw failure;
    }
    for (final (index, entry) in entries.indexed) {
      if (!ids.contains(entry.id)) continue;
      entries[index] = entry.copyWith(
        checked: checked,
        completedAt: checked ? now : null,
        updatedAt: now,
      );
    }
  }

  @override
  Future<List<Supermarket>> supermarkets() async => supermarketList;

  @override
  Future<ShoppingEntry> addItem(int foodId, double amount, {int? unitId}) =>
      throw UnimplementedError();

  @override
  Future<void> deleteEntries(Iterable<ShoppingEntry> entries) =>
      throw UnimplementedError();
}
