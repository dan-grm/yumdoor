import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/connectivity/connectivity_service.dart';
import 'package:yumdoor/platform/image_picker/image_picker_service.dart';
import 'package:yumdoor/platform/link_opener/link_opener.dart';
import 'package:yumdoor/platform/local_store/local_store.dart';
import 'package:yumdoor/platform/timers/timer_alert_service.dart';
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

void linkOpenerContract(LinkOpener Function() create) {
  for (final url in [
    'javascript:alert(1)',
    'data:text/html,hi',
    'file:///etc/passwd',
    '/relative',
    'https:no-host',
  ]) {
    test('refuses $url', () {
      expect(create().open(Uri.parse(url)), throwsArgumentError);
    });
  }
}

void localStoreContract(LocalStore Function() create) {
  late LocalStore store;
  setUp(() {
    store = create();
    for (final key in store.keys.toList()) {
      store.delete(key);
    }
  });

  test('round-trips values', () {
    store.write('a', 'eins');
    store.write('b', '{"x": [1, 2]}');

    expect(store.read('a'), 'eins');
    expect(store.read('b'), '{"x": [1, 2]}');
    expect(store.keys, unorderedEquals(['a', 'b']));
  });

  test('a missing key reads null', () {
    expect(store.read('missing'), isNull);
  });

  test('write replaces, delete removes', () {
    store.write('a', 'eins');
    store.write('a', 'zwei');
    expect(store.read('a'), 'zwei');

    store.delete('a');
    expect(store.read('a'), isNull);
    expect(store.keys, isEmpty);
  });
}

/// Without prompting the user: capabilities can always be read, and closing
/// notifications works when none were shown.
void alertChannelsContract(AlertChannels Function() create) {
  test('reports its capabilities without throwing', () {
    final channels = create();

    expect(channels.canPlaySound, isA<bool>());
    expect(channels.canVibrate, isA<bool>());
    expect(NotificationAccess.values, contains(channels.notificationAccess));
    expect(channels.runsInBackground, isA<bool>());
    expect(channels.isVisible, isA<bool>());
  });

  test('closing notifications without any is fine', () async {
    await create().closeNotifications();
  });
}

/// Without a user: picking needs a gesture, so only the capabilities and the
/// drop target's lifecycle are checked.
void imagePickerContract(ImagePickerService Function() create) {
  test('reports its capabilities without throwing', () {
    final picker = create();
    addTearDown(picker.dispose);

    expect(picker.canUseCamera, isA<bool>());
    expect(picker.supportsDrop, isA<bool>());
  });

  test(
    'drops emit nothing on their own and can be listened to again',
    () async {
      final picker = create();
      addTearDown(picker.dispose);
      final events = <ImageDropEvent>[];

      var subscription = picker.drops.listen(events.add);
      await pumpEventQueue();
      await subscription.cancel();
      subscription = picker.drops.listen(events.add);
      await pumpEventQueue();
      await subscription.cancel();

      expect(events, isEmpty);
    },
  );

  test('dispose while listening for drops is fine', () async {
    final picker = create();
    picker.drops.listen((_) {});
    await pumpEventQueue();
    picker.dispose();
  });
}
