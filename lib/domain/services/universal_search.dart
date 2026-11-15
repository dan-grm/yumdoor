import 'dart:async';
import 'dart:collection';

import '../../core/cancellation.dart';
import '../../core/failures.dart';
import '../models/food.dart';
import '../models/keyword.dart';
import '../models/recipe_match.dart';
import '../models/recipe_query.dart';
import '../models/recipe_sort.dart';
import '../models/recipe_summary.dart';
import '../models/result_page.dart';
import '../repositories/food_repository.dart';
import '../repositories/keyword_repository.dart';
import '../repositories/recipe_repository.dart';
import 'recipe_order.dart';
import 'text_match.dart';

/// Finds recipes whose name, ingredients or keywords match the search text.
///
/// Tandoor's text search only covers what the user's search preference says
/// (by default the name), and its text, food and keyword parameters combine
/// with AND. So this looks up the foods and keywords that match the text and
/// runs three searches, each with the other filters of the query: by name,
/// by any of those foods (`foods_or`) and by any of those keywords
/// (`keywords_or`). Their results are merged page by page, each recipe once.
///
/// How they are merged depends on the query's [RecipeQuery.effectiveSort].
/// Every search is sorted by the server in that order, and the merge always
/// takes the next recipe from the search whose next recipe comes first:
///
/// - By name, rating and newest, the results carry what they are sorted by
///   ([recipeOrder]), so the merged results are in that order as a whole.
///   Recipes that are equal come name matches first.
/// - By relevance, nothing is compared: name matches come first, then food
///   matches, then keyword matches, each part in the server's order.
/// - Last cooked, recently viewed and random can't be compared either
///   (results carry no last-cooked or viewed date), so they are merged like
///   relevance: name matches in that order first, then food matches, then
///   keyword matches.
///
/// A dynamic book holds the recipes added to it and those its saved search
/// finds. Tandoor can't search for both at once, so with books in the query
/// each of those searches also runs once per book with the book's saved
/// search ([RecipeQuery.savedSearchOfBook]; nothing for a book without
/// one), right after the one for the recipes added to the books.
class UniversalSearch {
  const UniversalSearch({
    required this.recipes,
    required this.foods,
    required this.keywords,
    this.candidateLimit = 50,
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
  _Source(this.kind, [this.savedSearchOfBook]);

  final _Kind kind;

  /// The book whose saved search this source runs instead of the query's
  /// books; `null` for the recipes added to them.
  final int? savedSearchOfBook;
  var nextPage = 1;
  var exhausted = false;

  /// Results over all pages, known once the first page loaded.
  int? count;
  final buffer = Queue<RecipeSummary>();
}

/// The results of one [UniversalSearch], loaded with [next].
class RecipeSearch {
  RecipeSearch._(this._search, this.query, this.pageSize, this._cancel)
    : _text = query.text.trim(),
      _matcher = TextMatcher(query.text),
      _sorted = recipeOrder(query.effectiveSort) != null,
      _order = recipeOrder(query.effectiveSort) ?? _sourceOrder {
    _sources = [
      for (final kind in _text.isEmpty ? [_Kind.name] : _Kind.values) ...[
        _Source(kind),
        for (final book in query.bookIds) _Source(kind, book),
      ],
    ];
  }

  final UniversalSearch _search;
  final RecipeQuery query;
  final int pageSize;
  final CancelSignal? _cancel;
  final String _text;
  final TextMatcher _matcher;

  /// Which of two recipes from different sources comes first; equal ones
  /// come in the order of [_sources].
  final Comparator<RecipeSummary> _order;

  /// Whether [_order] compares anything, rather than keeping the sources in
  /// their order.
  final bool _sorted;

  /// The searches in their order: by kind (name, foods, keywords), each
  /// first for the recipes added to the query's books, then for each book's
  /// saved search.
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
  /// Throws a [Failure] when the name search fails on the first call, or
  /// when nothing could be loaded. A food or keyword search that fails is
  /// tried again on the next call. By relevance it is skipped for this page,
  /// so its results may come after those of the sources behind it; sorted,
  /// the page ends where it failed, unless it would be empty.
  Future<ResultPage<RecipeMatch>> next() async {
    _checkCancelled();
    // Sources that already failed during this call aren't asked again.
    final failed = <_Source, Failure>{};
    if (!_started) failed.addAll(await _start());

    final items = <RecipeMatch>[];
    var withoutFailed = false;
    while (items.length < pageSize) {
      final empty = _sourcesToLoad(failed);
      if (empty.isNotEmpty) {
        final failures = await Future.wait(empty.map(_tryAdvance));
        _checkCancelled();
        for (final (i, failure) in failures.indexed) {
          if (failure != null) failed[empty[i]] = failure;
        }
        continue;
      }
      _Source? first;
      for (final source in _sources) {
        if (source.buffer.isEmpty || failed.containsKey(source)) continue;
        if (first == null ||
            _order(source.buffer.first, first.buffer.first) < 0) {
          first = source;
        }
      }
      if (first == null) break;
      // Sorted: a source that failed may hold recipes that come before this
      // one, so the page ends here and the next call asks it again. A page
      // that would be empty goes on without it, so the search shows what it
      // can, possibly out of order.
      if (_sorted && failed.isNotEmpty && !withoutFailed) {
        if (items.isNotEmpty) break;
        withoutFailed = true;
      }
      final recipe = first.buffer.removeFirst();
      if (_seen.add(recipe.id)) items.add(_match(first.kind, recipe));
    }
    if (items.isEmpty && failed.isNotEmpty) throw failed.values.first;
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

  /// Loads the first page of every source at once, so the total is known,
  /// and returns the food and keyword sources that failed.
  Future<Map<_Source, Failure>> _start() async {
    final failures = await Future.wait([
      for (final source in _sources)
        // After a failed first call, only what failed is loaded again.
        source.nextPage == 1 && !source.exhausted
            ? _tryAdvance(source)
            : Future.value(null),
    ]);
    _checkCancelled();
    // Without the name search there is nothing worth showing.
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
      // The cache sorted them; by relevance, name matches come first, as
      // online.
      if (query.effectiveSort != RecipeSort.relevance) {
        _total = name.count ?? 0;
        return {};
      }
      final byName = <RecipeSummary>[];
      final others = <RecipeSummary>[];
      for (final recipe in name.buffer) {
        (_matcher.contains(recipe.name) ? byName : others).add(recipe);
      }
      name.buffer
        ..clear()
        ..addAll(byName)
        ..addAll(others);
      _total = name.count ?? 0;
      return {};
    }
    _total = await _countAll();
    return {for (final (i, failure) in failures.indexed) _sources[i]: ?failure};
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
    final query = await _queryFor({source.kind}, source.savedSearchOfBook);
    if (query == null) {
      source
        ..count = 0
        ..exhausted = true;
      return;
    }
    final ResultPage<RecipeSummary> page;
    try {
      page = await _search.recipes.search(
        query,
        page: source.nextPage,
        pageSize: pageSize,
        cancel: _cancel,
      );
    } on NotFoundFailure {
      // A later page is gone: recipes were deleted since the first page.
      if (source.nextPage == 1) rethrow;
      source.exhausted = true;
      return;
    }
    if (page.fromCache) {
      // Only a whole search can come from the cache; offline results mixed
      // into server results would be misleading.
      if (!identical(source, _sources.first) ||
          source.nextPage != 1 ||
          _started) {
        throw const OfflineFailure();
      }
      _fromCache = true;
    }
    // A source whose first page failed during the first call wasn't counted.
    if (_started && source.count == null) _total += page.totalCount;
    source
      ..nextPage += 1
      ..count = page.totalCount
      ..exhausted = !page.hasMore
      ..buffer.addAll(page.items);
  }

  /// The query for the recipes that every one of [kinds] matches, or `null`
  /// if no recipe can match (no food or keyword matches the text). With
  /// [savedSearchOfBook], for those the book's saved search finds instead of
  /// those added to the query's books.
  Future<RecipeQuery?> _queryFor(
    Set<_Kind> kinds, [
    int? savedSearchOfBook,
  ]) async {
    final query = savedSearchOfBook == null
        ? this.query
        : this.query.copyWith(
            bookIds: const {},
            savedSearchOfBook: savedSearchOfBook,
          );
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
          if (_matcher.food(food)) food,
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
          if (_matcher.keyword(keyword)) keyword,
      ];
    } on Failure {
      _keywordLookup = null;
      rethrow;
    }
  }

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
    // Overlaps between a book's recipes and those of a saved search can't be
    // counted without loading them. A book without one finds nothing.
    if (_sources.any((s) => s.savedSearchOfBook != null && s.count! > 0)) {
      return estimate;
    }

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
      // Only the count matters; sorting would make the server work for
      // nothing.
      query.copyWith(sort: null),
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
        if (_matcher.contains(recipe.name)) {
          return RecipeMatch(recipe: recipe);
        }
        return RecipeMatch(
          recipe: recipe,
          foods: [
            for (final food in recipe.foods)
              if (_matcher.food(food)) food,
          ],
          keywords: [
            for (final keyword in recipe.keywords)
              if (_matcher.keyword(keyword)) keyword,
          ],
        );
    }
  }

  /// The sources that need their next page before the next recipe can be
  /// picked. Sorted, that is every source that ran out; otherwise only the
  /// first one still in play, as the others aren't reached before it ends.
  List<_Source> _sourcesToLoad(Map<_Source, Failure> failed) {
    final load = <_Source>[];
    for (final source in _sources) {
      if (failed.containsKey(source)) continue;
      if (source.buffer.isEmpty && !source.exhausted) load.add(source);
      if (!_sorted && (source.buffer.isNotEmpty || !source.exhausted)) break;
    }
    return load;
  }

  /// Sources in their order: name, foods, keywords.
  static int _sourceOrder(RecipeSummary a, RecipeSummary b) => 0;

  void _checkCancelled() {
    if (_cancel?.isCancelled ?? false) throw const CancelledFailure();
  }
}
