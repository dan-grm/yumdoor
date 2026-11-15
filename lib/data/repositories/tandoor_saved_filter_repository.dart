import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/recipe_query.dart';
import '../../domain/models/saved_filter.dart';
import '../../domain/repositories/saved_filter_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/saved_filter_mapper.dart';
import 'current_user.dart';

/// Saved searches per request page.
const _pageSize = 100;

/// Tandoor's `/api/custom-filter/` (docs/TANDOOR_API.md#saved-searches).
class TandoorSavedFilterRepository implements SavedFilterRepository {
  TandoorSavedFilterRepository(this._api, {CurrentUser? currentUser})
    : _currentUser = currentUser ?? CurrentUser(_api);

  final api.ApiApi _api;
  final CurrentUser _currentUser;

  @override
  Future<List<SavedFilter>> savedFilters() => guardRequest(() async {
    final userId = _currentUser.id();
    final filters = <api.CustomFilter>[];
    for (var page = 1; ; page++) {
      final response = await _api.apiCustomFilterList(
        page: page,
        pageSize: _pageSize,
      );
      final body = requireBody(response.data);
      filters.addAll(body.results);
      if (body.next == null) break;
    }
    final id = await userId;
    return [for (final filter in filters) filter.toDomain(userId: id)]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  });

  @override
  Future<SavedFilter> create(String name, RecipeQuery query) {
    final search = savedSearchJson(query);
    return guardRequest(() async {
      final userId = _currentUser.id();
      final response = await _api.apiCustomFilterCreate(
        customFilter: api.CustomFilter(
          (b) => b
            ..name = name.trim()
            ..search = search,
        ),
      );
      return requireBody(response.data).toDomain(userId: await userId);
    });
  }

  @override
  Future<SavedFilter> rename(int id, String name) => guardRequest(() async {
    final userId = _currentUser.id();
    final response = await _api.apiCustomFilterPartialUpdate(
      id: id,
      patchedCustomFilter: api.PatchedCustomFilter(
        (b) => b..name = name.trim(),
      ),
    );
    return requireBody(response.data).toDomain(userId: await userId);
  });

  @override
  Future<void> delete(int id) =>
      guardRequest(() => _api.apiCustomFilterDestroy(id: id));
}
