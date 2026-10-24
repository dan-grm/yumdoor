import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/offline.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_connectivity_service.dart';

void main() {
  late FakeConnectivityService connectivity;
  late ProviderContainer container;

  setUp(() {
    connectivity = FakeConnectivityService();
    container = ProviderContainer(
      overrides: appOverrides(connectivity: connectivity),
    );
    addTearDown(container.dispose);
  });

  bool offline() => container.read(isOfflineProvider);
  IsOffline notifier() => container.read(isOfflineProvider.notifier);

  test('is online while the network is there and the server answers', () {
    expect(offline(), isFalse);

    notifier().reportServerReachable(true);

    expect(offline(), isFalse);
  });

  test('follows the platform connectivity', () {
    expect(offline(), isFalse);

    connectivity.isOnline = false;
    expect(offline(), isTrue);

    connectivity.isOnline = true;
    expect(offline(), isFalse);
  });

  test('is offline after a request could not reach the server', () {
    notifier().reportServerReachable(false);
    expect(offline(), isTrue);

    notifier().reportServerReachable(true);
    expect(offline(), isFalse);
  });

  test('tries the server again when the network comes back', () {
    notifier().reportServerReachable(false);
    connectivity.isOnline = false;
    expect(offline(), isTrue);

    connectivity.isOnline = true;

    expect(offline(), isFalse);
  });

  test('stays offline without a network, whatever the server did', () {
    connectivity.isOnline = false;
    offline();

    notifier().reportServerReachable(true);

    expect(offline(), isTrue);
  });
}
