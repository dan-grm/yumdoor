import 'dart:async';
import 'dart:collection';

import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/food.dart';
import '../models/keyword.dart';
import '../models/recipe_match.dart';
import '../models/recipe_query.dart';
import '../models/recipe_summary.dart';
import '../models/result_page.dart';
import '../repositories/food_repository.dart';
import '../repositories/keyword_repository.dart';
import '../repositories/recipe_repository.dart';
import 'text_match.dart';

/// Finds recipes whose name, ingredients or keywords match the search text.
///
/// Tandoor's text search only covers what the user's search preference says
/// (by default the name), and its text, food and keyword parameters combine
/// with AND. So this looks up the foods and keywords that match the text and
/// runs three searches, each with the other filters of the query: by name,
/// by any of those foods (`foods_or`) and by any of those keywords
/// (`keywords_or`). Their results are merged page by page: name matches
/// first, then food matches, then keyword matches, each recipe once.
class UniversalSearch {
  const UniversalSearch({
    required this.recipes,
    required this.foods,
    required this.keywords,
    this.candidateLimit = 20,
  });

  final RecipeRepository recipes;
  final FoodRepository foods;
  final KeywordRepository keywords;

  /// How many matching foods and keywords are searched for at most.
  final int candidateLimit;

  /// A search for [query], [pageSize] results at a time. [cancel] aborts
  /// every request it makes.
  RecipeSearch start(
    RecipeQuery query, {
    int pageSize = 25,
    CancelSignal? cancel,
  }) => RecipeSearch._(this, query, pageSize, cancel);
}

enum _Kind { name, foods, keywords }

/// One of the searches that are merged.
class _Source {
  _Source(this.kind);

  final _Kind kind;
  var nextPage = 1;
  var exhausted = false;

  /// Results over all pages, known once the first page loaded.
  int? count;
  final buffer = Queue<RecipeSummary>();
}

/// The results of one [UniversalSearch], loaded with [next].
class RecipeSearch {
  RecipeSearch._(this._search, this.query, this.pageSize, this._cancel)
    : _text = query.text.trim() {
    _sources = _text.isEmpty
        ? [_Source(_Kind.name)]
        : [for (final kind in _Kind.values) _Source(kind)];
  }

  final UniversalSearch _search;
  final RecipeQuery query;
  final int pageSize;
  final CancelSignal? _cancel;
  final String _text;
  late final List<_Source> _sources;

  /// Recipes already returned, so none is returned twice.
  final _seen = <int>{};

  Future<List<Food>>? _foodLookup;
  Future<List<Keyword>>? _keywordLookup;
  List<Food>? _foods;
  List<Keyword>? _keywords;

  var _started = false;
  var _fromCache = false;
  var _total = 0;

  /// The next page of results: up to [pageSize] recipes that weren't
  /// returned before. Wait for one call to finish before the next.
  ///
  /// The first call fails when the name search fails. A later source that
  /// fails ends the page early with the results so far; the call after that
  /// tries it again, and fails if it fails again. The failure is a [Failure].
  Future<ResultPage<RecipeMatch>> next() async {
    _checkCancelled();
    if (!_started) await _start();

    final items = <RecipeMatch>[];
    for (final source in _sources) {
      while (items.length < pageSize) {
        if (source.buffer.isNotEmpty) {
          final recipe = source.buffer.removeFirst();
          if (_seen.add(recipe.id)) items.add(_match(source.kind, recipe));
          continue;
        }
        if (source.exhausted) break;
        try {
          await _advance(source);
        } on Failure {
          _checkCancelled();
          if (items.isEmpty) rethrow;
          return _page(items, hasMore: true);
        }
      }
      if (items.length >= pageSize) break;
    }
    return _page(
      items,
      hasMore: _sources.any((s) => s.buffer.isNotEmpty || !s.exhausted),
    );
  }

