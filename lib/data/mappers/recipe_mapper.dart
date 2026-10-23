import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_step.dart';
import '../../domain/models/recipe_summary.dart';
import 'food_mapper.dart';
import 'keyword_mapper.dart';
import 'mapping.dart';
import 'user_mapper.dart';

extension RecipeOverviewMapper on api.RecipeOverview {
  RecipeSummary toDomain() => RecipeSummary(
    id: requireId(id, 'Recipe'),
    name: name,
    description: description ?? '',
    image: optionalUri(image),
    keywords: [...?keywords?.map((k) => k.toDomain())],
    servings: servings ?? 1,
    servingsText: servingsText ?? '',
    workingTime: minutes(workingTime),
    waitingTime: minutes(waitingTime),
    rating: rating,
    lastCooked: lastCooked,
    createdBy: createdBy?.toDomain(),
    updatedAt: updatedAt,
  );
}

extension RecipeMapper on api.Recipe {
  Recipe toDomain() => Recipe(
    id: requireId(id, 'Recipe'),
    name: name,
    description: description ?? '',
    image: optionalUri(image),
    keywords: [...?keywords?.map((k) => k.toDomain())],
    servings: servings ?? 1,
    servingsText: servingsText ?? '',
    workingTime: minutes(workingTime),
    waitingTime: minutes(waitingTime),
    steps: [for (final step in steps) step.toDomain()],
    sourceUrl: optionalUri(sourceUrl),
    rating: rating,
    lastCooked: lastCooked,
    createdBy: createdBy?.toDomain(),
    updatedAt: updatedAt,
  );
}

extension StepMapper on api.Step {
  // `instructionsMarkdown` is server-rendered HTML for Tandoor's Vue frontend
  // and is deliberately not mapped (CLAUDE.md, rule 7).
  RecipeStep toDomain() => RecipeStep(
    id: requireId(id, 'Step'),
    name: name ?? '',
    instruction: instruction ?? '',
    ingredients: [for (final ingredient in ingredients) ingredient.toDomain()],
    time: minutes(time),
    order: order ?? 0,
    showAsHeader: showAsHeader ?? false,
  );
}

extension IngredientMapper on api.Ingredient {
  Ingredient toDomain() => Ingredient(
    id: requireId(id, 'Ingredient'),
    food: food?.toDomain(),
    unit: unit?.toDomain(),
    amount: amount,
    noAmount: noAmount ?? false,
    isHeader: isHeader ?? false,
    note: note ?? '',
    originalText: originalText,
    order: order ?? 0,
  );
}
