import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/offline.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/domain/repositories/shopping_check_queue.dart';
import 'package:yumdoor/features/shopping/shopping_screen.dart';
import 'package:yumdoor/features/shopping/shopping_sync.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_book_user_repositories.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_shopping_check_queue.dart';
import '../../fakes/fake_shopping_repository.dart';
import '../../fakes/in_memory_local_store.dart';
import '../../fixtures/shopping.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  setUpAll(loadBundledFonts);

  late FakeShoppingRepository repository;
  late InMemoryLocalStore store;
  late FakeShoppingCheckQueue queue;

  /// What remembers Markt am Eck on the test server.
  final storedChoice = '${marketAmEck.id} $testServerUrl';

  setUp(() {
    repository = FakeShoppingRepository(
      entries: mockupShoppingList(),
      supermarketList: const [marketAmEck, bioladen],
    );
    store = InMemoryLocalStore();
    queue = FakeShoppingCheckQueue();
  });

  Future<GoRouter> pumpList(
    WidgetTester tester, {
    ThemeData? theme,
    FakeConnectivityService? connectivity,
    Size size = phoneSize,
  }) => pumpRoutes(
    tester,
    location: '/shopping',
    theme: theme,
    size: size,
    overrides: [
      ...appOverrides(
        shopping: repository,
        shoppingQueue: queue,
        localStore: store,
        connectivity: connectivity,
        tokenStore: loggedInTokenStore(),
        users: FakeUserRepository(const [anna, lena], anna.id),
      ),
      clockProvider.overrideWithValue(() => DateTime(2026, 11, 18, 12)),
    ],
    routes: [tabsRoute()],
  );

  /// The section headers, top to bottom.
  List<String> sections(WidgetTester tester) {
    final headers = [
      for (final name in ['OBST UND GEMÜSE', 'KÜHLREGAL', 'VORRAT'])
        if (find.text(name).evaluate().isNotEmpty) name,
    ];
    return headers..sort(
      (a, b) => tester
          .getTopLeft(find.text(a))
          .dy
          .compareTo(tester.getTopLeft(find.text(b)).dy),
    );
  }

  Finder row(String name) => find.ancestor(
    of: find.text(name),
    matching: find.byWidgetPredicate((widget) => widget is InkWell),
  );

  testWidgets('shows merged rows by category in the chosen store order', (
    tester,
  ) async {
    store.write('shopping.supermarket', storedChoice);
    await pumpList(tester, size: const Size(390, 1400));

    expect(find.text('Einkaufsliste'), findsOneWidget);
    expect(find.text('Geteilt mit deinem Haushalt · 7 offen'), findsOneWidget);
    expect(find.text('Supermarkt: Markt am Eck'), findsOneWidget);
    expect(sections(tester), ['OBST UND GEMÜSE', 'KÜHLREGAL', 'VORRAT']);
    // Two entries of carrots, merged and in plural.
    expect(find.text('Karotten'), findsOneWidget);
    expect(find.text('1,1 kg'), findsOneWidget);
    expect(find.text('½ Bund'), findsOneWidget);
    expect(find.text('Zitronen'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    // Where rows come from is hidden unless chosen.
    expect(find.text('Ofenkarotten, Linsen-Bolognese'), findsNothing);
    expect(find.text('von Lena hinzugefügt'), findsNothing);
    // The done rows are collapsed.
    expect(find.text('Erledigt · 3'), findsOneWidget);
    expect(find.text('Olivenöl'), findsNothing);

    await tester.tap(find.text('Erledigt · 3'));
    await tester.pumpAndSettle();
    expect(find.text('Olivenöl'), findsOneWidget);
  });

  testWidgets('shows where rows come from when chosen, remembered', (
    tester,
  ) async {
    await pumpList(tester, size: const Size(390, 1400));
    final toggle = find.byTooltip('Herkunft der Artikel');
    expect(tester.getSemantics(toggle), isSemantics(isSelected: false));

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Ofenkarotten, Linsen-Bolognese'), findsOneWidget);
    expect(find.text('von Lena hinzugefügt'), findsOneWidget);
    expect(tester.getSemantics(toggle), isSemantics(isSelected: true));
    await tester.tap(find.text('Erledigt · 3'));
    await tester.pumpAndSettle();
    expect(find.text('von dir hinzugefügt'), findsOneWidget);
    expect(store.read('shopping.showSources'), '1');

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Ofenkarotten, Linsen-Bolognese'), findsNothing);
    expect(store.read('shopping.showSources'), isNull);
  });

  testWidgets('checks a row off at once, and undo checks it back on', (
    tester,
  ) async {
    await pumpList(tester);

    await tester.tap(find.text('Karotten'));
    await tester.pump();

    // Sent right away, both entries of the row together.
    expect(repository.checkCalls.single.ids, {101, 102});
    expect(repository.checkCalls.single.checked, isTrue);
    expect(find.text('Karotten abgehakt'), findsOneWidget);
    expect(find.text('Geteilt mit deinem Haushalt · 6 offen'), findsOneWidget);
    expect(find.text('Erledigt · 4'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Karotten'), findsNothing);

    await tester.tap(find.text('Rückgängig'));
    await tester.pumpAndSettle();

    expect(repository.checkCalls.last.ids, {101, 102});
    expect(repository.checkCalls.last.checked, isFalse);
    expect(find.text('Karotten'), findsOneWidget);
    expect(find.text('Erledigt · 3'), findsOneWidget);
    expect(repository.entries.where((e) => e.checked), hasLength(3));
  });

  testWidgets('unchecks a row from Erledigt', (tester) async {
    await pumpList(tester, size: const Size(390, 1400));

    await tester.tap(find.text('Erledigt · 3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Olivenöl'));
    await tester.pumpAndSettle();

    expect(repository.checkCalls.single.ids, {109});
    expect(repository.checkCalls.single.checked, isFalse);
    expect(find.text('Olivenöl wieder auf der Liste'), findsOneWidget);
    expect(find.text('Erledigt · 2'), findsOneWidget);
    expect(find.text('Geteilt mit deinem Haushalt · 8 offen'), findsOneWidget);
    // Back in its section, with a ring instead of a check.
    expect(
      tester.getTopLeft(find.text('Olivenöl')).dy,
      lessThan(tester.getTopLeft(find.text('Erledigt · 2')).dy),
    );
  });

  testWidgets('a failed check-off goes back and says why', (tester) async {
    repository.checkFailure = const ServerFailure(statusCode: 500);
    await pumpList(tester);

    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Feta nicht abgehakt.'), findsOneWidget);
    expect(find.text('Erledigt · 3'), findsOneWidget);
    expect(row('Feta'), findsOneWidget);
    expect(find.text('Geteilt mit deinem Haushalt · 7 offen'), findsOneWidget);
  });

  testWidgets('a check-off the server can not get waits on the device', (
    tester,
  ) async {
    repository
      ..checkFailure = const OfflineFailure()
      ..checkFailsOnce = true;
    await pumpList(tester, size: const Size(390, 1400));

    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();

    expect(find.textContaining('nicht abgehakt'), findsNothing);
    expect(find.text('Erledigt · 4'), findsOneWidget);
    expect(find.text('1 Änderung noch nicht gesendet'), findsOneWidget);
    expect(queue.pending.keys, [105]);
  });

  testWidgets(
    'offline, ticking works and is sent once back online; the rest is '
    'disabled',
    (tester) async {
      repository.cachedAt = DateTime(2026, 11, 17, 19, 30);
      final connectivity = FakeConnectivityService(isOnline: false);
      await pumpList(
        tester,
        connectivity: connectivity,
        size: const Size(390, 1400),
      );

      expect(find.text('Offline · Stand vom 17. Nov., 19:30'), findsOneWidget);
      expect(
        find.text('Geteilt mit deinem Haushalt · 7 offen'),
        findsOneWidget,
      );
      await tester.tap(find.text('Feta'));
      await tester.pumpAndSettle();

      // Moved to Erledigt, marked as waiting, nothing sent.
      expect(repository.checkCalls, isEmpty);
      expect(find.text('Feta abgehakt'), findsOneWidget);
      expect(
        find.text('Geteilt mit deinem Haushalt · 6 offen'),
        findsOneWidget,
      );
      expect(find.text('1 Änderung noch nicht gesendet'), findsOneWidget);
      expect(find.text('Erledigt · 4'), findsOneWidget);
      await tester.tap(find.text('Erledigt · 4'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: row('Feta'),
          matching: find.text('wird synchronisiert'),
        ),
        findsOneWidget,
      );
      expect(find.text('wird synchronisiert'), findsOneWidget);

      // The other changes still need a connection.
      await tester.tap(find.byTooltip('Mehr zu Karotten'));
      await tester.pumpAndSettle();
      expect(find.text('Habe ich da'), findsNothing);
      expect(
        find.textContaining('Offline kannst du nichts ändern'),
        findsOneWidget,
      );

      // Back online: sent, read from the server, and the marks go.
      repository.cachedAt = null;
      connectivity.isOnline = true;
      await tester.pumpAndSettle();
      expect(repository.checkCalls.single.ids, {105});
      expect(repository.checkCalls.single.checked, isTrue);
      expect(find.textContaining('Offline · Stand vom'), findsNothing);
      expect(find.text('wird synchronisiert'), findsNothing);
      expect(find.textContaining('noch nicht gesendet'), findsNothing);
      expect(find.text('Erledigt · 4'), findsOneWidget);
      expect(queue.pending, isEmpty);
    },
  );

  testWidgets('remembers the chosen supermarket', (tester) async {
    await pumpList(tester, size: const Size(390, 1400));
    // Without one, the categories go by name.
    expect(sections(tester), ['KÜHLREGAL', 'OBST UND GEMÜSE', 'VORRAT']);

    await tester.tap(find.text('Supermarkt wählen'));
    await tester.pumpAndSettle();
    expect(find.text('Keiner (Abteilungen nach Name)'), findsOneWidget);
    await tester.tap(find.text('Markt am Eck'));
    await tester.pumpAndSettle();

    expect(store.values['shopping.supermarket'], storedChoice);
    expect(find.text('Supermarkt: Markt am Eck'), findsOneWidget);
    expect(sections(tester), ['OBST UND GEMÜSE', 'KÜHLREGAL', 'VORRAT']);

    await tester.tap(find.text('Supermarkt: Markt am Eck'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keiner (Abteilungen nach Name)'));
    await tester.pumpAndSettle();

    expect(store.values, isNot(contains('shopping.supermarket')));
    expect(sections(tester), ['KÜHLREGAL', 'OBST UND GEMÜSE', 'VORRAT']);
  });

  testWidgets('without supermarkets, there is no picker', (tester) async {
    repository.supermarketList = const [];
    await pumpList(tester);

    expect(find.text('Supermarkt wählen'), findsNothing);
    expect(find.text('Karotten'), findsOneWidget);
  });

  testWidgets('an empty list says where items come from', (tester) async {
    repository.entries.clear();
    await pumpList(tester);

    expect(find.text('Die Einkaufsliste ist leer.'), findsOneWidget);
    expect(find.text('Geteilt mit deinem Haushalt · 0 offen'), findsOneWidget);
    expect(find.textContaining('Erledigt'), findsNothing);
    // Nothing whose origin could be shown.
    expect(find.byTooltip('Herkunft der Artikel'), findsNothing);
  });

  testWidgets('everything checked off says so', (tester) async {
    repository.entries.removeWhere((entry) => !entry.checked);
    await pumpList(tester);

    expect(find.text('Alles erledigt.'), findsOneWidget);
    expect(find.text('Erledigt · 3'), findsOneWidget);
  });

  testWidgets('says when Tandoor cut the list off', (tester) async {
    repository.truncated = true;
    await pumpList(tester);

    expect(
      find.text(
        'Tandoor schickt höchstens 1.000 Einträge. '
        'Die neuesten fehlen hier vielleicht.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a failed read offers to try again', (tester) async {
    repository.fetchFailure = const ServerFailure();
    await pumpList(tester);

    expect(find.text('Nochmal versuchen'), findsOneWidget);

    repository.fetchFailure = null;
    await tester.tap(find.text('Nochmal versuchen'));
    await tester.pumpAndSettle();

    expect(find.text('Karotten'), findsOneWidget);
  });

  testWidgets('pull to refresh shows what the others changed', (tester) async {
    await pumpList(tester);
    repository.entries.removeWhere((entry) => entry.id == 105);

    await tester.fling(find.text('Karotten'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Feta'), findsNothing);
    expect(find.text('Geteilt mit deinem Haushalt · 6 offen'), findsOneWidget);
  });

  testWidgets('reads the list again when the tab comes back', (tester) async {
    final router = await pumpList(tester);
    expect(repository.fetchCalls, 1);
    repository.entries.add(
      mockupShoppingList().first.copyWith(
        id: 200,
        food: mockupShoppingList().first.food.copyWith(
          id: 50,
          name: 'Ingwer',
          pluralName: null,
        ),
        createdBy: const UserRef(id: 2, name: 'Lena'),
        source: null,
      ),
    );

    router.go('/plan');
    await tester.pumpAndSettle();
    router.go('/shopping');
    await tester.pumpAndSettle();

    expect(repository.fetchCalls, 2);
    expect(find.text('Ingwer'), findsOneWidget);
  });

  testWidgets('stays in sync while in view, online and in front', (
    tester,
  ) async {
    final connectivity = FakeConnectivityService();
    await pumpList(tester, connectivity: connectivity);
    expect(repository.fetchedAfter, [null]);

    // Lena ticks Feta off on her phone.
    repository.now = repository.now.add(const Duration(minutes: 1));
    final feta = repository.entries.indexWhere((e) => e.id == 105);
    repository.entries[feta] = repository.entries[feta].copyWith(
      checked: true,
      completedAt: repository.now,
      updatedAt: repository.now,
    );
    await tester.pump(shoppingPollInterval);
    await tester.pumpAndSettle();
    expect(repository.fetchedAfter, hasLength(2));
    expect(repository.fetchedAfter.last, isNotNull);
    expect(find.text('Geteilt mit deinem Haushalt · 6 offen'), findsOneWidget);

    // Offline: nothing to ask. Back online: read in full at once.
    connectivity.isOnline = false;
    await tester.pump(const Duration(seconds: 30));
    expect(repository.fetchedAfter, hasLength(2));
    connectivity.isOnline = true;
    await tester.pump();
    expect(repository.fetchedAfter, hasLength(3));
    expect(repository.fetchedAfter.last, isNull);

    // In the background (another browser tab): paused, caught up on return.
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump(const Duration(seconds: 30));
    expect(repository.fetchedAfter, hasLength(3));
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(repository.fetchedAfter, hasLength(4));
    expect(repository.fetchedAfter.last, isNull);

    // Polling again.
    await tester.pump(shoppingPollInterval);
    expect(repository.fetchedAfter, hasLength(5));
    expect(repository.fetchedAfter.last, isNotNull);
  });

  testWidgets('keeps asking an unreachable server and catches up after', (
    tester,
  ) async {
    final connectivity = FakeConnectivityService();
    await pumpList(tester, connectivity: connectivity);
    final offline = ProviderScope.containerOf(
      tester.element(find.byType(ShoppingScreen)),
    ).read(isOfflineProvider.notifier);

    offline.reportServerReachable(false);
    await tester.pump(shoppingPollInterval);
    expect(repository.fetchedAfter, hasLength(2));
    expect(repository.fetchedAfter.last, isNotNull);

    offline.reportServerReachable(true);
    await tester.pump();
    expect(repository.fetchedAfter, hasLength(3));
    expect(repository.fetchedAfter.last, isNull);

    // Unreachable, then the device's network goes, too: paused.
    offline.reportServerReachable(false);
    connectivity.isOnline = false;
    await tester.pump(const Duration(seconds: 30));
    expect(repository.fetchedAfter, hasLength(3));
    connectivity.isOnline = true;
    await tester.pump();
    expect(repository.fetchedAfter, hasLength(4));
    expect(repository.fetchedAfter.last, isNull);
  });

  testWidgets('undo after going offline waits on the device', (tester) async {
    final connectivity = FakeConnectivityService();
    await pumpList(
      tester,
      connectivity: connectivity,
      size: const Size(390, 1400),
    );

    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();
    connectivity.isOnline = false;
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rückgängig'));
    await tester.pumpAndSettle();

    expect(repository.checkCalls, hasLength(1));
    expect(row('Feta'), findsOneWidget);
    expect(find.text('Erledigt · 3'), findsOneWidget);
    expect(find.text('wird synchronisiert'), findsOneWidget);

    connectivity.isOnline = true;
    await tester.pumpAndSettle();
    expect(repository.checkCalls.last.ids, {105});
    expect(repository.checkCalls.last.checked, isFalse);
    expect(find.text('wird synchronisiert'), findsNothing);
  });

  testWidgets('a failed read is tried again when the tab comes back', (
    tester,
  ) async {
    repository.fetchFailure = const OfflineFailure();
    final router = await pumpList(tester);
    expect(find.text('Nochmal versuchen'), findsOneWidget);

    repository.fetchFailure = null;
    router.go('/plan');
    await tester.pumpAndSettle();
    router.go('/shopping');
    await tester.pumpAndSettle();

    expect(find.text('Karotten'), findsOneWidget);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('mockup 12 in $name', tags: goldenTags, (tester) async {
        store.write('shopping.supermarket', storedChoice);
        await pumpList(tester, theme: theme);

        await expectLater(
          find.byType(ShoppingScreen),
          matchesGoldenFile('../goldens/shopping_list_$name.png'),
        );
      });
    }

    testWidgets('with sources in light', tags: goldenTags, (tester) async {
      store
        ..write('shopping.supermarket', storedChoice)
        ..write('shopping.showSources', '1');
      await pumpList(tester, theme: lightTheme);

      await expectLater(
        find.byType(ShoppingScreen),
        matchesGoldenFile('../goldens/shopping_list_sources_light.png'),
      );
    });

    testWidgets('offline in light', tags: goldenTags, (tester) async {
      store.write('shopping.supermarket', storedChoice);
      repository.cachedAt = DateTime(2026, 11, 17, 19, 30);
      await pumpList(
        tester,
        theme: lightTheme,
        connectivity: FakeConnectivityService(isOnline: false),
      );

      await expectLater(
        find.byType(ShoppingScreen),
        matchesGoldenFile('../goldens/shopping_list_offline_light.png'),
      );
    });

    testWidgets(
      'offline with a change not sent yet in light',
      tags: goldenTags,
      (tester) async {
        store.write('shopping.supermarket', storedChoice);
        repository.cachedAt = DateTime(2026, 11, 17, 19, 30);
        // Olivenöl put back on the list offline, before a restart.
        queue.pending[109] = PendingCheck(
          checked: false,
          at: DateTime.utc(2026, 11, 18, 11),
        );
        await pumpList(
          tester,
          theme: lightTheme,
          size: const Size(390, 1100),
          connectivity: FakeConnectivityService(isOnline: false),
        );

        expect(find.text('1 Änderung noch nicht gesendet'), findsOneWidget);
        expect(find.text('wird synchronisiert'), findsOneWidget);
        await expectLater(
          find.byType(ShoppingScreen),
          matchesGoldenFile('../goldens/shopping_list_pending_light.png'),
        );
      },
    );
  });
}
