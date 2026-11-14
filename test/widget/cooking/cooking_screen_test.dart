import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/design/components/timer_chip.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/cooking/cooking_screen.dart';
import 'package:yumdoor/platform/timers/timer_alert_service.dart';
import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

import '../../fakes/fake_alert_channels.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fakes/fake_wake_lock_service.dart';
import '../../fakes/in_memory_local_store.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository repository;
  late FakeWakeLockService wakeLock;
  late InMemoryLocalStore localStore;
  late DateTime now;
  late FakeAlertChannels alerts;

  setUpAll(loadBundledFonts);

  setUp(() {
    repository = FakeRecipeRepository([ofenkarotten]);
    wakeLock = FakeWakeLockService();
    localStore = InMemoryLocalStore();
    now = DateTime.utc(2026, 11, 14, 18);
    alerts = FakeAlertChannels(runsInBackground: false);
  });

  /// Cooking mode pushed over a stand-in recipe screen, like the app does.
  Future<GoRouter> pumpCooking(
    WidgetTester tester, {
    String query = '?servings=4',
    ThemeData? theme,
    Size size = phoneSize,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: '/recipe/7',
      theme: theme,
      size: size,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(repository),
        wakeLockServiceProvider.overrideWithValue(wakeLock),
        localStoreProvider.overrideWithValue(localStore),
        clockProvider.overrideWithValue(() => now),
        timerAlertServiceProvider.overrideWithValue(
          ChannelTimerAlertService(alerts),
        ),
      ],
      routes: [
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) => const Text('recipe screen'),
          routes: [
            GoRoute(
              path: 'cook',
              builder: (context, state) => CookingScreen(
                recipeId: int.parse(state.pathParameters['id']!),
                servings: int.tryParse(
                  state.uri.queryParameters['servings'] ?? '',
                ),
              ),
            ),
            GoRoute(
              path: 'cooked',
              builder: (context, state) => Text('cooked ${state.uri}'),
            ),
          ],
        ),
      ],
    );
    unawaitedPush(router, '/recipe/7/cook$query');
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> next(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the first step and the recipe name', (tester) async {
    await pumpCooking(tester);

    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    expect(find.text('Schritt 1 von 3'), findsOneWidget);
    expect(find.text('SCHRITT 1'), findsOneWidget);
    expect(find.text('Den Ofen auf 200 °C vorheizen.'), findsOneWidget);
    // Step 1 has no ingredients.
    expect(find.text('Zutaten'), findsNothing);
  });

  testWidgets('Weiter and Zurück move between steps', (tester) async {
    await pumpCooking(tester);

    await next(tester, 'Weiter zu Schritt 2');
    expect(find.text('Schritt 2 von 3'), findsOneWidget);
    expect(find.textContaining('Karotten schräg'), findsOneWidget);

    await tester.tap(find.byTooltip('Zurück zu Schritt 1'));
    await tester.pumpAndSettle();
    expect(find.text('Schritt 1 von 3'), findsOneWidget);
  });

  testWidgets('the back button is disabled on the first step', (tester) async {
    await pumpCooking(tester);

    final back = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.chevron_left_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(back.onPressed, isNull);
  });

  testWidgets('swiping changes the step', (tester) async {
    await pumpCooking(tester);

    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Schritt 2 von 3'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Schritt 1 von 3'), findsOneWidget);
  });

  testWidgets('tapping a step dot jumps to that step', (tester) async {
    await pumpCooking(tester);

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(find.text('Schritt 3 von 3'), findsOneWidget);
  });

  testWidgets('amounts are scaled to the chosen servings, read-only', (
    tester,
  ) async {
    await pumpCooking(tester, query: '?servings=4');
    await next(tester, 'Weiter zu Schritt 2');

    expect(find.text('für 4 Portionen'), findsOneWidget);
    expect(find.text('Karotten'), findsOneWidget);
    expect(find.text('600 g'), findsOneWidget);
    expect(find.text('2 EL'), findsOneWidget);
    expect(find.text('1 TL'), findsOneWidget);
    expect(find.text('Salz'), findsOneWidget);
    // Nothing here changes the servings.
    expect(find.byTooltip('Mehr Portionen'), findsNothing);
    expect(find.byTooltip('Weniger Portionen'), findsNothing);

    await next(tester, 'Weiter zu Schritt 3');
    expect(find.text('200 g'), findsOneWidget);
    expect(find.text('½ Bund'), findsOneWidget);
  });

  testWidgets('without servings, the recipe\'s own servings are used', (
    tester,
  ) async {
    await pumpCooking(tester, query: '');
    await next(tester, 'Weiter zu Schritt 2');

    expect(find.text('für 2 Portionen'), findsOneWidget);
    expect(find.text('300 g'), findsOneWidget);
  });

  testWidgets('the last step offers Fertig gekocht, which opens the cook '
      'log in place of cooking mode', (tester) async {
    final router = await pumpCooking(tester);
    await next(tester, 'Weiter zu Schritt 2');
    await next(tester, 'Weiter zu Schritt 3');

    expect(find.text('SCHRITT 3 · LETZTER'), findsOneWidget);
    expect(find.textContaining('Weiter zu'), findsNothing);

    await next(tester, 'Fertig gekocht');
    expect(find.text('cooked /recipe/7/cooked?servings=4'), findsOneWidget);
    expect(find.byType(CookingScreen), findsNothing);

    // Back from there leads to the recipe, not into cooking mode again.
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('recipe screen'), findsOneWidget);
  });

  testWidgets('Fertig gekocht passes the recipe\'s servings without '
      '?servings=', (tester) async {
    await pumpCooking(tester, query: '');
    await next(tester, 'Weiter zu Schritt 2');
    await next(tester, 'Weiter zu Schritt 3');

    await next(tester, 'Fertig gekocht');
    expect(find.text('cooked /recipe/7/cooked?servings=2'), findsOneWidget);
  });

  testWidgets('the close button returns to the recipe', (tester) async {
    await pumpCooking(tester);

    await tester.tap(find.byTooltip('Kochmodus beenden'));
    await tester.pumpAndSettle();

    expect(find.text('recipe screen'), findsOneWidget);
  });

  group('wake lock', () {
    testWidgets('is acquired on enter and released on leave', (tester) async {
      await pumpCooking(tester);

      expect(wakeLock.status, WakeLockStatus.active);
      expect(find.byTooltip('Bildschirm bleibt an'), findsOneWidget);

      await tester.tap(find.byTooltip('Kochmodus beenden'));
      await tester.pumpAndSettle();

      expect(wakeLock.status, WakeLockStatus.inactive);
    });

    testWidgets('the toggle releases and reacquires it', (tester) async {
      await pumpCooking(tester);

      await tester.tap(find.byTooltip('Bildschirm bleibt an'));
      await tester.pumpAndSettle();
      expect(wakeLock.status, WakeLockStatus.inactive);
      expect(find.byTooltip('Bildschirm anlassen'), findsOneWidget);

      await tester.tap(find.byTooltip('Bildschirm anlassen'));
      await tester.pumpAndSettle();
      expect(wakeLock.status, WakeLockStatus.active);
    });

    testWidgets('the icon follows the platform dropping it', (tester) async {
      await pumpCooking(tester);

      wakeLock.dropByPlatform();
      await tester.pump();
      expect(find.byTooltip('Bildschirm anlassen'), findsOneWidget);

      wakeLock.resume();
      await tester.pump();
      expect(find.byTooltip('Bildschirm bleibt an'), findsOneWidget);
    });

    testWidgets('if unsupported, a hint is shown once per session', (
      tester,
    ) async {
      wakeLock = FakeWakeLockService(outcome: WakeLockStatus.unsupported);
      final router = await pumpCooking(tester);
      const hint =
          'Dein Gerät kann den Bildschirm hier nicht anlassen. Stell die '
          'automatische Sperre zum Kochen länger ein.';

      expect(find.text(hint), findsOneWidget);
      expect(find.byTooltip('Bildschirm kann nicht anbleiben'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      ScaffoldMessenger.of(tester.element(find.text('recipe screen')))
          .clearSnackBars();
      await tester.pumpAndSettle();

      unawaitedPush(router, '/recipe/7/cook?servings=4');
      await tester.pumpAndSettle();
      expect(find.text(hint), findsNothing);
    });

    testWidgets('if denied, the hint is shown too', (tester) async {
      wakeLock = FakeWakeLockService(outcome: WakeLockStatus.denied);
      await pumpCooking(tester);

      expect(
        find.textContaining('Dein Gerät kann den Bildschirm'),
        findsOneWidget,
      );
    });
  });

  testWidgets('step templates show amounts scaled to the servings', (
    tester,
  ) async {
    final step = ofenkarotten.steps[1].copyWith(
      instruction:
          '{{ ingredients[0] }} schräg schneiden, mit '
          '{{ ingredients[1].amount }} {{ ingredients[1].unit }} Öl mischen '
          'und auf ein Blech ({{ scale(30) }} × 40 cm) geben. {{ unbekannt }}',
    );
    repository.recipes[7] = ofenkarotten.copyWith(
      steps: [ofenkarotten.steps[0], step, ofenkarotten.steps[2]],
    );
    // The recipe is for 2 servings.
    await pumpCooking(tester, query: '?servings=4');
    await next(tester, 'Weiter zu Schritt 2');

    expect(
      find.text(
        '600 g Karotten schräg schneiden, mit 2 EL Öl mischen und auf ein '
        'Blech (60 × 40 cm) geben. {{ unbekannt }}',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  group('ticking off ingredients', () {
    /// The tick-off button of [name]'s row.
    Finder row(String name) => find.bySemanticsLabel('$name abhaken');

    bool isDone(WidgetTester tester, String name) {
      final data = tester.getSemantics(row(name)).getSemanticsData();
      return data.flagsCollection.isChecked == CheckedState.isTrue;
    }

    testWidgets('a tap toggles a row, announced as checked', (tester) async {
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');

      expect(isDone(tester, 'Karotten'), isFalse);
      await tester.tap(find.text('Karotten'));
      await tester.pump();
      expect(isDone(tester, 'Karotten'), isTrue);
      expect(isDone(tester, 'Olivenöl'), isFalse);

      await tester.tap(find.text('Karotten'));
      await tester.pump();
      expect(isDone(tester, 'Karotten'), isFalse);
    });

    testWidgets('survives paging and a reload', (tester) async {
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tester.tap(find.text('Karotten'));
      await tester.pump();

      await next(tester, 'Weiter zu Schritt 3');
      await tester.tap(find.byTooltip('Zurück zu Schritt 2'));
      await tester.pumpAndSettle();
      expect(isDone(tester, 'Karotten'), isTrue);

      // A reload: a new app with the same storage.
      await tester.pumpWidget(const SizedBox());
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      expect(isDone(tester, 'Karotten'), isTrue);
    });

    testWidgets('stays in memory when it can\'t be saved', (tester) async {
      localStore.refuseWrites = true;
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tester.tap(find.text('Karotten'));
      await tester.pump();

      // Step 1 has no ingredients, so step 2's rows are gone meanwhile.
      await tester.tap(find.byTooltip('Zurück zu Schritt 1'));
      await tester.pumpAndSettle();
      await next(tester, 'Weiter zu Schritt 2');

      expect(isDone(tester, 'Karotten'), isTrue);
      expect(localStore.values, isEmpty);
    });

    testWidgets('is per step', (tester) async {
      final step3 = ofenkarotten.steps[2].copyWith(
        ingredients: [
          ...ofenkarotten.steps[2].ingredients,
          ofenkarotten.steps[1].ingredients.first,
        ],
      );
      repository.recipes[7] = ofenkarotten.copyWith(
        steps: [ofenkarotten.steps[0], ofenkarotten.steps[1], step3],
      );
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tester.tap(find.text('Karotten'));
      await tester.pump();

      await next(tester, 'Weiter zu Schritt 3');
      expect(isDone(tester, 'Karotten'), isFalse);
    });

    testWidgets('is forgotten after Fertig', (tester) async {
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tester.tap(find.text('Karotten'));
      await tester.pump();
      await next(tester, 'Weiter zu Schritt 3');
      await tester.tap(find.text('Feta'));
      await tester.pump();

      await next(tester, 'Fertig gekocht');
      expect(localStore.values, isEmpty);

      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      expect(isDone(tester, 'Karotten'), isFalse);
    });

    testWidgets('is forgotten a day after the last change', (tester) async {
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tester.tap(find.text('Karotten'));
      await tester.pump();
      await tester.tap(find.byTooltip('Kochmodus beenden'));
      await tester.pumpAndSettle();

      now = now.add(const Duration(hours: 25));
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      expect(isDone(tester, 'Karotten'), isFalse);
      expect(localStore.values, isEmpty);
    });
  });

  group('timers', () {
    /// Step 2 roasts for 25 minutes, named like in mockup 07.
    void roastFor25Minutes() {
      repository.recipes[7] = ofenkarotten.copyWith(
        steps: [
          ofenkarotten.steps[0],
          ofenkarotten.steps[1].copyWith(
            name: 'Rösten',
            time: const Duration(minutes: 25),
          ),
          ofenkarotten.steps[2],
        ],
      );
    }

    /// Lets [seconds] pass on the clock and the tickers.
    Future<void> wait(WidgetTester tester, int seconds) async {
      for (var i = 0; i < seconds; i++) {
        now = now.add(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
      }
    }

    /// Taps [label] while timers tick, where pumpAndSettle never settles.
    Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
      await tester.tap(finder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    /// The chip whose screen-reader label starts with [label].
    Finder chip(String label) => find.byWidgetPredicate(
      (widget) =>
          widget is TimerChip && widget.semanticsLabel.startsWith(label),
    );

    testWidgets('start from the step\'s time; the chip counts down', (
      tester,
    ) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');

      await tapAndWait(tester, find.text('Timer starten · 25:00'));
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('Timer starten · 25:00'), findsNothing);
      // The first timer prepares the alerts: audio, notification prompt.
      expect(alerts.unlocks, 1);
      expect(alerts.permissionRequests, 1);

      await wait(tester, 3);
      expect(find.text('24:57'), findsOneWidget);
      expect(chip('Rösten, noch 24:57'), findsOneWidget);
    });

    testWidgets('phones are told once that timers need the app open', (
      tester,
    ) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');

      await tapAndWait(tester, find.text('Timer starten · 25:00'));
      expect(
        find.text('Timer melden sich nur, solange Yumdoor geöffnet ist.'),
        findsOneWidget,
      );
    });

    testWidgets('two timers run at once, also across steps', (tester) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tapAndWait(tester, find.text('Timer starten · 25:00'));
      await wait(tester, 60);

      await tapAndWait(tester, find.byTooltip('Timer stellen'));
      await tapAndWait(tester, find.byTooltip('Eine Minute mehr'));
      expect(find.text('6 Min'), findsOneWidget);
      await tapAndWait(tester, find.text('Starten'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('24:00'), findsOneWidget);
      expect(find.text('06:00'), findsOneWidget);
      await tapAndWait(tester, find.text('Weiter zu Schritt 3'));
      expect(chip('Rösten'), findsOneWidget);
      expect(chip('Timer'), findsOneWidget);
    });

    testWidgets('a finished timer alerts until it is turned off', (
      tester,
    ) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tapAndWait(tester, find.text('Timer starten · 25:00'));

      now = now.add(const Duration(minutes: 25));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('fertig'), findsOneWidget);
      expect(chip('Rösten ist fertig'), findsOneWidget);
      expect(alerts.chimes, 1);

      await wait(tester, 30);
      expect(alerts.chimes, 2);

      await tapAndWait(tester, find.text('fertig'));
      await tapAndWait(tester, find.text('Ausschalten'));
      expect(find.text('fertig'), findsNothing);
      expect(alerts.closes, 1);
      await wait(tester, 30);
      expect(alerts.chimes, 2);
      // The step can be timed again.
      expect(find.text('Timer starten · 25:00'), findsOneWidget);
    });

    testWidgets('pause, +1 min and delete from the sheet', (tester) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tapAndWait(tester, find.text('Timer starten · 25:00'));

      await tapAndWait(tester, find.text('25:00').first);
      await tapAndWait(tester, find.text('Anhalten'));
      await wait(tester, 10);
      expect(find.text('25:00'), findsWidgets);
      expect(chip('Rösten, angehalten bei 25:00'), findsOneWidget);

      await tapAndWait(tester, find.text('+1 Min'));
      await tapAndWait(tester, find.text('Fortsetzen'));
      await wait(tester, 1);
      expect(find.text('25:59'), findsWidgets);

      await tapAndWait(tester, find.text('Timer löschen'));
      expect(find.text('25:58'), findsNothing);
      expect(localStore.values.keys, isNot(contains('cooking-timers.7')));
    });

    testWidgets('timers survive paging and a reload', (tester) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tapAndWait(tester, find.text('Timer starten · 25:00'));

      // A reload two minutes later: a new app with the same storage.
      await tester.pumpWidget(const SizedBox());
      now = now.add(const Duration(minutes: 2));
      await pumpCooking(tester);

      expect(find.text('23:00'), findsOneWidget);
    });

    testWidgets('a timer still alerts after leaving with ×', (tester) async {
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tapAndWait(tester, find.text('Timer starten · 25:00'));
      await tapAndWait(tester, find.byTooltip('Kochmodus beenden'));
      expect(find.text('recipe screen'), findsOneWidget);

      now = now.add(const Duration(minutes: 25));
      await tester.pump(const Duration(seconds: 1));
      expect(alerts.chimes, 1);

      // Outside cooking mode it can't be turned off, so it alerts only once.
      await wait(tester, 60);
      expect(alerts.chimes, 1);
    });

    testWidgets('many steps and timers fit on a narrow phone', (tester) async {
      repository.recipes[7] = ofenkarotten.copyWith(
        steps: [
          for (var i = 0; i < 9; i++)
            ofenkarotten.steps[1].copyWith(
              id: 100 + i,
              name: 'Schmoren und Ablöschen',
              time: const Duration(minutes: 90),
            ),
        ],
      );
      alerts
        ..runsInBackground = true
        ..notificationAccess = NotificationAccess.granted;
      await pumpCooking(tester, size: const Size(360, 740));
      Future<void> startStepTimer() async {
        final button = find.text('Timer starten · 1:30:00');
        await tester.ensureVisible(button);
        await tapAndWait(tester, button);
      }

      await startStepTimer();
      await tapAndWait(tester, find.text('Weiter zu Schritt 2'));
      await startStepTimer();

      expect(tester.takeException(), isNull);
      expect(find.byType(TimerChip), findsNWidgets(2));
    });

    testWidgets('Fertig forgets the timers', (tester) async {
      // A desktop: no hint over the buttons.
      alerts
        ..runsInBackground = true
        ..notificationAccess = NotificationAccess.granted;
      roastFor25Minutes();
      await pumpCooking(tester);
      await next(tester, 'Weiter zu Schritt 2');
      await tapAndWait(tester, find.text('Timer starten · 25:00'));
      await tapAndWait(tester, find.text('Weiter zu Schritt 3'));

      await tapAndWait(tester, find.text('Fertig gekocht'));

      expect(localStore.values.keys, isNot(contains('cooking-timers.7')));
    });

    group('from durations in the step text', () {
      /// Step 2 with [instruction], no explicit time and no name.
      void step2(String instruction, {Duration time = Duration.zero}) {
        repository.recipes[7] = ofenkarotten.copyWith(
          steps: [
            ofenkarotten.steps[0],
            ofenkarotten.steps[1].copyWith(
              instruction: instruction,
              time: time,
            ),
            ofenkarotten.steps[2],
          ],
        );
      }

      Finder highlight(String phrase) => find.byWidgetPredicate(
        (widget) => widget is TimerHighlight && widget.text == phrase,
      );

      testWidgets('a tap on a highlight starts a timer named after the step', (
        tester,
      ) async {
        step2('Erst 5 Minuten anbraten, dann 20–25 Minuten köcheln.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');
        expect(highlight('5 Minuten'), findsOneWidget);
        expect(highlight('20–25 Minuten'), findsOneWidget);
        expect(
          find.bySemanticsLabel('20–25 Minuten, Timer starten'),
          findsOneWidget,
        );
        expect(
          tester.getSemantics(
            find.bySemanticsLabel('20–25 Minuten, Timer starten'),
          ),
          isSemantics(isButton: true, hasTapAction: true),
        );

        await tapAndWait(tester, highlight('20–25 Minuten'));
        expect(chip('Schritt 2, noch 25:00'), findsOneWidget);

        await wait(tester, 2);
        expect(chip('Schritt 2, noch 24:58'), findsOneWidget);
        await tapAndWait(tester, highlight('5 Minuten'));
        expect(chip('Schritt 2, noch 05:00'), findsOneWidget);
        expect(find.byType(TimerChip), findsNWidgets(2));
      });

      testWidgets('a double tap starts one timer', (tester) async {
        step2('25 Minuten rösten.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        await tester.tap(highlight('25 Minuten'));
        await tester.pump(const Duration(milliseconds: 100));
        await tapAndWait(tester, highlight('25 Minuten'));

        expect(find.byType(TimerChip), findsOneWidget);
      });

      testWidgets('the same length twice in a step starts two timers', (
        tester,
      ) async {
        step2('10 Minuten anbraten, dann weitere 10 Minuten köcheln.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        await tapAndWait(tester, highlight('10 Minuten').first);
        await tapAndWait(tester, highlight('10 Minuten').last);

        expect(find.byType(TimerChip), findsNWidgets(2));
        // The button's timer is set.
        expect(find.text('Timer starten · 10:00'), findsNothing);
      });

      testWidgets('after +1 min, the button still knows its timer', (
        tester,
      ) async {
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');
        await tapAndWait(tester, find.text('Timer starten · 25:00'));
        await tapAndWait(tester, chip('Schritt 2'));
        await tapAndWait(tester, find.text('+1 Min'));
        // Closes the sheet.
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Anhalten'), findsNothing);

        expect(find.text('Timer starten · 25:00'), findsNothing);
      });

      testWidgets('a highlight keeps the button for the step\'s own time', (
        tester,
      ) async {
        step2(
          'Erst 5 Minuten anbraten, dann köcheln.',
          time: const Duration(minutes: 15),
        );
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        await tapAndWait(tester, highlight('5 Minuten'));
        expect(chip('Schritt 2, noch 05:00'), findsOneWidget);
        expect(find.text('Timer starten · 15:00'), findsOneWidget);
      });

      testWidgets('link text starts no timer', (tester) async {
        step2('Wie im [Video 10 min](https://example.com/) köcheln.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        expect(find.byType(TimerHighlight), findsNothing);
        expect(find.textContaining('Timer starten'), findsNothing);
      });

      testWidgets('Timer starten uses the first duration without a time', (
        tester,
      ) async {
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');
        // The fixture: "… mischen und 25 Minuten rösten."
        expect(highlight('25 Minuten'), findsOneWidget);

        await tapAndWait(tester, find.text('Timer starten · 25:00'));
        expect(chip('Schritt 2, noch 25:00'), findsOneWidget);
        expect(find.text('Timer starten · 25:00'), findsNothing);
      });

      testWidgets('the step\'s own time wins for Timer starten', (
        tester,
      ) async {
        step2('10 Minuten ruhen lassen.', time: const Duration(minutes: 15));
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        expect(find.text('Timer starten · 15:00'), findsOneWidget);
        expect(highlight('10 Minuten'), findsOneWidget);
      });

      testWidgets('text without a duration has no highlight or button', (
        tester,
      ) async {
        step2('Im Ofen bei 200 °C backen, wie in Schritt 1.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        expect(find.byType(TimerHighlight), findsNothing);
        expect(find.textContaining('Timer starten'), findsNothing);
      });

      testWidgets('highlights sit next to templates', (tester) async {
        step2('{{ ingredients[0] }} 1 Stunde 20 Minuten im Ofen garen.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');

        expect(find.textContaining('600 g Karotten'), findsOneWidget);
        expect(highlight('1 Stunde 20 Minuten'), findsOneWidget);
        expect(find.text('Timer starten · 1:20:00'), findsOneWidget);
      });

      testWidgets('highlights scale with the text, once', (tester) async {
        step2('25 Minuten rösten.');
        await pumpCooking(tester);
        await next(tester, 'Weiter zu Schritt 2');
        final normal = tester.getRect(highlight('25 Minuten')).height;

        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpAndSettle();

        expect(
          tester.getRect(highlight('25 Minuten')).height,
          moreOrLessEquals(normal * 1.3, epsilon: 1),
        );
      });
    });
  });

  testWidgets('a recipe without steps says so', (tester) async {
    repository.recipes[7] = ofenkarotten.copyWith(steps: []);
    await pumpCooking(tester);

    expect(find.text('Dieses Rezept hat keine Schritte.'), findsOneWidget);
    expect(find.byTooltip('Kochmodus beenden'), findsOneWidget);
  });

  testWidgets('long German step text fits at 390 px', (tester) async {
    repository.recipes[8] = longNames;
    await pumpRoutes(
      tester,
      location: '/cook',
      overrides: [
        recipeRepositoryProvider.overrideWithValue(repository),
        wakeLockServiceProvider.overrideWithValue(wakeLock),
      ],
      routes: [
        GoRoute(
          path: '/cook',
          builder: (context, state) =>
              const CookingScreen(recipeId: 8, servings: 12),
        ),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(find.text('für 12 Portionen'), findsOneWidget);
    expect(find.text('3.703,5 Vakuumpackungen à 500 Gramm'), findsNothing);
    expect(find.text('3.704 Vakuumpackungen à 500 Gramm'), findsOneWidget);
  });

  group('layout', () {
    for (final size in [phoneSize, landscapeSize, tabletSize]) {
      testWidgets(
        'step 2 fits at ${size.width.round()}×${size.height.round()}',
        (tester) async {
          await pumpCooking(tester, size: size);
          await next(tester, 'Weiter zu Schritt 2');

          expect(tester.takeException(), isNull);
          expect(find.textContaining('Karotten schräg'), findsOneWidget);
          expect(find.text('Karotten'), findsOneWidget);
          final step = tester.getTopLeft(
            find.textContaining('Karotten schräg'),
          );
          final ingredient = tester.getTopLeft(find.text('Karotten'));
          if (size.width >= YumdoorTokens.light.sizeWide) {
            // Side by side: the ingredients right of the step, not below it.
            expect(ingredient.dx, greaterThan(step.dx + size.width / 3));
          } else {
            expect(ingredient.dy, greaterThan(step.dy));
            expect(find.text('Alle'), findsNothing);
          }
        },
      );
    }

    testWidgets('wide: all ingredients from a toggle, still tickable', (
      tester,
    ) async {
      await pumpCooking(tester, size: tabletSize);
      await next(tester, 'Weiter zu Schritt 2');
      expect(find.text('Feta'), findsNothing);

      await tester.tap(find.text('Alle'));
      await tester.pumpAndSettle();
      expect(find.text('Feta'), findsOneWidget);
      expect(find.text('SCHRITT 3 · ANRICHTEN'), findsOneWidget);
      await tester.tap(find.text('Feta'));
      await tester.pump();

      // The choice stays while paging; the tick belongs to step 3.
      await next(tester, 'Weiter zu Schritt 3');
      expect(find.text('Karotten'), findsOneWidget);
      await tester.tap(find.text('Dieser Schritt'));
      await tester.pumpAndSettle();
      expect(find.text('Karotten'), findsNothing);
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Feta abhaken'))
            .getSemanticsData()
            .flagsCollection
            .isChecked,
        CheckedState.isTrue,
      );
    });

    testWidgets('wide: the chips are one exclusive choice', (tester) async {
      await pumpCooking(tester, size: tabletSize);

      final data = tester
          .getSemantics(find.bySemanticsLabel('Dieser Schritt'))
          .getSemanticsData();
      expect(data.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(data.flagsCollection.isSelected, Tristate.isTrue);
      // Announced as a radio button only with a checked state.
      expect(data.flagsCollection.isChecked, CheckedState.isTrue);
    });

    testWidgets('wide "Alle" titles a single group with its step', (
      tester,
    ) async {
      repository.recipes[7] = ofenkarotten.copyWith(
        steps: [
          ofenkarotten.steps[0],
          ofenkarotten.steps[1],
          ofenkarotten.steps[2].copyWith(ingredients: []),
        ],
      );
      await pumpCooking(tester, size: tabletSize);
      await next(tester, 'Weiter zu Schritt 2');
      await next(tester, 'Weiter zu Schritt 3');
      await tester.tap(find.text('Alle'));
      await tester.pumpAndSettle();

      expect(find.text('SCHRITT 2'), findsWidgets);
      expect(find.text('Karotten'), findsOneWidget);
    });

    testWidgets('notches count: narrow inside the safe area', (tester) async {
      tester.view.padding = const FakeViewPadding(left: 60, right: 60);
      addTearDown(tester.view.resetPadding);
      await pumpCooking(tester, size: const Size(800, 390));
      await next(tester, 'Weiter zu Schritt 2');

      expect(find.text('Alle'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a tablet in portrait is wide', (tester) async {
      await pumpCooking(tester, size: const Size(768, 1024));

      expect(find.text('Alle'), findsOneWidget);
    });

    testWidgets('wide: a step without ingredients says so', (tester) async {
      await pumpCooking(tester, size: tabletSize);

      expect(
        find.text('Für diesen Schritt brauchst du keine Zutaten.'),
        findsOneWidget,
      );
    });
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('mockup 05: a running timer in $name', tags: goldenTags, (
        tester,
      ) async {
        repository.recipes[7] = ofenkarotten.copyWith(
          steps: [
            ofenkarotten.steps[0].copyWith(
              name: 'Ofen',
              time: const Duration(minutes: 10),
            ),
            ofenkarotten.steps[1].copyWith(time: const Duration(minutes: 25)),
            ofenkarotten.steps[2],
          ],
        );
        alerts
          ..runsInBackground = true
          ..notificationAccess = NotificationAccess.granted;
        await pumpCooking(tester, theme: theme);
        await tester.tap(find.text('Timer starten · 10:00'));
        await tester.pump();
        now = now.add(const Duration(minutes: 5, seconds: 48));
        await tester.tap(find.text('Weiter zu Schritt 2'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('Karotten'));
        await tester.pump();

        await expectLater(
          find.byType(CookingScreen),
          matchesGoldenFile('../goldens/cooking_timer_running_$name.png'),
        );
      });

      testWidgets('mockup 07: a finished timer in $name', tags: goldenTags, (
        tester,
      ) async {
        repository.recipes[7] = ofenkarotten.copyWith(
          steps: [
            ofenkarotten.steps[0],
            ofenkarotten.steps[1].copyWith(
              name: 'Rösten',
              time: const Duration(minutes: 25),
            ),
            ofenkarotten.steps[2],
          ],
        );
        alerts
          ..runsInBackground = true
          ..notificationAccess = NotificationAccess.granted;
        await pumpCooking(tester, theme: theme);
        await next(tester, 'Weiter zu Schritt 2');
        await tester.tap(find.text('Timer starten · 25:00'));
        await tester.pump();
        now = now.add(const Duration(minutes: 25));
        await tester.tap(find.text('Weiter zu Schritt 3'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('Feta'));
        await tester.pump();

        await expectLater(
          find.byType(CookingScreen),
          matchesGoldenFile('../goldens/cooking_timer_finished_$name.png'),
        );
      });

      testWidgets('step 2 on a tablet in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpCooking(tester, theme: theme, size: tabletSize);
        await next(tester, 'Weiter zu Schritt 2');
        await tester.tap(find.text('Karotten'));
        await tester.pump();

        await expectLater(
          find.byType(CookingScreen),
          matchesGoldenFile('../goldens/cooking_step_tablet_$name.png'),
        );
      });

      testWidgets('step 2 in landscape in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpCooking(tester, theme: theme, size: landscapeSize);
        await next(tester, 'Weiter zu Schritt 2');

        await expectLater(
          find.byType(CookingScreen),
          matchesGoldenFile('../goldens/cooking_step_landscape_$name.png'),
        );
      });

      testWidgets('step 2 at 4 servings in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpCooking(tester, theme: theme);
        await next(tester, 'Weiter zu Schritt 2');
        // As in the mockup: the first ingredient is already in the pot.
        await tester.tap(find.text('Karotten'));
        await tester.pump();

        await expectLater(
          find.byType(CookingScreen),
          matchesGoldenFile('../goldens/cooking_step_$name.png'),
        );
      });
    }
  });
}

/// Pushes [location] without awaiting the route's result.
void unawaitedPush(GoRouter router, String location) {
  router.push<void>(location).ignore();
}
