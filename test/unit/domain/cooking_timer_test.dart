import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/cooking_timer.dart';

void main() {
  final start = DateTime.utc(2026, 11, 14, 18);
  DateTime at(int seconds) => start.add(Duration(seconds: seconds));

  CookingTimer timer({Duration duration = const Duration(minutes: 25)}) =>
      CookingTimer.start(
        id: 't1',
        label: 'Rösten',
        duration: duration,
        now: start,
        stepId: 2,
      );

  group('end-time math', () {
    test('remaining time follows the clock', () {
      final t = timer();

      expect(t.remaining(start), const Duration(minutes: 25));
      expect(t.remaining(at(252)), const Duration(minutes: 20, seconds: 48));
      expect(t.isFinished(at(1499)), isFalse);
    });

    test('a suspended tab sees the right time on resume', () {
      // No ticks for 10 minutes: nothing counted down, the end time decides.
      expect(timer().remaining(at(600)), const Duration(minutes: 15));
    });

    test('finishes at the end and never goes negative', () {
      final t = timer();

      expect(t.isFinished(at(1500)), isTrue);
      expect(t.remaining(at(4000)), Duration.zero);
    });
  });

  group('pause and resume', () {
    test('a paused timer keeps its remaining time', () {
      final paused = timer().pause(at(300));

      expect(paused.isPaused, isTrue);
      expect(paused.remaining(at(300)), const Duration(minutes: 20));
      expect(paused.remaining(at(3000)), const Duration(minutes: 20));
    });

    test('resuming runs from the time that was left', () {
      final resumed = timer().pause(at(300)).resume(at(1000));

      expect(resumed.isPaused, isFalse);
      expect(resumed.remaining(at(1000)), const Duration(minutes: 20));
      expect(resumed.isFinished(at(2200)), isTrue);
    });

    test('pausing a finished timer does nothing', () {
      final t = timer(duration: const Duration(seconds: 10));

      expect(t.pause(at(20)).isPaused, isFalse);
    });
  });

  group('extend', () {
    test('+1 min on a running timer moves the end', () {
      final t = timer().extend(const Duration(minutes: 1), at(60));

      expect(t.remaining(at(60)), const Duration(minutes: 25));
      expect(t.duration, const Duration(minutes: 26));
    });

    test('+1 min on a paused timer adds to what is left', () {
      final t = timer()
          .pause(at(300))
          .extend(const Duration(minutes: 1), at(400));

      expect(t.remaining(at(9999)), const Duration(minutes: 21));
    });

    test('+1 min on a finished timer runs it again from now', () {
      final finished = timer(duration: const Duration(seconds: 10))
          .alerted(at(10));

      final t = finished.extend(const Duration(minutes: 1), at(100));

      expect(t.remaining(at(100)), const Duration(minutes: 1));
      expect(t.lastAlertAt, isNull);
    });
  });

  group('alerts', () {
    test('when finished, then every 30 s until dismissed', () {
      var t = timer(duration: const Duration(seconds: 10));

      expect(t.needsAlert(at(5)), isFalse);
      expect(t.needsAlert(at(10)), isTrue);
      t = t.alerted(at(10));
      expect(t.needsAlert(at(39)), isFalse);
      expect(t.needsAlert(at(40)), isTrue);
    });

    test('without repeat, only once', () {
      final t = timer(duration: const Duration(seconds: 10));

      expect(t.needsAlert(at(10), repeat: false), isTrue);
      expect(t.alerted(at(10)).needsAlert(at(100), repeat: false), isFalse);
    });
  });

  group('reload', () {
    test('running and paused timers round-trip through JSON', () {
      final running = timer().alerted(at(1));
      final paused = CookingTimer.start(
        id: 't2',
        label: 'Timer',
        duration: const Duration(minutes: 5),
        now: start,
      ).pause(at(60));

      final read = [
        for (final t in [running, paused])
          CookingTimer.fromJson(jsonDecode(jsonEncode(t.toJson())))!,
      ];

      expect(read, hasLength(2));
      expect(read[0].id, 't1');
      expect(read[0].stepId, 2);
      expect(read[0].remaining(at(300)), const Duration(minutes: 20));
      expect(read[0].lastAlertAt, at(1));
      expect(read[1].stepId, isNull);
      expect(read[1].isPaused, isTrue);
      expect(read[1].remaining(at(9999)), const Duration(minutes: 4));
    });

    test('unreadable entries are null', () {
      for (final json in <Object?>[
        5,
        {'id': 'a'},
        {'id': 'b', 'label': 'x', 'durationMs': 1000},
        {
          'id': 'c',
          'label': 'y',
          'durationMs': 1000,
          'endsAt': '2026-11-14T18:00:00.000Z',
          'pausedMs': 5,
        },
      ]) {
        expect(CookingTimer.fromJson(json), isNull, reason: '$json');
      }
    });
  });
}
