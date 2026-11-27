import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/cook_log.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_query.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/recommendation.dart';
import 'package:yumdoor/domain/models/result_page.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/domain/services/rule_based_recommendation_provider.dart';

import '../../fakes/fake_cook_log_repository.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_recipe_repository.dart';

const me = UserRef(id: 1, name: 'Daniel');
const anna = UserRef(id: 2, name: 'Anna');
const ben = UserRef(id: 3, name: 'Ben');

const pasta = Keyword(id: 1, name: 'Pasta');
const soup = Keyword(id: 2, name: 'Suppe');
const autumn = Keyword(id: 3, name: 'Herbst');

/// Thursday, November 26, 2026.
final today = CalendarDay(2026, 11, 26);

/// 7 pm on the day [days] days before [today], on this device's clock.
DateTime daysAgo(int days) =>
    today.addDays(-days).atLocalTime(const Duration(hours: 19));

Recipe recipe(
  int id,
  String name, {
  List<int> foods = const [],
  List<Keyword> keywords = const [],
  double? rating,
  DateTime? lastCooked,
}) => Recipe(
  id: id,
  name: name,
  keywords: keywords,
  rating: rating,
  lastCooked: lastCooked,
  steps: [
    RecipeStep(
      id: id,
      ingredients: [
        for (final food in foods)
          Ingredient(
            id: id * 100 + food,
            food: Food(id: food, name: 'Food $food'),
          ),
      ],
    ),
  ],
);

final lentilBolognese = recipe(
  1,
  'Linsen-Bolognese',
  foods: [10, 11, 12],
  keywords: [pasta],
);
final lentilSoup = recipe(
  2,
  'Linsensuppe',
  foods: [10, 11, 12, 13],
  keywords: [soup],
);
final pumpkinSoup = recipe(
  3,
  'Kürbissuppe',
  foods: [20, 12],
  keywords: [soup, autumn],
);
final appleCake = recipe(
  4,
  'Apfelkuchen',
  foods: [30],
  rating: 4.5,
  lastCooked: daysAgo(56),
);
final stirFry = recipe(
  5,
  'Gemüsepfanne',
  foods: [40],
  rating: 5,
  lastCooked: daysAgo(6),
);
final pizza = recipe(6, 'Pizza', foods: [50]);
final curry = recipe(7, 'Curry', foods: [60]);
final risotto = recipe(8, 'Risotto', foods: [70]);

