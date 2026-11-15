import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_match.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_sort.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/result_page.dart';
import 'package:yumdoor/domain/repositories/food_repository.dart';
import 'package:yumdoor/domain/services/universal_search.dart';

import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_recipe_repository.dart';

const karotte = Food(id: 1, name: 'Karotte', pluralName: 'Karotten');
const kartoffel = Food(id: 2, name: 'Kartoffel', pluralName: 'Kartoffeln');
const zwiebel = Food(id: 3, name: 'Zwiebel');
const vegetarisch = Keyword(id: 1, name: 'Vegetarisch');
const karottenzeit = Keyword(id: 2, name: 'Karottenzeit');
const schnell = Keyword(id: 3, name: 'Schnell');

Recipe recipe(
  int id,
  String name, {
  List<Food> foods = const [],
  List<Keyword> keywords = const [],
}) => Recipe(
  id: id,
  name: name,
  keywords: keywords,
  steps: [
    RecipeStep(
      id: id,
      ingredients: [
        for (final (i, food) in foods.indexed)
          Ingredient(id: id * 100 + i, food: food),
      ],
    ),
  ],
);

void main() {
  late FakeRecipeRepository recipes;
  late FakeFoodRepository foods;
  late FakeKeywordRepository keywords;

  UniversalSearch search() =>
      UniversalSearch(recipes: recipes, foods: foods, keywords: keywords);

  /// Every page of [query], as recipe ids per page.
  Future<List<List<int>>> allPages(
    RecipeQuery query, {
    int pageSize = 2,
  }) async {
    final results = search().start(query, pageSize: pageSize);
    final pages = <List<int>>[];
    while (true) {
      final page = await results.next();
      pages.add([for (final match in page.items) match.recipe.id]);
      if (!page.hasMore) return pages;
    }
  }

  setUp(() {
    foods = FakeFoodRepository(const [karotte, kartoffel, zwiebel]);
    keywords = FakeKeywordRepository(const [
      vegetarisch,
      karottenzeit,
      schnell,
    ]);
    recipes = FakeRecipeRepository([
      // Only the keyword matches "Karotte".
      recipe(1, 'Apfelkuchen', keywords: [karottenzeit]),
      // Name and ingredient match.
      recipe(2, 'Karottensuppe', foods: [karotte]),
      // Only the ingredient matches.
      recipe(3, 'Gemüsepfanne', foods: [karotte, zwiebel]),
      // Ingredient and keyword match.
      recipe(4, 'Bolognese', foods: [karotte], keywords: [karottenzeit]),
      // Nothing matches.
      recipe(5, 'Pfannkuchen', keywords: [vegetarisch]),
      // Only the name matches.
      recipe(6, 'Karottenkuchen', keywords: [schnell]),
    ]);
  });

  group('merge', () {
    test('name matches first, then ingredients, then keywords', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 25,
      );

      expect(pages, [
        [2, 6, 3, 4, 1],
      ]);
    });

    test('pages across sources without duplicates', () async {
      final pages = await allPages(const RecipeQuery(text: 'Karotte'));

      expect(pages, [
        [2, 6],
        [3, 4],
        [1],
      ]);
    });

    test('a page can end in a source and continue in the next', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 3,
      );

      expect(pages, [
        [2, 6, 3],
        [4, 1],
      ]);
    });

    test('skips duplicates that fill a whole server page', () async {
      // Recipe 2 is the only food match on the server's first page and was
      // already returned by name.
      final pages = await allPages(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 1,
      );

      // The last page can be empty: whether the rest are duplicates is only
      // known after loading them.
      expect(pages.expand((ids) => ids), [2, 6, 3, 4, 1]);
    });

    test('counts every recipe once', () async {
      final results = search().start(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 2,
      );

      final first = await results.next();

      // 2 by name, 3 by food, 2 by keyword; 2 overlaps.
      expect(first.totalCount, 5);
    });

    test('applies the other filters to every source', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Karotte', foodIds: {3}),
        pageSize: 25,
      );

      expect(pages, [
        [3],
      ]);
      expect(recipes.searches.map((s) => s.query.foodIds), everyElement({3}));
    });

    test('without text it is a single search', () async {
      final pages = await allPages(const RecipeQuery(), pageSize: 25);

      expect(pages, [
        [1, 2, 3, 4, 5, 6],
      ]);
      expect(recipes.searches, hasLength(1));
      expect(foods.queries, isEmpty);
    });
  });

  group('sort', () {
    test('by rating merges every source in that order', () async {
      const ratings = {1: 5.0, 2: 3.0, 3: 4.0, 6: 4.0};
      for (final MapEntry(:key, :value) in ratings.entries) {
        recipes.recipes[key] = recipes.recipes[key]!.copyWith(rating: value);
      }

      final pages = await allPages(
        const RecipeQuery(text: 'Karotte', sort: RecipeSort.rating),
        pageSize: 25,
      );

      // Equal ratings: name matches first. Unrated last.
      expect(pages, [
        [1, 6, 3, 2, 4],
      ]);
      expect(
        recipes.searches.where((s) => s.pageSize > 1).map((s) => s.query.sort),
        everyElement(RecipeSort.rating),
      );
    });

    test('by name merges across pages of every source', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Karotte', sort: RecipeSort.name),
      );

      // Apfelkuchen, Bolognese, Gemüsepfanne, Karottenkuchen, Karottensuppe.
      expect(pages, [
        [1, 4],
        [3, 6],
        [2],
      ]);
      // The overlaps are counted unsorted.
      final counts = recipes.searches.where((s) => s.pageSize == 1);
      expect(counts, isNotEmpty);
      expect(counts.map((s) => s.query.sort), everyElement(isNull));
    });

    test('a failing source ends the page where it failed', () async {
      final results = search().start(
        const RecipeQuery(text: 'Karotte', sort: RecipeSort.name),
        pageSize: 2,
      );
      List<int> ids(ResultPage<RecipeMatch> page) => [
        for (final m in page.items) m.recipe.id,
      ];

      expect(ids(await results.next()), [1, 4]);
      recipes
        ..failure = const ServerFailure()
        ..failWhen = (query) => query.anyFoodIds.isNotEmpty;
      // The food search's second page may hold a recipe before
      // Karottenkuchen, so the page stops before it.
      final second = await results.next();
      expect(ids(second), [3]);
      expect(second.hasMore, isTrue);
      recipes.failure = null;
      expect(ids(await results.next()), [6, 2]);
    });

    test('by newest merges by id, newest first', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Karotte', sort: RecipeSort.newest),
        pageSize: 25,
      );

      expect(pages, [
        [6, 4, 3, 2, 1],
      ]);
    });

    test('without a key in the results, name matches come first', () async {
      for (final sort in [
        RecipeSort.lastCooked,
        RecipeSort.recentlyViewed,
        RecipeSort.random,
      ]) {
        final pages = await allPages(
          RecipeQuery(text: 'Karotte', sort: sort),
          pageSize: 25,
        );

        expect(pages, [
          [2, 6, 3, 4, 1],
        ], reason: '$sort');
      }
    });

    test('relevance without text is by name', () {
      expect(const RecipeQuery().effectiveSort, RecipeSort.name);
      expect(
        const RecipeQuery(sort: RecipeSort.relevance).effectiveSort,
        RecipeSort.name,
      );
      expect(
        const RecipeQuery(text: 'Suppe').effectiveSort,
        RecipeSort.relevance,
      );
      expect(
        const RecipeQuery(text: 'Suppe', sort: RecipeSort.rating).effectiveSort,
        RecipeSort.rating,
      );
    });
  });

  group('one source', () {
    test('without matching foods there is no food search', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Kuchen'),
        pageSize: 25,
      );

      expect(pages, [
        [1, 5, 6],
      ]);
      expect(
        recipes.searches.where((s) => s.query.anyFoodIds.isNotEmpty),
        isEmpty,
      );
    });

    test('an empty name search still finds ingredients', () async {
      final pages = await allPages(
        const RecipeQuery(text: 'Zwiebel'),
        pageSize: 25,
      );

      expect(pages, [
        [3],
      ]);
    });

    test('a failing name search fails the search', () async {
      recipes
        ..failure = const OfflineFailure()
        ..failWhen = (query) => query.text.isNotEmpty;

      expect(
        search().start(const RecipeQuery(text: 'Karotte')).next(),
        throwsA(isA<OfflineFailure>()),
      );
    });

    test('a failing food search is skipped and tried again', () async {
      recipes
        ..failure = const ServerFailure()
        ..failWhen = (query) => query.anyFoodIds.isNotEmpty;
      final results = search().start(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 25,
      );

      final first = await results.next();
      expect(first.items.map((m) => m.recipe.id), [2, 6, 1, 4]);
      expect(first.hasMore, isTrue);

      await expectLater(results.next(), throwsA(isA<ServerFailure>()));

      recipes.failure = null;
      final second = await results.next();
      expect(second.items.map((m) => m.recipe.id), [3]);
      expect(second.hasMore, isFalse);
      expect(second.totalCount, 5);
    });

    test('without name matches a failing food search still shows keyword '
        'matches', () async {
      recipes = FakeRecipeRepository([
        recipe(1, 'Apfelkuchen', keywords: [karottenzeit]),
        recipe(3, 'Gemüsepfanne', foods: [karotte]),
      ]);
      recipes
        ..failure = const ServerFailure()
        ..failWhen = (query) => query.anyFoodIds.isNotEmpty;

      final first = await search()
          .start(const RecipeQuery(text: 'Karotte'))
          .next();

      expect(first.items.map((m) => m.recipe.id), [1]);
      expect(first.hasMore, isTrue);
    });

    test('a later page that is gone ends its source', () async {
      final results = search().start(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 2,
      );
      await results.next();
      // Recipe 4 was deleted, so page 2 of the food search is a 404.
      recipes.recipes.remove(4);

      final second = await results.next();

      expect(second.items.map((m) => m.recipe.id), [3, 1]);
      expect(recipes.searches.last.page, 2);
    });

    test('a failing food lookup is retried', () async {
      foods.failure = const ServerFailure();
      final results = search().start(
        const RecipeQuery(text: 'Karotte'),
        pageSize: 25,
      );

      final first = await results.next();
      expect(first.items.map((m) => m.recipe.id), [2, 6, 1, 4]);
      expect(first.hasMore, isTrue);

      foods.failure = null;
      final second = await results.next();
      expect(second.items.map((m) => m.recipe.id), [3]);
    });

    test(
      'a failing first food and keyword search fails nothing else',
      () async {
        recipes
          ..failure = const ServerFailure()
          ..failWhen = (query) => query.text.isEmpty;
        final results = search().start(
          const RecipeQuery(text: 'Karotte'),
          pageSize: 25,
        );

        final first = await results.next();

        expect(first.items.map((m) => m.recipe.id), [2, 6]);
        expect(first.totalCount, greaterThanOrEqualTo(2));
      },
    );
  });

  group('reasons', () {
    test('says which food or keyword matched', () async {
      final page = await search()
          .start(const RecipeQuery(text: 'Karotte'), pageSize: 25)
          .next();

      expect(page.items, [
        RecipeMatch(recipe: recipes.recipes[2]!.summaryAsServer),
        RecipeMatch(recipe: recipes.recipes[6]!.summaryAsServer),
        RecipeMatch(
          recipe: recipes.recipes[3]!.summaryAsServer,
          foods: const [karotte],
        ),
        RecipeMatch(
          recipe: recipes.recipes[4]!.summaryAsServer,
          foods: const [karotte],
        ),
        RecipeMatch(
          recipe: recipes.recipes[1]!.summaryAsServer,
          keywords: const [karottenzeit],
        ),
      ]);
    });

    test('only foods and keywords that contain the text count', () async {
      // A fuzzy search preference makes Tandoor return similar foods too.
      final page = await UniversalSearch(
        recipes: recipes,
        foods: _AllFoods(const [kartoffel, karotte, zwiebel]),
        keywords: keywords,
      ).start(const RecipeQuery(text: 'karotte'), pageSize: 25).next();

      final anyFoods = recipes.searches
          .map((s) => s.query.anyFoodIds)
          .where((ids) => ids.isNotEmpty);
      expect(anyFoods, everyElement({karotte.id}));
      expect(page.items.firstWhere((m) => m.recipe.id == 3).foods, const [
        karotte,
      ]);
    });

    test('ignores accents', () async {
      recipes = FakeRecipeRepository([
        recipe(1, 'Kartoffelbrei', foods: [const Food(id: 9, name: 'Püree')]),
      ]);

      final page = await UniversalSearch(
        recipes: recipes,
        foods: _AllFoods(const [Food(id: 9, name: 'Püree')]),
        keywords: keywords,
      ).start(const RecipeQuery(text: 'Puree')).next();

      expect(page.items.single.foods.single.name, 'Püree');
    });
  });

  group('offline', () {
    setUp(() => recipes.fromCache = true);

    test('uses the cache result alone, name matches first', () async {
      // The cache matches the text against names, foods and keywords; the
      // fake only against names, so search for something only names have.
      final results = search().start(
        const RecipeQuery(text: 'kuchen'),
        pageSize: 2,
      );

      final first = await results.next();
      expect(first.fromCache, isTrue);
      expect(first.items.map((m) => m.recipe.id), [1, 5]);
      expect(first.totalCount, 3);
      final second = await results.next();
      expect(second.items.map((m) => m.recipe.id), [6]);
      expect(second.hasMore, isFalse);
      expect(
        recipes.searches.where((s) => s.query.text.isNotEmpty),
        hasLength(1),
      );
    });

    test('says why a cached recipe matched', () async {
      final cached = FakeRecipeRepository([
        recipe(3, 'Gemüsepfanne', foods: [karotte, zwiebel]),
        recipe(1, 'Apfelkuchen', keywords: [karottenzeit]),
        recipe(2, 'Karottensuppe', foods: [karotte]),
      ])..fromCache = true;

      final page = await UniversalSearch(
        recipes: _MatchAll(cached),
        foods: foods,
        keywords: keywords,
      ).start(const RecipeQuery(text: 'Karotte')).next();

      expect(page.items.map((m) => m.recipe.id), [2, 3, 1]);
      expect(page.items[0].foods, isEmpty);
      expect(page.items[1].foods, const [karotte]);
      expect(page.items[2].keywords, const [karottenzeit]);
    });

    test('keeps the order of the cache when sorted', () async {
      final cached = FakeRecipeRepository([
        recipe(3, 'Gemüsepfanne', foods: [karotte, zwiebel]),
        recipe(1, 'Apfelkuchen', keywords: [karottenzeit]),
        recipe(2, 'Karottensuppe', foods: [karotte]),
      ])..fromCache = true;

      final page =
          await UniversalSearch(
                recipes: _MatchAll(cached),
                foods: foods,
                keywords: keywords,
              )
              .start(
                const RecipeQuery(text: 'Karotte', sort: RecipeSort.rating),
              )
              .next();

      expect(page.items.map((m) => m.recipe.id), [3, 1, 2]);
    });
  });

  test('a cancelled search throws CancelledFailure', () async {
    final cancel = CancelSignal()..cancel();

    expect(
      search().start(const RecipeQuery(text: 'Karotte'), cancel: cancel).next(),
      throwsA(isA<CancelledFailure>()),
    );
  });
}

extension on Recipe {
  /// The summary as the server returns it, without foods.
  RecipeSummary get summaryAsServer => summary.copyWith(foods: const []);
}

/// Returns every food for any text, like Tandoor with a fuzzy preference.
class _AllFoods implements FoodRepository {
  _AllFoods(this.foods);

  final List<Food> foods;

  @override
  Future<List<Food>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) async => foods;

  @override
  Future<Food> fetchFood(int id) => throw UnimplementedError();
}

/// Answers text searches with every recipe, with their foods, like the
/// offline cache, which matches names, foods and keywords.
class _MatchAll extends FakeRecipeRepository {
  _MatchAll(FakeRecipeRepository inner) : super(inner.recipes.values) {
    fromCache = inner.fromCache;
  }

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) async => ResultPage(
    items: [for (final r in recipes.values) r.summary],
    totalCount: recipes.length,
    hasMore: false,
    fromCache: fromCache,
  );
}
