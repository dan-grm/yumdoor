import 'package:json_annotation/json_annotation.dart';

/// A day in the calendar, without a time or a time zone, such as the day a
/// meal is planned for.
class CalendarDay implements Comparable<CalendarDay> {
  /// Normalizes overflowing values like [DateTime] does: `CalendarDay(2026,
  /// 1, 32)` is February 1.
  factory CalendarDay(int year, int month, int day) {
    final utc = DateTime.utc(year, month, day);
    return CalendarDay._(utc.year, utc.month, utc.day);
  }

  /// The day [dateTime] falls on in its own time zone: local for a local
  /// [DateTime], UTC for a UTC one. Convert with [DateTime.toLocal] first for
  /// the day on this device.
  factory CalendarDay.of(DateTime dateTime) =>
      CalendarDay._(dateTime.year, dateTime.month, dateTime.day);

  /// Today on this device.
  factory CalendarDay.today() => CalendarDay.of(DateTime.now());

  /// The day written as in [toString] (`2026-11-20`), or `null` if [text] is
  /// not such a day, as for `2026-02-30`.
  static CalendarDay? tryParse(String text) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
    if (match == null) return null;
    final [year, month, day] = [
      for (var i = 1; i <= 3; i++) int.parse(match.group(i)!),
    ];
    final parsed = CalendarDay(year, month, day);
    return parsed.month == month && parsed.day == day ? parsed : null;
  }

  const CalendarDay._(this.year, this.month, this.day);

  final int year;

  /// 1 to 12.
  final int month;

  /// 1 to 31.
  final int day;

  /// 1 (Monday) to 7 (Sunday), like [DateTime.weekday].
  int get weekday => _utc.weekday;

  /// The day [days] days later (earlier for a negative [days]).
  CalendarDay addDays(int days) => CalendarDay(year, month, day + days);

  /// The number of days from [other] to this day: 1 if this is the day after
  /// [other], negative if it is before.
  int differenceInDays(CalendarDay other) => _utc.difference(other._utc).inDays;

  bool isBefore(CalendarDay other) => compareTo(other) < 0;
  bool isAfter(CalendarDay other) => compareTo(other) > 0;

  /// This day at [timeOfDay] after midnight, in this device's time zone.
  DateTime atLocalTime([Duration timeOfDay = Duration.zero]) => DateTime(
    year,
    month,
    day,
    timeOfDay.inHours,
    timeOfDay.inMinutes.remainder(60),
    timeOfDay.inSeconds.remainder(60),
  );

  DateTime get _utc => DateTime.utc(year, month, day);

  @override
  int compareTo(CalendarDay other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) =>
      other is CalendarDay &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  /// ISO 8601, e.g. `2026-11-20`.
  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}

/// Stores a [CalendarDay] as written by [CalendarDay.toString], for the
/// offline cache's JSON.
class CalendarDayConverter implements JsonConverter<CalendarDay, String> {
  const CalendarDayConverter();

  @override
  CalendarDay fromJson(String json) =>
      CalendarDay.tryParse(json) ??
      (throw FormatException('Not a calendar day', json));

  @override
  String toJson(CalendarDay day) => day.toString();
}
