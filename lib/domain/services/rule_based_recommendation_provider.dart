import 'dart:async';
import 'dart:math' as math;

import '../../core/failures.dart';
import '../models/calendar_day.dart';
import '../models/cook_log.dart';
import '../models/keyword.dart';
import '../models/recipe_query.dart';
import '../models/recipe_sort.dart';
import '../models/recipe_summary.dart';
import '../models/recommendation.dart';
import '../models/seasonal_keywords.dart';
import '../models/user_ref.dart';
import '../repositories/cook_log_repository.dart';
import '../repositories/keyword_repository.dart';
import '../repositories/recipe_repository.dart';
import 'recommendation_provider.dart';

/// Suggests recipes by fixed rules on the space's data, each with the reasons
/// that brought it up:
///
/// - **Highly rated, not cooked for a while:** the current user rated it at
///   least [minRating] and last cooked it [notCookedForDays] or more days
///   ago (Tandoor's `rating_gte` and `cookedon_lte`, which count only the
///   user's own cook log).
/// - **In season:** it has a keyword the user mapped to the current month.
/// - **Cooked recently by others:** someone else in the space cooked it in
///   the last [othersWithinDays] days, labelled by name. Everyone in the space
///   counts, since normal users can't list their household.
/// - **Similar to recently cooked:** its foods and keywords overlap with one
///   of the user's [similarSources] last cooked recipes by a Jaccard index of
///   at least [minSimilarity].
///
/// Recipes planned this week and recipes the user cooked in the last
/// [ownCookedWithinDays] days are left out. Each rule gives a score from 0
/// to 1; a recipe found by several rules gets all their reasons and the
/// score `1 - (1 - a)(1 - b)…`, so more reasons rank it higher. Equal scores
/// are ordered by a hash of the recipe and the day: the order changes from
/// day to day, but not between calls on the same day.
///
/// The rules run at the same time, and each makes at most [parallelRequests]
/// requests at once. A rule that fails with a [Failure] is left out (other
/// errors are bugs and aren't caught). [recommend] throws the
/// first failure only if every rule failed, or if nothing is left to suggest
/// and a rule failed.
class RuleBasedRecommendationProvider implements RecommendationProvider {
  RuleBasedRecommendationProvider({
    required this.recipes,
    required this.cookLogs,
    required this.keywords,
    required this.seasonalKeywords,
    this.parallelRequests = 4,
  }) : assert(parallelRequests > 0, 'parallelRequests must be positive');

  /// [RuleBasedRecommendationProvider.id].
  static const providerId = 'rules';

  /// The lowest own rating, in stars, that counts as highly rated.
  static const minRating = 4;

  /// How long a highly rated recipe must not have been cooked, in days.
  static const notCookedForDays = 21;

  /// How far back other people's cooking counts, in days, today included.
  static const othersWithinDays = 14;

  /// Recipes the user cooked this many days back, today included, are left
  /// out.
  static const ownCookedWithinDays = 7;

  /// How many of the user's last cooked recipes similar ones are looked for.
  static const similarSources = 3;

  /// The lowest Jaccard index over foods and keywords that counts as similar.
  static const minSimilarity = 0.2;

  /// How many candidates each search rule considers.
  static const _searchSize = 20;

  /// How many recipes each search of the similarity rule considers. Its
  /// "any of these foods" search matches most recipes (salt, onions).
  static const _similarSearchSize = 50;

  /// How many candidates of the similarity rule are loaded to compare foods.
  /// Search results don't carry ingredients.
  static const _similarCandidates = 8;

  /// How many cook log entries are read, and how far back, for other
  /// people's cooking, the user's own and the similarity sources. In a space
  /// that cooks more than this in [_recentDays] days, the oldest are missed.
  static const _recentLimit = 100;
  static const _recentDays = 42;

  final RecipeRepository recipes;
  final CookLogRepository cookLogs;
  final KeywordRepository keywords;

