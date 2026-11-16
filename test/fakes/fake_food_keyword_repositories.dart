import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/repositories/food_repository.dart';
import 'package:yumdoor/domain/repositories/keyword_repository.dart';
import 'package:yumdoor/domain/repositories/unit_repository.dart';
import 'package:yumdoor/domain/services/text_match.dart';

/// [FoodRepository] for tests: autocomplete matches names case-insensitively,
/// [create] is get-or-create by name or plural name like Tandoor's. Set
/// [failure] to make it throw.
class FakeFoodRepository implements FoodRepository {
  FakeFoodRepository([Iterable<Food> foods = const []]) : foods = [...foods];

  final List<Food> foods;
  final queries = <String>[];

  /// The names passed to [create], trimmed.
  final created = <String>[];
  Failure? failure;

  @override
  Future<List<Food>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) async {
    queries.add(query);
    if (failure case final failure?) throw failure;
    return _complete(foods, (f) => f.name, query, limit);
  }

  @override
  Future<Food> fetchFood(int id) async =>
      foods.where((f) => f.id == id).firstOrNull ??
      (throw const NotFoundFailure());

  @override
  Future<Food> create(String name) async {
    final trimmed = _requireName(name);
    if (failure case final failure?) throw failure;
    created.add(trimmed);
    return _getOrCreate<Food>(
      foods,
      (f) => [f.name, ?f.pluralName],
      trimmed,
      (id) => Food(id: id, name: trimmed),
      (f) => f.id,
    );
  }
}

/// [KeywordRepository] for tests, like [FakeFoodRepository].
class FakeKeywordRepository implements KeywordRepository {
  FakeKeywordRepository([Iterable<Keyword> keywords = const []])
    : keywords = [...keywords];

  final List<Keyword> keywords;

  /// The names passed to [create], trimmed.
  final created = <String>[];
  Failure? failure;

  @override
  Future<List<Keyword>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) async {
    if (failure case final failure?) throw failure;
    return _complete(keywords, (k) => k.name, query, limit);
  }

  @override
  Future<Keyword> fetchKeyword(int id) async =>
      keywords.where((k) => k.id == id).firstOrNull ??
      (throw const NotFoundFailure());

  @override
  Future<Keyword> create(String name) async {
    final trimmed = _requireName(name);
    if (failure case final failure?) throw failure;
    created.add(trimmed);
    return _getOrCreate<Keyword>(
      keywords,
      (k) => [k.name],
      trimmed,
      (id) => Keyword(id: id, name: trimmed),
      (k) => k.id,
    );
  }
}

/// [UnitRepository] for tests, like [FakeFoodRepository]; autocomplete
/// ignores accents like the real one.
class FakeUnitRepository implements UnitRepository {
  FakeUnitRepository([Iterable<Unit> units = const []]) : units = [...units];

  final List<Unit> units;
  final queries = <String>[];

  /// The names passed to [create], trimmed.
  final created = <String>[];
  Failure? failure;

  @override
  Future<List<Unit>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) async {
    queries.add(query);
    if (failure case final failure?) throw failure;
    final matcher = TextMatcher(query);
    return units.where((u) => matcher.contains(u.name)).take(limit).toList();
  }

  @override
  Future<Unit> create(String name) async {
    final trimmed = _requireName(name);
    if (failure case final failure?) throw failure;
    created.add(trimmed);
    return _getOrCreate<Unit>(
      units,
      (u) => [u.name, ?u.pluralName],
      trimmed,
      (id) => Unit(id: id, name: trimmed, pluralName: trimmed),
      (u) => u.id,
    );
  }
}

List<T> _complete<T>(
  List<T> items,
  String Function(T) name,
  String query,
  int limit,
) => items
    .where((item) => name(item).toLowerCase().contains(query.toLowerCase()))
    .take(limit)
    .toList();

String _requireName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) throw ArgumentError.value(name, 'name', 'is blank');
  return trimmed;
}

/// The item in [items] one of whose [names] is [name] ignoring case, or a new
/// one from [make], added to [items] with the next free id.
T _getOrCreate<T>(
  List<T> items,
  List<String> Function(T) names,
  String name,
  T Function(int id) make,
  int Function(T) id,
) {
  final lower = name.toLowerCase();
  for (final item in items) {
    if (names(item).any((n) => n.toLowerCase() == lower)) return item;
  }
  final next = items.fold(0, (max, item) => id(item) > max ? id(item) : max);
  final item = make(next + 1);
  items.add(item);
  return item;
}
