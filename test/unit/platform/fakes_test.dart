import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_wake_lock_service.dart';
import '../../fakes/in_memory_token_store.dart';
import '../../platform/contracts.dart';

void main() {
  group('InMemoryTokenStore', () => tokenStoreContract(InMemoryTokenStore.new));

  group('FakeWakeLockService', () {
    for (final outcome in [
      WakeLockStatus.active,
      WakeLockStatus.denied,
      WakeLockStatus.unsupported,
    ]) {
      group(
        'granting $outcome',
        () => wakeLockContract(() => FakeWakeLockService(outcome: outcome)),
      );
    }

    test('is reacquired after the platform drops it', () async {
      final wakeLock = FakeWakeLockService();
      await wakeLock.acquire();

      wakeLock.dropByPlatform();
      expect(wakeLock.status, WakeLockStatus.inactive);
      wakeLock.resume();
      expect(wakeLock.status, WakeLockStatus.active);

      await wakeLock.release();
      wakeLock.resume();
      expect(wakeLock.status, WakeLockStatus.inactive);
    });
  });

  group('FakeConnectivityService', () {
    connectivityContract(FakeConnectivityService.new);

    test('emits when switched', () async {
      final connectivity = FakeConnectivityService();
      final changes = <bool>[];
      connectivity.onlineChanges.listen(changes.add);

      connectivity
        ..isOnline = false
        ..isOnline = false
        ..isOnline = true;

      expect(changes, [false, true]);
    });
  });

  test('providers can be overridden with the fakes', () {
    final wakeLock = FakeWakeLockService();
    final container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
        wakeLockServiceProvider.overrideWithValue(wakeLock),
        connectivityServiceProvider.overrideWithValue(
          FakeConnectivityService(isOnline: false),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(wakeLockServiceProvider), same(wakeLock));
    expect(container.read(connectivityServiceProvider).isOnline, isFalse);
  });

  test('the native stubs are what the VM gets by default', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final wakeLock = container.read(wakeLockServiceProvider);
    expect(await wakeLock.acquire(), WakeLockStatus.unsupported);
    expect(container.read(connectivityServiceProvider).isOnline, isTrue);
  });
}
