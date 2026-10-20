import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/connectivity/connectivity_service.dart';
import 'package:yumdoor/platform/token_store/token_store.dart';
import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

// Behavior every implementation of a platform service must have. Run against
// the fakes on the VM (test/unit/platform/) and against the web
// implementations in Chrome (test/web/).

void tokenStoreContract(TokenStore Function() create) {
  late TokenStore store;
  setUp(() async {
    store = create();
    await store.clear();
  });

  test('is empty after clear', () async {
    expect(await store.readServerUrl(), isNull);
    expect(await store.readToken(), isNull);
  });

  test('round-trips server URL and token with id', () async {
    final url = Uri.parse('https://tandoor.example.com/');
    await store.writeServerUrl(url);
    await store.writeToken(const StoredToken('device-token', id: 42));

    expect(await store.readServerUrl(), url);
    expect(await store.readToken(), const StoredToken('device-token', id: 42));
  });

  test('a token without id replaces one with id', () async {
    await store.writeToken(const StoredToken('device-token', id: 42));
    await store.writeToken(const StoredToken('pasted-token'));

    expect(await store.readToken(), const StoredToken('pasted-token'));
  });

  test('clearToken keeps the server URL', () async {
    final url = Uri.parse('https://tandoor.example.com/');
    await store.writeServerUrl(url);
    await store.writeToken(const StoredToken('device-token', id: 42));

    await store.clearToken();

    expect(await store.readToken(), isNull);
    expect(await store.readServerUrl(), url);
  });

  test('clear removes everything', () async {
    await store.writeServerUrl(Uri.parse('https://tandoor.example.com/'));
    await store.writeToken(const StoredToken('device-token', id: 42));

    await store.clear();

    expect(await store.readServerUrl(), isNull);
    expect(await store.readToken(), isNull);
  });
}

void wakeLockContract(WakeLockService Function() create) {
  late WakeLockService wakeLock;
  setUp(() => wakeLock = create());
  tearDown(() => wakeLock.dispose());

  test('starts inactive or unsupported', () {
    expect(
      wakeLock.status,
      isIn([WakeLockStatus.inactive, WakeLockStatus.unsupported]),
    );
  });

  test('acquire reports the resulting status and emits changes', () async {
    final changes = <WakeLockStatus>[];
    wakeLock.statusChanges.listen(changes.add);
    final before = wakeLock.status;

    final result = await wakeLock.acquire();

    expect(result, wakeLock.status);
    if (before == WakeLockStatus.unsupported) {
      expect(result, WakeLockStatus.unsupported);
    } else {
      expect(result, isIn([WakeLockStatus.active, WakeLockStatus.denied]));
      await pumpEventQueue();
      expect(changes, [result]);
    }
  });

  test('release ends in inactive unless unsupported', () async {
    await wakeLock.acquire();
    await wakeLock.release();

    expect(
      wakeLock.status,
      isIn([WakeLockStatus.inactive, WakeLockStatus.unsupported]),
    );
  });

  test('release without acquire is harmless', () async {
    final before = wakeLock.status;
    await wakeLock.release();
    expect(wakeLock.status, before);
  });
}

void connectivityContract(ConnectivityService Function() create) {
  test('reports a state and only emits changes', () async {
    final connectivity = create();
    addTearDown(connectivity.dispose);
    final changes = <bool>[];
    connectivity.onlineChanges.listen(changes.add);

    await pumpEventQueue();

    expect(connectivity.isOnline, isA<bool>());
    expect(changes, isEmpty);
  });
}
