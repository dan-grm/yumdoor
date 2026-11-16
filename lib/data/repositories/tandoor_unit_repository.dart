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
    final matcher = TextMatcher(query);
    final response = await _api.apiUnitList(
      query: query.trim(),
      // With a fuzzy search preference Tandoor doesn't filter, it only orders
      // by similarity, and a short text is about as similar to every unit.
      // A space has few units, so one page of the most Tandoor allows holds
      // all of them; without fuzzy search the server sends only matches.
      pageSize: matcher.isEmpty ? limit : _maxPageSize,
      cancelToken: cancelTokenFor(cancel),
    );
    return requireBody(response.data).results
        .map((dto) => dto.toDomain())
        .where((unit) => matcher.contains(unit.name))
        .take(limit)
        .toList();
  });

  /// `DefaultPagination.max_page_size` (`cookbook/views/api.py:224`).
  static const _maxPageSize = 200;

  @override
  Future<Unit> create(String name) async {
    final trimmed = requireName(name);
    return guardRequest(() async {
      final response = await _api.apiUnitCreate(
        unit: api.Unit((b) => b..name = trimmed),
      );
      return requireBody(response.data).toDomain();
    });
  }
}
