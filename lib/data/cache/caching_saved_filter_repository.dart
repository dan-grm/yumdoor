import 'dart:async';

import '../../core/failures.dart';
import '../../domain/models/recipe_query.dart';
import '../../domain/models/saved_filter.dart';
import '../../domain/repositories/saved_filter_repository.dart';
import 'saved_filter_cache.dart';

/// Lists saved searches from the server and keeps the last list in the
/// [SavedFilterCache], which answers when the server can't be reached
/// ([OfflineFailure]). Changes are only made online (offline is read-only).
class CachingSavedFilterRepository implements SavedFilterRepository {
  CachingSavedFilterRepository(this._remote, this._cache)
    : _epoch = _cache.epoch;

  final SavedFilterRepository _remote;
  final SavedFilterCache _cache;

  /// [SavedFilterCache.epoch] when this session started: once logout
  /// cleared the cache, nothing more is stored.
  final int _epoch;
  var _closed = false;

  /// Stops storing lists: the session ended, and logout clears the cache. A
  /// list that arrives later must not bring the old user's back.
  void close() => _closed = true;

  @override
  Future<List<SavedFilter>> savedFilters() async {
    final List<SavedFilter> filters;
    try {
      filters = await _remote.savedFilters();
    } on OfflineFailure {
      // Nothing stored yet: offline as before.
      final stored = await _readCache();
      if (stored == null || stored.isEmpty) rethrow;
      return stored;
    }
    if (!_closed) {
      unawaited(_ignoreErrors(_cache.putAll(filters, epoch: _epoch)));
    }
    return filters;
  }

  @override
  Future<SavedFilter> create(String name, RecipeQuery query) =>
      _remote.create(name, query);

  @override
  Future<SavedFilter> rename(int id, String name) => _remote.rename(id, name);

  @override
  Future<void> delete(int id) => _remote.delete(id);

  Future<List<SavedFilter>?> _readCache() async {
    try {
      return await _cache.all();
    } on Object {
      return null;
    }
  }
}

/// The cache is a convenience: when it fails, the app goes on without it.
Future<void> _ignoreErrors(Future<void> future) async {
  try {
    await future;
  } on Object {
    // Ignored.
  }
}
