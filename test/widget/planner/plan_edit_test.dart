import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/calendar_day.dart';
import 'package:yumdoor/domain/models/meal_plan.dart';
import 'package:yumdoor/domain/models/meal_type.dart';
import 'package:yumdoor/domain/models/recipe_summary.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/features/planner/plan_actions.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_book_user_repositories.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_meal_plan_repository.dart';
import '../../fakes/fake_meal_type_repository.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

const _lunch = MealType(id: 2, name: 'Mittagessen', order: 1);
const _dinner = MealType(id: 3, name: 'Abendessen', order: 2);

MealPlan _plan(
  int id,
  int day,
  MealType type, {
  String? recipe,
  String title = '',
  double servings = 4,
  int? toDay,
  bool onShoppingList = false,
}) => MealPlan(
  id: id,
  recipe: recipe == null ? null : RecipeSummary(id: id + 100, name: recipe),
  title: title,
  servings: servings,
  fromDay: CalendarDay(2026, 11, day),
  toDay: CalendarDay(2026, 11, toDay ?? day),
  mealType: type,
  onShoppingList: onShoppingList,
  createdBy: 1,
);

/// The German short weekdays, Monday the 16th to Sunday the 22nd.
const _weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

void main() {
  setUpAll(loadBundledFonts);

  /// Wednesday; the week runs from Monday the 16th to Sunday the 22nd.
  final now = DateTime(2026, 11, 18, 12);

  late FakeMealPlanRepository repository;
  late FakeConnectivityService connectivity;

  setUp(() {
    repository = FakeMealPlanRepository([
      _plan(1, 16, _dinner, recipe: 'Linsen-Bolognese'),
      _plan(2, 18, _dinner, recipe: 'Ofenkarotten', onShoppingList: true),
      _plan(3, 20, _lunch, title: 'Reste', toDay: 21),
    ]);
    connectivity = FakeConnectivityService();
  });

  Future<void> pumpPlanner(WidgetTester tester, {ThemeData? theme}) =>
      pumpRoutes(
        tester,
        location: '/plan',
        // Tall enough for the week and the shopping card under it.
        size: const Size(390, 1000),
        theme: theme,
        overrides: [
          ...appOverrides(
            mealPlans: repository,
            mealTypes: FakeMealTypeRepository([_lunch, _dinner]),
            users: FakeUserRepository(const [UserRef(id: 1, name: 'Anna')]),
            connectivity: connectivity,
          ),
          clockProvider.overrideWithValue(() => now),
        ],
        routes: [tabsRoute()],
      );

  /// The weekday whose row shows [finder] (its first match).
  String dayOf(WidgetTester tester, Finder finder) {
    final y = tester.getCenter(finder.first).dy;
    var day = _weekdays.first;
    for (final weekday in _weekdays) {
      // Rows scrolled far away aren't built.
      if (find.text(weekday).evaluate().isEmpty) continue;
      // The labels sit at the top of their rows.
      if (tester.getTopLeft(find.text(weekday)).dy <= y) day = weekday;
    }
    return day;
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester, String meal) =>
      tap(tester, find.byTooltip('Optionen für $meal').first);

  /// Long-presses [meal] and drags it onto the row of [weekday]; returns the
  /// gesture, still down.
  Future<TestGesture> dragTo(
    WidgetTester tester,
    String meal,
    String weekday, {
    bool longPress = true,
  }) async {
    final gesture = await tester.startGesture(
      tester.getCenter(find.text(meal).last),
      kind: longPress ? PointerDeviceKind.touch : PointerDeviceKind.mouse,
    );
    if (longPress) await tester.pump(kLongPressTimeout * 2);
    final target = tester.getCenter(find.text(weekday));
    // In steps, as a finger would.
    await gesture.moveTo(target.translate(0, -20));
    await tester.pump();
    await gesture.moveTo(target);
    await tester.pump();
    return gesture;
  }

  ButtonStyleButton button(WidgetTester tester, String label) => tester.widget(
    find.ancestor(
      of: find.text(label),
      matching: find.bySubtype<ButtonStyleButton>(),
    ),
  );

  group('drag and drop', () {
    testWidgets('moves a meal to another day', (tester) async {
      await pumpPlanner(tester);
      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Mo');

      final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Di');
      expect(find.text('Hier ablegen'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('Hier ablegen'), findsNothing);
      expect(repository.updates.single.id, 1);
      expect(
        repository.updates.single.changes,
        MealPlanChanges(day: CalendarDay(2026, 11, 17)),
      );
      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Di');
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows the move at once and reverts it if saving fails', (
      tester,
    ) async {
      final gate = repository.gate = Completer<void>();
      repository.updateFailure = const ServerFailure(statusCode: 500);
      await pumpPlanner(tester);

      final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Do');
      await gesture.up();
      await tester.pump();
      await tester.pump();
      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Do');

      gate.complete();
      await tester.pumpAndSettle();

      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Mo');
      expect(find.textContaining('Nicht verschoben.'), findsOneWidget);
    });

    testWidgets('a plan of several days keeps its length', (tester) async {
      await pumpPlanner(tester);

      // Picked up on its second day, Saturday, and dropped on Sunday.
      final gesture = await dragTo(tester, 'Reste', 'So');
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        repository.updates.single.changes,
        MealPlanChanges(day: CalendarDay(2026, 11, 21)),
      );
      expect(find.text('Reste'), findsNWidgets(2));
      expect(dayOf(tester, find.text('Reste').first), 'Sa');
      expect(dayOf(tester, find.text('Reste').last), 'So');
    });

    testWidgets('dropping on the same day does nothing', (tester) async {
      await pumpPlanner(tester);

      final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Mo');
      expect(find.text('Hier ablegen'), findsNothing);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(repository.updates, isEmpty);
    });

    testWidgets('the day under the meal keeps its height', (tester) async {
      await pumpPlanner(tester);
      final before = tester.getTopLeft(find.text('So')).dy;

      // Wednesday has a meal; "Hier ablegen" covers it.
      final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Mi');
      expect(find.text('Hier ablegen'), findsOneWidget);
      expect(tester.getTopLeft(find.text('So')).dy, before);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('scrolls while the meal is held at the bottom edge', (
      tester,
    ) async {
      for (var id = 20; id < 26; id++) {
        repository.plans.add(_plan(id, 17, _dinner, title: 'Gericht $id'));
      }
      await pumpPlanner(tester);
      final list = find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      );
      ScrollPosition position() =>
          tester.state<ScrollableState>(list.first).position;
      expect(position().pixels, 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Linsen-Bolognese')),
      );
      await tester.pump(kLongPressTimeout * 2);
      final bottom = tester.getRect(list.first).bottomCenter;
      await gesture.moveTo(bottom.translate(0, -30));
      await gesture.moveTo(bottom.translate(0, -10));
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(position().pixels, greaterThan(0));
      // The day under the still pointer now, not the one before scrolling.
      final under = dayOf(tester, find.text('Hier ablegen'));
      expect(under, isIn(['Fr', 'Sa', 'So']));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(dayOf(tester, find.text('Linsen-Bolognese')), under);
      // It stopped with the drag.
      final stopped = position().pixels;
      await tester.pump(const Duration(milliseconds: 200));
      expect(position().pixels, stopped);
    });

    testWidgets('with a mouse, dragging starts right away', (tester) async {
      await pumpPlanner(tester);

      final gesture = await dragTo(
        tester,
        'Linsen-Bolognese',
        'Di',
        longPress: false,
      );
      await gesture.up();
      await tester.pumpAndSettle();

      expect(repository.updates.single.changes.day, CalendarDay(2026, 11, 17));
    });

    testWidgets('a mouse click that wobbles a little doesn\'t drag', (
      tester,
    ) async {
      await pumpPlanner(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Linsen-Bolognese')),
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveBy(const Offset(3, 2));
      await tester.pump();
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(repository.updates, isEmpty);
    });

    testWidgets('a finger swipe scrolls, also on a desktop platform', (
      tester,
    ) async {
      // A laptop with a touch screen.
      await pumpPlanner(
        tester,
        theme: lightTheme.copyWith(platform: TargetPlatform.windows),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Linsen-Bolognese')),
      );
      await gesture.moveTo(tester.getCenter(find.text('Di')));
      await tester.pump();
      expect(find.text('Hier ablegen'), findsNothing);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(repository.updates, isEmpty);
    });

    testWidgets('a meal being moved can\'t be changed again meanwhile', (
      tester,
    ) async {
      final gate = repository.gate = Completer<void>();
      await pumpPlanner(tester);

      final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Di');
      await gesture.up();
      await tester.pump();
      await tester.pump();

      final menu = tester.widget<PopupMenuButton<Object?>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuButton &&
              widget.tooltip == 'Optionen für Linsen-Bolognese',
        ),
      );
      expect(menu.enabled, isFalse);
      final again = await dragTo(tester, 'Linsen-Bolognese', 'Mi');
      expect(find.text('Hier ablegen'), findsNothing);
      await again.up();

      gate.complete();
      await tester.pumpAndSettle();
      expect(repository.updates, hasLength(1));
      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Di');
    });
  });

  testWidgets('"Verschieben" in the menu picks another day', (tester) async {
    await pumpPlanner(tester);

    await openMenu(tester, 'Linsen-Bolognese');
    await tap(tester, find.text('Verschieben'));
    expect(find.byType(MovePlanSheet), findsOneWidget);
    // The day it is on can't be chosen again.
    expect(
      button(tester, 'Auf Montag, 16. Nov. verschieben').onPressed,
      isNull,
    );

    await tap(
      tester,
      find.descendant(
        of: find.byType(MovePlanSheet),
        matching: find.text('19'),
      ),
    );
    await tap(tester, find.text('Auf Donnerstag, 19. Nov. verschieben'));

    expect(find.byType(MovePlanSheet), findsNothing);
    expect(
      repository.updates.single.changes,
      MealPlanChanges(day: CalendarDay(2026, 11, 19)),
    );
    expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Do');
    expect(find.text('Auf Donnerstag, 19. Nov. verschoben.'), findsOneWidget);
  });

  group('edit', () {
    testWidgets('changes the servings', (tester) async {
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      expect(find.byType(EditPlanSheet), findsOneWidget);
      expect(find.text('Mahlzeit bearbeiten'), findsOneWidget);
      // Nothing changed yet.
      expect(button(tester, 'Speichern').onPressed, isNull);
      // Not on the shopping list.
      expect(find.textContaining('Einkaufsliste'), findsNothing);

      await tap(tester, find.byTooltip('Mehr Portionen'));
      await tap(tester, find.text('Speichern'));

      expect(find.byType(EditPlanSheet), findsNothing);
      expect(repository.updates.single.id, 1);
      expect(repository.updates.single.changes, MealPlanChanges(servings: 5));
      expect(find.text('Gespeichert.'), findsOneWidget);
      expect(find.text('Abendessen · 5 Port.'), findsOneWidget);
    });

    testWidgets('changes the meal type and the day', (tester) async {
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      await tap(
        tester,
        find.descendant(
          of: find.byType(EditPlanSheet),
          matching: find.text('Mittagessen'),
        ),
      );
      await tap(
        tester,
        find.descendant(
          of: find.byType(EditPlanSheet),
          matching: find.text('17'),
        ),
      );
      await tap(tester, find.text('Speichern'));

      expect(
        repository.updates.single.changes,
        MealPlanChanges(day: CalendarDay(2026, 11, 17), mealType: _lunch),
      );
      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Di');
    });

    testWidgets('says that the shopping list follows the servings', (
      tester,
    ) async {
      await pumpPlanner(tester);

      await openMenu(tester, 'Ofenkarotten');
      await tap(tester, find.text('Bearbeiten'));

      expect(
        find.text(
          'Steht auf der Einkaufsliste. Änderst du die Portionen, passen '
          'sich die Mengen dort an.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('servings with decimals step to whole numbers', (tester) async {
      repository.plans[0] = repository.plans[0].copyWith(servings: 2.5);
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      expect(
        find.descendant(
          of: find.byType(EditPlanSheet),
          matching: find.text('2,5'),
        ),
        findsOneWidget,
      );
      await tap(tester, find.byTooltip('Mehr Portionen'));
      expect(find.text('3'), findsOneWidget);
      await tap(tester, find.byTooltip('Weniger Portionen'));
      await tap(tester, find.byTooltip('Weniger Portionen'));
      expect(find.text('1'), findsOneWidget);
      await tap(tester, find.byTooltip('Mehr Portionen'));
      await tap(tester, find.text('Speichern'));

      expect(repository.updates.single.changes, MealPlanChanges(servings: 2));
    });

    testWidgets('1,5 servings can go down to 1', (tester) async {
      repository.plans[0] = repository.plans[0].copyWith(servings: 1.5);
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      await tap(tester, find.byTooltip('Weniger Portionen'));
      await tap(tester, find.text('Speichern'));

      expect(repository.updates.single.changes, MealPlanChanges(servings: 1));
    });

    testWidgets('servings with decimals stay unless changed', (tester) async {
      repository.plans[0] = repository.plans[0].copyWith(servings: 2.5);
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      await tap(
        tester,
        find.descendant(
          of: find.byType(EditPlanSheet),
          matching: find.text('Mittagessen'),
        ),
      );
      await tap(tester, find.text('Speichern'));

      expect(
        repository.updates.single.changes,
        MealPlanChanges(mealType: _lunch),
      );
    });

    testWidgets('a failed save keeps the sheet open', (tester) async {
      repository.updateFailure = const ServerFailure(statusCode: 500);
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      await tap(tester, find.byTooltip('Mehr Portionen'));
      await tap(tester, find.text('Speichern'));

      expect(find.byType(EditPlanSheet), findsOneWidget);
      expect(find.textContaining('Nicht gespeichert.'), findsOneWidget);
    });
  });

  group('delete', () {
    testWidgets('asks first, and keeps the meal if not confirmed', (
      tester,
    ) async {
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Löschen'));
      expect(find.text('Mahlzeit löschen?'), findsOneWidget);
      expect(
        find.text(
          '„Linsen-Bolognese“ wird für alle im Haushalt aus dem Plan '
          'gelöscht.',
        ),
        findsOneWidget,
      );

      await tap(tester, find.text('Behalten'));
      expect(repository.deleted, isEmpty);
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
    });

    testWidgets('deletes once confirmed', (tester) async {
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Löschen'));
      await tap(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Löschen'),
        ),
      );

      expect(repository.deleted, [1]);
      expect(find.text('Linsen-Bolognese'), findsNothing);
      expect(find.text('Aus dem Plan gelöscht.'), findsOneWidget);
    });

    testWidgets('says that the shopping list entries go too', (tester) async {
      await pumpPlanner(tester);

      await openMenu(tester, 'Ofenkarotten');
      await tap(tester, find.text('Löschen'));

      expect(
        find.textContaining('seine Zutaten verschwinden von der Einkaufsliste'),
        findsOneWidget,
      );
    });

    testWidgets('a failure says so and keeps the meal', (tester) async {
      repository.deleteFailure = const ServerFailure(statusCode: 500);
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Löschen'));
      await tap(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Löschen'),
        ),
      );

      expect(find.textContaining('Nicht gelöscht.'), findsOneWidget);
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
    });

    testWidgets('a meal deleted elsewhere meanwhile counts as deleted', (
      tester,
    ) async {
      await pumpPlanner(tester);
      // Someone else in the household deleted it.
      repository.plans.removeWhere((plan) => plan.id == 1);
      repository.deleteFailure = const NotFoundFailure();

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Löschen'));
      await tap(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Löschen'),
        ),
      );

      expect(find.text('Linsen-Bolognese'), findsNothing);
      expect(find.text('Aus dem Plan gelöscht.'), findsOneWidget);
    });

    testWidgets('hides the meal at once, back if deleting fails', (
      tester,
    ) async {
      final gate = repository.gate = Completer<void>();
      repository.deleteFailure = const ServerFailure(statusCode: 500);
      await pumpPlanner(tester);

      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Löschen'));
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Löschen'),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Linsen-Bolognese'), findsNothing);

      gate.complete();
      await tester.pumpAndSettle();
      expect(find.text('Linsen-Bolognese'), findsOneWidget);
      expect(find.textContaining('Nicht gelöscht.'), findsOneWidget);
    });
  });

  group('offline', () {
    testWidgets('dragging and the menu are disabled', (tester) async {
      connectivity.isOnline = false;
      await pumpPlanner(tester);

      final menu = tester.widget<PopupMenuButton<Object?>>(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuButton &&
              widget.tooltip == 'Optionen für Linsen-Bolognese',
        ),
      );
      expect(menu.enabled, isFalse);
      // The reason, on tap.
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Tooltip &&
              (widget.message?.startsWith('Offline kannst du nichts') ?? false),
        ),
        findsWidgets,
      );

      final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Di');
      expect(find.text('Hier ablegen'), findsNothing);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(repository.updates, isEmpty);
      expect(dayOf(tester, find.text('Linsen-Bolognese')), 'Mo');
      // The long press says why.
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.textContaining('Offline kannst du nichts ändern.'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('saving an edit is disabled with an explanation', (
      tester,
    ) async {
      await pumpPlanner(tester);
      await openMenu(tester, 'Linsen-Bolognese');
      await tap(tester, find.text('Bearbeiten'));
      await tap(tester, find.byTooltip('Mehr Portionen'));

      connectivity.isOnline = false;
      await tester.pumpAndSettle();

      expect(button(tester, 'Speichern').onPressed, isNull);
      expect(
        find.descendant(
          of: find.byType(EditPlanSheet),
          matching: find.textContaining('Offline kannst du nichts ändern.'),
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('long names and large text fit at 390 px', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    repository.plans.add(
      _plan(
        9,
        17,
        _dinner,
        recipe: 'Ofengemüse mit Kichererbsen und Joghurt-Tahini-Soße',
      ),
    );
    await pumpPlanner(tester);
    expect(tester.takeException(), isNull);

    await openMenu(
      tester,
      'Ofengemüse mit Kichererbsen und Joghurt-Tahini-Soße',
    );
    await tap(tester, find.text('Bearbeiten'));
    expect(tester.takeException(), isNull);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('dragging in $name', tags: goldenTags, (tester) async {
        await pumpPlanner(tester, theme: theme);
        final gesture = await dragTo(tester, 'Linsen-Bolognese', 'Di');

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/planner_drag_$name.png'),
        );
        await gesture.up();
        await tester.pumpAndSettle();
      });

      testWidgets('edit sheet in $name', tags: goldenTags, (tester) async {
        await pumpPlanner(tester, theme: theme);
        await openMenu(tester, 'Ofenkarotten');
        await tap(tester, find.text('Bearbeiten'));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/plan_edit_sheet_$name.png'),
        );
      });
    }
  });
}
