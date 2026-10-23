import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/app/session.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/domain/models/session.dart';
import 'package:yumdoor/platform/token_store/token_store.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_auth_repository.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/in_memory_token_store.dart';

void main() {
  late InMemoryTokenStore store;
  late FakeAuthRepository auth;
  late FakeConnectivityService connectivity;
  late ProviderContainer container;

  void start(InMemoryTokenStore tokenStore) {
    store = tokenStore;
    container = ProviderContainer(
      overrides: appOverrides(
        tokenStore: store,
        auth: auth,
        connectivity: connectivity,
      ),
    );
    addTearDown(container.dispose);
  }

  SessionController controller() =>
      container.read(sessionControllerProvider.notifier);

  Future<Session?> session() =>
      container.read(sessionControllerProvider.future);

  setUp(() {
    auth = FakeAuthRepository();
    connectivity = FakeConnectivityService();
  });

  test('restores the stored session without asking the server', () async {
    start(loggedInTokenStore());

    expect(
      await session(),
      Session(
        serverUrl: testServerUrl,
        token: FakeAuthRepository.deviceToken,
        deviceTokenId: FakeAuthRepository.deviceTokenId,
      ),
    );
    expect(auth.verified, isEmpty);
    expect(
      container.read(tandoorConnectionProvider),
      TandoorConnection(testServerUrl, FakeAuthRepository.deviceToken),
    );
  });

  test('has no session without a stored token', () async {
    start(InMemoryTokenStore(serverUrl: testServerUrl));

    expect(await session(), isNull);
    // Riverpod wraps the StateError in a ProviderException.
    expect(
      () => container.read(tandoorConnectionProvider),
      throwsA(predicate((e) => '$e'.contains('Not logged in'))),
    );
  });

  test('password login stores the device token, not the password', () async {
    start(InMemoryTokenStore());
    await session();

    await controller().loginWithPassword(
      testServerUrl,
      username: 'anna',
      password: 'anna-dev-only',
    );

    expect((await session())?.token, FakeAuthRepository.deviceToken);
    expect(store.serverUrl, testServerUrl);
    expect(
      store.token,
      const StoredToken(
        FakeAuthRepository.deviceToken,
        id: FakeAuthRepository.deviceTokenId,
      ),
    );
  });

  test('a failed login leaves the session as it was', () async {
    start(InMemoryTokenStore());
    await session();

    await expectLater(
      controller().loginWithPassword(
        testServerUrl,
        username: 'anna',
        password: 'wrong',
      ),
      throwsA(isA<InvalidCredentialsFailure>()),
    );
    expect(await session(), isNull);
    expect(store.token, isNull);
  });

  test('token login stores the token without an id', () async {
    start(InMemoryTokenStore());
    await session();

    await controller().loginWithToken(testServerUrl, 'tda_pasted');

    expect(store.token, const StoredToken('tda_pasted'));
  });

  group('logout', () {
    test('revokes the device token and keeps the server URL', () async {
      start(loggedInTokenStore());
      final before = await session();

      await controller().logout();

      expect(auth.revoked, [before]);
      expect(await session(), isNull);
      expect(store.token, isNull);
      expect(store.serverUrl, testServerUrl);
    });

    test('still logs out when offline, without revoking', () async {
      connectivity.isOnline = false;
      start(loggedInTokenStore());
      await session();

      await controller().logout();

      expect(auth.revoked, isEmpty);
      expect(await session(), isNull);
    });

    test('still logs out when revoking fails', () async {
      start(loggedInTokenStore());
      await session();
      auth.failure = const OfflineFailure();

      await controller().logout();

      expect(await session(), isNull);
      expect(store.token, isNull);
    });
  });

  group('checkToken', () {
    test('ends the session when the token was rejected', () async {
      start(loggedInTokenStore());
      await session();
      auth.rejectedTokens.add(FakeAuthRepository.deviceToken);

      await controller().checkToken();

      expect(await session(), isNull);
      expect(store.token, isNull);
      expect(store.serverUrl, testServerUrl);
    });

    test('keeps the session when the token still works', () async {
      start(loggedInTokenStore());
      await session();

      await controller().checkToken();

      expect(await session(), isNotNull);
    });

    test('keeps the session when the server cannot be reached', () async {
      start(loggedInTokenStore());
      await session();
      auth.failure = const OfflineFailure();

      await controller().checkToken();

      expect(await session(), isNotNull);
    });

    test('checks once for many rejected requests at a time', () async {
      start(loggedInTokenStore());
      await session();

      await Future.wait([
        controller().checkToken(),
        controller().checkToken(),
        controller().checkToken(),
      ]);

      expect(auth.verified, hasLength(1));
    });
  });
}