void main() {
  late FakeRecipeRepository recipes;
  late FakeCookLogRepository cookLogs;
  late FakeKeywordRepository keywords;
  late SeasonalKeywords seasonal;

  void log(Recipe recipe, UserRef user, DateTime at, {int? rating}) {
    cookLogs.recipes[recipe.id] = recipe.summary;
    cookLogs.entries.add(
      CookLog(
        id: cookLogs.entries.length + 1,
        recipeId: recipe.id,
        rating: rating,
        createdBy: user,
        createdAt: at,
      ),
    );
  }

  RuleBasedRecommendationProvider provider({int parallelRequests = 4}) =>
      RuleBasedRecommendationProvider(
        recipes: recipes,
        cookLogs: cookLogs,
        keywords: keywords,
        seasonalKeywords: () async => seasonal,
        parallelRequests: parallelRequests,
      );

  MealPlan plan(Recipe recipe) => MealPlan(
    id: recipe.id,
    recipe: recipe.summary,
    servings: 2,
    fromDay: today.addDays(1),
    toDay: today.addDays(1),
    mealType: const MealType(id: 1, name: 'Abendessen'),
    createdBy: anna.id,
  );

  Future<List<Recommendation>> recommend({
    List<MealPlan> mealPlans = const [],
    CalendarDay? day,
    int limit = 10,
    int parallelRequests = 4,
  }) => provider(parallelRequests: parallelRequests).recommend(
    RecommendationContext(
      today: day ?? today,
      userId: me.id,
      mealPlans: mealPlans,
    ),
    limit: limit,
  );

  Map<int, List<RecommendationReason>> reasonsOf(List<Recommendation> list) => {
    for (final r in list) r.recipe.id: r.reasons,
  };

  setUp(() {
    recipes = FakeRecipeRepository([
      lentilBolognese,
      lentilSoup,
      pumpkinSoup,
      pizza,
      curry,
      risotto,
    ]);
    cookLogs = FakeCookLogRepository();
    keywords = FakeKeywordRepository([pasta, soup, autumn]);
    seasonal = const SeasonalKeywords.empty();
  });

  test('has a stable id', () {
    expect(provider().id, 'rules');
    expect(RuleBasedRecommendationProvider.providerId, 'rules');
  });

  void addRated() =>
      recipes.recipes.addAll({appleCake.id: appleCake, stirFry.id: stirFry});

  group('highly rated, not cooked for a while', () {
    setUp(addRated);

    test('suggests own ratings of 4 or more not cooked for 3 weeks', () async {
      log(appleCake, me, daysAgo(56), rating: 5);
      log(stirFry, me, daysAgo(6), rating: 5);

      final result = await recommend();

      expect(reasonsOf(result), {
        appleCake.id: [
          const RecommendationReason.highlyRated(4.5),
          RecommendationReason.notCookedSince(daysAgo(56)),
        ],
      });
      final query = recipes.searches
          .singleWhere((s) => s.query.minRating != null)
          .query;
      expect(query.minRating, 4);
      expect(CalendarDay.of(query.lastCookedBefore!), today.addDays(-21));
    });

    test('a longer break and a better rating score higher', () async {
      recipes.recipes[9] = recipe(
        9,
        'Gulasch',
        rating: 4.5,
        lastCooked: daysAgo(120),
      );
      recipes.recipes[10] = recipe(
        10,
        'Waffeln',
        rating: 5,
        lastCooked: daysAgo(56),
      );
      log(appleCake, me, daysAgo(56));
      log(recipes.recipes[9]!, me, daysAgo(120));
      log(recipes.recipes[10]!, me, daysAgo(56));

      final result = await recommend();

      expect([for (final r in result) r.recipe.id], [9, 10, appleCake.id]);
    });
  });

  group('in season', () {
    test('suggests recipes with a keyword of the month', () async {
      seasonal = SeasonalKeywords({
        11: [autumn.id],
        6: [pasta.id],
      });

      final result = await recommend();

      expect(reasonsOf(result), {
        pumpkinSoup.id: [const RecommendationReason.inSeason(autumn)],
      });
    });

    test('makes no request without a mapping for the month', () async {
      seasonal = SeasonalKeywords({
        6: [pasta.id],
      });

      expect(await recommend(), isEmpty);
      expect(
        recipes.searches.where((s) => s.query.anyKeywordIds.isNotEmpty),
        isEmpty,
      );
    });

    test('names the mapped keyword for a recipe with a child of it', () async {
      const vegetables = Keyword(id: 50, name: 'Wintergemüse');
      keywords.keywords.add(vegetables);
      seasonal = SeasonalKeywords({
        11: [vegetables.id],
      });
      recipes = _ChildKeywordSearch(recipes.recipes.values, {
        vegetables.id: [pumpkinSoup.summary],
      });

      final result = await recommend();

      expect(reasonsOf(result), {
        pumpkinSoup.id: [const RecommendationReason.inSeason(vegetables)],
      });
    });

    test('uses the stored name when the keyword cannot be loaded', () async {
      seasonal = SeasonalKeywords(
        {
          11: [autumn.id],
        },
        names: {autumn.id: autumn.name},
      );
      keywords = _OfflineKeywords();
      recipes = _ChildKeywordSearch(recipes.recipes.values, {
        autumn.id: [pizza.summary],
      });

      final result = await recommend();

      expect(reasonsOf(result), {
        pizza.id: [RecommendationReason.inSeason(autumn)],
      });
    });

    test('fails when the mapped keyword cannot be loaded', () async {
      seasonal = SeasonalKeywords({
        11: [autumn.id],
      });
      keywords = _OfflineKeywords();
      recipes = _ChildKeywordSearch(recipes.recipes.values, {
        autumn.id: [pizza.summary],
      });

      await expectLater(recommend(), throwsA(isA<OfflineFailure>()));
    });

    test('a mapping that fails to load counts as none', () async {
      log(pizza, anna, daysAgo(1));
      final rules = RuleBasedRecommendationProvider(
        recipes: recipes,
        cookLogs: cookLogs,
        keywords: keywords,
        seasonalKeywords: () async => throw StateError('Not logged in'),
      );

      final result = await rules.recommend(
        RecommendationContext(today: today, userId: me.id),
      );

      expect([for (final r in result) r.recipe.id], [pizza.id]);
    });

    test('leaves out recipes whose mapped keyword is gone', () async {
      seasonal = SeasonalKeywords({
        11: [99],
      });
      recipes = _ChildKeywordSearch(recipes.recipes.values, {
        99: [pumpkinSoup.summary],
      });

      expect(await recommend(), isEmpty);
    });
  });

  group('cooked recently by others', () {
    test('names everyone who cooked it in the last 14 days', () async {
      log(pizza, ben, daysAgo(5));
      log(pizza, anna, daysAgo(2));
      log(pizza, anna, daysAgo(4));
      log(risotto, ben, daysAgo(14));
      log(lentilSoup, me, daysAgo(10));

      final result = await recommend();

      expect(reasonsOf(result)[pizza.id], [
        RecommendationReason.cookedRecentlyBy(anna, daysAgo(2)),
        RecommendationReason.cookedRecentlyBy(ben, daysAgo(5)),
      ]);
      expect(reasonsOf(result), isNot(contains(risotto.id)));
      // Own cooking isn't someone else's.
      expect(
        reasonsOf(result)[lentilSoup.id] ?? [],
        isNot(contains(isA<CookedRecentlyBy>())),
      );
    });

    test('newer and by more people scores higher', () async {
      log(pizza, anna, daysAgo(1));
      log(pizza, ben, daysAgo(1));
      log(curry, anna, daysAgo(1));
      log(risotto, anna, daysAgo(10));

      final result = await recommend();

      expect(
        [for (final r in result) r.recipe.id],
        [pizza.id, curry.id, risotto.id],
      );
    });
  });

  group('similar to recently cooked', () {
    test('suggests recipes sharing foods and keywords', () async {
      log(lentilBolognese, me, daysAgo(10));

      final result = await recommend();

      // Linsensuppe shares 3 of 6 foods and keywords; Kürbissuppe 1 of 7.
      expect(reasonsOf(result), {
        lentilSoup.id: [
          RecommendationReason.similarTo(lentilBolognese.summary),
        ],
      });
      // Loaded only to compare, not as if the user opened them.
      expect(recipes.unopenedFetches, unorderedEquals([2, 3]));
      expect(recipes.fetchCount, 2);
    });

    test('compares with the last three recipes the user cooked', () async {
      log(lentilBolognese, me, daysAgo(20));
      log(pizza, me, daysAgo(15));
      log(curry, me, daysAgo(14));
      log(risotto, me, daysAgo(12));

      expect(await recommend(), isEmpty);
    });

    test('names the closest of them', () async {
      final noodles = recipe(
        9,
        'Nudeln mit Tomaten',
        foods: [11, 80],
        keywords: [pasta],
      );
      recipes.recipes[noodles.id] = noodles;
      log(lentilBolognese, me, daysAgo(12));
      log(pumpkinSoup, me, daysAgo(10));

      final result = await recommend();

      expect(reasonsOf(result)[lentilSoup.id], [
        RecommendationReason.similarTo(lentilBolognese.summary),
      ]);
      expect(reasonsOf(result)[noodles.id], [
        RecommendationReason.similarTo(lentilBolognese.summary),
      ]);
    });
  });

  test('merges the reasons of all rules, the strongest first', () async {
    seasonal = SeasonalKeywords({
      11: [autumn.id],
    });
    log(pumpkinSoup, anna, daysAgo(1));
    log(pizza, ben, daysAgo(3));

    final result = await recommend();

    expect(result.first.recipe.id, pumpkinSoup.id);
    expect(result.first.reasons, [
      const RecommendationReason.inSeason(autumn),
      RecommendationReason.cookedRecentlyBy(anna, daysAgo(1)),
    ]);
    // Better than either reason alone.
    final alone = result.firstWhere((r) => r.recipe.id == pizza.id);
    expect(result.first.score, greaterThan(0.35));
    expect(result.first.score, greaterThan(alone.score));
  });

  group('leaves out', () {
    test('recipes planned this week', () async {
      log(curry, anna, daysAgo(1));
      log(pizza, anna, daysAgo(1));

      final result = await recommend(mealPlans: [plan(curry)]);

      expect([for (final r in result) r.recipe.id], [pizza.id]);
    });

    test('recipes the user cooked in the last 7 days', () async {
      log(pizza, anna, daysAgo(2));
      log(pizza, me, daysAgo(6));
      log(curry, anna, daysAgo(2));
      log(curry, me, daysAgo(7));

      final result = await recommend();

      expect([for (final r in result) r.recipe.id], [curry.id]);
    });

    test('excluded recipes before loading similar ones', () async {
      log(lentilBolognese, me, daysAgo(10));

      final result = await recommend(mealPlans: [plan(lentilSoup)]);

      expect(result, isEmpty);
      expect(recipes.fetchCount, 1); // Kürbissuppe only.
    });
  });

  test('sorts by score and keeps at most limit', () async {
    seasonal = SeasonalKeywords({
      11: [soup.id],
    });
    addRated();
    log(appleCake, me, daysAgo(56));
    log(pizza, anna, daysAgo(1));

    final result = await recommend(limit: 3);

    expect(result, hasLength(3));
    for (var i = 1; i < result.length; i++) {
      expect(result[i - 1].score, greaterThanOrEqualTo(result[i].score));
    }
    recipes.searches.clear();
    expect(await recommend(limit: 0), isEmpty);
    expect(recipes.searches, isEmpty);
  });

  test('orders equal scores the same all day, differently by day', () async {
    for (var id = 20; id < 30; id++) {
      recipes.recipes[id] = recipe(id, 'Herbstrezept $id', keywords: [autumn]);
    }
    seasonal = SeasonalKeywords({
      for (var month = 1; month <= 12; month++) month: [autumn.id],
    });
    List<int> ids(List<Recommendation> list) => [
      for (final r in list) r.recipe.id,
    ];

    final first = ids(await recommend(limit: 20));
    expect(ids(await recommend(limit: 20)), first);

    final orders = {
      for (var day = 1; day <= 10; day++)
        ids(await recommend(day: today.addDays(day), limit: 20)).join(','),
    };
    expect(orders.length, greaterThan(1));
  });

  group('a failing rule', () {
    test('leaves the others', () async {
      seasonal = SeasonalKeywords({
        11: [autumn.id],
      });
      log(pizza, anna, daysAgo(1));
      recipes
        ..failure = const ServerFailure(statusCode: 500)
        ..failWhen = (query) => query.anyKeywordIds.isNotEmpty;

      final result = await recommend();

      expect([for (final r in result) r.recipe.id], [pizza.id]);
    });

    test('without the cook log, searches still suggest', () async {
      seasonal = SeasonalKeywords({
        11: [autumn.id],
      });
      addRated();
      cookLogs.failure = const OfflineFailure();

      final result = await recommend();

      // Without dates from the cook log, too.
      expect(reasonsOf(result), {
        pumpkinSoup.id: [const RecommendationReason.inSeason(autumn)],
        appleCake.id: [const RecommendationReason.highlyRated(4.5)],
      });
    });

    test('throws when all fail', () async {
      cookLogs.failure = const OfflineFailure();
      recipes.failure = const OfflineFailure();

      expect(recommend(), throwsA(isA<OfflineFailure>()));
    });

    test('throws when nothing is left and something failed', () async {
      cookLogs.failure = const ServerFailure(statusCode: 502);

      expect(recommend(), throwsA(isA<ServerFailure>()));
    });

    test('counts results from the offline cache as offline', () async {
      cookLogs.failure = const OfflineFailure();
      recipes.fromCache = true;

      expect(recommend(), throwsA(isA<OfflineFailure>()));
    });

    test('a similar recipe that fails to load hides only itself', () async {
      log(lentilBolognese, me, daysAgo(10));
      recipes = _FailingFetch(recipes.recipes.values, {pumpkinSoup.id});

      final result = await recommend();

      expect([for (final r in result) r.recipe.id], [lentilSoup.id]);
    });
  });

  test('makes at most parallelRequests requests at once', () async {
    for (var id = 20; id < 30; id++) {
      recipes.recipes[id] = recipe(
        id,
        'Lieblingsrezept $id',
        rating: 5,
        lastCooked: daysAgo(30),
      );
    }
    final counting = _CountingCookLogs();
    cookLogs = counting;

    final result = await recommend(parallelRequests: 3);

    expect(result, hasLength(10));
    expect(counting.calls, 10);
    expect(counting.maxRunning, 3);
  });
}

