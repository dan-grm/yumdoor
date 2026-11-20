import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/domain/services/shopping_list_groups.dart';

void main() {
  const produce = SupermarketCategory(id: 1, name: 'Obst & Gemüse');
  const chilled = SupermarketCategory(id: 2, name: 'Kühlregal');
  const pantry = SupermarketCategory(id: 3, name: 'Vorrat');
  const bakery = SupermarketCategory(id: 4, name: 'Bäckerei');

  const carrot = ShoppingFood(id: 1, name: 'Karotte', category: produce);
  const parsley = ShoppingFood(id: 2, name: 'Petersilie', category: produce);
  const feta = ShoppingFood(id: 3, name: 'Feta', category: chilled);
  const rice = ShoppingFood(id: 4, name: 'Risottoreis', category: pantry);
  const bread = ShoppingFood(id: 5, name: 'Brot', category: bakery);
  const lemon = ShoppingFood(id: 6, name: 'Zitrone');
  const apple = ShoppingFood(id: 7, name: 'Äpfel');

  const gram = Unit(id: 10, name: 'g');
  const kilo = Unit(id: 11, name: 'kg');
  const bunch = Unit(id: 12, name: 'Bund');

  const anna = UserRef(id: 1, name: 'Anna');
  const ben = UserRef(id: 2, name: 'Ben');

  final time = DateTime.utc(2026, 11, 20, 10);

  ShoppingEntrySource source(String recipe) => ShoppingEntrySource(
    listRecipeId: recipe.hashCode,
    recipeName: recipe,
    servings: 2,
  );

  var nextId = 100;
  ShoppingEntry entry(
    ShoppingFood food, {
    Unit? unit,
    double amount = 1,
    bool checked = false,
    DateTime? completedAt,
    UserRef createdBy = anna,
    String? recipe,
  }) => ShoppingEntry(
    id: nextId++,
    food: food,
    unit: unit,
    amount: amount,
    checked: checked,
    completedAt: completedAt,
    updatedAt: completedAt ?? time,
    createdBy: createdBy,
    source: recipe == null ? null : source(recipe),
  );

  List<String?> sectionNames(ShoppingListGroups groups) => [
    for (final section in groups.sections) section.category?.name,
  ];

  group('sections', () {
    final entries = [
      entry(rice),
      entry(lemon),
      entry(feta),
      entry(bread),
      entry(carrot),
    ];

    test('follow the store order, unlisted categories by name, '
        'uncategorized last', () {
      final groups = groupShoppingList(
        entries,
        store: const Supermarket(id: 1, name: 'Markt', categoryIds: [3, 1]),
      );
      expect(sectionNames(groups), [
        'Vorrat',
        'Obst & Gemüse',
        'Bäckerei',
        'Kühlregal',
        null,
      ]);
    });

    test('go by name without a store, ignoring case and accents', () {
      expect(sectionNames(groupShoppingList(entries)), [
        'Bäckerei',
        'Kühlregal',
        'Obst & Gemüse',
        'Vorrat',
        null,
      ]);
    });

    test('ignore store categories that have no entries, and duplicates', () {
      final groups = groupShoppingList(
        [entry(carrot), entry(feta)],
        store: const Supermarket(
          id: 1,
          name: 'Markt',
          categoryIds: [99, 2, 4, 2, 1],
        ),
      );
      expect(sectionNames(groups), ['Kühlregal', 'Obst & Gemüse']);
    });

    test('have no uncategorized section when every food has a category', () {
      expect(sectionNames(groupShoppingList([entry(carrot)])), [
        'Obst & Gemüse',
      ]);
    });

    test('hold rows by food name, ignoring accents', () {
      final groups = groupShoppingList([
        entry(lemon),
        entry(apple),
        entry(parsley),
        entry(carrot),
      ]);
      expect(
        [
          for (final section in groups.sections)
            [for (final row in section.rows) row.food.name],
        ],
        [
          ['Karotte', 'Petersilie'],
          ['Äpfel', 'Zitrone'],
        ],
      );
    });
  });

  group('rows', () {
    test('merge open entries of the same food and unit', () {
      final a = entry(carrot, unit: gram, amount: 300, recipe: 'Ofenkarotten');
      final b = entry(carrot, unit: gram, amount: 500, recipe: 'Bolognese');
      final c = entry(carrot, unit: gram, amount: 300, recipe: 'Ofenkarotten');
      final groups = groupShoppingList([a, b, c]);

      final row = groups.sections.single.rows.single;
      expect(row.food, carrot);
      expect(row.unit, gram);
      expect(row.amount, 1100);
      expect(row.hasAmount, isTrue);
      expect(row.entryIds, [a.id, b.id, c.id]);
      expect(row.recipeNames, ['Ofenkarotten', 'Bolognese']);
      expect(row.addedBy, isEmpty);
      expect(row.completedAt, isNull);
      expect(groups.openCount, 1);
    });

    test('list who added manual items, each once', () {
      final row = groupShoppingList([
        entry(lemon, createdBy: ben),
        entry(lemon, createdBy: anna, recipe: 'Risotto'),
        entry(lemon, createdBy: anna),
        entry(lemon, createdBy: ben),
      ]).sections.single.rows.single;
      expect(row.addedBy, [ben, anna]);
      expect(row.recipeNames, ['Risotto']);
      expect(row.amount, 4);
    });

    test('skip empty recipe names', () {
      final row = groupShoppingList([entry(lemon, recipe: '')])
          .sections
          .single
          .rows
          .single;
      expect(row.recipeNames, isEmpty);
      expect(row.addedBy, isEmpty);
    });

    test('keep the same food in different units apart, '
        'without a unit first', () {
      final rows = groupShoppingList([
        entry(carrot, unit: kilo, amount: 1),
        entry(carrot, unit: gram, amount: 200),
        entry(carrot, amount: 3),
        entry(carrot, unit: gram, amount: 100),
      ]).sections.single.rows;
      expect(
        [for (final row in rows) (row.unit?.name, row.amount)],
        [(null, 3), ('g', 300), ('kg', 1)],
      );
    });

    test('entries without an amount add nothing to the sum', () {
      final rows = groupShoppingList([
        entry(parsley, unit: bunch, amount: 0),
        entry(parsley, unit: bunch, amount: 0.5),
        entry(carrot, amount: 0),
        entry(carrot, amount: 0),
      ]).sections.single.rows;
      expect(rows[0].food, carrot);
      expect(rows[0].amount, 0);
      expect(rows[0].hasAmount, isFalse);
      expect(rows[0].entryIds, hasLength(2));
      expect(rows[1].amount, 0.5);
      expect(rows[1].entryIds, hasLength(2));
    });
  });

  group('done', () {
    test('holds checked rows apart, most recently completed first', () {
      final groups = groupShoppingList([
        entry(carrot, checked: true, completedAt: time),
        entry(carrot),
        entry(feta, checked: true, completedAt: time.add(_hour)),
        entry(rice, checked: true, completedAt: time.subtract(_hour)),
      ]);
      expect(groups.sections.single.rows.single.food, carrot);
      expect(groups.openCount, 1);
      expect(
        [for (final row in groups.done) row.food.name],
        ['Feta', 'Karotte', 'Risottoreis'],
      );
      expect(groups.done.first.completedAt, time.add(_hour));
    });

    test('merges checked entries, completed when the last one was', () {
      final a = entry(
        feta,
        unit: gram,
        amount: 200,
        checked: true,
        completedAt: time,
      );
      final b = entry(
        feta,
        unit: gram,
        amount: 100,
        checked: true,
        completedAt: time.add(_hour),
      );
      final done = groupShoppingList([a, b]).done;
      expect(done.single.amount, 300);
      expect(done.single.entryIds, [a.id, b.id]);
      expect(done.single.completedAt, time.add(_hour));
    });

    test('falls back to the update time without a completion time', () {
      final groups = groupShoppingList([
        entry(carrot, checked: true, completedAt: time),
        ShoppingEntry(
          id: 1,
          food: feta,
          amount: 1,
          checked: true,
          updatedAt: time.add(_hour),
          createdBy: anna,
        ),
      ]);
      expect(
        [for (final row in groups.done) row.food.name],
        ['Feta', 'Karotte'],
      );
    });

    test('rows completed at the same time go by name', () {
      final groups = groupShoppingList([
        entry(rice, checked: true, completedAt: time),
        entry(carrot, checked: true, completedAt: time),
      ]);
      expect(
        [for (final row in groups.done) row.food.name],
        ['Karotte', 'Risottoreis'],
      );
    });
  });

  test('an empty list has no sections and nothing done', () {
    final groups = groupShoppingList(
      const [],
      store: const Supermarket(id: 1, name: 'Markt', categoryIds: [1, 2]),
    );
    expect(groups.sections, isEmpty);
    expect(groups.done, isEmpty);
    expect(groups.openCount, 0);
    expect(groups.isEmpty, isTrue);
  });

  test('a list with only checked entries has no sections', () {
    final groups = groupShoppingList([
      entry(carrot, checked: true, completedAt: time),
    ]);
    expect(groups.sections, isEmpty);
    expect(groups.done, hasLength(1));
    expect(groups.isEmpty, isFalse);
  });
}

const _hour = Duration(hours: 1);
