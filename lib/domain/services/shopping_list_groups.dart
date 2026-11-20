import '../models/shopping.dart';
import '../models/unit.dart';
import '../models/user_ref.dart';
import 'text_match.dart';

/// Arranges the shopping list for a walk through [store]: one row per food
/// and unit, open rows grouped by supermarket category, checked rows apart.
///
/// Sections come in [store]'s category order, then the categories it doesn't
/// list, by name, then the uncategorized foods (section with a `null`
/// category, shown as "Sonstiges"). Without a store, all categories go by
/// name, uncategorized last. Rows in a section go by food name, then unit
/// name, without a unit first.
///
/// Entries of the same food and unit merge into one row, open and checked
/// ones separately; the same food in different units stays separate rows.
/// Checked rows are in [ShoppingListGroups.done], most recently completed
/// first.
ShoppingListGroups groupShoppingList(
  List<ShoppingEntry> entries, {
  Supermarket? store,
}) {
  final open = <_RowKey, List<ShoppingEntry>>{};
  final done = <_RowKey, List<ShoppingEntry>>{};
  for (final entry in entries) {
    final key = (food: entry.food.id, unit: entry.unit?.id);
    (entry.checked ? done : open).putIfAbsent(key, () => []).add(entry);
  }

  final byCategory = <int?, List<ShoppingListRow>>{};
  final categories = <int, SupermarketCategory>{};
  for (final group in open.values) {
    final category = group.first.food.category;
    if (category != null) categories.putIfAbsent(category.id, () => category);
    byCategory.putIfAbsent(category?.id, () => []).add(_row(group));
  }

  final storeOrder = <int, int>{};
  for (final id in store?.categoryIds ?? const <int>[]) {
    storeOrder.putIfAbsent(id, () => storeOrder.length);
  }
  final sortedCategories = categories.values.toList()
    ..sort((a, b) {
      final ia = storeOrder[a.id];
      final ib = storeOrder[b.id];
      if (ia != null && ib != null) return ia.compareTo(ib);
      if (ia != null) return -1;
      if (ib != null) return 1;
      final byName = foldText(a.name).compareTo(foldText(b.name));
      return byName != 0 ? byName : a.id.compareTo(b.id);
    });

  final sections = [
    for (final category in sortedCategories)
      ShoppingListSection(
        category: category,
        rows: _sorted(byCategory[category.id]!),
      ),
    if (byCategory[null] case final rows?)
      ShoppingListSection(category: null, rows: _sorted(rows)),
  ];

  final doneRows = [for (final group in done.values) _row(group)]
    ..sort((a, b) {
      final byTime = b.completedAt!.compareTo(a.completedAt!);
      return byTime != 0 ? byTime : _byFoodAndUnit(a, b);
    });

  return ShoppingListGroups(
    sections: List.unmodifiable(sections),
    done: List.unmodifiable(doneRows),
  );
}

typedef _RowKey = ({int food, int? unit});

ShoppingListRow _row(List<ShoppingEntry> entries) {
  var amount = 0.0;
  final recipeNames = <String>{};
  final addedBy = <int, UserRef>{};
  DateTime? completedAt;
  for (final entry in entries) {
    if (entry.amount > 0) amount += entry.amount;
    final source = entry.source;
    if (source == null) {
      addedBy.putIfAbsent(entry.createdBy.id, () => entry.createdBy);
    } else if (source.recipeName.isNotEmpty) {
      recipeNames.add(source.recipeName);
    }
    if (entry.checked) {
      // Tandoor sets `completed_at` on check-off; `updated_at` stands in if a
      // checked entry has none.
      final time = entry.completedAt ?? entry.updatedAt;
      if (completedAt == null || time.isAfter(completedAt)) completedAt = time;
    }
  }
  final first = entries.first;
  return ShoppingListRow(
    food: first.food,
    unit: first.unit,
    amount: amount,
    entryIds: List.unmodifiable([for (final e in entries) e.id]),
    recipeNames: List.unmodifiable(recipeNames),
    addedBy: List.unmodifiable(addedBy.values),
    completedAt: completedAt,
  );
}

List<ShoppingListRow> _sorted(List<ShoppingListRow> rows) =>
    List.unmodifiable(rows..sort(_byFoodAndUnit));

int _byFoodAndUnit(ShoppingListRow a, ShoppingListRow b) {
  final byFood = foldText(a.food.name).compareTo(foldText(b.food.name));
  if (byFood != 0) return byFood;
  final byFoodId = a.food.id.compareTo(b.food.id);
  if (byFoodId != 0) return byFoodId;
  return switch ((a.unit, b.unit)) {
    (null, null) => 0,
    (null, _) => -1,
    (_, null) => 1,
    (final ua?, final ub?) => _byUnit(ua, ub),
  };
}

int _byUnit(Unit a, Unit b) {
  final byName = foldText(a.name).compareTo(foldText(b.name));
  return byName != 0 ? byName : a.id.compareTo(b.id);
}

/// The shopping list arranged by [groupShoppingList].
class ShoppingListGroups {
  const ShoppingListGroups({required this.sections, required this.done});

  /// Open rows by supermarket category, in store order. No section is empty.
  final List<ShoppingListSection> sections;

  /// Checked rows, most recently completed first.
  final List<ShoppingListRow> done;

  /// How many open rows there are ("7 offen").
  int get openCount =>
      sections.fold(0, (count, section) => count + section.rows.length);

  /// Whether there is nothing on the list, open or done.
  bool get isEmpty => sections.isEmpty && done.isEmpty;
}

/// The open rows of one supermarket category.
class ShoppingListSection {
  const ShoppingListSection({required this.category, required this.rows});

  /// `null` for foods without a category ("Sonstiges").
  final SupermarketCategory? category;

  /// By food name, then unit.
  final List<ShoppingListRow> rows;
}

/// The entries of one food and unit, merged.
class ShoppingListRow {
  const ShoppingListRow({
    required this.food,
    required this.unit,
    required this.amount,
    required this.entryIds,
    required this.recipeNames,
    required this.addedBy,
    this.completedAt,
  });

  final ShoppingFood food;

  /// `null` for entries without a unit.
  final Unit? unit;

  /// The sum of the entries' amounts; 0 if none has one. Entries without an
  /// amount add nothing.
  final double amount;

  /// The merged entries, to check them off or delete them together.
  final List<int> entryIds;

  /// The recipes the entries were added for, each once, in list order.
  final List<String> recipeNames;

  /// Who added the entries that were added by hand, each once, in list order.
  final List<UserRef> addedBy;

  /// For a checked row, when its last entry was checked off; `null` while
  /// open.
  final DateTime? completedAt;

  bool get hasAmount => amount > 0;
}
