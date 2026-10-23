import 'package:yumdoor/core/cancellation.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/repositories/food_repository.dart';
import 'package:yumdoor/domain/repositories/keyword_repository.dart';

/// [FoodRepository] for tests: autocomplete matches names case-insensitively.
class FakeFoodRepository implements FoodRepository {
  FakeFoodRepository([this.foods = const []]);

  final List<Food> foods;
  final queries = <String>[];

  @override
  Future<List<Food>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) async {
    queries.add(query);
    return _complete(foods, (f) => f.name, query, limit);
  }

  @override
  Future<Food> fetchFood(int id) async =>
      foods.where((f) => f.id == id).firstOrNull ??
      (throw const NotFoundFailure());
}

/// [KeywordRepository] for tests, like [FakeFoodRepository].
class FakeKeywordRepository implements KeywordRepository {
  FakeKeywordRepository([this.keywords = const []]);

  final List<Keyword> keywords;

  @override
  Future<List<Keyword>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) async => _complete(keywords, (k) => k.name, query, limit);

  @override
  Future<Keyword> fetchKeyword(int id) async =>
      keywords.where((k) => k.id == id).firstOrNull ??
      (throw const NotFoundFailure());
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
