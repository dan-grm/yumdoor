import 'dart:async';

import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/image_upload.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/result_page.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/repositories/recipe_repository.dart';
import 'package:yumdoor/domain/services/recipe_order.dart';

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
/// order of [recipes], or in the query's order if it has a [RecipeQuery.sort]
/// that summaries can be compared by (equal ones in the order of [recipes]).
/// Books match [bookEntries], saved searches [savedSearches] and
/// [savedFilters].
/// Like Tandoor, every part of the query must match.
class FakeRecipeRepository implements RecipeRepository {
  FakeRecipeRepository(Iterable<Recipe> recipes)
    : recipes = {for (final r in recipes) r.id: r};

  final Map<int, Recipe> recipes;
  Failure? failure;

  /// The recipes added to each book, by book id.
  Map<int, Set<int>> bookEntries = {};

  /// The recipes each dynamic book's saved search finds, by book id.
  Map<int, Set<int>> savedSearches = {};

  /// The recipes each saved filter finds, by filter id.
  Map<int, Set<int>> savedFilters = {};

  /// Makes the searches it returns `true` for throw [failure] instead of
  /// all of them.
  bool Function(RecipeQuery query)? failWhen;

  /// Marks search results as coming from the offline cache, which returns
  /// every match on one page.
  bool fromCache = false;
  int fetchCount = 0;

  /// The recipes [recordView] was called for, in order.
  final views = <int>[];
  final searches = <SearchCall>[];

  /// While set, searches wait for it before answering.
  Completer<void>? gate;

  /// Makes [fetchRecipe] answer as if offline with a stored copy: the
  /// recipe, or [OfflineFailure] when the caller doesn't allow cached ones.
  bool offline = false;

  @override
  Future<Recipe> fetchRecipe(int id, {bool allowCached = true}) async {
    fetchCount++;
    if (failure case final failure?) throw failure;
    if (offline && !allowCached) throw const OfflineFailure();
    return recipes[id] ?? (throw const NotFoundFailure());
  }

  /// The drafts saved, with the recipe id (`null` for a new one), in order.
  final saves = <({int? id, RecipeDraft draft})>[];

  @override
  Future<Recipe> createRecipe(RecipeDraft draft) async {
    saves.add((id: null, draft: draft));
    if (failure case final failure?) throw failure;
    final id = recipes.keys.fold(0, (a, b) => a > b ? a : b) + 1;
    return recipes[id] = _fromDraft(id, draft);
  }

  @override
  Future<Recipe> updateRecipe(int id, RecipeDraft draft) async {
    saves.add((id: id, draft: draft));
    if (failure case final failure?) throw failure;
    final recipe = recipes[id] ?? (throw const NotFoundFailure());
    return recipes[id] = _fromDraft(id, draft, recipe);
  }

  /// [draft] as saved over [recipe], with new ids for new steps and
  /// ingredients and for new foods, units and keywords.
  Recipe _fromDraft(int id, RecipeDraft draft, [Recipe? recipe]) {
    var nextId = 100000 + saves.length * 1000;
    int idOf(int? id) => id ?? nextId++;
    return (recipe ?? Recipe(id: id, name: draft.name)).copyWith(
      name: draft.name,
      description: draft.description,
      servings: draft.servings,
      servingsText: draft.servingsText,
      workingTime: draft.workingTime,
      waitingTime: draft.waitingTime,
      keywords: [
        for (final k in draft.keywords) Keyword(id: idOf(k.id), name: k.name),
      ],
      sourceUrl: draft.sourceUrl,
      steps: [
        for (final (order, step) in draft.steps.indexed)
          RecipeStep(
            id: idOf(step.id),
            name: step.name,
            instruction: step.instruction,
            time: step.time,
            order: order,
            ingredients: [
              for (final (order, i) in step.ingredients.indexed)
                Ingredient(
                  id: idOf(i.id),
                  food: switch (i.food) {
                    final f? => Food(id: idOf(f.id), name: f.name),
                    null => null,
                  },
                  unit: switch (i.unit) {
                    final u? => Unit(id: idOf(u.id), name: u.name),
                    null => null,
                  },
                  amount: i.amount,
                  noAmount: i.noAmount,
                  isHeader: i.isHeader,
                  note: i.note,
                  originalText: i.originalText,
                  order: order,
                ),
            ],
          ),
      ],
    );
  }

