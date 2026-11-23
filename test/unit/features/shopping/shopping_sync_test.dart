import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/features/shopping/shopping_providers.dart';
import 'package:yumdoor/features/shopping/shopping_sync.dart';

import '../../../fakes/app_overrides.dart';
import '../../../fakes/fake_shopping_repository.dart';
import '../../../fakes/in_memory_local_store.dart';
import '../../../fixtures/shopping.dart';

const _poll = Duration(seconds: 5);

void main() {
  group('ShoppingSync', () {
    late List<String> calls;
    late ShoppingSync sync;
    Completer<void>? gate;

    setUp(() {
      calls = [];
      gate = null;
      sync = ShoppingSync(
        poll: () async {
          calls.add('poll');
          await gate?.future;
        },
        reload: () async {
          calls.add('reload');
          await gate?.future;
        },
        reloadInterval: const Duration(seconds: 20),
      );
      addTearDown(sync.dispose);
    });

    test('polls every 5 s while active', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        async.elapse(const Duration(seconds: 4));
        expect(calls, isEmpty);
        async.elapse(const Duration(seconds: 1));
        expect(calls, ['poll']);
        async.elapse(const Duration(seconds: 10));
        expect(calls, ['poll', 'poll', 'poll']);
      });
    });

    test('reads in full every reload interval instead of polling', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        async.elapse(const Duration(seconds: 40));
        expect(calls, [
          ...['poll', 'poll', 'poll', 'reload'],
          ...['poll', 'poll', 'poll', 'reload'],
        ]);
      });
    });

    test('a read elsewhere puts the next full read off', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        async.elapse(const Duration(seconds: 15));
        sync.didReload();
        async.elapse(const Duration(seconds: 15));
        expect(calls, List.filled(6, 'poll'));
      });
    });

    test('pauses, and catches up with a full read on resume', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        async.elapse(_poll);
        sync.setActive(false);
        async.elapse(const Duration(minutes: 1));
        expect(calls, ['poll']);

        sync.setActive(true);
        async.flushMicrotasks();
        expect(calls, ['poll', 'reload']);
        async.elapse(_poll);
        expect(calls, ['poll', 'reload', 'poll']);
      });
    });

    test('reads never overlap; the next starts 5 s after one ends', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        gate = Completer();
        async.elapse(const Duration(seconds: 30));
        expect(calls, ['poll']);

        gate!.complete();
        gate = null;
        async.elapse(const Duration(seconds: 4));
        expect(calls, ['poll']);
        async.elapse(const Duration(seconds: 1));
        expect(calls, ['poll', 'poll']);
      });
    });

    test('a read still running when paused schedules nothing', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        gate = Completer();
        async.elapse(_poll);
        sync.setActive(false);
        gate!.complete();
        async.elapse(const Duration(minutes: 1));
        expect(calls, ['poll']);
      });
    });

    test('resuming during a running read catches up after it', () {
      fakeAsync((async) {
        sync.setActive(true, catchUp: false);
        final slow = gate = Completer();
        async.elapse(_poll);
        sync.setActive(false);
        gate = null;
        sync.setActive(true);
        async.flushMicrotasks();
        expect(calls, ['poll']);

        slow.complete();
        async.flushMicrotasks();
        expect(calls, ['poll', 'reload']);
      });
    });

    test('keeps going after a failed read', () {
      fakeAsync((async) {
        var failing = true;
        final failingSync = ShoppingSync(
          poll: () async {
            calls.add('poll');
            if (failing) throw StateError('server');
          },
          reload: () async => calls.add('reload'),
        );
        failingSync.setActive(true, catchUp: false);
        async.elapse(_poll);
        failing = false;
        async.elapse(_poll);
        expect(calls, ['poll', 'poll']);
        failingSync.dispose();
        async.elapse(const Duration(minutes: 1));
        expect(calls, ['poll', 'poll']);
      });
    });
  });

  group('with the shopping list', () {
    late FakeShoppingRepository repository;
    late ProviderContainer container;
    late ShoppingSync sync;

    ShoppingList list() => container.read(shoppingListProvider.notifier);

    ShoppingEntry? entry(int id) {
      for (final entry
          in container.read(shoppingListProvider).requireValue.entries) {
        if (entry.id == id) return entry;
      }
      return null;
    }

    /// Lena, on her phone, checks off [id] at [at].
    void othersCheck(int id, DateTime at) {
      final index = repository.entries.indexWhere((e) => e.id == id);
      repository.entries[index] = repository.entries[index].copyWith(
        checked: true,
        completedAt: at,
        updatedAt: at,
      );
    }

    /// Starts a list, synced every 5 s and in full every 30 s, in fake time.
    void start(FakeAsync async) {
      repository = FakeShoppingRepository(entries: mockupShoppingList());
      container = ProviderContainer(
        overrides: [
          tokenStoreProvider.overrideWithValue(loggedInTokenStore()),
          shoppingRepositoryProvider.overrideWithValue(repository),
          localStoreProvider.overrideWithValue(InMemoryLocalStore()),
          clockProvider.overrideWithValue(() => repository.now),
        ],
      );
      container.listen(shoppingListProvider, (_, _) {});
      async.flushMicrotasks();
      expect(container.read(shoppingListProvider).hasValue, isTrue);
      sync = ShoppingSync(
        poll: () => list().poll(),
        reload: () => list().catchUp(),
        reloadInterval: const Duration(seconds: 30),
      )..setActive(true, catchUp: false);
    }

    void stop() {
      sync.dispose();
      container.dispose();
    }

    test("shows the others' check-offs and additions within 5 s", () {
      fakeAsync((async) {
        start(async);
        final before = repository.now;
        repository.now = before.add(const Duration(minutes: 1));
        othersCheck(105, repository.now);
        final lemons = repository.entries
            .firstWhere((e) => e.id == 108)
            .copyWith(id: 120, updatedAt: repository.now);
        repository.entries.add(lemons);

        async.elapse(_poll);
        expect(repository.fetchedAfter.last, before);
        expect(entry(105)!.checked, isTrue);
        expect(entry(120), isNotNull);
        expect(entry(101)!.checked, isFalse);

        // The next poll asks only for what changed since this one.
        async.elapse(_poll);
        expect(repository.fetchedAfter.last, repository.now);
        stop();
      });
    });

    test('a deleted entry goes with the next full read', () {
      fakeAsync((async) {
        start(async);
        repository.entries.removeWhere((e) => e.id == 108);

        async.elapse(const Duration(seconds: 25));
        expect(entry(108), isNotNull);
        expect(repository.fetchedAfter.skip(1), everyElement(isNotNull));

        async.elapse(_poll);
        expect(repository.fetchedAfter.last, isNull);
        expect(entry(108), isNull);
        stop();
      });
    });

    test('a poll does not undo a check-off still being sent', () {
      fakeAsync((async) {
        start(async);
        repository.checkGate = Completer();
        unawaited(list().setChecked([103], checked: true));
        async.flushMicrotasks();

        // The server doesn't have it yet, and Lena changed the entry.
        repository.now = repository.now.add(const Duration(minutes: 1));
        final index = repository.entries.indexWhere((e) => e.id == 103);
        repository.entries[index] = repository.entries[index].copyWith(
          amount: 2,
          updatedAt: repository.now,
        );
        async.elapse(_poll);
        expect(entry(103)!.amount, 2);
        expect(entry(103)!.checked, isTrue);

        repository.checkGate!.complete();
        async.flushMicrotasks();
        expect(entry(103)!.checked, isTrue);
        async.elapse(_poll);
        expect(entry(103)!.checked, isTrue);
        expect(entry(103)!.completedAt, repository.now);
        stop();
      });
    });

    test('a poll from before a delete does not bring the entry back', () {
      fakeAsync((async) {
        start(async);
        repository.now = repository.now.add(const Duration(minutes: 1));
        othersCheck(108, repository.now);
        final slow = Completer<void>();
        repository.fetchGates.add(slow);
        async.elapse(_poll);

        unawaited(list().delete(list().entriesOf([108])));
        async.flushMicrotasks();
        expect(entry(108), isNull);

        slow.complete();
        async.flushMicrotasks();
        expect(entry(108), isNull);
        stop();
      });
    });

    test('a poll from before a full read keeps its newer states', () {
      fakeAsync((async) {
        start(async);
        final slow = Completer<void>();
        repository.fetchGates.add(slow);
        async.elapse(_poll);

        // Lena checks Feta off; a full read shows it while the poll hangs.
        repository.now = repository.now.add(const Duration(minutes: 1));
        othersCheck(105, repository.now);
        unawaited(list().refresh());
        async.flushMicrotasks();
        expect(entry(105)!.checked, isTrue);

        slow.complete();
        async.flushMicrotasks();
        expect(entry(105)!.checked, isTrue);
        stop();
      });
    });
  });
}
