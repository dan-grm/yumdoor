import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/cooking_progress.dart';
import '../platform/local_store/local_store.dart';
import 'platform_providers.dart';

part 'cooking_progress_store.g.dart';

/// Saved [CookingProgress] per recipe in the [LocalStore].
///
/// Keyed by recipe id only, so it is cleared on logout: the next login may be
/// someone else, or another server.
class CookingProgressStore {
  CookingProgressStore(this._store);

  final LocalStore _store;

  static const _prefix = 'cooking-progress.';

  Iterable<String> get _keys => _store.keys.where((k) => k.startsWith(_prefix));

  /// The saved progress of [recipeId], `null` if none, unreadable or expired.
  CookingProgress? read(int recipeId, DateTime now) {
    final saved = _store.read('$_prefix$recipeId');
    final progress = saved == null ? null : CookingProgress.fromJson(saved);
    return progress == null || progress.isExpired(now) ? null : progress;
  }

  void write(int recipeId, CookingProgress progress) =>
      _store.write('$_prefix$recipeId', progress.toJson());

  void delete(int recipeId) => _store.delete('$_prefix$recipeId');

  /// Drops the progress of every recipe that is unreadable or expired.
  void prune(DateTime now) {
    for (final key in _keys.toList()) {
      final saved = CookingProgress.fromJson(_store.read(key) ?? '');
      if (saved == null || saved.isExpired(now)) _store.delete(key);
    }
  }

  /// Drops all progress, on logout.
  void clear() => _keys.toList().forEach(_store.delete);
}

@Riverpod(keepAlive: true)
CookingProgressStore cookingProgressStore(Ref ref) =>
    CookingProgressStore(ref.watch(localStoreProvider));