  ResultPage<RecipeMatch> _page(
    List<RecipeMatch> items, {
    required bool hasMore,
  }) {
    // Once everything is loaded, the count is exact.
    if (!hasMore || _total < _seen.length) _total = _seen.length;
    return ResultPage(
      items: items,
      totalCount: _total,
      hasMore: hasMore,
      fromCache: _fromCache,
    );
  }

  /// Loads the first page of every source at once, so the total is known.
  Future<void> _start() async {
    final failures = await Future.wait([
      for (final source in _sources)
        // After a failed first call, only what failed is loaded again.
        source.nextPage == 1 && !source.exhausted
            ? _tryAdvance(source)
            : Future.value(null),
    ]);
    _checkCancelled();
    // Without the name search there is nothing worth showing; a failed food
    // or keyword search is tried again when its turn comes.
    if (failures.first case final failure?) throw failure;
    _started = true;

    final name = _sources.first;
    if (_fromCache) {
      // Offline: the cache already matched names, ingredients and keywords.
      for (final source in _sources.skip(1)) {
        source
          ..buffer.clear()
          ..exhausted = true;
      }
      // Name matches first, as online.
      final recipes = name.buffer.toList();
      name.buffer
        ..clear()
        ..addAll(recipes.where((r) => containsFolded(r.name, _text)))
        ..addAll(recipes.where((r) => !containsFolded(r.name, _text)));
      _total = name.count ?? 0;
      return;
    }
    _total = await _countAll();
  }

  Future<Failure?> _tryAdvance(_Source source) async {
    try {
      await _advance(source);
      return null;
    } on Failure catch (failure) {
      return failure;
    }
  }

  /// Loads the next page of [source].
  Future<void> _advance(_Source source) async {
    final query = await _queryFor({source.kind});
    if (query == null) {
      source
        ..count = 0
        ..exhausted = true;
      return;
    }
    final page = await _search.recipes.search(
      query,
      page: source.nextPage,
      pageSize: pageSize,
      cancel: _cancel,
    );
    if (page.fromCache) {
      // Only a whole search can come from the cache; offline results mixed
      // into server results would be misleading.
      if (source.kind != _Kind.name || source.nextPage != 1 || _started) {
        throw const OfflineFailure();
      }
      _fromCache = true;
    }
    source
      ..nextPage += 1
      ..count = page.totalCount
      ..exhausted = !page.hasMore
      ..buffer.addAll(page.items);
  }

  /// The query for the recipes that every one of [kinds] matches, or `null`
  /// if no recipe can match (no food or keyword matches the text).
  Future<RecipeQuery?> _queryFor(Set<_Kind> kinds) async {
    if (_text.isEmpty) return query;
    var result = query.copyWith(text: '');
    if (kinds.contains(_Kind.name)) result = result.copyWith(text: _text);
    if (kinds.contains(_Kind.foods)) {
      final foods = await _matchingFoods();
      if (foods.isEmpty) return null;
      result = result.copyWith(anyFoodIds: {for (final f in foods) f.id});
    }
    if (kinds.contains(_Kind.keywords)) {
      final keywords = await _matchingKeywords();
      if (keywords.isEmpty) return null;
      result = result.copyWith(anyKeywordIds: {for (final k in keywords) k.id});
    }
    return result;
  }

  Future<List<Food>> _matchingFoods() async {
    if (_foods case final foods?) return foods;
    final lookup = _foodLookup ??= _search.foods.autocomplete(
      _text,
      limit: _search.candidateLimit,
      cancel: _cancel,
    );
    try {
      // With a fuzzy search preference Tandoor returns foods that are only
      // similar ("Kartoffel" for "Karotte"); keep those that contain the text.
      return _foods = [
        for (final food in await lookup)
          if (_foodMatches(food)) food,
      ];
    } on Failure {
      _foodLookup = null;
      rethrow;
    }
  }

  Future<List<Keyword>> _matchingKeywords() async {
    if (_keywords case final keywords?) return keywords;
    final lookup = _keywordLookup ??= _search.keywords.autocomplete(
      _text,
      limit: _search.candidateLimit,
      cancel: _cancel,
    );
    try {
      return _keywords = [
        for (final keyword in await lookup)
          if (containsFolded(keyword.name, _text)) keyword,
      ];
    } on Failure {
      _keywordLookup = null;
      rethrow;
    }
  }

