import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/platform/image_picker/image_picker_service.dart';
import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

import '../../fakes/fake_alert_channels.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_image_picker_service.dart';
import '../../fakes/fake_link_opener.dart';
import '../../fakes/in_memory_local_store.dart';
import '../../fakes/fake_wake_lock_service.dart';
import '../../fakes/in_memory_token_store.dart';
import '../../platform/contracts.dart';

void main() {
  group('InMemoryTokenStore', () => tokenStoreContract(InMemoryTokenStore.new));

  group(
    'FakeAlertChannels',
    () => alertChannelsContract(FakeAlertChannels.new),
  );

  group('InMemoryLocalStore', () => localStoreContract(InMemoryLocalStore.new));

  group('FakeLinkOpener', () {
    linkOpenerContract(FakeLinkOpener.new);

    test('records opened links', () async {
      final links = FakeLinkOpener();
      await links.open(Uri.parse('https://example.com/'));
      expect(links.opened, [Uri.parse('https://example.com/')]);
    });
  });

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

  group('FakeImagePickerService', () {
    imagePickerContract(FakeImagePickerService.new);

    test('returns the next pick and records the source', () async {
      final picker = FakeImagePickerService(
        nextPick: checkImage(name: 'a.png', bytes: pngBytes),
      );

      expect(await picker.pickFromCamera(), isA<PickedImage>());
      picker.nextPick = null;
      expect(await picker.pickFile(), isNull);
      expect(picker.picks, ['camera', 'file']);
    });

    test('delivers drops only while listened to', () async {
      final picker = FakeImagePickerService();
      final events = <ImageDropEvent>[];

      picker.drop('ignored.png', pngBytes);
      final subscription = picker.drops.listen(events.add);
      expect(picker.isDropTarget, isTrue);
      picker
        ..hover(isOver: true)
        ..drop('a.png', pngBytes);
      await subscription.cancel();

      expect(picker.isDropTarget, isFalse);
      expect(events, [
        isA<ImageDragHover>().having((e) => e.isOver, 'isOver', isTrue),
        isA<ImageDragHover>().having((e) => e.isOver, 'isOver', isFalse),
        isA<ImageDropped>().having((e) => e.result.name, 'name', 'a.png'),
      ]);
    });
  });

  group('native ImagePickerService', () {
    imagePickerContract(ImagePickerService.new);

    test('offers nothing and picks nothing', () async {
      final picker = ImagePickerService();
      expect(picker.canUseCamera, isFalse);
      expect(picker.supportsDrop, isFalse);
      expect(await picker.pickFromCamera(), isNull);
      expect(await picker.pickFile(), isNull);
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
