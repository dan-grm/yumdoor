/// Tandoor has no note on a shopping entry, so Yumdoor keeps it in the name
/// of the entry's food: "Burger Patties, von Vegetarian Butcher" is the item
/// "Burger Patties" with the note "von Vegetarian Butcher". The note starts at
/// the first ", " (docs/TANDOOR_API.md#shopping-list).
const _separator = ', ';

/// [foodName] split at its first ", ": the name, and the note (empty if
/// there is none). Both are trimmed; a name that would be empty stays whole.
({String name, String note}) splitFoodNote(String foodName) {
  final at = foodName.indexOf(_separator);
  if (at <= 0) return (name: foodName, note: '');
  final name = foodName.substring(0, at).trim();
  final note = foodName.substring(at + _separator.length).trim();
  if (name.isEmpty) return (name: foodName, note: '');
  return (name: name, note: note);
}

/// The food name for [name] with [note], the inverse of [splitFoodNote];
/// just [name] without a note.
String joinFoodNote(String name, String note) {
  final trimmed = note.trim();
  return trimmed.isEmpty ? name : '$name$_separator$trimmed';
}
