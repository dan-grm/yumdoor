import 'package:freezed_annotation/freezed_annotation.dart';

import 'meal_plan.dart';
import 'unit.dart';
import 'user_ref.dart';

part 'shopping.freezed.dart';

/// A section of a supermarket, such as "Obst & Gemüse". Foods have at most
/// one.
@freezed
abstract class SupermarketCategory with _$SupermarketCategory {
  const factory SupermarketCategory({required int id, required String name}) =
      _SupermarketCategory;
}

/// A supermarket and the order of its categories, for walking through it.
@freezed
abstract class Supermarket with _$Supermarket {
  const factory Supermarket({
    required int id,
    required String name,

    /// The ids of its categories, in the order they come in the store.
    /// Categories not in it come after these.
    @Default(<int>[]) List<int> categoryIds,
  }) = _Supermarket;
}

/// The food of a [ShoppingEntry], with what the list needs to group it.
@freezed
abstract class ShoppingFood with _$ShoppingFood {
  const factory ShoppingFood({
    required int id,
    required String name,
    String? pluralName,

    /// `null` for a food without one; it is grouped as uncategorized.
    SupermarketCategory? category,
  }) = _ShoppingFood;
}

/// The recipe a [ShoppingEntry] was added for.
@freezed
abstract class ShoppingEntrySource with _$ShoppingEntrySource {
  const factory ShoppingEntrySource({
    /// The recipe on the shopping list (Tandoor's `ShoppingListRecipe`). All
    /// entries added for the recipe at once share it.
    required int listRecipeId,

    /// `null` if Tandoor links no recipe.
    int? recipeId,

    /// The recipe's name; empty if Tandoor sends none.
    @Default('') String recipeName,

    /// The servings the amounts were scaled to.
    required double servings,

    /// The meal plan it was added for, if any.
    MealPlan? mealPlan,
  }) = _ShoppingEntrySource;
}

/// One line on the shopping list of the current user's household.
@freezed
abstract class ShoppingEntry with _$ShoppingEntry {
  const factory ShoppingEntry({
    required int id,
    required ShoppingFood food,

    /// `null` for an entry without a unit, such as "2 Eier".
    Unit? unit,

    /// 0 for an entry without an amount.
    required double amount,
    @Default(false) bool checked,

    /// When it was checked off; `null` while it is unchecked.
    DateTime? completedAt,

    /// When it last changed on the server, including being checked off.
    required DateTime updatedAt,
    required UserRef createdBy,

    /// `null` for an item added by hand.
    ShoppingEntrySource? source,
  }) = _ShoppingEntry;
}

/// The shopping list as read from the server.
@freezed
abstract class ShoppingListSnapshot with _$ShoppingListSnapshot {
  const factory ShoppingListSnapshot({
    /// Unchecked entries and entries checked within the user's "recent days"
    /// setting, oldest first. After an incremental read, only the entries
    /// changed since then.
    required List<ShoppingEntry> entries,

    /// Pass this as `updatedAfter` to the next read to get only what changed
    /// since this one. Slightly before the read, so nothing is missed;
    /// entries may come again.
    required DateTime syncedAt,

    /// Whether the server cut the list off at [maxShoppingEntries]. It keeps
    /// the oldest entries, so the newest are missing.
    @Default(false) bool truncated,
  }) = _ShoppingListSnapshot;
}

/// The most entries Tandoor returns for one read of the shopping list.
const maxShoppingEntries = 1000;
