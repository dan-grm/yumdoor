import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/app/session.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/repositories/shopping_check_queue.dart';
import 'package:yumdoor/features/shopping/shopping_providers.dart';

import '../../../fakes/app_overrides.dart';
import '../../../fakes/fake_connectivity_service.dart';
import '../../../fakes/fake_shopping_check_queue.dart';
import '../../../fakes/fake_shopping_repository.dart';
import '../../../fakes/in_memory_local_store.dart';
import '../../../fixtures/shopping.dart';

void main() {
  late FakeShoppingRepository repository;
  late InMemoryLocalStore store;
  late FakeShoppingCheckQueue queue;
  late FakeConnectivityService connectivity;
  late ProviderContainer container;
  final now = DateTime.utc(2026, 11, 18, 15);

  /// What remembers Markt am Eck on the test server.
  final storedChoice = '${marketAmEck.id} $testServerUrl';

  Future<ProviderContainer> create() async {
    final container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(loggedInTokenStore()),
        shoppingRepositoryProvider.overrideWithValue(repository),
        shoppingCheckQueueProvider.overrideWithValue(queue),
        connectivityServiceProvider.overrideWithValue(connectivity),
        localStoreProvider.overrideWithValue(store),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    container.listen(shoppingListProvider, (_, _) {});
    await container.read(sessionControllerProvider.future);
    return container;
  }

  setUp(() async {
    repository = FakeShoppingRepository(
      entries: mockupShoppingList(),
      supermarketList: const [marketAmEck, bioladen],
    );
    store = InMemoryLocalStore();
    queue = FakeShoppingCheckQueue();
    connectivity = FakeConnectivityService();
    container = await create();
  });

  ShoppingList list() => container.read(shoppingListProvider.notifier);

  ShoppingEntry entry(int id) => container
      .read(shoppingListProvider)
      .requireValue
      .entries
      .firstWhere((entry) => entry.id == id);

  test('shows a check-off at once and sends it right away', () async {
    await container.read(shoppingListProvider.future);
    repository.checkGate = Completer();

    final saved = list().setChecked([101, 102], checked: true);

    expect(entry(101).checked, isTrue);
    await pumpEventQueue();
    expect(entry(101).completedAt, now);
    expect(entry(102).checked, isTrue);
    // Sent before it is confirmed, not after an undo window.
    expect(repository.checkCalls.single.ids, {101, 102});
    expect(repository.checkCalls.single.checked, isTrue);

    repository.checkGate!.complete();
    expect(await saved, isNull);
    expect(entry(101).checked, isTrue);
  });

  test('takes a failed check-off back', () async {
    await container.read(shoppingListProvider.future);
    repository.checkFailure = const ServerFailure(statusCode: 500);

    final failure = await list().setChecked([103], checked: true);

    expect(failure, isA<ServerFailure>());
    expect(entry(103).checked, isFalse);
    expect(queue.pending, isEmpty);
  });

  test('sends an undo after the check-off it undoes', () async {
    await container.read(shoppingListProvider.future);
    repository.checkGate = Completer();

    final checked = list().setChecked([103], checked: true);
    final undone = list().setChecked([103], checked: false);
    await pumpEventQueue();

    expect(repository.checkCalls, hasLength(1));
    expect(entry(103).checked, isFalse);

    repository.checkGate!.complete();
    expect(await checked, isNull);
    expect(await undone, isNull);
    expect(repository.checkCalls.map((call) => call.checked), [true, false]);
    expect(entry(103).checked, isFalse);
    expect(repository.entries.firstWhere((e) => e.id == 103).checked, isFalse);
  });

  test('a failed change keeps the later ones', () async {
    await container.read(shoppingListProvider.future);
    repository
      ..checkGate = Completer()
      ..checkFailure = const ServerFailure()
      ..checkFailsOnce = true;

    final checked = list().setChecked([103], checked: true);
    final undone = list().setChecked([103], checked: false);
    final rechecked = list().setChecked([103], checked: true);
    repository.checkGate!.complete();

    expect(await checked, isA<ServerFailure>());
    expect(await undone, isNull);
    expect(await rechecked, isNull);
    expect(entry(103).checked, isTrue);
  });

  test('a read that started before the change was saved keeps it', () async {
    await container.read(shoppingListProvider.future);
    repository.checkGate = Completer();
    final saved = list().setChecked([105], checked: true);

    // The read sees the server before the check-off arrives.
    final refreshed = list().refresh();
    await refreshed;
    expect(entry(105).checked, isTrue);

    repository.checkGate!.complete();
    await saved;
    expect(entry(105).checked, isTrue);

    // A later read has it from the server.
    await list().refresh();
    expect(entry(105).checked, isTrue);
    expect(entry(105).completedAt, repository.now);
  });

  test('a failed undo shows the saved check-off again', () async {
    await container.read(shoppingListProvider.future);
    expect(await list().setChecked([103], checked: true), isNull);

    repository.checkFailure = const ServerFailure(statusCode: 500);
    final failure = await list().setChecked([103], checked: false);

    expect(failure, isA<ServerFailure>());
    expect(entry(103).checked, isTrue);
  });

  test('an older read that ends last does not replace a newer one', () async {
    await container.read(shoppingListProvider.future);
    final slow = Completer<void>();
    repository.fetchGates.add(slow);
    final older = list().refresh();
    await pumpEventQueue();
    // Someone checks off Feta between the two reads.
    await repository.setChecked({105}, checked: true);

    await list().refresh();
    expect(entry(105).checked, isTrue);

    slow.complete();
    await older;
    expect(entry(105).checked, isTrue);
  });

  test(
    'refresh shows what others changed and keeps the list on failure',
    () async {
      await container.read(shoppingListProvider.future);
      repository.entries.removeWhere((entry) => entry.id == 108);

      await list().refresh();
      expect(
        container
            .read(shoppingListProvider)
            .requireValue
            .entries
            .map((e) => e.id),
        isNot(contains(108)),
      );

      repository.fetchFailure = const OfflineFailure();
      await expectLater(list().refresh(), throwsA(isA<OfflineFailure>()));
      expect(
        container.read(shoppingListProvider).requireValue.entries,
        hasLength(10),
      );
    },
  );

  test('groups in the order of the chosen supermarket, remembered', () async {
    await container.read(shoppingListProvider.future);
    await container.read(shoppingSupermarketsProvider.future);
    container.listen(shoppingGroupsProvider, (_, _) {});

    List<String?> sections() => [
      for (final section
          in container.read(shoppingGroupsProvider).requireValue.sections)
        section.category?.name,
    ];

    expect(sections(), ['Kühlregal', 'Obst und Gemüse', 'Vorrat']);
    expect(container.read(shoppingGroupsProvider).requireValue.openCount, 7);

    container.read(shoppingSupermarketChoiceProvider.notifier).set(7);
    expect(sections(), ['Obst und Gemüse', 'Kühlregal', 'Vorrat']);
    expect(store.values['shopping.supermarket'], storedChoice);

    // Another start of the app.
    container = await create();
    await container.read(shoppingListProvider.future);
    await container.read(shoppingSupermarketsProvider.future);
    container.listen(shoppingGroupsProvider, (_, _) {});
    expect(container.read(shoppingSupermarketProvider), marketAmEck);
    expect(sections(), ['Obst und Gemüse', 'Kühlregal', 'Vorrat']);

    container.read(shoppingSupermarketChoiceProvider.notifier).set(null);
    expect(store.values, isNot(contains('shopping.supermarket')));
  });

  test('ignores a supermarket remembered for another server', () async {
    store.write(
      'shopping.supermarket',
      '${marketAmEck.id} https://other.example',
    );
    await container.read(shoppingSupermarketsProvider.future);

    expect(container.read(shoppingSupermarketChoiceProvider), isNull);
    expect(container.read(shoppingSupermarketProvider), isNull);
  });

  test('reports a truncated list', () async {
    expect(
      (await container.read(shoppingListProvider.future)).truncated,
      isFalse,
    );

    repository.truncated = true;
    await list().refresh();
    expect(container.read(shoppingListProvider).requireValue.truncated, isTrue);
  });

  group('offline cache', () {
    final cachedAt = DateTime(2026, 11, 17, 19, 30);

    test('shows the stored list with when it was read', () async {
      repository.cachedAt = cachedAt;
      container = await create();

      final view = await container.read(shoppingListProvider.future);
      expect(view.cachedAt, cachedAt);
      expect(view.entries, hasLength(mockupShoppingList().length));
    });

    test('a refresh from the cache keeps the list shown and fails', () async {
      await container.read(shoppingListProvider.future);
      repository
        ..cachedAt = cachedAt
        ..entries.removeAt(0);

      await expectLater(list().refresh(), throwsA(isA<OfflineFailure>()));
      final view = container.read(shoppingListProvider).requireValue;
      expect(view.cachedAt, isNull);
      expect(view.entries, hasLength(mockupShoppingList().length));
    });

    test('a poll on the stored list reads it in full', () async {
      repository.cachedAt = cachedAt;
      container = await create();
      await container.read(shoppingListProvider.future);

      repository.cachedAt = null;
      await list().poll();
      expect(repository.fetchedAfter.last, isNull);
      expect(
        container.read(shoppingListProvider).requireValue.cachedAt,
        isNull,
      );
    });

    test('the server list replaces the stored one', () async {
      repository.cachedAt = cachedAt;
      container = await create();
      await container.read(shoppingListProvider.future);

      repository.cachedAt = null;
      await list().refresh();
      expect(
        container.read(shoppingListProvider).requireValue.cachedAt,
        isNull,
      );
    });
  });

  group('offline check-offs', () {
    Set<int> pendingIds() =>
        container.read(shoppingListProvider).requireValue.pendingIds;

    /// The check-offs sent, as "{ids} checked".
    List<String> sent() => [
      for (final call in repository.checkCalls)
        '{${(call.ids.toList()..sort()).join(', ')}} ${call.checked}',
    ];

    Future<void> goOffline() async {
      await container.read(shoppingListProvider.future);
      connectivity.isOnline = false;
    }

    test('are kept on the device and shown as pending', () async {
      await goOffline();

      expect(await list().setChecked([101, 102], checked: true), isNull);
      expect(await list().setChecked([109], checked: false), isNull);

      expect(repository.checkCalls, isEmpty);
      expect(entry(101).checked, isTrue);
      expect(entry(101).completedAt, now);
      expect(entry(109).checked, isFalse);
      expect(pendingIds(), {101, 102, 109});
      expect(queue.pending, {
        101: PendingCheck(checked: true, at: now),
        102: PendingCheck(checked: true, at: now),
        109: PendingCheck(checked: false, at: now),
      });
    });

    test('ticking and unticking again sends nothing', () async {
      await goOffline();

      await list().setChecked([105], checked: true);
      await list().setChecked([105], checked: false);
      await list().setChecked([109], checked: false);
      await list().setChecked([109], checked: true);

      expect(queue.pending, isEmpty);
      expect(pendingIds(), isEmpty);
      expect(entry(105).checked, isFalse);
      expect(entry(109).checked, isTrue);

      connectivity.isOnline = true;
      await pumpEventQueue();
      expect(repository.checkCalls, isEmpty);
    });

    test('compare with what was sent before going offline', () async {
      await container.read(shoppingListProvider.future);
      // Sent and saved; the list read before still has Feta open.
      expect(await list().setChecked([105], checked: true), isNull);
      connectivity.isOnline = false;

      await list().setChecked([105], checked: false);
      await list().setChecked([105], checked: true);
      expect(queue.pending, isEmpty);
      expect(entry(105).checked, isTrue);
      await list().setChecked([105], checked: false);

      expect(queue.pending, {105: PendingCheck(checked: false, at: now)});
      connectivity.isOnline = true;
      await pumpEventQueue();
      expect(sent().last, '{105} false');
      expect(repository.entries.firstWhere((e) => e.id == 105).checked, false);
    });

    test(
      'a send that fails after going offline is no longer the base',
      () async {
        await container.read(shoppingListProvider.future);
        repository
          ..checkGate = Completer()
          ..checkFailure = const ServerFailure(statusCode: 500)
          ..checkFailsOnce = true;
        // Ticked online; the request hangs, then the connection goes.
        final ticked = list().setChecked([105], checked: true);
        await pumpEventQueue();
        connectivity.isOnline = false;
        await list().setChecked([105], checked: false);
        repository.checkGate!.complete();
        expect(await ticked, isA<ServerFailure>());

        // The server never got the tick: ticking again must be sent.
        await list().setChecked([105], checked: true);
        expect(queue.pending.keys, [105]);
        expect(pendingIds(), {105});
        connectivity.isOnline = true;
        await pumpEventQueue();
        expect(repository.entries.firstWhere((e) => e.id == 105).checked, true);
        expect(pendingIds(), isEmpty);
      },
    );

    test('a tick while the queue is being sent is sent after it', () async {
      repository.cachedAt = DateTime(2026, 11, 18, 14);
      connectivity = FakeConnectivityService(isOnline: false);
      container = await create();
      await container.read(shoppingListProvider.future);
      await list().setChecked([105], checked: true);

      // Back online: the queue goes out, slowly.
      repository.checkGate = Completer();
      connectivity.isOnline = true;
      await pumpEventQueue();
      expect(sent(), ['{105} true']);
      // Still on the stored list, Feta is unticked meanwhile.
      repository.cachedAt = null;
      await list().setChecked([105], checked: false);
      expect(entry(105).checked, isFalse);
      expect(queue.pending, {105: PendingCheck(checked: false, at: now)});

      repository.checkGate!.complete();
      await pumpEventQueue();
      expect(sent(), ['{105} true', '{105} false']);
      expect(repository.entries.firstWhere((e) => e.id == 105).checked, false);
      expect(queue.pending, isEmpty);
      expect(entry(105).checked, isFalse);
    });

    test('ticking back to what is being sent queues nothing', () async {
      repository.cachedAt = DateTime(2026, 11, 18, 14);
      connectivity = FakeConnectivityService(isOnline: false);
      container = await create();
      await container.read(shoppingListProvider.future);
      await list().setChecked([105], checked: true);
      repository.checkGate = Completer();
      connectivity.isOnline = true;
      await pumpEventQueue();

      await list().setChecked([105], checked: false);
      await list().setChecked([105], checked: true);
      expect(queue.pending, isEmpty);
      expect(entry(105).checked, isTrue);

      repository.checkGate!.complete();
      await pumpEventQueue();
      expect(sent(), ['{105} true']);
      expect(repository.entries.firstWhere((e) => e.id == 105).checked, true);
    });

    test('one state failing does not hold back the other', () async {
      await goOffline();
      await list().setChecked([103], checked: true);
      await list().setChecked([109], checked: false);
      repository
        ..checkFailure = const ServerFailure(statusCode: 500)
        ..checkFailsOnce = true;

      connectivity.isOnline = true;
      await pumpEventQueue();

      expect(sent(), ['{103} true', '{109} false']);
      expect(queue.pending.keys, [103]);
      expect(pendingIds(), {103});
    });

    test('the last tick of an entry replaces the one before', () async {
      await goOffline();
      final later = now;

      await list().setChecked([105], checked: true);
      await list().setChecked([105], checked: false);
      await list().setChecked([105], checked: true);

      expect(queue.pending, {105: PendingCheck(checked: true, at: later)});
    });

    test('are sent once back online, one request per state', () async {
      await goOffline();
      await list().setChecked([103], checked: true);
      await list().setChecked([105], checked: true);
      await list().setChecked([109], checked: false);

      connectivity.isOnline = true;
      await pumpEventQueue();

      expect(sent(), ['{103, 105} true', '{109} false']);
      expect(queue.pending, isEmpty);
      expect(pendingIds(), isEmpty);
      expect(entry(105).checked, isTrue);
      expect(entry(109).checked, isFalse);
      // A read after shows the server's state, the same.
      await list().refresh();
      expect(entry(105).checked, isTrue);
      expect(entry(109).checked, isFalse);
    });

    test('a read while offline keeps them on top', () async {
      await goOffline();
      await list().setChecked([105], checked: true);

      repository.cachedAt = DateTime(2026, 11, 18, 14);
      container.invalidate(shoppingListProvider);
      await container.read(shoppingListProvider.future);

      expect(entry(105).checked, isTrue);
      expect(pendingIds(), {105});
    });

    test('survive a restart of the app and are sent then', () async {
      queue.pending[105] = PendingCheck(checked: true, at: now);
      container = await create();

      await container.read(shoppingListProvider.future);
      await pumpEventQueue();

      expect(sent(), ['{105} true']);
      expect(queue.pending, isEmpty);
      expect(entry(105).checked, isTrue);
    });

    test('an app started offline shows them and waits', () async {
      queue.pending[105] = PendingCheck(checked: true, at: now);
      connectivity = FakeConnectivityService(isOnline: false);
      repository.cachedAt = DateTime(2026, 11, 18, 14);
      container = await create();

      await container.read(shoppingListProvider.future);
      await pumpEventQueue();

      expect(repository.checkCalls, isEmpty);
      expect(entry(105).checked, isTrue);
      expect(pendingIds(), {105});

      repository.cachedAt = null;
      connectivity.isOnline = true;
      await pumpEventQueue();
      expect(repository.checkCalls.single.ids, {105});
      expect(pendingIds(), isEmpty);
    });

    test('an entry deleted on the server meanwhile is dropped', () async {
      await goOffline();
      await list().setChecked([105], checked: true);
      // Lena deletes Feta while this device is offline.
      repository.entries.removeWhere((e) => e.id == 105);

      connectivity.isOnline = true;
      await pumpEventQueue();

      expect(repository.checkCalls.single.ids, {105});
      expect(queue.pending, isEmpty);
      await list().refresh();
      expect(
        container
            .read(shoppingListProvider)
            .requireValue
            .entries
            .map((e) => e.id),
        isNot(contains(105)),
      );
      expect(pendingIds(), isEmpty);
    });

    for (final failure in [
      const ServerFailure(statusCode: 502),
      const UnauthorizedFailure(),
      const OfflineFailure(),
    ]) {
      test('a failed send ($failure) keeps them and tries again', () async {
        await goOffline();
        await list().setChecked([105], checked: true);
        repository
          ..checkFailure = failure
          ..checkFailsOnce = true;

        connectivity.isOnline = true;
        await pumpEventQueue();
        expect(repository.checkCalls, hasLength(1));
        expect(queue.pending.keys, [105]);
        expect(pendingIds(), {105});
        expect(entry(105).checked, isTrue);

        // The next read the server answers takes them along; after an error
        // from the server, not right away, but coming back to the list.
        await list().poll();
        await pumpEventQueue();
        if (failure is! OfflineFailure) {
          expect(repository.checkCalls, hasLength(1));
          await list().catchUp();
          await pumpEventQueue();
        }
        expect(repository.checkCalls, hasLength(2));
        expect(queue.pending, isEmpty);
        expect(pendingIds(), isEmpty);
        expect(repository.entries.firstWhere((e) => e.id == 105).checked, true);
      });
    }

    test('a tick sent while the server can not be reached is queued', () async {
      await container.read(shoppingListProvider.future);
      repository
        ..checkFailure = const OfflineFailure()
        ..checkFailsOnce = true;

      expect(await list().setChecked([105], checked: true), isNull);

      expect(entry(105).checked, isTrue);
      expect(pendingIds(), {105});
      expect(queue.pending.keys, [105]);

      await list().catchUp();
      expect(repository.checkCalls, hasLength(2));
      expect(pendingIds(), isEmpty);
      expect(entry(105).checked, isTrue);
    });

    test('online, a tick goes out at once in place of a queued one', () async {
      await goOffline();
      await list().setChecked([105], checked: true);
      repository.checkGate = Completer();

      // Back online, before the queue is sent: unticked again.
      connectivity.isOnline = true;
      final unticked = list().setChecked([105], checked: false);
      await pumpEventQueue();
      expect(queue.pending, isEmpty);

      repository.checkGate!.complete();
      expect(await unticked, isNull);
      await pumpEventQueue();
      expect(sent().last, '{105} false');
      expect(repository.entries.firstWhere((e) => e.id == 105).checked, false);
      expect(entry(105).checked, isFalse);
    });
  });

  test('ignores a remembered supermarket the space no longer has', () async {
    store.write('shopping.supermarket', '99 $testServerUrl');
    await container.read(shoppingSupermarketsProvider.future);

    expect(container.read(shoppingSupermarketProvider), isNull);
  });
}
