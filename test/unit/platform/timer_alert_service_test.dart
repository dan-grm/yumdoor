import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/timers/timer_alert_service.dart';

import '../../fakes/fake_alert_channels.dart';

void main() {
  late FakeAlertChannels channels;
  late TimerAlertService service;

  void start(FakeAlertChannels fake) {
    channels = fake;
    service = ChannelTimerAlertService(
      fake,
      channelTimeout: const Duration(milliseconds: 50),
    );
  }

  Future<TimerAlertOutcome> alert() => service.alert(
    title: 'Ofen ist fertig',
    body: 'Ofenkarotten mit Feta',
    tag: '1',
  );

  group('prepare', () {
    test('unlocks sound and asks for notifications', () async {
      start(FakeAlertChannels());

      final capabilities = await service.prepare();

      expect(channels.unlocks, 1);
      expect(channels.permissionRequests, 1);
      expect(capabilities.notifications, NotificationAccess.granted);
      expect(capabilities.backgroundAlerts, isTrue);
    });

    test('a second call while the first is pending gets its result', () async {
      start(FakeAlertChannels());

      final results = await Future.wait([service.prepare(), service.prepare()]);

      expect(channels.permissionRequests, 1);
      expect(results.last.notifications, NotificationAccess.granted);
    });

    test('waits for a slow answer to the prompt', () async {
      final answer = Completer<void>();
      start(FakeAlertChannels(permissionAnswer: answer.future));

      final prepared = service.prepare();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      answer.complete();

      expect((await prepared).notifications, NotificationAccess.granted);
    });

    test('unlocks sound on every timer start, asks only once', () async {
      start(FakeAlertChannels());

      await service.prepare();
      await service.prepare();

      expect(channels.unlocks, 2);
      expect(channels.permissionRequests, 1);
    });

    test('doesn\'t ask again after an earlier answer', () async {
      for (final access in [
        NotificationAccess.granted,
        NotificationAccess.denied,
        NotificationAccess.unsupported,
      ]) {
        start(FakeAlertChannels(notificationAccess: access));

        await service.prepare();

        expect(channels.permissionRequests, 0, reason: '$access');
      }
    });

    test('a denied prompt leaves no background alerts', () async {
      start(FakeAlertChannels(answer: NotificationAccess.denied));

      final capabilities = await service.prepare();

      expect(capabilities.notifications, NotificationAccess.denied);
      expect(capabilities.backgroundAlerts, isFalse);
    });
  });

  test('iOS: notifications granted, but no background alerts', () {
    start(
      FakeAlertChannels(
        notificationAccess: NotificationAccess.granted,
        runsInBackground: false,
      ),
    );

    expect(service.capabilities.backgroundAlerts, isFalse);
  });

  group('alert', () {
    test('in the foreground: sound and vibration, no notification', () async {
      start(FakeAlertChannels(notificationAccess: NotificationAccess.granted));

      final outcome = await alert();

      expect(outcome.sound, isTrue);
      expect(outcome.vibration, isTrue);
      expect(outcome.notification, isFalse);
      expect(channels.notifications, isEmpty);
    });

    test('in the background: a notification too', () async {
      start(
        FakeAlertChannels(
          notificationAccess: NotificationAccess.granted,
          isVisible: false,
        ),
      );

      final outcome = await alert();

      expect(outcome.notification, isTrue);
      expect(channels.notifications, [
        ('Ofen ist fertig', 'Ofenkarotten mit Feta', '1'),
      ]);
    });

    test('no notification when denied, unasked or unsupported', () async {
      for (final access in [
        NotificationAccess.denied,
        NotificationAccess.notAsked,
        NotificationAccess.unsupported,
      ]) {
        start(FakeAlertChannels(notificationAccess: access, isVisible: false));

        final outcome = await alert();

        expect(outcome.notification, isFalse, reason: '$access');
        expect(outcome.sound, isTrue, reason: '$access');
      }
    });

    test('without sound, vibration still works', () async {
      start(FakeAlertChannels(canPlaySound: false));

      final outcome = await alert();

      expect(outcome.sound, isFalse);
      expect(outcome.vibration, isTrue);
      expect(channels.chimes, 0);
    });

    test('without vibration (desktop, iOS), sound still works', () async {
      start(FakeAlertChannels(canVibrate: false));

      final outcome = await alert();

      expect(outcome.vibration, isFalse);
      expect(outcome.sound, isTrue);
    });

    test('a failing channel doesn\'t stop the others', () async {
      start(
        FakeAlertChannels(
          notificationAccess: NotificationAccess.granted,
          isVisible: false,
        ),
      );
      channels
        ..soundFails = true
        ..vibrationFails = true;

      final outcome = await alert();

      expect(outcome.sound, isFalse);
      expect(outcome.vibration, isFalse);
      expect(outcome.notification, isTrue);
    });

    test('a hanging channel times out without blocking the others', () async {
      start(
        FakeAlertChannels(
          notificationAccess: NotificationAccess.granted,
          isVisible: false,
        ),
      );
      channels.soundHangs = true;

      final outcome = await alert();

      expect(outcome.sound, isFalse);
      expect(outcome.vibration, isTrue);
      expect(outcome.notification, isTrue);
    });

    test('nothing at all is reported as silent', () async {
      start(
        FakeAlertChannels(
          canPlaySound: false,
          canVibrate: false,
          notificationAccess: NotificationAccess.unsupported,
        ),
      );

      expect((await alert()).silent, isTrue);
      expect(service.capabilities.backgroundAlerts, isFalse);
    });
  });

  test('dismissAlerts closes the notifications', () async {
    start(
      FakeAlertChannels(
        notificationAccess: NotificationAccess.granted,
        isVisible: false,
      ),
    );
    await alert();

    await service.dismissAlerts();

    expect(channels.closes, 1);
    expect(channels.notifications, isEmpty);
  });

  test('the native placeholder offers nothing and never throws', () async {
    final service = TimerAlertService();

    final capabilities = await service.prepare();
    final outcome = await service.alert(title: 't', body: 'b', tag: '1');

    expect(
      capabilities,
      const TimerAlertCapabilities(
        sound: false,
        vibration: false,
        notifications: NotificationAccess.unsupported,
        backgroundAlerts: false,
      ),
    );
    expect(outcome.silent, isTrue);
    await service.dismissAlerts();
  });
}
