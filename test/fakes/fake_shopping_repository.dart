import 'dart:async';

import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/domain/repositories/shopping_repository.dart';
import 'package:yumdoor/domain/services/recipe_shopping.dart';

/// A [ShoppingRepository.addRecipe] call, as the fake received it.
typedef AddRecipeCall = ({int recipeId, double servings, int? mealPlanId});

/// A [ShoppingRepository.setChecked] call, as the fake received it.
typedef SetCheckedCall = ({Set<int> ids, bool checked});

/// [ShoppingRepository] for tests: a list of [entries] that [fetch] returns
/// and [setChecked] changes, and [addRecipe] calls it records. Set
/// [failure] to make [addRecipe] throw, [fetchFailure] or [checkFailure]
/// for the others. [editFailure] fails [addItem] and [deleteEntries].
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

  /// Whether [fetch] reports the list as cut off at the server's maximum.
  bool truncated = false;
  Failure? checkFailure;

  /// Whether [checkFailure] fails only the next [setChecked].
  bool checkFailsOnce = false;

  /// How many times [fetch] was called.
  var fetchCalls = 0;

  /// The [setChecked] calls, in order, including failed ones.
  final checkCalls = <SetCheckedCall>[];

  /// Each [fetch] reads the list, then waits for the first of these, if
  /// any, before it answers.
  final fetchGates = <Completer<void>>[];

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

  /// The `updatedAfter` of each [fetch], in order; `null` for a full read.
  final fetchedAfter = <DateTime?>[];

  /// With `updatedAfter`, only the entries changed since then, as Tandoor
  /// does. [now] is the `syncedAt` for the next read.
  @override
  Future<ShoppingListSnapshot> fetch({DateTime? updatedAfter}) async {
    fetchCalls++;
    fetchedAfter.add(updatedAfter);
    if (fetchFailure case final failure?) throw failure;
    final read = [
      for (final entry in entries)
        if (updatedAfter == null || !entry.updatedAt.isBefore(updatedAfter))
          entry,
    ];
    if (fetchGates.isNotEmpty) await fetchGates.removeAt(0).future;
    return ShoppingListSnapshot(
      entries: read,
      syncedAt: now,
      truncated: truncated,
    );
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

  /// The foods [addItem] knows by id; others come as `Food 7` (with their id).
  final foods = <int, ShoppingFood>{};

  /// The units [addItem] knows by id; unknown ones are left out.
  final units = <int, Unit>{};

  /// Set to make [addItem] or [deleteEntries] throw.
  Failure? editFailure;

  /// The [addItem] calls that succeeded.
  final addedItems = <({int foodId, double amount, int? unitId})>[];

  /// The ids passed to [deleteEntries] that succeeded, in order.
  final deletedIds = <int>[];

  var _nextId = 1000;

  @override
  Future<ShoppingEntry> addItem(
    int foodId,
    double amount, {
    int? unitId,
  }) async {
    if (editFailure case final failure?) throw failure;
    addedItems.add((foodId: foodId, amount: amount, unitId: unitId));
    final entry = ShoppingEntry(
      id: _nextId++,
      food: foods[foodId] ?? ShoppingFood(id: foodId, name: 'Food $foodId'),
      unit: units[unitId],
      amount: amount,
      updatedAt: now,
      createdBy: const UserRef(id: 1, name: 'Anna'),
    );
    entries.add(entry);
    return entry;
  }

  @override
  Future<void> deleteEntries(Iterable<ShoppingEntry> toDelete) async {
    if (editFailure case final failure?) throw failure;
    final ids = {for (final e in toDelete) e.id};
    deletedIds.addAll(ids);
    entries.removeWhere((e) => ids.contains(e.id));
  }
}
