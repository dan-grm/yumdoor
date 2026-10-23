import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/cancellation.dart';
import '../../domain/models/food.dart';
import '../../domain/repositories/food_repository.dart';
import '../api/api_failures.dart';
import '../mappers/food_mapper.dart';
import '../mappers/mapping.dart';

class TandoorFoodRepository implements FoodRepository {
  TandoorFoodRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<Food>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) => guardRequest(() async {
    final response = await _api.apiFoodList(
      query: query.trim(),
      pageSize: limit,
      cancelToken: cancelTokenFor(cancel),
    );
    return [
      for (final food in requireBody(response.data).results) food.toDomain(),
    ];
  });

  @override
  Future<Food> fetchFood(int id) => guardRequest(() async {
    final response = await _api.apiFoodRetrieve(id: id);
    return requireBody(response.data).toDomain();
  });
}
