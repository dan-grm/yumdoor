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
/// Open entries of the same food and unit merge into one row; the same food
/// in different units stays separate rows. Checked entries are in
/// [ShoppingListGroups.done], most recently completed first, merged only
/// when they were checked off together (same completion time), so undoing
/// a check-off doesn't bring back what was bought days earlier.
///
/// An entry id that comes more than once (an incremental read appended to a
/// full one) counts once, as its last occurrence. A row takes its food, and a
/// section its category, from the most recently updated entry.
ShoppingListGroups groupShoppingList(
  List<ShoppingEntry> entries, {
  Supermarket? store,
}) {
  final byId = <int, ShoppingEntry>{
    for (final entry in entries) entry.id: entry,
  };
  final open = <_RowKey, List<ShoppingEntry>>{};
  final done = <_RowKey, List<ShoppingEntry>>{};
  for (final entry in byId.values) {
    final key = (
      food: entry.food.id,
      unit: entry.unit?.id,
      completedAt: entry.checked ? _completedAt(entry) : null,
    );
    (entry.checked ? done : open).putIfAbsent(key, () => []).add(entry);
  }

  final byCategory = <int?, List<ShoppingListRow>>{};
  final categories = <int, (SupermarketCategory, DateTime)>{};
  for (final group in open.values) {
    final latest = _latest(group);
    final category = latest.food.category;
    if (category != null) {
      final known = categories[category.id];
      if (known == null || latest.updatedAt.isAfter(known.$2)) {
        categories[category.id] = (category, latest.updatedAt);
      }
    }
    byCategory.putIfAbsent(category?.id, () => []).add(_row(group));
  }

  final storeOrder = <int, int>{};
  for (final id in store?.categoryIds ?? const <int>[]) {
    storeOrder.putIfAbsent(id, () => storeOrder.length);
  }
  final sortedCategories =
      [for (final (category, _) in categories.values) category]..sort((a, b) {
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

typedef _RowKey = ({int food, int? unit, DateTime? completedAt});

/// Tandoor sets `completed_at` on check-off; `updated_at` stands in if a
/// checked entry has none.
DateTime _completedAt(ShoppingEntry entry) =>
    entry.completedAt ?? entry.updatedAt;

ShoppingEntry _latest(List<ShoppingEntry> entries) => entries.reduce(
  (latest, entry) => entry.updatedAt.isAfter(latest.updatedAt) ? entry : latest,
);

ShoppingListRow _row(List<ShoppingEntry> entries) {
  var amount = 0.0;
  var someWithoutAmount = false;
  final recipeNames = <String>{};
  final addedBy = <int, UserRef>{};
  DateTime? completedAt;
  for (final entry in entries) {
    if (entry.amount > 0) {
      amount += entry.amount;
    } else {
      someWithoutAmount = true;
    }
    final source = entry.source;
    if (source == null) {
      addedBy.putIfAbsent(entry.createdBy.id, () => entry.createdBy);
    } else if (source.recipeName.isNotEmpty) {
      recipeNames.add(source.recipeName);
    }
    if (entry.checked) {
      final time = _completedAt(entry);
      if (completedAt == null || time.isAfter(completedAt)) completedAt = time;
    }
  }
  final latest = _latest(entries);
  return ShoppingListRow(
    food: latest.food,
    unit: latest.unit,
    amount: amount,
    someWithoutAmount: amount > 0 && someWithoutAmount,
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
    this.someWithoutAmount = false,
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

  /// Whether, besides [amount], some merged entries have no amount, such as
  /// "1 Bund" for one recipe plus "Petersilie" for another. `false` when
  /// none has one.
  final bool someWithoutAmount;

  /// The merged entries, to check them off or delete them together.
  final List<int> entryIds;

  /// The names of the recipes the entries were added for, each once, in list
  /// order; a recipe planned twice is named once.
  final List<String> recipeNames;

  /// Who added the entries that were added by hand, each once, in list order.
  final List<UserRef> addedBy;

  /// For a checked row, when it was checked off; `null` while open.
  final DateTime? completedAt;

  bool get hasAmount => amount > 0;
}
