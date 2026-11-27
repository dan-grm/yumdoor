import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/seasonal_keywords.dart';

void main() {
  group('SeasonalKeywords', () {
    test('empty has no keywords in any month', () {
      const keywords = SeasonalKeywords.empty();

      expect(keywords.isEmpty, isTrue);
      expect(keywords.keywordIds, isEmpty);
      for (var month = 1; month <= 12; month++) {
        expect(keywords.forMonth(month), isEmpty);
      }
      expect(SeasonalKeywords({}), const SeasonalKeywords.empty());
    });

    test('months without keywords are left out', () {
      final keywords = SeasonalKeywords({3: [], 4: []});

      expect(keywords.isEmpty, isTrue);
      expect(keywords, const SeasonalKeywords.empty());
    });

    test('looks up a month', () {
      final keywords = SeasonalKeywords({
        10: [4, 7],
        11: [7],
      });

      expect(keywords.isEmpty, isFalse);
      expect(keywords.forMonth(10), {4, 7});
      expect(keywords.forMonth(11), {7});
      expect(keywords.forMonth(12), isEmpty);
      expect(keywords.keywordIds, {4, 7});
    });

    test('looks up the month of a day', () {
      final keywords = SeasonalKeywords({
        11: [7],
        12: [9],
      });

      expect(keywords.forDay(CalendarDay(2026, 11, 30)), {7});
      expect(keywords.forDay(CalendarDay(2026, 12, 1)), {9});
      expect(keywords.forDay(CalendarDay(2027, 1, 1)), isEmpty);
    });

    test('rejects months outside 1 to 12', () {
      expect(
        () => SeasonalKeywords({
          0: [1],
        }),
        throwsArgumentError,
      );
      expect(
        () => SeasonalKeywords({
          13: [1],
        }),
        throwsArgumentError,
      );
      const keywords = SeasonalKeywords.empty();
      expect(() => keywords.forMonth(0), throwsArgumentError);
      expect(() => keywords.forMonth(13), throwsArgumentError);
      expect(() => keywords.withMonth(13, [1]), throwsArgumentError);
    });

    test('withMonth replaces or clears one month', () {
      final keywords = SeasonalKeywords({
        5: [1],
        6: [2],
      });

      final changed = keywords.withMonth(5, [3, 4]);
      expect(changed.forMonth(5), {3, 4});
      expect(changed.forMonth(6), {2});
      expect(keywords.forMonth(5), {1}, reason: 'the original is unchanged');

      final cleared = keywords.withMonth(5, []).withMonth(6, []);
      expect(cleared.isEmpty, isTrue);
    });

    test('retainKeywords drops keywords that no longer exist', () {
      final keywords = SeasonalKeywords({
        5: [1, 2],
        6: [2],
        7: [3],
      });

      expect(
        keywords.retainKeywords({1, 3}),
        SeasonalKeywords({
          5: [1],
          7: [3],
        }),
      );
      expect(keywords.retainKeywords({}), const SeasonalKeywords.empty());
    });

    test('the keyword sets are read-only', () {
      final keywords = SeasonalKeywords({
        5: [1],
      });

      expect(() => keywords.forMonth(5).add(2), throwsUnsupportedError);
    });

    test('equality ignores order and duplicates', () {
      final a = SeasonalKeywords({
        1: [1, 2],
        2: [3],
      });
      final b = SeasonalKeywords({
        2: [3, 3],
        1: [2, 1],
      });

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(
        a,
        isNot(
          SeasonalKeywords({
            1: [1, 2],
          }),
        ),
      );
      expect(
        a,
        isNot(
          SeasonalKeywords({
            1: [1, 2],
            2: [4],
          }),
        ),
      );
      expect(
        a,
        isNot(
          SeasonalKeywords({
            1: [1, 2],
            3: [3],
          }),
        ),
      );
    });

    group('names', () {
      test('are kept for mapped keywords only', () {
        final keywords = SeasonalKeywords(
          {
            4: [1],
          },
          names: {1: 'Spargel', 9: 'Weg', 1000: ''},
        );

        expect(keywords.nameOf(1), 'Spargel');
        expect(keywords.nameOf(9), isNull);
      });

      test('withNames refreshes a renamed keyword', () {
        final keywords = SeasonalKeywords(
          {
            4: [1, 2],
          },
          names: {1: 'Alt', 2: 'Kürbis'},
        ).withNames({1: 'Neu', 7: 'x'});

        expect(keywords.nameOf(1), 'Neu');
        expect(keywords.nameOf(2), 'Kürbis');
        expect(keywords.nameOf(7), isNull);
      });

      test('withMonth keeps them and adds new ones', () {
        final keywords = SeasonalKeywords(
          {
            4: [1],
          },
          names: {1: 'Spargel'},
        ).withMonth(5, [1, 2], names: {2: 'Kürbis'});

        expect(keywords.nameOf(1), 'Spargel');
        expect(keywords.nameOf(2), 'Kürbis');
        expect(keywords.withMonth(5, []).nameOf(2), isNull);
      });

      test('retainKeywords drops names of dropped keywords', () {
        final keywords = SeasonalKeywords(
          {
            4: [1, 2],
          },
          names: {1: 'a', 2: 'b'},
        ).retainKeywords({1});

        expect(keywords.nameOf(1), 'a');
        expect(keywords.nameOf(2), isNull);
      });

      test('take part in equality', () {
        final a = SeasonalKeywords(
          {
            4: [1],
          },
          names: {1: 'a'},
        );
        final b = SeasonalKeywords(
          {
            4: [1],
          },
          names: {1: 'b'},
        );

        expect(a, isNot(b));
        expect(a, a.withNames({1: 'a'}));
      });
    });

    group('JSON', () {
      test('round trip', () {
        final keywords = SeasonalKeywords({
          12: [9, 3],
          1: [4],
        });

        final json = keywords.toJson();
        expect(json, '{"1":[4],"12":[3,9]}');
        expect(SeasonalKeywords.fromJson(json), keywords);
      });

      test('round trip with names', () {
        final keywords = SeasonalKeywords(
          {
            4: [1, 2],
          },
          names: {2: 'Kürbis', 1: 'Spargel'},
        );

        final json = keywords.toJson();
        expect(json, '{"4":[1,2],"names":{"1":"Spargel","2":"Kürbis"}}');
        final read = SeasonalKeywords.fromJson(json)!;
        expect(read, keywords);
        expect(read.nameOf(1), 'Spargel');
        expect(read.nameOf(3), isNull);
      });

      test('reads the old form with ids only', () {
        final read = SeasonalKeywords.fromJson('{"4":[1],"5":[1,3]}')!;

        expect(read.forMonth(5), {1, 3});
        expect(read.nameOf(1), isNull);
      });

      test('bad names are null', () {
        for (final source in [
          '{"names":[]}',
          '{"names":{"x":"a"}}',
          '{"names":{"1":2}}',
        ]) {
          expect(SeasonalKeywords.fromJson(source), isNull, reason: source);
        }
      });

      test('round trip of empty', () {
        const keywords = SeasonalKeywords.empty();

        expect(keywords.toJson(), '{}');
        expect(SeasonalKeywords.fromJson(keywords.toJson()), keywords);
      });

      test('anything else is null', () {
        for (final source in [
          '',
          'nicht json',
          '[]',
          'null',
          '{"13":[1]}',
          '{"0":[1]}',
          '{"Mai":[1]}',
          '{"05":[1]}',
          '{" 5":[1]}',
          '{"5":1}',
          '{"5":["1"]}',
          '{"5":[1.5]}',
          '{"5":[null]}',
        ]) {
          expect(SeasonalKeywords.fromJson(source), isNull, reason: source);
        }
      });
    });
  });
}