  bool _foodMatches(Food food) =>
      containsFolded(food.name, _text) ||
      containsFolded(food.pluralName ?? '', _text);

  /// The number of distinct recipes over all sources: exact when every
  /// source fit on its first page or the overlaps could be counted, else an
  /// estimate that becomes exact once everything is loaded.
  Future<int> _countAll() async {
    final loaded = {
      for (final source in _sources)
        for (final recipe in source.buffer) recipe.id,
    };
    final complete = _sources.every((s) => s.exhausted);
    if (complete) return loaded.length;

    final duplicates =
        _sources.fold(0, (sum, s) => sum + s.buffer.length) - loaded.length;
    final estimate =
        _sources.fold(0, (sum, s) => sum + (s.count ?? 0)) - duplicates;
    final counted = [
      for (final source in _sources)
        if ((source.count ?? 0) > 0) source.kind,
    ];
    if (_sources.any((s) => s.count == null)) return estimate;
    if (counted.length < 2) return estimate;

    // Inclusion–exclusion: |A ∪ B ∪ C| = Σ|A| − Σ|A ∩ B| + |A ∩ B ∩ C|.
    final subsets = <Set<_Kind>>[
      for (var i = 0; i < counted.length; i++)
        for (var j = i + 1; j < counted.length; j++) {counted[i], counted[j]},
      if (counted.length == 3) counted.toSet(),
    ];
    try {
      final overlaps = await Future.wait([
        for (final subset in subsets) _count(subset),
      ]);
      var total = _sources.fold(0, (sum, s) => sum + s.count!);
      for (var i = 0; i < subsets.length; i++) {
        total += subsets[i].length.isEven ? -overlaps[i] : overlaps[i];
      }
      return total;
    } on Failure {
      _checkCancelled();
      return estimate;
    }
  }

  Future<int> _count(Set<_Kind> kinds) async {
    final query = await _queryFor(kinds);
    if (query == null) return 0;
    final page = await _search.recipes.search(
      query,
      pageSize: 1,
      cancel: _cancel,
    );
    if (page.fromCache) throw const OfflineFailure();
    return page.totalCount;
  }

  /// Why [recipe], found by the [kind] search, matched.
  RecipeMatch _match(_Kind kind, RecipeSummary recipe) {
    if (_text.isEmpty) return RecipeMatch(recipe: recipe);
    switch (kind) {
      case _Kind.foods:
        final candidates = _foods ?? const [];
        // Recipes from the cache know their foods; server results don't.
        final ids = {for (final food in recipe.foods) food.id};
        final present = [
          for (final food in candidates)
            if (ids.contains(food.id)) food,
        ];
        return RecipeMatch(
          recipe: recipe,
          foods: present.isEmpty ? candidates : present,
        );
      case _Kind.keywords:
        final candidates = _keywords ?? const [];
        final ids = {for (final keyword in recipe.keywords) keyword.id};
        // A child keyword of a match doesn't match the text itself.
        final present = [
          for (final keyword in candidates)
            if (ids.contains(keyword.id)) keyword,
        ];
        return RecipeMatch(
          recipe: recipe,
          keywords: present.isEmpty ? candidates : present,
        );
      case _Kind.name:
        // The user's search preference, or the offline cache, may also
        // match ingredients and keywords.
        if (containsFolded(recipe.name, _text)) {
          return RecipeMatch(recipe: recipe);
        }
        return RecipeMatch(
          recipe: recipe,
          foods: [
            for (final food in recipe.foods)
              if (_foodMatches(food)) food,
          ],
          keywords: [
            for (final keyword in recipe.keywords)
              if (containsFolded(keyword.name, _text)) keyword,
          ],
        );
    }
  }

  void _checkCancelled() {
    if (_cancel?.isCancelled ?? false) throw const CancelledFailure();
  }
}
