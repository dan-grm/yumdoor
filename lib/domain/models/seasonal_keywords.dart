import 'dart:convert';

import 'calendar_day.dart';

/// Which keywords mean "in season" in which month, as set up by the user:
/// month (1 to 12) → keyword ids. Empty by default; nothing is built in.
///
/// Keywords are mapped by id, so a renamed keyword stays mapped. Ids of
/// keywords deleted on the server are dropped with [retainKeywords]. The
/// last known name of each keyword is kept next to its id ([nameOf]), to
/// show it while the server can't be asked.
class SeasonalKeywords {
  /// Throws an [ArgumentError] for a month outside 1 to 12. Months without
  /// keywords are left out, and so are [names] of unmapped keywords.
  factory SeasonalKeywords(
    Map<int, Iterable<int>> months, {
    Map<int, String> names = const {},
  }) {
    for (final month in months.keys) {
      _checkMonth(month);
    }
    final mapped = {
      for (final MapEntry(key: month, value: ids) in months.entries)
        if (ids.isNotEmpty) month: Set<int>.unmodifiable(ids),
    };
    final used = {for (final ids in mapped.values) ...ids};
    return SeasonalKeywords._(mapped, {
      for (final MapEntry(key: id, value: name) in names.entries)
        if (used.contains(id) && name.isNotEmpty) id: name,
    });
  }

  /// No keywords in any month.
  const SeasonalKeywords.empty() : _months = const {}, _names = const {};

  const SeasonalKeywords._(this._months, this._names);

  final Map<int, Set<int>> _months;
  final Map<int, String> _names;

  /// The last known name of keyword [id]; `null` if none was stored, e.g.
  /// in a mapping saved before names were kept.
  String? nameOf(int id) => _names[id];

  /// A copy that knows [names] (id → name) of mapped keywords; other ids are
  /// ignored.
  SeasonalKeywords withNames(Map<int, String> names) =>
      SeasonalKeywords(_months, names: {..._names, ...names});

  /// Whether no month has keywords.
  bool get isEmpty => _months.isEmpty;

  /// The keyword ids of [month] (1 to 12); empty if it has none. Throws an
  /// [ArgumentError] for another month.
  Set<int> forMonth(int month) {
    _checkMonth(month);
    return _months[month] ?? const {};
  }

  /// The keyword ids of the month [day] is in: what is in season on
  /// [day], e.g. `RecommendationContext.today`.
  Set<int> forDay(CalendarDay day) => forMonth(day.month);

  /// Every keyword id in any month.
  Set<int> get keywordIds => {for (final ids in _months.values) ...ids};

  /// A copy with [month]'s keywords replaced by [keywordIds]; an empty
  /// [keywordIds] clears the month. Throws an [ArgumentError] for a month
  /// outside 1 to 12.
  SeasonalKeywords withMonth(
    int month,
    Iterable<int> keywordIds, {
    Map<int, String> names = const {},
  }) {
    _checkMonth(month);
    return SeasonalKeywords(
      {..._months, month: keywordIds},
      names: {..._names, ...names},
    );
  }

  /// A copy with only the keyword ids in [existing], e.g. to drop keywords
  /// deleted on the server.
  SeasonalKeywords retainKeywords(Set<int> existing) => SeasonalKeywords({
    for (final MapEntry(key: month, value: ids) in _months.entries)
      month: ids.where(existing.contains),
  }, names: _names);

  static void _checkMonth(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be 1 to 12');
    }
  }

  static const _namesKey = 'names';

  /// `{"1": [4, 7], "10": [12], "names": {"4": "Spargel"}}`: months in
  /// order, ids sorted; `names` only if there are any.
  String toJson() => jsonEncode({
    for (final month in _months.keys.toList()..sort())
      '$month': _months[month]!.toList()..sort(),
    if (_names.isNotEmpty)
      _namesKey: {
        for (final id in _names.keys.toList()..sort()) '$id': _names[id],
      },
  });

  /// Parses what [toJson] wrote, or the older form without `names`; `null`
  /// if [source] is not that, e.g. written by another version or edited by
  /// hand.
  static SeasonalKeywords? fromJson(String source) {
    try {
      final json = jsonDecode(source);
      if (json is! Map<String, Object?>) return null;
      final months = <int, List<int>>{};
      final names = <int, String>{};
      for (final MapEntry(:key, :value) in json.entries) {
        if (key == _namesKey) {
          if (value is! Map<String, Object?>) return null;
          for (final MapEntry(key: idKey, value: name) in value.entries) {
            final id = int.tryParse(idKey);
            if (id == null || name is! String) return null;
            names[id] = name;
          }
          continue;
        }
        final month = int.tryParse(key);
        // Only keys as toJson writes them, so "05" can't replace "5".
        if (month == null || month < 1 || month > 12 || '$month' != key) {
          return null;
        }
        if (value is! List<Object?> || value.any((id) => id is! int)) {
          return null;
        }
        months[month] = value.cast<int>();
      }
      return SeasonalKeywords(months, names: names);
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is SeasonalKeywords &&
      other._months.length == _months.length &&
      _months.entries.every((entry) {
        final ids = other._months[entry.key];
        return ids != null &&
            ids.length == entry.value.length &&
            ids.containsAll(entry.value);
      }) &&
      other._names.length == _names.length &&
      _names.entries.every((entry) => other._names[entry.key] == entry.value);

  @override
  int get hashCode => Object.hashAllUnordered([
    for (final MapEntry(key: month, value: ids) in _months.entries)
      Object.hash(month, Object.hashAllUnordered(ids)),
    for (final MapEntry(:key, :value) in _names.entries)
      Object.hash(key, value),
  ]);

  @override
  String toString() => 'SeasonalKeywords(${toJson()})';
}
