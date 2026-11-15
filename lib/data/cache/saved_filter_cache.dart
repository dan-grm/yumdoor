import 'package:drift/drift.dart';

import '../../domain/models/saved_filter.dart';
import '../mappers/saved_filter_mapper.dart';
import 'cache_database.dart';

/// The user's saved searches in the [CacheDatabase], as last listed. Cleared
/// with the rest of the cache (`RecipeCache.clear`).
class SavedFilterCache {
  SavedFilterCache(this._db);

  final CacheDatabase _db;

  /// Replaces the stored list with [filters].
  Future<void> putAll(List<SavedFilter> filters) => _db.transaction(() async {
    await _db.delete(_db.cachedSavedFilters).go();
    await _db.batch(
      (batch) => batch.insertAll(_db.cachedSavedFilters, [
        for (final (position, filter) in filters.indexed)
          CachedSavedFiltersCompanion.insert(
            id: Value(filter.id),
            name: filter.name,
            search: Value(switch (filter.query) {
              final query? => savedSearchJson(query),
              null => null,
            }),
            own: filter.own,
            position: position,
          ),
      ]),
    );
  });

  /// The stored list, in its order; empty if nothing is stored.
  Future<List<SavedFilter>> all() async {
    final query = _db.select(_db.cachedSavedFilters)
      ..orderBy([(f) => OrderingTerm.asc(f.position)]);
    return [
      for (final row in await query.get())
        SavedFilter(
          id: row.id,
          name: row.name,
          query: switch (row.search) {
            final search? => savedSearchQuery(search),
            null => null,
          },
          own: row.own,
        ),
    ];
  }
}
