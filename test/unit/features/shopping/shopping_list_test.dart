import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/app/session.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/features/shopping/shopping_providers.dart';

import '../../../fakes/app_overrides.dart';
import '../../../fakes/fake_shopping_repository.dart';
import '../../../fakes/in_memory_local_store.dart';
import '../../../fixtures/shopping.dart';

void main() {
  late FakeShoppingRepository repository;
  late InMemoryLocalStore store;
  late ProviderContainer container;
  final now = DateTime.utc(2026, 11, 18, 15);

  /// What remembers Markt am Eck on the test server.
  final storedChoice = '${marketAmEck.id} $testServerUrl';

  Future<ProviderContainer> create() async {
    final container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(loggedInTokenStore()),
        shoppingRepositoryProvider.overrideWithValue(repository),
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
    repository.checkFailure = const OfflineFailure();

    final failure = await list().setChecked([103], checked: true);

    expect(failure, isA<OfflineFailure>());
    expect(entry(103).checked, isFalse);
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

    repository.checkFailure = const OfflineFailure();
    final failure = await list().setChecked([103], checked: false);

    expect(failure, isA<OfflineFailure>());
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

  test('ignores a remembered supermarket the space no longer has', () async {
    store.write('shopping.supermarket', '99 $testServerUrl');
    await container.read(shoppingSupermarketsProvider.future);

    expect(container.read(shoppingSupermarketProvider), isNull);
  });
}
