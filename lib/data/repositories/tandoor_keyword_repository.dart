import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/keyword.dart';
import '../../domain/repositories/keyword_repository.dart';
import '../api/api_failures.dart';
import '../mappers/keyword_mapper.dart';
import '../mappers/mapping.dart';

class TandoorKeywordRepository implements KeywordRepository {
  TandoorKeywordRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<Keyword>> autocomplete(String query, {int limit = 10}) =>
      guardRequest(() async {
        final response = await _api.apiKeywordList(
          query: query.trim(),
          pageSize: limit,
        );
        return [
          for (final keyword in requireBody(response.data).results)
            keyword.toDomain(),
        ];
      });
}
