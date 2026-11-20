import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/meal_plan.dart';
import '../../domain/models/shopping.dart';
import 'food_mapper.dart';
import 'mapping.dart';
import 'meal_plan_mapper.dart';
import 'user_mapper.dart';

extension SupermarketCategoryMapper on api.SupermarketCategory {
  SupermarketCategory toDomain() =>
      SupermarketCategory(id: requireId(id, 'SupermarketCategory'), name: name);
}

extension SupermarketMapper on api.Supermarket {
  /// The categories ordered by their `order`, ties by relation id (the order
  /// they were added in).
  Supermarket toDomain() {
    final relations = [...?categoryToSupermarket]
      ..sort((a, b) {
        final byOrder = (a.order ?? 0).compareTo(b.order ?? 0);
        return byOrder != 0 ? byOrder : (a.id ?? 0).compareTo(b.id ?? 0);
      });
    final categoryIds = <int>[];
    for (final relation in relations) {
      final id = requireId(relation.category.id, 'SupermarketCategory');
      if (!categoryIds.contains(id)) categoryIds.add(id);
    }
    return Supermarket(
      id: requireId(id, 'Supermarket'),
      name: name,
      categoryIds: categoryIds,
    );
  }
}

extension ShoppingFoodMapper on api.FoodShopping {
  ShoppingFood toDomain() => ShoppingFood(
    id: requireId(id, 'Food'),
    name: name,
    pluralName: optionalText(pluralName),
    category: supermarketCategory?.toDomain(),
  );
}

extension ShoppingEntrySourceMapper on api.ShoppingListRecipe {
  ShoppingEntrySource toDomain() => ShoppingEntrySource(
    listRecipeId: requireId(id, 'ShoppingListRecipe'),
    recipeId: recipe ?? recipeData?.id,
    // `name` is empty for entries added for a recipe; the recipe has it.
    recipeName: optionalText(recipeData?.name) ?? name ?? '',
    servings: servings,
    mealPlan: _mealPlan,
  );

  /// The entry still loads if its meal plan can't be mapped; only the link
  /// to the plan is lost.
  MealPlan? get _mealPlan {
    try {
      return mealPlanData?.toDomain();
    } on FormatException {
      return null;
    }
  }
}

extension ShoppingEntryMapper on api.ShoppingListEntry {
  ShoppingEntry toDomain() => ShoppingEntry(
    id: requireId(id, 'ShoppingListEntry'),
    food:
        food?.toDomain() ??
        (throw const FormatException('ShoppingListEntry without food')),
    unit: unit?.toDomain(),
    amount: amount,
    checked: checked ?? false,
    completedAt: completedAt,
    updatedAt:
        updatedAt ??
        (throw const FormatException('ShoppingListEntry without updated_at')),
    createdBy:
        createdBy?.toDomain() ??
        (throw const FormatException('ShoppingListEntry without owner')),
    source: listRecipeData?.toDomain(),
  );
}
