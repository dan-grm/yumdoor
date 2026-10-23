import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/cancellation.dart';
import '../../domain/models/keyword.dart';
import '../../domain/repositories/keyword_repository.dart';
import '../api/api_failures.dart';
import '../mappers/keyword_mapper.dart';
import '../mappers/mapping.dart';

class TandoorKeywordRepository implements KeywordRepository {
  TandoorKeywordRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<Keyword>> autocomplete(
    String query, {
    int limit = 10,
    CancelSignal? cancel,
  }) => guardRequest(() async {
    final response = await _api.apiKeywordList(
      query: query.trim(),
      pageSize: limit,
      cancelToken: cancelTokenFor(cancel),
    );
    return [
      for (final keyword in requireBody(response.data).results)
        keyword.toDomain(),
    ];
  });

  @override
  Future<Keyword> fetchKeyword(int id) => guardRequest(() async {
    final response = await _api.apiKeywordRetrieve(id: id);
    return requireBody(response.data).toDomain();
  });
}
