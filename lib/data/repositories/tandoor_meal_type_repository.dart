import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/meal_type.dart';
import '../../domain/repositories/meal_type_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/meal_plan_mapper.dart';

/// Meal types per request page: `DefaultPagination.max_page_size`.
const _pageSize = 200;

class TandoorMealTypeRepository implements MealTypeRepository {
  TandoorMealTypeRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<MealType>> list() => guardRequest(_list);

  Future<List<MealType>> _list() async {
    final types = <MealType>[];
    for (var page = 1; ; page++) {
      final response = requireBody(
        (await _api.apiMealTypeList(page: page, pageSize: _pageSize)).data,
      );
      types.addAll(response.results.map((dto) => dto.toDomain()));
      if (response.next == null || response.results.isEmpty) break;
    }
    return types..sort(compareMealTypes);
  }

  /// Tandoor only returns an existing type of the same name if the current
  /// user created it, and its name check is case-sensitive, so it would
  /// create "abendessen" next to someone else's "Abendessen"
  /// (docs/TANDOOR_API.md#meal-types). The existing types are checked here
  /// first.
  @override
  Future<MealType> create(String name) async {
    final trimmed = requireName(name);
    if (trimmed.runes.length > maxMealTypeNameLength) {
      throw ArgumentError.value(
        name,
        'name',
        'is longer than $maxMealTypeNameLength characters',
      );
    }
    return guardRequest(() async {
      final existing = await _list();
      final lower = trimmed.toLowerCase();
      if (_named(existing, lower) case final type?) return type;
      final last = existing.fold<int?>(
        null,
        (max, type) => max == null || type.order > max ? type.order : max,
      );
      try {
        final response = await _api.apiMealTypeCreate(
          mealType: api.MealType(
            (b) => b
              ..name = trimmed
              ..order = last == null ? 0 : last + 1,
          ),
        );
        return requireBody(response.data).toDomain();
      } on DioException catch (e) {
        // Someone else created the same name meanwhile: Tandoor's unique
        // constraint fails with 500.
        if (e.response?.statusCode != 500) rethrow;
        final match = _named(await _list(), lower);
        if (match == null) rethrow;
        return match;
      }
    });
  }

  static MealType? _named(List<MealType> types, String lowerName) {
    for (final type in types) {
      if (type.name.trim().toLowerCase() == lowerName) return type;
    }
    return null;
  }
}
