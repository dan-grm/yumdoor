import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/locale.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/session.dart';
import 'package:yumdoor/domain/models/cooking_timer.dart';
import 'package:yumdoor/features/cooking/cooking_providers.dart';
import 'package:yumdoor/platform/timers/timer_alert_service.dart';

import '../../../fakes/app_overrides.dart';
import '../../../fakes/fake_alert_channels.dart';
import '../../../fakes/in_memory_local_store.dart';

void main() {
  late InMemoryLocalStore store;
  late FakeAlertChannels alerts;
  late ProviderContainer container;
  var now = DateTime.utc(2026, 11, 14, 18);

  setUp(() {
    store = InMemoryLocalStore();
    alerts = FakeAlertChannels();
    container = ProviderContainer(
      overrides: [
        ...appOverrides(
          tokenStore: loggedInTokenStore(),
          localStore: store,
          timerAlerts: ChannelTimerAlertService(alerts),
        ),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    container.read(localeOverrideProvider.notifier).set(const Locale('de'));
  });

  CookingTimersController controller() =>
      container.read(cookingTimersControllerProvider(7).notifier);
  List<CookingTimer> timers() =>
      container.read(cookingTimersControllerProvider(7));

  test('two timers started at the same moment get their own ids', () async {
    await controller().start(label: 'A', duration: const Duration(minutes: 1));
    await controller().start(label: 'B', duration: const Duration(minutes: 1));

    expect(timers().map((t) => t.id).toSet(), hasLength(2));
    controller().remove(timers().first.id);
    expect(timers().map((t) => t.label), ['B']);
  });

  test('finished timers alert together, with their own tags', () async {
    alerts
      ..notificationAccess = NotificationAccess.granted
      ..isVisible = false;
    await controller().start(label: 'A', duration: const Duration(minutes: 1));
    await controller().start(label: 'B', duration: const Duration(minutes: 1));
    controller().attach(recipeName: 'Suppe');

    now = now.add(const Duration(minutes: 1));
    await controller().tick();

    expect(alerts.notifications.map((n) => (n.$1, n.$2)), [
      ('A ist fertig', 'Suppe'),
      ('B ist fertig', 'Suppe'),
    ]);
    expect(alerts.notifications.map((n) => n.$3).toSet(), hasLength(2));

    controller().remove(timers().first.id);
    expect(alerts.notifications.map((n) => n.$1), ['B ist fertig']);
  });

  test('saved timers come back at app start, without cooking mode', () async {
    await controller().start(label: 'A', duration: const Duration(minutes: 1));
    // A reload: a new app with the same storage.
    final reloaded = ProviderContainer(
      overrides: [
        ...appOverrides(
          tokenStore: loggedInTokenStore(),
          localStore: store,
          timerAlerts: ChannelTimerAlertService(alerts),
        ),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(reloaded.dispose);
    reloaded.read(localeOverrideProvider.notifier).set(const Locale('de'));

    expect(reloaded.read(restoredTimersProvider), 1);
    expect(reloaded.exists(cookingTimersControllerProvider(7)), isTrue);
    now = now.add(const Duration(minutes: 1));
    await reloaded.read(cookingTimersControllerProvider(7).notifier).tick();
    expect(alerts.chimes, 1);
  });

  test(
    'without cooking mode on screen, a finished timer alerts once',
    () async {
      await controller().start(
        label: 'A',
        duration: const Duration(minutes: 1),
      );
      now = now.add(const Duration(minutes: 1));
      await controller().tick();
      now = now.add(const Duration(minutes: 1));
      await controller().tick();
      expect(alerts.chimes, 1);

      controller().attach(recipeName: 'Suppe');
      await controller().tick();
      expect(alerts.chimes, 2);
    },
  );

  test('forget closes only its own notifications', () async {
    alerts
      ..notificationAccess = NotificationAccess.granted
      ..isVisible = false;
    await controller().start(label: 'A', duration: const Duration(minutes: 1));
    final other = container.read(cookingTimersControllerProvider(8).notifier);
    await other.start(label: 'B', duration: const Duration(minutes: 1));
    now = now.add(const Duration(minutes: 1));
    await controller().tick();
    await other.tick();

    controller().forget();

    expect(alerts.notifications.map((n) => n.$1), ['B ist fertig']);
  });

  test('forget stops and forgets every timer', () async {
    await controller().start(label: 'A', duration: const Duration(minutes: 1));

    controller().forget();
    now = now.add(const Duration(minutes: 2));
    await controller().tick();

    expect(timers(), isEmpty);
    expect(alerts.chimes, 0);
    expect(store.values, isEmpty);
  });

  test('logout ends the timers', () async {
    await container.read(sessionControllerProvider.future);
    await controller().start(label: 'A', duration: const Duration(minutes: 1));

    await container.read(sessionControllerProvider.notifier).logout();

    expect(timers(), isEmpty);
    expect(store.values, isEmpty);
  });
}