/// Finds the recipes in [byKeyword] for a single keyword, as a search
/// including child keywords would.
class _ChildKeywordSearch extends FakeRecipeRepository {
  _ChildKeywordSearch(super.recipes, this.byKeyword);

  final Map<int, List<RecipeSummary>> byKeyword;

  @override
  Future<ResultPage<RecipeSummary>> search(
    RecipeQuery query, {
    int page = 1,
    int pageSize = 25,
    CancelSignal? cancel,
  }) async {
    if (query.anyKeywordIds.length == 1) {
      final items = byKeyword[query.anyKeywordIds.single] ?? const [];
      return ResultPage(items: items, totalCount: items.length, hasMore: false);
    }
    return super.search(query, page: page, pageSize: pageSize, cancel: cancel);
  }
}

/// A keyword repository that can't reach the server.
class _OfflineKeywords extends FakeKeywordRepository {
  @override
  Future<Keyword> fetchKeyword(int id) async => throw const OfflineFailure();
}

/// Fails to load the recipes in [failing].
class _FailingFetch extends FakeRecipeRepository {
  _FailingFetch(super.recipes, this.failing);

  final Set<int> failing;

  @override
  Future<Recipe> fetchRecipe(
    int id, {
    bool allowCached = true,
    bool opened = true,
  }) async {
    if (failing.contains(id)) throw const ServerFailure(statusCode: 500);
    return super.fetchRecipe(id, allowCached: allowCached, opened: opened);
  }
}

/// Counts [lastCooked] calls and how many run at once.
class _CountingCookLogs extends FakeCookLogRepository {
  int calls = 0;
  int running = 0;
  int maxRunning = 0;

  @override
  Future<DateTime?> lastCooked(int recipeId) async {
    calls++;
    running++;
    if (running > maxRunning) maxRunning = running;
    await Future<void>.delayed(Duration.zero);
    running--;
    return super.lastCooked(recipeId);
  }
}
