import '../../domain/models/calendar_day.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/recipe_sort.dart';

/// The path of the search screen.
const searchPath = '/search';

// Query parameters, so a search survives reload and can be shared:
// `/search?q=suppe&food=12&food=40&keyword=3&rating=4&cooked_before=2026-09-01`,
// `never=1` and `times_min=5` for the times cooked, `missing=0` for cookable
// now (`1`: one food missing), `book=4&book=7`, `created_by=2` and
// `sort=rating` (only when the user chose an order), `saved=5` for a saved
// search the chips can't show.
const _text = 'q';
const _food = 'food';
const _keyword = 'keyword';
const _minRating = 'rating';
const _lastCookedBefore = 'cooked_before';
const _neverCooked = 'never';
const _minTimesCooked = 'times_min';
const _maxMissingFoods = 'missing';
const _book = 'book';
const _createdBy = 'created_by';
const _sort = 'sort';
const _savedFilter = 'saved';
const _pickDay = 'day';

/// The value of the sort parameter for [sort].
String _sortName(RecipeSort sort) => switch (sort) {
  RecipeSort.relevance => 'relevance',
  RecipeSort.name => 'name',
  RecipeSort.lastCooked => 'last_cooked',
  RecipeSort.rating => 'rating',
  RecipeSort.newest => 'newest',
  RecipeSort.recentlyViewed => 'viewed',
  RecipeSort.random => 'random',
};

/// The most missing foods a link may ask for; the search screen offers 0
/// and 1.
const _maxMissingLimit = 1;

/// The path of the search screen in picker mode, opened from the planner to
/// choose a recipe for a day (`?day=2026-11-25`, besides the search
/// parameters). It covers the whole screen, like the recipe.
const pickRecipePath = '/plan/pick';

/// The location of the picker showing [query], planning for [day].
String pickRecipeLocation(RecipeQuery query, CalendarDay day) =>
    searchLocation(query, pickDay: day);

/// The day the picker at [uri] plans for, `null` if it is missing or invalid.
CalendarDay? pickDayFromUri(Uri uri) =>
    CalendarDay.tryParse(uri.queryParameters[_pickDay] ?? '');

/// The location of the search screen showing [query]; the picker for
/// [pickDay] if given.
String searchLocation(RecipeQuery query, {CalendarDay? pickDay}) {
  final text = query.text.trim();
  final params = <String, List<String>>{
    if (text.isNotEmpty) _text: [text],
    if (query.foodIds.isNotEmpty)
      _food: [for (final id in query.foodIds) '$id'],
    if (query.keywordIds.isNotEmpty)
      _keyword: [for (final id in query.keywordIds) '$id'],
    if (query.minRating case final rating?) _minRating: ['$rating'],
    if (query.lastCookedBefore case final day?)
      _lastCookedBefore: [_formatDay(day)],
    if (query.neverCooked)
      _neverCooked: ['1']
    else if (query.minTimesCooked case final times?)
      _minTimesCooked: ['$times'],
    if (query.maxMissingFoods case final missing?)
      _maxMissingFoods: ['$missing'],
    if (query.bookIds.isNotEmpty)
      _book: [for (final id in query.bookIds) '$id'],
    if (query.createdBy case final user?) _createdBy: ['$user'],
    if (query.sort case final sort?) _sort: [_sortName(sort)],
    if (query.savedFilter case final filter?) _savedFilter: ['$filter'],
    if (pickDay != null) _pickDay: ['$pickDay'],
  };
  return Uri(
    path: pickDay == null ? searchPath : pickRecipePath,
    queryParameters: params.isEmpty ? null : params,
  ).toString();
}

/// The query in a search location. Parameters that don't parse are dropped,
/// so a mangled link still opens the search.
RecipeQuery searchQueryFromUri(Uri uri) {
  final params = uri.queryParametersAll;
  Set<int> ids(String name) => {
    for (final value in params[name] ?? const <String>[])
      if (int.tryParse(value) case final id? when id > 0) id,
  };
  return RecipeQuery(
    text: (params[_text]?.first ?? '').trim(),
    foodIds: ids(_food),
    keywordIds: ids(_keyword),
    minRating: switch (int.tryParse(params[_minRating]?.first ?? '')) {
      final rating? when rating >= 1 && rating <= 5 => rating,
      _ => null,
    },
    lastCookedBefore: _parseDay(params[_lastCookedBefore]?.first),
    neverCooked: params[_neverCooked]?.first == '1',
    minTimesCooked: params[_neverCooked]?.first == '1'
        ? null
        : switch (int.tryParse(params[_minTimesCooked]?.first ?? '')) {
            final times? when times >= 1 => times,
            _ => null,
          },
    maxMissingFoods: switch (int.tryParse(
      params[_maxMissingFoods]?.first ?? '',
    )) {
      final missing? when missing >= 0 && missing <= _maxMissingLimit =>
        missing,
      _ => null,
    },
    bookIds: ids(_book),
    createdBy: switch (int.tryParse(params[_createdBy]?.first ?? '')) {
      final user? when user > 0 => user,
      _ => null,
    },
    savedFilter: switch (int.tryParse(params[_savedFilter]?.first ?? '')) {
      final filter? when filter > 0 => filter,
      _ => null,
    },
    sort: RecipeSort.values
        .where((sort) => _sortName(sort) == params[_sort]?.first)
        .firstOrNull,
  );
}

String _formatDay(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

DateTime? _parseDay(String? value) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value ?? '');
  if (match == null) return null;
  final [year, month, day] = [
    for (var group = 1; group <= 3; group++) int.parse(match.group(group)!),
  ];
  final date = DateTime(year, month, day);
  // DateTime rolls 2026-02-31 over into March; reject it instead.
  return date.month == month && date.day == day ? date : null;
}
