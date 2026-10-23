import 'dart:async';

import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/result_page.dart';
import 'package:yumdoor/domain/repositories/recipe_repository.dart';

/// A [RecipeRepository.search] call, as the fake received it.
typedef SearchCall = ({
  RecipeQuery query,
  int page,
  int pageSize,
  CancelSignal? cancel,
});

/// [RecipeRepository] for tests, answering from [recipes]. Set [failure] to
/// make every call throw it.
///
/// Search matches the text against names, foods against the ingredients
/// (without child foods) and keywords against the recipe's keywords, in the
/// order of [recipes].
class FakeRecipeRepository implements RecipeRepository {
  FakeRecipeRepository(Iterable<Recipe> recipes)
    : recipes = {for (final r in recipes) r.id: r};

  final Map<int, Recipe> recipes;
  Failure? failure;
  int fetchCount = 0;
  final searches = <SearchCall>[];

  /// While set, searches wait for it before answering.
  Completer<void>? gate;

  @override
  Future<Recipe> fetchRecipe(int id) async {
    fetchCount++;
    if (failure case final failure?) throw failure;
    return recipes[id] ?? (throw const NotFoundFailure());
  }

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) async {
    searches.add((
      query: query,
      page: page,
      pageSize: pageSize,
      cancel: cancel,
    ));
    if (gate case final gate?) await gate.future;
    if (cancel?.isCancelled ?? false) throw const CancelledFailure();
    if (failure case final failure?) throw failure;

    final matches = recipes.values.where((r) => _matches(r, query)).toList();
    final start = (page - 1) * pageSize;
    if (page > 1 && start >= matches.length) throw const NotFoundFailure();
    final end = (start + pageSize).clamp(0, matches.length);
    return ResultPage(
      items: [for (final r in matches.sublist(start, end)) _summary(r)],
      totalCount: matches.length,
      hasMore: end < matches.length,
    );
  }

  static bool _matches(Recipe recipe, RecipeQuery query) {
    final foods = {
      for (final step in recipe.steps)
        for (final ingredient in step.ingredients) ?ingredient.food?.id,
    };
    final keywords = {for (final k in recipe.keywords) k.id};
    return recipe.name.toLowerCase().contains(query.text.toLowerCase()) &&
        foods.containsAll(query.foodIds) &&
        keywords.containsAll(query.keywordIds);
  }

  static RecipeSummary _summary(Recipe recipe) => RecipeSummary(
    id: recipe.id,
    name: recipe.name,
    description: recipe.description,
    image: recipe.image,
    keywords: recipe.keywords,
    servings: recipe.servings,
    servingsText: recipe.servingsText,
    workingTime: recipe.workingTime,
    waitingTime: recipe.waitingTime,
    rating: recipe.rating,
    lastCooked: recipe.lastCooked,
  );
}
