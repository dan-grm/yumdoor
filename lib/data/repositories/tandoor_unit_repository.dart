import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/cancellation.dart';
import '../../domain/models/unit.dart';
import '../../domain/repositories/unit_repository.dart';
import '../../domain/services/text_match.dart';
import '../api/api_failures.dart';
import '../mappers/food_mapper.dart';
import '../mappers/mapping.dart';

class TandoorUnitRepository implements UnitRepository {
  TandoorUnitRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<Unit>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) => guardRequest(() async {
    final response = await _api.apiUnitList(
      query: query.trim(),
      pageSize: limit,
      cancelToken: cancelTokenFor(cancel),
    );
    // With a fuzzy search preference Tandoor only orders by similarity.
    final matcher = TextMatcher(query);
    return [
      for (final unit in requireBody(response.data).results)
        if (unit.toDomain() case final unit when matcher.unit(unit)) unit,
    ];
  });

  @override
  Future<Unit> create(String name) {
    final trimmed = requireName(name);
    return guardRequest(() async {
      final response = await _api.apiUnitCreate(
        unit: api.Unit((b) => b..name = trimmed),
      );
      return requireBody(response.data).toDomain();
    });
  }
}
