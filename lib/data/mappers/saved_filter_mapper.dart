import 'dart:convert';

import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_sort.dart';
import '../../domain/models/saved_filter.dart';
import 'mapping.dart';
import 'recipe_sort_mapper.dart';

extension SavedFilterMapper on api.CustomFilter {
  /// [userId] is the current user's, to tell their own saved searches from
  /// those shared with them.
  SavedFilter toDomain({required int userId}) => SavedFilter(
    id: requireId(id, 'CustomFilter'),
    name: name,
    query: savedSearchQuery(search),
    own: createdBy == userId,
  );
}

/// The search a saved search's `search` JSON stands for, as the search
/// screen shows it, or `null` if it has parameters the filter chips can't
/// show (or can't be read).
///
/// Tandoor's search page saves the parameters it shows as JSON, with
/// `"version": "2"` (`vue3/src/pages/SearchPage.vue`,
/// docs/TANDOOR_API.md#saved-searches).
RecipeQuery? savedSearchQuery(String json) {
  final Object? decoded;
  try {
    decoded = jsonDecode(json);
  } on FormatException {
    return null;
  }
  if (decoded is! Map<String, dynamic>) return null;
  // Tandoor reads `keywords` only without `keywords_or`, and so on.
  final params = {...decoded};
  for (final alias in ['keywords', 'foods', 'books']) {
    if (!_isEmpty(params['${alias}_or'])) params.remove(alias);
  }
  var query = const RecipeQuery();
  for (final MapEntry(:key, :value) in params.entries) {
    if (_isEmpty(value)) continue;
    final next = _apply(query, key, value as Object);
    if (next == null) return null;
    query = next;
  }
  return query;
}

/// [query] with the saved search parameter [key] set to [value], `null` if
/// the chips can't show it.
RecipeQuery? _apply(RecipeQuery query, String key, Object value) {
  switch (key) {
    case 'version' || 'page' || 'page_size':
      return query;
    case 'include_children':
      // Tandoor's default; anything else changes every food and keyword
      // filter.
      return '$value' == 'true' ? query : null;
    case 'query':
      return value is String ? query.copyWith(text: value.trim()) : null;
    case 'foods_and':
      return _withIds(
        value,
        (ids) => query.copyWith(foodIds: {...query.foodIds, ...ids}),
      );
    case 'keywords_and':
      return _withIds(
        value,
        (ids) => query.copyWith(keywordIds: {...query.keywordIds, ...ids}),
      );
    // "Any of": a single one is the same as "all of"; more can't be shown.
    case 'foods' || 'foods_or':
      return _withIds(
        value,
        (ids) => ids.length == 1
            ? query.copyWith(foodIds: {...query.foodIds, ...ids})
            : null,
      );
    case 'keywords' || 'keywords_or':
      return _withIds(
        value,
        (ids) => ids.length == 1
            ? query.copyWith(keywordIds: {...query.keywordIds, ...ids})
            : null,
      );
    case 'books' || 'books_or':
      return _withIds(
        value,
        (ids) => query.copyWith(bookIds: {...query.bookIds, ...ids}),
      );
    case 'rating_gte':
      return switch (_int(value)) {
        final rating? when rating >= 1 && rating <= 5 => query.copyWith(
          minRating: rating,
        ),
        _ => null,
      };
    case 'cookedon_lte':
      return switch (_day(value)) {
        final day? => query.copyWith(lastCookedBefore: day),
        null => null,
      };
    case 'timescooked':
      return _int(value) == 0
          ? query.copyWith(neverCooked: true, minTimesCooked: null)
          : null;
    case 'timescooked_gte':
      return switch (_int(value)) {
        // Never cooked wins, as on Tandoor.
        _ when query.neverCooked => query,
        final times? when times >= 1 => query.copyWith(minTimesCooked: times),
        _ => null,
      };
    case 'makenow':
      // Tandoor's search page saves "true" (cookable now) and "false"
      // (no filter); Yumdoor saves the number of missing foods.
      return switch (value) {
        true || 'true' || 'yes' => query.copyWith(maxMissingFoods: 0),
        false || 'false' => query,
        _ => switch (_int(value)) {
          final missing? when missing == 0 || missing == 1 => query.copyWith(
            maxMissingFoods: missing,
          ),
          _ => null,
        },
      };
    case 'createdby':
      return switch (_int(value)) {
        final user? when user > 0 => query.copyWith(createdBy: user),
        _ => null,
      };
    case 'sort_order':
      // An order Yumdoor doesn't offer (or Tandoor can't sort by, such as
      // `times_cooked`) only doesn't apply: it doesn't narrow the search.
      return query.copyWith(sort: query.sort ?? _sort('$value'));
    case 'random':
      return '$value' == 'true'
          ? query.copyWith(sort: RecipeSort.random)
          : query;
    default:
      return null;
  }
}

