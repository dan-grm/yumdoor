import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../api/api_failures.dart';
import '../mappers/food_mapper.dart';
import '../mappers/mapping.dart';

class TandoorFoodRepository implements FoodRepository {
  TandoorFoodRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<Food>> autocomplete(String query, {int limit = 10}) =>
      guardRequest(() async {
        final response = await _api.apiFoodList(
          query: query.trim(),
          pageSize: limit,
        );
        return [
          for (final food in requireBody(response.data).results)
            food.toDomain(),
        ];
      });
}
