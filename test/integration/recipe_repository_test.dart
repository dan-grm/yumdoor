@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_repositories.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/repositories/recipe_repository.dart';

import '../../tool/seed/data.dart';
import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  late TandoorRepositories repositories;
  late RecipeRepository recipes;

  setUp(() {
    repositories = TandoorRepositories(
      TandoorConnection(tandoor.baseUrl, tandoor.token('anna')),
    );
    recipes = repositories.recipes;
  });
  tearDown(() => repositories.close());

  Future<int> foodId(String name) async {
    final foods = await repositories.foods.autocomplete(name);
    return foods.singleWhere((f) => f.name == name).id;
  }

  Future<int> keywordId(String name) async {
    final keywords = await repositories.keywords.autocomplete(name);
    return keywords.singleWhere((k) => k.name == name).id;
  }

  Future<Set<String>> names(RecipeQuery query) async {
    final page = await recipes.search(query, pageSize: 100);
    expect(page.hasMore, isFalse);
    return {for (final recipe in page.items) recipe.name};
  }

  test('pages through all recipes', () async {
    final all = <RecipeSummary>[];
    var page = 1;
    while (true) {
      final result = await recipes.search(
        const RecipeQuery(),
        page: page++,
        pageSize: 10,
      );
      expect(result.totalCount, seedRecipes.length);
      all.addAll(result.items);
      if (!result.hasMore) break;
    }

    expect(page - 1, (seedRecipes.length / 10).ceil());
    expect(
      all.map((r) => r.name).toSet(),
      seedRecipes.map((r) => r.name).toSet(),
    );
  });

  test('throws NotFoundFailure for a page past the end', () {
    expect(
      recipes.search(const RecipeQuery(), page: 99, pageSize: 100),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('finds recipes by name', () async {
    expect(
      await names(const RecipeQuery(text: 'karottensuppe')),
      contains('Karottensuppe mit Ingwer'),
    );
  });

  test('filters by food, including child foods', () async {
    final query = RecipeQuery(foodIds: {await foodId('Wurzelgemüse')});

    final expected = seedRecipesWithAnyFood(
      seedFoodWithChildren('Wurzelgemüse'),
    );
    expect(expected, isNotEmpty);
    expect(await names(query), expected);
  });

  test('the carrot filter finds the carrot recipes', () async {
    final query = RecipeQuery(foodIds: {await foodId('Karotte')});

    final expected = seedRecipesWithAnyFood(seedFoodWithChildren('Karotte'));
    expect(expected, isNotEmpty);
    expect(await names(query), expected);
  });

  test('filters by the current user\'s rating', () async {
    final page = await recipes.search(
      const RecipeQuery(minRating: 4),
      pageSize: 100,
    );

    expect(page.items, isNotEmpty);
    for (final recipe in page.items) {
      expect(recipe.rating, greaterThanOrEqualTo(4), reason: recipe.name);
    }
  });

  test('requires every selected food', () async {
    final query = RecipeQuery(
      foodIds: {await foodId('Karotte'), await foodId('Zwiebel')},
    );

    final expected = seedRecipesWithAnyFood({'Karotte'})
        .intersection(seedRecipesWithAnyFood({'Zwiebel'}));
    expect(expected, isNotEmpty);
    expect(await names(query), expected);
  });

  test('filters by keyword', () async {
    final query = RecipeQuery(keywordIds: {await keywordId('Suppe')});

    final expected = {
      for (final recipe in seedRecipes)
        if (recipe.keywords.contains('Suppe')) recipe.name,
    };
    expect(expected, isNotEmpty);
    expect(await names(query), expected);
  });

  test('loads a recipe with per-step ingredients', () async {
    final seed = seedRecipes.singleWhere(
      (r) => r.name == 'Apfelkuchen vom Blech',
    );
    final summary = (await recipes.search(RecipeQuery(text: seed.name))).items
        .singleWhere((r) => r.name == seed.name);

    final recipe = await recipes.fetchRecipe(summary.id);

    expect(recipe.name, seed.name);
    expect(recipe.servings, seed.servings);
    expect(recipe.workingTime, Duration(minutes: seed.workingTime));
    expect(recipe.waitingTime, Duration(minutes: seed.waitingTime));
    expect(recipe.createdBy?.name, 'Anna');
    expect(recipe.keywords.map((k) => k.name).toSet(), seed.keywords.toSet());
    expect(
      recipe.steps.map((s) => s.instruction),
      seed.steps.map((s) => s.instruction),
    );
    expect(
      recipe.steps.map((s) => s.time),
      seed.steps.map((s) => Duration(minutes: s.time)),
    );
    for (final (i, step) in recipe.steps.indexed) {
      final seedIngredients = seed.steps[i].ingredients;
      expect(step.ingredients.map((x) => x.food?.name), [
        for (final x in seedIngredients) x.food,
      ]);
      expect(step.ingredients.map((x) => x.isHeader), [
        for (final x in seedIngredients) x.isHeader,
      ]);
      expect(step.ingredients.map((x) => x.amount), [
        for (final x in seedIngredients) x.amount.toDouble(),
      ]);
    }
  });

  test('throws NotFoundFailure for a missing recipe', () {
    expect(recipes.fetchRecipe(999999999), throwsA(isA<NotFoundFailure>()));
  });

  test('throws UnauthorizedFailure for an invalid token', () async {
    final invalid = TandoorRepositories(
      TandoorConnection(
        tandoor.baseUrl,
        'tda_00000000_0000_0000_0000_000000000000',
      ),
    );
    addTearDown(invalid.close);

    await expectLater(
      invalid.recipes.search(const RecipeQuery()),
      throwsA(isA<UnauthorizedFailure>()),
    );
  });
}