  /// The user's month → keyword mapping.
  final Future<SeasonalKeywords> Function() seasonalKeywords;

  /// How many requests each rule makes at once at most.
  final int parallelRequests;

  @override
  String get id => providerId;

  @override
  Future<List<Recommendation>> recommend(
    RecommendationContext context, {
    int limit = 10,
  }) async {
    RangeError.checkNotNegative(limit, 'limit');
    if (limit == 0) return const [];
    final today = context.today;
    final recent = _attempt(
      () => cookLogs.recent(
        limit: _recentLimit,
        since: today.addDays(-_recentDays).atLocalTime(),
      ),
    );
    Future<_Outcome<List<_Hit>>> fromRecent(
      FutureOr<List<_Hit>> Function(List<RecentCookLog> logs) rule,
    ) async => switch (await recent) {
      _Outcome(:final failure?) => _Outcome.failed(failure),
      _Outcome(:final value) => await _attempt(() async => rule(value!)),
    };

    final outcomes = await Future.wait([
      _attempt(() => _highlyRated(today)),
      _attempt(() => _inSeason(today)),
      fromRecent((logs) => _cookedByOthers(logs, context)),
      fromRecent((logs) => _similar(logs, context)),
    ]);
    final failures = [for (final outcome in outcomes) ?outcome.failure];
    if (failures.length == outcomes.length) throw failures.first;

    final excluded = _excluded((await recent).value, context);

    final byRecipe = <int, List<_Hit>>{};
    for (final outcome in outcomes) {
      for (final hit in outcome.value ?? const <_Hit>[]) {
        if (excluded.contains(hit.recipe.id)) continue;
        (byRecipe[hit.recipe.id] ??= []).add(hit);
      }
    }
    final merged = [for (final hits in byRecipe.values) _merge(hits)];
    final tieBreak = {
      for (final r in merged) r.recipe.id: _dayHash(today, r.recipe.id),
    };
    merged.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final byHash = tieBreak[a.recipe.id]!.compareTo(tieBreak[b.recipe.id]!);
      return byHash != 0 ? byHash : a.recipe.id.compareTo(b.recipe.id);
    });
    // Nothing to show and something failed: say what, rather than nothing.
    if (merged.isEmpty && failures.isNotEmpty) throw failures.first;
    return merged.take(limit).toList();
  }

  /// The recipes not to suggest: planned this week, or cooked by the user
  /// in the last [ownCookedWithinDays] days according to [logs] (if they
  /// could be read).
  Set<int> _excluded(
    List<RecentCookLog>? logs,
    RecommendationContext context,
  ) => {
    for (final plan in context.mealPlans) ?plan.recipe?.id,
    for (final log in logs ?? const <RecentCookLog>[])
      if (_isOwn(log, context) &&
          _daysAgo(log.entry.createdAt, context.today) < ownCookedWithinDays)
        log.recipe.id,
  };

  /// Searches the server. Recommendations are online only: results from the
  /// offline cache count as [OfflineFailure].
  Future<List<RecipeSummary>> _search(
    RecipeQuery query, {
    int pageSize = _searchSize,
  }) async {
    final page = await recipes.search(query, pageSize: pageSize);
    if (page.fromCache) throw const OfflineFailure();
    return page.items;
  }

  /// Highly rated by the user and not cooked for [notCookedForDays] days.
  Future<List<_Hit>> _highlyRated(CalendarDay today) async {
    final found = await _search(
      RecipeQuery(
        minRating: minRating,
        lastCookedBefore: today.addDays(-notCookedForDays).atLocalTime(),
        sort: RecipeSort.rating,
      ),
    );
    // Search results have no last-cooked date (docs/TANDOOR_API.md).
    final lastCooked = await _mapBounded(found, (recipe) async {
      try {
        return await cookLogs.lastCooked(recipe.id);
      } on Failure {
        // The date makes the reason richer; the recipe counts without it.
        return null;
      }
    });
    return [
      for (final (i, recipe) in found.indexed)
        if (recipe.rating case final rating? when rating >= minRating)
          _highlyRatedHit(recipe, rating, lastCooked[i], today),
    ];
  }

  _Hit _highlyRatedHit(
    RecipeSummary recipe,
    double rating,
    DateTime? lastCooked,
    CalendarDay today,
  ) {
    // 4 stars 0.3, 5 stars 0.4, plus up to 0.15 for up to 9 more weeks.
    var score = 0.3 + 0.1 * (rating - minRating).clamp(0, 1);
    if (lastCooked != null) {
      final overdue = (_daysAgo(lastCooked, today) - notCookedForDays) / 63;
      score += 0.15 * overdue.clamp(0, 1);
    }
    return _Hit(recipe, score, [
      RecommendationReason.highlyRated(rating),
      if (lastCooked != null) RecommendationReason.notCookedSince(lastCooked),
    ]);
  }

  /// Recipes with a keyword mapped to [today]'s month.
  Future<List<_Hit>> _inSeason(CalendarDay today) async {
    SeasonalKeywords mapping;
    try {
      mapping = await seasonalKeywords();
    } on Failure {
      rethrow;
    } on Object {
      // No mapping to read (not logged in, storage error): nothing in season.
      mapping = const SeasonalKeywords.empty();
    }
    final ids = mapping.forDay(today).toList()..sort();
    if (ids.isEmpty) return const [];
    // One search per keyword, so each recipe is known to have it. Searches
    // include child keywords, which a recipe may have instead. "Any of" finds
    // nothing for a deleted keyword; "all of" would ignore it and find every
    // recipe (docs/TANDOOR_API.md).
    final pages = await _mapBounded(
      ids,
      (id) =>
          _search(RecipeQuery(anyKeywordIds: {id}, sort: RecipeSort.rating)),
    );
    // The mapped keywords that recipes have only through a child keyword,
    // loaded once each; `null` if it was deleted. Other failures fail the
    // rule.
    final mapped = <int, Keyword?>{};
    Future<Keyword?> keyword(int id) async {
      if (mapped.containsKey(id)) return mapped[id];
      try {
        return mapped[id] = await keywords.fetchKeyword(id);
      } on NotFoundFailure {
        return mapped[id] = null;
      }
    }

    final hits = <_Hit>[];
    final seen = <int>{};
    for (final (i, found) in pages.indexed) {
      final id = ids[i];
      for (final recipe in found) {
        if (seen.contains(recipe.id)) continue;
        final reason =
            recipe.keywords.where((k) => k.id == id).firstOrNull ??
            await keyword(id);
        if (reason == null) continue;
        seen.add(recipe.id);
        hits.add(_Hit(recipe, 0.35, [RecommendationReason.inSeason(reason)]));
      }
    }
    return hits;
  }

  /// Recipes other people cooked in the last [othersWithinDays] days.
  List<_Hit> _cookedByOthers(
    List<RecentCookLog> logs,
    RecommendationContext context,
  ) {
    final today = context.today;
    // Per recipe, each person's newest entry; logs come newest first.
    final byRecipe = <int, Map<int, (UserRef, RecentCookLog)>>{};
    for (final log in logs) {
      final user = log.entry.createdBy;
      if (user == null || user.id == context.userId) continue;
      if (_daysAgo(log.entry.createdAt, today) >= othersWithinDays) continue;
      (byRecipe[log.recipe.id] ??= {}).putIfAbsent(user.id, () => (user, log));
    }
    return [
      for (final people in byRecipe.values)
        _othersHit(people.values.toList(), today),
    ];
  }

  _Hit _othersHit(List<(UserRef, RecentCookLog)> people, CalendarDay today) {
    people.sort((a, b) => b.$2.entry.createdAt.compareTo(a.$2.entry.createdAt));
    final newest = _daysAgo(people.first.$2.entry.createdAt, today);
    // 0.3 today down to 0.2, plus 0.05 for each other person, at most 0.4.
    final score = math.min(
      0.4,
      0.2 + 0.1 * (1 - newest / othersWithinDays) + 0.05 * (people.length - 1),
    );
    return _Hit(people.first.$2.recipe, score, [
      for (final (user, log) in people)
        RecommendationReason.cookedRecentlyBy(user, log.entry.createdAt),
    ]);
  }

  /// Recipes like the ones the user cooked last.
  Future<List<_Hit>> _similar(
    List<RecentCookLog> logs,
    RecommendationContext context,
  ) async {
    final sources = <int, RecipeSummary>{};
    for (final log in logs) {
      if (sources.length >= similarSources) break;
      if (_isOwn(log, context)) {
        sources.putIfAbsent(log.recipe.id, () => log.recipe);
      }
    }
    final features = {
      for (final source in sources.values) source: _features(source),
    }..removeWhere((_, f) => f.isEmpty);
    if (features.isEmpty) return const [];

    final keywordIds = {
      for (final source in features.keys) ...source.keywords.map((k) => k.id),
    };
    final foodIds = {
      for (final source in features.keys) ...source.foods.map((f) => f.id),
    };
    // By the user's rating, unrated last, rather than by name: which recipes
    // make it onto the page shouldn't depend on their names.
    final searches = [
      if (keywordIds.isNotEmpty)
        RecipeQuery(anyKeywordIds: keywordIds, sort: RecipeSort.rating),
      if (foodIds.isNotEmpty)
        RecipeQuery(anyFoodIds: foodIds, sort: RecipeSort.rating),
    ];
    final pages = await _mapBounded(
      searches,
      (query) => _search(query, pageSize: _similarSearchSize),
    );

    // Search results carry keywords but not foods: rank them by keywords
    // (and whether they share a food) and load the best to compare foods.
    final sourceKeywords = [
      for (final source in features.keys)
        {for (final k in source.keywords) 'k${k.id}'},
    ];
    final excluded = _excluded(logs, context);
    final candidates = <int, ({RecipeSummary recipe, double rank})>{};
    for (final (i, found) in pages.indexed) {
      final byFood = searches[i].anyFoodIds.isNotEmpty;
      for (final recipe in found) {
        if (sources.containsKey(recipe.id) || excluded.contains(recipe.id)) {
          continue;
        }
        final keywords = {for (final k in recipe.keywords) 'k${k.id}'};
        var rank = 0.0;
        for (final theirs in sourceKeywords) {
          rank = math.max(rank, _jaccard(keywords, theirs));
        }
        final previous = candidates[recipe.id];
        candidates[recipe.id] = (
          recipe: recipe,
          rank: (previous?.rank ?? rank) + (byFood ? 0.5 : 0),
        );
      }
    }
    final best = candidates.values.toList()
      ..sort((a, b) {
        final byRank = b.rank.compareTo(a.rank);
        return byRank != 0 ? byRank : a.recipe.id.compareTo(b.recipe.id);
      });

    Failure? failure;
    final loaded = await _mapBounded(best.take(_similarCandidates), (
      candidate,
    ) async {
      try {
        // Only to compare: not stored as opened, no offline copy.
        final recipe = await recipes.fetchRecipe(
          candidate.recipe.id,
          allowCached: false,
          opened: false,
        );
        return recipe.summary;
      } on Failure catch (e) {
        // One recipe that can't be loaded doesn't hide the others.
        failure ??= e;
        return null;
      }
    });
    if (loaded.isNotEmpty && loaded.every((r) => r == null)) throw failure!;

    final hits = <_Hit>[];
    for (final recipe in loaded) {
      if (recipe == null) continue;
      final own = _features(recipe);
      RecipeSummary? closest;
      var similarity = 0.0;
      for (final MapEntry(key: source, value: theirs) in features.entries) {
        final value = _jaccard(own, theirs);
        if (value > similarity) (closest, similarity) = (source, value);
      }
      if (closest == null || similarity < minSimilarity) continue;
      hits.add(
        _Hit(recipe, 0.15 + 0.35 * similarity, [
          RecommendationReason.similarTo(closest),
        ]),
      );
    }
    return hits;
  }

  /// Runs [task] for each of [items], at most [parallelRequests] at once,
  /// and returns the results in the order of [items].
  Future<List<R>> _mapBounded<T, R>(
    Iterable<T> items,
    Future<R> Function(T item) task,
  ) async {
    final list = items.toList();
    final results = List<R?>.filled(list.length, null);
    var next = 0;
    Future<void> worker() async {
      while (next < list.length) {
        final i = next++;
        results[i] = await task(list[i]);
      }
    }

    await Future.wait([
      for (var w = 0; w < math.min(parallelRequests, list.length); w++)
        worker(),
    ]);
    return results.cast<R>();
  }
}

