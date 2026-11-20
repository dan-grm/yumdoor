import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';

void main() {
  test('normalizes overflowing days and months', () {
    expect(CalendarDay(2026, 1, 32), CalendarDay(2026, 2, 1));
    expect(CalendarDay(2026, 13, 1), CalendarDay(2027, 1, 1));
    expect(CalendarDay(2026, 3, 0), CalendarDay(2026, 2, 28));
  });

  test('takes the day of a DateTime in its own time zone', () {
    expect(
      CalendarDay.of(DateTime(2026, 11, 20, 23, 59)),
      CalendarDay(2026, 11, 20),
    );
    expect(
      CalendarDay.of(DateTime.utc(2026, 11, 20, 0, 30)),
      CalendarDay(2026, 11, 20),
    );
  });

  test('adds days across months, years and leap days', () {
    expect(CalendarDay(2026, 11, 30).addDays(1), CalendarDay(2026, 12, 1));
    expect(CalendarDay(2026, 12, 31).addDays(1), CalendarDay(2027, 1, 1));
    expect(CalendarDay(2028, 2, 28).addDays(1), CalendarDay(2028, 2, 29));
    expect(CalendarDay(2026, 3, 1).addDays(-1), CalendarDay(2026, 2, 28));
  });

  test('counts the days between two days, also over a DST change', () {
    // Europe switches to summer time on 2026-03-29.
    expect(
      CalendarDay(2026, 3, 30).differenceInDays(CalendarDay(2026, 3, 28)),
      2,
    );
    expect(
      CalendarDay(2026, 11, 16).differenceInDays(CalendarDay(2026, 11, 22)),
      -6,
    );
  });

  test('compares and orders days', () {
    final monday = CalendarDay(2026, 11, 16);
    final tuesday = CalendarDay(2026, 11, 17);

    expect(monday.isBefore(tuesday), isTrue);
    expect(tuesday.isAfter(monday), isTrue);
    expect(monday.isBefore(CalendarDay(2026, 11, 16)), isFalse);
    expect([tuesday, monday]..sort(), [monday, tuesday]);
    expect(CalendarDay(2026, 11, 16).hashCode, monday.hashCode);
  });

  test('knows its weekday', () {
    expect(CalendarDay(2026, 11, 16).weekday, DateTime.monday);
    expect(CalendarDay(2026, 11, 22).weekday, DateTime.sunday);
  });

  test('is a local DateTime at a time of day', () {
    expect(
      CalendarDay(
        2026,
        11,
        16,
      ).atLocalTime(const Duration(hours: 18, minutes: 30, seconds: 5)),
      DateTime(2026, 11, 16, 18, 30, 5),
    );
    expect(CalendarDay(2026, 11, 16).atLocalTime(), DateTime(2026, 11, 16));
  });

  test('prints as an ISO 8601 date', () {
    expect(CalendarDay(2026, 3, 7).toString(), '2026-03-07');
  });
}
