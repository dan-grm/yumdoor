import 'dart:convert';

import 'calendar_day.dart';

/// Which keywords mean "in season" in which month, as set up by the user:
/// month (1 to 12) → keyword ids. Empty by default; nothing is built in.
///
/// Keywords are kept by id only, so a renamed keyword stays mapped. Ids of
/// keywords deleted on the server are dropped with [retainKeywords].
class SeasonalKeywords {
  /// Throws an [ArgumentError] for a month outside 1 to 12. Months without
  /// keywords are left out.
  factory SeasonalKeywords(Map<int, Iterable<int>> months) {
    for (final month in months.keys) {
      _checkMonth(month);
    }
    return SeasonalKeywords._({
      for (final MapEntry(key: month, value: ids) in months.entries)
        if (ids.isNotEmpty) month: Set.unmodifiable(ids),
    });
  }

  /// No keywords in any month.
  const SeasonalKeywords.empty() : _months = const {};

  const SeasonalKeywords._(this._months);

  final Map<int, Set<int>> _months;

  /// Whether no month has keywords.
  bool get isEmpty => _months.isEmpty;

  /// The keyword ids of [month] (1 to 12); empty if it has none. Throws an
  /// [ArgumentError] for another month.
  Set<int> forMonth(int month) {
    _checkMonth(month);
    return _months[month] ?? const {};
  }

  /// The keyword ids of the month [day] is in, e.g. today.
  Set<int> forDay(CalendarDay day) => forMonth(day.month);

  /// The keyword ids of the current month on this device.
  Set<int> get thisMonth => forDay(CalendarDay.today());

  /// Every keyword id in any month.
  Set<int> get keywordIds => {for (final ids in _months.values) ...ids};

  /// A copy with [month]'s keywords replaced by [keywordIds]; an empty
  /// [keywordIds] clears the month. Throws an [ArgumentError] for a month
  /// outside 1 to 12.
  SeasonalKeywords withMonth(int month, Iterable<int> keywordIds) {
    _checkMonth(month);
    return SeasonalKeywords({..._months, month: keywordIds});
  }

  /// A copy with only the keyword ids in [existing], e.g. to drop keywords
  /// deleted on the server.
  SeasonalKeywords retainKeywords(Set<int> existing) => SeasonalKeywords({
    for (final MapEntry(key: month, value: ids) in _months.entries)
      month: ids.where(existing.contains),
  });

  static void _checkMonth(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be 1 to 12');
    }
  }

  /// `{"1": [4, 7], "10": [12]}`: months in order, ids sorted.
  String toJson() => jsonEncode({
    for (final month in _months.keys.toList()..sort())
      '$month': _months[month]!.toList()..sort(),
  });

  /// Parses what [toJson] wrote; `null` if [source] is not that, e.g.
  /// written by another version or edited by hand.
  static SeasonalKeywords? fromJson(String source) {
    try {
      final json = jsonDecode(source);
      if (json is! Map<String, Object?>) return null;
      final months = <int, List<int>>{};
      for (final MapEntry(:key, :value) in json.entries) {
        final month = int.tryParse(key);
        if (month == null || month < 1 || month > 12) return null;
        if (value is! List<Object?> || value.any((id) => id is! int)) {
          return null;
        }
        months[month] = value.cast<int>();
      }
      return SeasonalKeywords(months);
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
      });

  @override
  int get hashCode => Object.hashAllUnordered([
    for (final MapEntry(key: month, value: ids) in _months.entries)
      Object.hash(month, Object.hashAllUnordered(ids)),
  ]);

  @override
  String toString() => 'SeasonalKeywords(${toJson()})';
}