/// What one rule found for one recipe.
class _Hit {
  const _Hit(this.recipe, this.score, this.reasons);

  final RecipeSummary recipe;

  /// 0 to 1 (exclusive).
  final double score;
  final List<RecommendationReason> reasons;
}

/// The result of a rule: its value, or the [Failure] it threw.
class _Outcome<T> {
  const _Outcome.value(T this.value) : failure = null;
  const _Outcome.failed(Failure this.failure) : value = null;

  final T? value;
  final Failure? failure;
}

Future<_Outcome<T>> _attempt<T>(Future<T> Function() task) async {
  try {
    return _Outcome.value(await task());
  } on Failure catch (failure) {
    return _Outcome.failed(failure);
  }
}

/// One recommendation from the hits of all rules for one recipe: the best
/// hit's reasons first.
Recommendation _merge(List<_Hit> hits) {
  // Equal hits keep the order of the rules.
  final sorted = [...hits.indexed]
    ..sort((a, b) {
      final byScore = b.$2.score.compareTo(a.$2.score);
      return byScore != 0 ? byScore : a.$1.compareTo(b.$1);
    });
  var miss = 1.0;
  for (final (_, hit) in sorted) {
    miss *= 1 - hit.score;
  }
  return Recommendation(
    recipe: sorted.first.$2.recipe,
    score: (1 - miss).clamp(0.0, 1.0),
    reasons: [for (final (_, hit) in sorted) ...hit.reasons],
  );
}

