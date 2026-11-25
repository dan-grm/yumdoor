import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/shopping.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_book_user_repositories.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_ingredient_parser.dart';
import '../../fakes/fake_shopping_repository.dart';
import '../../fixtures/shopping.dart';
import '../fonts.dart';
import '../harness.dart';

void main() {
  setUpAll(loadBundledFonts);

  late FakeShoppingRepository repository;
  late FakeFoodRepository foods;
  late FakeIngredientParser parser;

  setUp(() {
    repository = FakeShoppingRepository(entries: mockupShoppingList());
    foods = FakeFoodRepository(const [
      Food(id: 1, name: 'Karotte'),
      Food(id: 20, name: 'Zitrone'),
    ]);
    parser = FakeIngredientParser({
      '2 Zitronen': const ParsedIngredient(
        originalText: '2 Zitronen',
        food: NamedRef(id: 20, name: 'Zitrone'),
        amount: 2,
      ),
    });
  });

  Future<void> pumpList(
    WidgetTester tester, {
    FakeConnectivityService? connectivity,
  }) => pumpRoutes(
    tester,
    location: '/shopping',
    size: const Size(390, 1400),
    overrides: [
      ...appOverrides(
        shopping: repository,
        foods: foods,
        ingredientParser: parser,
        connectivity: connectivity,
        tokenStore: loggedInTokenStore(),
        users: FakeUserRepository(const [anna, lena], anna.id),
      ),
      clockProvider.overrideWithValue(() => DateTime(2026, 11, 18, 12)),
    ],
    routes: [tabsRoute()],
  );

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
  }

  Future<void> openActions(WidgetTester tester, String name) async {
    await tester.tap(find.byTooltip('Mehr zu $name'));
    await tester.pumpAndSettle();
  }

  testWidgets('adds a typed line parsed by Tandoor', (tester) async {
    await pumpList(tester);

    await type(tester, '2 Zitronen');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(parser.parsed, ['2 Zitronen']);
    expect(repository.addedItems.single, (
      foodId: 20,
      amount: 2.0,
      unitId: null,
    ));
    expect(find.text('2 Zitronen auf die Liste gesetzt'), findsOneWidget);
    expect(find.text('Food 20'), findsOneWidget);
    // The field is empty again.
    expect(find.text('Artikel hinzufügen'), findsOneWidget);
  });

  testWidgets('suggests foods while typing', (tester) async {
    await pumpList(tester);

    await type(tester, '2 Zitr');
    expect(find.text('Zitrone'), findsOneWidget);
    await tester.tap(find.text('Zitrone'));
    await tester.pumpAndSettle();

    expect(find.text('2 Zitrone'), findsOneWidget);
    // Nothing is parsed while typing.
    expect(parser.parsed, isEmpty);
  });

  testWidgets('a line without a food says so and keeps the text', (
    tester,
  ) async {
    await pumpList(tester);

    await type(tester, 'blabla');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.textContaining('habe ich nicht verstanden'), findsOneWidget);
    expect(repository.addedItems, isEmpty);
    expect(find.text('blabla'), findsOneWidget);
  });

  testWidgets('a failed add says why', (tester) async {
    repository.editFailure = const OfflineFailure();
    await pumpList(tester);

    await type(tester, '2 Zitronen');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.textContaining('Nicht hinzugefügt.'), findsOneWidget);
    expect(find.text('2 Zitronen'), findsOneWidget);
  });

  testWidgets('"Habe ich da" marks the food on hand and checks the row off', (
    tester,
  ) async {
    await pumpList(tester);

    await openActions(tester, 'Karotten');
    await tester.tap(find.text('Habe ich da'));
    await tester.pumpAndSettle();

    expect(foods.foods[0].onHand, isTrue);
    expect(repository.checkCalls.single.ids, {101, 102});
    expect(repository.checkCalls.single.checked, isTrue);
    expect(find.text('Karotten ist als vorrätig markiert'), findsOneWidget);
    expect(find.text('Erledigt · 4'), findsOneWidget);
  });

  testWidgets('deleting a row removes its entries, undo brings them back', (
    tester,
  ) async {
    repository.foods[1] = const ShoppingFood(
      id: 1,
      name: 'Karotte',
      pluralName: 'Karotten',
      category: produce,
    );
    await pumpList(tester);

    await openActions(tester, 'Karotten');
    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, unorderedEquals([101, 102]));
    expect(find.text('Karotten'), findsNothing);
    expect(find.text('Karotten gelöscht'), findsOneWidget);

    await tester.tap(find.text('Rückgängig'));
    await tester.pumpAndSettle();

    expect(repository.addedItems.map((i) => i.foodId), [1, 1]);
    expect(find.text('Karotten'), findsOneWidget);
  });

  testWidgets('a long press selects rows, which are deleted together', (
    tester,
  ) async {
    await pumpList(tester);

    await tester.longPress(find.text('Karotten'));
    await tester.pumpAndSettle();
    expect(find.text('1 ausgewählt'), findsOneWidget);
    expect(find.text('Einkaufsliste'), findsNothing);
    // The rows' own actions are away while selecting.
    expect(find.byTooltip('Mehr zu Feta'), findsNothing);

    // A tap selects instead of checking off.
    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();
    expect(find.text('2 ausgewählt'), findsOneWidget);
    expect(repository.checkCalls, isEmpty);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Feta auswählen')),
      isSemantics(isChecked: true),
    );

    await tester.tap(find.byTooltip('Ausgewählte löschen'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds, unorderedEquals([101, 102, 105]));
    expect(find.text('Karotten'), findsNothing);
    expect(find.text('Feta'), findsNothing);
    expect(find.text('2 Artikel gelöscht'), findsOneWidget);
    // The selection is over.
    expect(find.text('Einkaufsliste'), findsOneWidget);

    await tester.tap(find.text('Rückgängig'));
    await tester.pumpAndSettle();
    expect(
      repository.addedItems.map((i) => i.foodId),
      unorderedEquals([1, 1, 4]),
    );
  });

  testWidgets('selecting from the heading; a second tap unselects, '
      'closing keeps everything', (tester) async {
    await pumpList(tester);

    await tester.tap(find.byTooltip('Mehrere auswählen'));
    await tester.pumpAndSettle();
    expect(find.text('0 ausgewählt'), findsOneWidget);
    // Nothing to delete yet.
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.delete_outline_rounded),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();
    expect(find.text('1 ausgewählt'), findsOneWidget);
    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();
    expect(find.text('0 ausgewählt'), findsOneWidget);

    await tester.tap(find.byTooltip('Auswahl beenden'));
    await tester.pumpAndSettle();
    expect(find.text('Einkaufsliste'), findsOneWidget);
    expect(repository.deletedIds, isEmpty);
    expect(repository.checkCalls, isEmpty);
    // Tapping checks off again.
    await tester.tap(find.text('Feta'));
    await tester.pump();
    expect(repository.checkCalls.single.ids, {105});
  });

  testWidgets('a failed delete of the selection keeps it and says why', (
    tester,
  ) async {
    repository.editFailure = const OfflineFailure();
    await pumpList(tester);

    await tester.longPress(find.text('Feta'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ausgewählte löschen'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Nicht alles gelöscht.'), findsOneWidget);
    expect(find.text('1 ausgewählt'), findsOneWidget);
    expect(find.text('Feta'), findsOneWidget);
  });

  testWidgets('a selected row that someone else partly ticks off stays one '
      'selected row', (tester) async {
    await pumpList(tester);
    await tester.longPress(find.text('Karotten'));
    await tester.pumpAndSettle();

    // Lena buys the carrots for one of the two recipes.
    repository.entries[0] = repository.entries[0].copyWith(
      checked: true,
      completedAt: DateTime.utc(2026, 11, 18, 11),
      updatedAt: DateTime.utc(2026, 11, 18, 11),
    );
    await tester.fling(find.text('Feta'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Erledigt · 4'));
    await tester.pumpAndSettle();

    expect(find.text('1 ausgewählt'), findsOneWidget);
    await tester.tap(find.byTooltip('Ausgewählte löschen'));
    await tester.pumpAndSettle();
    // Only what is still to buy.
    expect(repository.deletedIds, [102]);
  });

  testWidgets('closing "Erledigt" takes its rows out of the selection', (
    tester,
  ) async {
    await pumpList(tester);
    await tester.tap(find.text('Erledigt · 3'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Milch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feta'));
    await tester.pumpAndSettle();
    expect(find.text('2 ausgewählt'), findsOneWidget);

    await tester.tap(find.text('Erledigt · 3'));
    await tester.pumpAndSettle();
    expect(find.text('1 ausgewählt'), findsOneWidget);
    await tester.tap(find.text('Erledigt · 3'));
    await tester.pumpAndSettle();
    expect(find.text('1 ausgewählt'), findsOneWidget);

    await tester.tap(find.byTooltip('Ausgewählte löschen'));
    await tester.pumpAndSettle();
    expect(repository.deletedIds, [105]);
  });

  testWidgets('offline, deleting the selection is disabled and says why', (
    tester,
  ) async {
    await pumpList(
      tester,
      connectivity: FakeConnectivityService(isOnline: false),
    );

    await tester.longPress(find.text('Feta'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ausgewählte löschen'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Offline kannst du nichts ändern'),
      findsOneWidget,
    );
    expect(repository.deletedIds, isEmpty);
    expect(find.text('Feta'), findsOneWidget);
  });

  testWidgets('a failed delete keeps the row and says why', (tester) async {
    repository.editFailure = const OfflineFailure();
    await pumpList(tester);

    await openActions(tester, 'Feta');
    await tester.tap(find.text('Löschen'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Feta nicht gelöscht.'), findsOneWidget);
    expect(find.text('Feta'), findsOneWidget);
  });

  testWidgets('offline, adding and row actions are disabled and say why', (
    tester,
  ) async {
    await pumpList(
      tester,
      connectivity: FakeConnectivityService(isOnline: false),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Offline kannst du nichts ändern'),
      findsOneWidget,
    );

    await openActions(tester, 'Feta');
    expect(find.text('Habe ich da'), findsNothing);
    expect(
      find.textContaining('Offline kannst du nichts ändern'),
      findsOneWidget,
    );
    expect(parser.parsed, isEmpty);
    expect(repository.addedItems, isEmpty);
  });
}
