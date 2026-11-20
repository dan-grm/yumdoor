import '../models/recipe.dart';
import 'scaling_service.dart';

/// Decides which ingredients of a recipe go on the shopping list, and how
/// much, so every place that adds a recipe to the list agrees.
///
/// Like Tandoor's own frontend, it builds one entry per ingredient; amounts
/// are not merged across ingredients or recipes. It skips:
///
/// - headers and free-text lines without a food;
/// - foods marked `ignoreShopping` (salt, water);
/// - foods someone in the household has on hand, counted in
///   [RecipeShopping.onHandCount].
///
/// `noAmount` ingredients ("Salz und Pfeffer") are added with amount 0.
///
/// Limitation: a step that is another recipe is not expanded; only the
/// ingredients listed in this recipe's own steps are added.
RecipeShopping buildRecipeShopping(Recipe recipe, {required int servings}) {
  final scaling = ScalingService(
    recipeServings: recipe.servings,
    servings: servings,
  );
  final entries = <ShoppingEntryDraft>[];
  var onHand = 0;
  for (final step in recipe.steps) {
    for (final ingredient in step.ingredients) {
      final food = ingredient.food;
      if (ingredient.isHeader || food == null || food.ignoreShopping) continue;
      if (food.onHand) {
        onHand++;
        continue;
      }
      entries.add(
        ShoppingEntryDraft(
          ingredientId: ingredient.id,
          foodId: food.id,
          unitId: ingredient.unit?.id,
          amount: ingredient.noAmount || ingredient.amount <= 0
              ? 0
              : ingredient.amount * scaling.factor,
        ),
      );
    }
  }
  return RecipeShopping(
    entries: List.unmodifiable(entries),
    onHandCount: onHand,
  );
}

/// What adding a recipe to the shopping list creates, with counts for the UI.
class RecipeShopping {
  const RecipeShopping({required this.entries, required this.onHandCount});

  /// The entries to create, in recipe order.
  final List<ShoppingEntryDraft> entries;

  /// Ingredients left out because their food is on hand ("hast du schon").
  final int onHandCount;

  /// Ingredients that go on the list.
  int get neededCount => entries.length;

  /// Whether there is nothing to add, though there may be [onHandCount]
  /// ingredients at home.
  bool get isEmpty => entries.isEmpty;
}

/// One shopping list entry to create for a recipe ingredient.
class ShoppingEntryDraft {
  const ShoppingEntryDraft({
    required this.ingredientId,
    required this.foodId,
    required this.unitId,
    required this.amount,
  });

  final int ingredientId;
  final int foodId;

  /// `null` for an ingredient without a unit.
  final int? unitId;

  /// Scaled to the chosen servings, unrounded; 0 for `noAmount` ingredients.
  final double amount;

  @override
  bool operator ==(Object other) =>
      other is ShoppingEntryDraft &&
      other.ingredientId == ingredientId &&
      other.foodId == foodId &&
      other.unitId == unitId &&
      other.amount == amount;

  @override
  int get hashCode => Object.hash(ingredientId, foodId, unitId, amount);

  @override
  String toString() =>
      'ShoppingEntryDraft(ingredient: $ingredientId, food: $foodId, '
      'unit: $unitId, amount: $amount)';
}
