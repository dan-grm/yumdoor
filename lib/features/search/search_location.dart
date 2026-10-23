import '../../domain/models/recipe_query.dart';

/// The path of the search screen.
const searchPath = '/search';

// Query parameters, so a search survives reload and can be shared:
// `/search?q=suppe&food=12&food=40&keyword=3&rating=4&cooked_before=2026-09-01`.
const _text = 'q';
const _food = 'food';
const _keyword = 'keyword';
const _minRating = 'rating';
const _lastCookedBefore = 'cooked_before';

/// The location of the search screen showing [query].
String searchLocation(RecipeQuery query) {
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
  };
  return Uri(
    path: searchPath,
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