bool _isOwn(RecentCookLog log, RecommendationContext context) =>
    log.entry.createdBy?.id == context.userId;

/// How many days before [today] [date] is, on this device's calendar; 0 for
/// today and for dates after it.
int _daysAgo(DateTime date, CalendarDay today) =>
    math.max(0, today.differenceInDays(CalendarDay.of(date.toLocal())));

/// The recipe's foods and keywords, for comparing recipes.
Set<String> _features(RecipeSummary recipe) => {
  for (final food in recipe.foods) 'f${food.id}',
  for (final keyword in recipe.keywords) 'k${keyword.id}',
};

double _jaccard(Set<String> a, Set<String> b) {
  if (a.isEmpty || b.isEmpty) return 0;
  final shared = a.intersection(b).length;
  return shared / (a.length + b.length - shared);
}

/// A hash of [day] and [recipeId] that is the same on every platform and
/// every run, to order equal scores the same way all day.
int _dayHash(CalendarDay day, int recipeId) {
  const modulus = 2147483647; // 2^31 - 1, so products stay exact on the web.
  var hash = 1;
  for (final value in [day.year, day.month, day.day, recipeId]) {
    hash = (hash + value % modulus) % modulus;
    hash = hash * 48271 % modulus;
    hash = hash * 48271 % modulus;
  }
  return hash;
}