  /// The image uploads and removals, in order: the upload, or `null` for a
  /// removal.
  final imageChanges = <({int id, ImageUpload? image})>[];

  /// Makes [uploadImage] and [removeImage] throw it.
  Failure? imageFailure;

  /// Where the fake stores uploaded images.
  static Uri imageUrl(int id, int upload) =>
      Uri.parse('https://example.com/media/recipes/${upload}_$id.jpg');

  @override
  Future<Recipe> uploadImage(int id, ImageUpload image) =>
      _changeImage(id, image);

  @override
  Future<Recipe> removeImage(int id) => _changeImage(id, null);

  Future<Recipe> _changeImage(int id, ImageUpload? image) async {
    imageChanges.add((id: id, image: image));
    if (failure ?? imageFailure case final failure?) throw failure;
    final recipe = recipes[id] ?? (throw const NotFoundFailure());
    return recipes[id] = recipe.copyWith(
      image: image == null ? null : imageUrl(id, imageChanges.length),
    );
  }

  @override
  Future<void> recordView(int id) async {
    views.add(id);
    if (failure case final failure?) throw failure;
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
    if (failure case final failure? when failWhen?.call(query) ?? true) {
      throw failure;
    }

    final matches = recipes.values.where((r) => _matches(r, query)).toList();
    if (query.sort != null) {
      if (recipeOrder(query.effectiveSort) case final order?) {
        final position = {for (final (i, r) in matches.indexed) r.id: i};
        matches.sort((a, b) {
          final result = order(_summary(a), _summary(b));
          return result != 0 ? result : position[a.id]! - position[b.id]!;
        });
      }
    }
    if (fromCache) {
      if (page > 1) throw const OfflineFailure();
      return ResultPage(
        items: [for (final r in matches) _summary(r)],
        totalCount: matches.length,
        hasMore: false,
        fromCache: true,
      );
    }
    final start = (page - 1) * pageSize;
    if (page > 1 && start >= matches.length) throw const NotFoundFailure();
    final end = (start + pageSize).clamp(0, matches.length);
    return ResultPage(
      items: [for (final r in matches.sublist(start, end)) _summary(r)],
      totalCount: matches.length,
      hasMore: end < matches.length,
      fromCache: fromCache,
    );
  }

  bool _matches(Recipe recipe, RecipeQuery query) {
    if (query.bookIds.isNotEmpty &&
        !query.bookIds.any(
          (b) => bookEntries[b]?.contains(recipe.id) ?? false,
        )) {
      return false;
    }
    if (query.savedSearchOfBook case final book?
        when !(savedSearches[book]?.contains(recipe.id) ?? false)) {
      return false;
    }
    if (query.savedFilter case final filter?
        when !(savedFilters[filter]?.contains(recipe.id) ?? false)) {
      return false;
    }
    final foods = {
      for (final step in recipe.steps)
        for (final ingredient in step.ingredients) ?ingredient.food?.id,
    };
    final keywords = {for (final k in recipe.keywords) k.id};
    return recipe.name.toLowerCase().contains(query.text.toLowerCase()) &&
        foods.containsAll(query.foodIds) &&
        keywords.containsAll(query.keywordIds) &&
        (query.anyFoodIds.isEmpty || query.anyFoodIds.any(foods.contains)) &&
        (query.anyKeywordIds.isEmpty ||
            query.anyKeywordIds.any(keywords.contains));
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