/// [query] as the `search` JSON of a saved search, in the format Tandoor's
/// search page reads (so a search saved in Yumdoor opens there too).
String savedSearchJson(RecipeQuery query) {
  if (query.savedFilter != null) {
    throw ArgumentError.value(query, 'query', 'contains a saved search');
  }
  final text = query.text.trim();
  // Tandoor's search page names relevance `-score` and the random order
  // `random`.
  final sortOrder = switch (query.sort) {
    null => null,
    RecipeSort.relevance => '-score',
    RecipeSort.random => 'random',
    final sort => sortParams(sort).sortOrder,
  };
  return jsonEncode({
    if (text.isNotEmpty) 'query': text,
    if (query.foodIds.isNotEmpty) 'foods_and': [...query.foodIds],
    if (query.keywordIds.isNotEmpty) 'keywords_and': [...query.keywordIds],
    if (query.anyFoodIds.isNotEmpty) 'foods': [...query.anyFoodIds],
    if (query.anyKeywordIds.isNotEmpty) 'keywords': [...query.anyKeywordIds],
    if (query.bookIds.isNotEmpty) 'books': [...query.bookIds],
    'rating_gte': ?query.minRating,
    if (query.lastCookedBefore case final day?) 'cookedon_lte': _formatDay(day),
    if (query.neverCooked)
      'timescooked': 0
    else
      'timescooked_gte': ?query.minTimesCooked,
    // Tandoor's search page only knows "true"; the server reads a number.
    if (query.maxMissingFoods case final missing?)
      'makenow': missing == 0 ? 'true' : missing,
    'createdby': ?query.createdBy,
    'sort_order': ?sortOrder,
    'version': '2',
  });
}

/// The sort order with [sortOrder] as Tandoor's `sort_order`, `null` if
/// Yumdoor doesn't offer it.
RecipeSort? _sort(String sortOrder) => switch (sortOrder) {
  'random' => RecipeSort.random,
  'score' || '-score' => RecipeSort.relevance,
  _ =>
    RecipeSort.values
        .where((sort) => sortParams(sort).sortOrder == sortOrder)
        .firstOrNull,
};

/// Whether Tandoor treats [value] as not given.
bool _isEmpty(Object? value) =>
    value == null || value == '' || (value is List && value.isEmpty);

/// The ids in [value], a list of ids or of objects with an `id` (Tandoor's
/// search page saves some lists that way), passed to [use]; `null` if
/// [value] is something else.
RecipeQuery? _withIds(Object value, RecipeQuery? Function(Set<int> ids) use) {
  if (value is! List) return null;
  final ids = <int>{};
  for (final item in value) {
    final id = switch (item) {
      {'id': final Object id} => _int(id),
      _ => _int(item),
    };
    if (id == null || id <= 0) return null;
    ids.add(id);
  }
  return use(ids);
}

int? _int(Object? value) => switch (value) {
  int() => value,
  double() when value == value.roundToDouble() => value.toInt(),
  String() => int.tryParse(value.trim()),
  _ => null,
};

/// The day in [value]: `2026-11-01`, or a date and time such as Tandoor's
/// search page saves (`2026-10-31T23:00:00.000Z`, midnight in the browser's
/// time zone), taken in local time.
DateTime? _day(Object value) {
  if (value is! String) return null;
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value.trim());
  if (match != null) {
    final [year, month, day] = [
      for (var group = 1; group <= 3; group++) int.parse(match.group(group)!),
    ];
    final date = DateTime(year, month, day);
    return date.month == month && date.day == day ? date : null;
  }
  final time = DateTime.tryParse(value.trim())?.toLocal();
  return time == null ? null : DateTime(time.year, time.month, time.day);
}

String _formatDay(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';
