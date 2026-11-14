import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dart:convert';

import '../domain/models/cooking_progress.dart';
import '../domain/models/cooking_timer.dart';
import '../platform/local_store/local_store.dart';
import 'platform_providers.dart';

part 'cooking_progress_store.g.dart';

/// Saved [CookingProgress] and [CookingTimer]s per recipe in the
/// [LocalStore].
///
/// Keyed by recipe id only, so it is cleared on logout: the next login may be
/// someone else, or another server.
class CookingProgressStore {
  CookingProgressStore(this._store);

  final LocalStore _store;

  static const _prefix = 'cooking-progress.';
  static const _timersPrefix = 'cooking-timers.';

  Iterable<String> get _keys => _store.keys.where((k) => k.startsWith(_prefix));
  Iterable<String> get _timerKeys =>
      _store.keys.where((k) => k.startsWith(_timersPrefix));

  /// The saved progress of [recipeId], `null` if none, unreadable or expired.
  CookingProgress? read(int recipeId, DateTime now) {
    final saved = _store.read('$_prefix$recipeId');
    final progress = saved == null ? null : CookingProgress.fromJson(saved);
    return progress == null || progress.isExpired(now) ? null : progress;
  }

  void write(int recipeId, CookingProgress progress) =>
      _store.write('$_prefix$recipeId', progress.toJson());

  void delete(int recipeId) => _store.delete('$_prefix$recipeId');

  /// Drops the progress and timers of every recipe that are unreadable or
  /// expired.
  void prune(DateTime now) {
    for (final key in _keys.toList()) {
      final saved = CookingProgress.fromJson(_store.read(key) ?? '');
      if (saved == null || saved.isExpired(now)) _store.delete(key);
    }
    for (final key in _timerKeys.toList()) {
      if (_readTimers(key, now) == null) _store.delete(key);
    }
  }

  /// The saved timers of [recipeId]; empty once they were left alone for
  /// [CookingProgress.lifetime].
  List<CookingTimer> readTimers(int recipeId, DateTime now) =>
      _readTimers('$_timersPrefix$recipeId', now) ?? const [];

  List<CookingTimer>? _readTimers(String key, DateTime now) {
    try {
      if (jsonDecode(_store.read(key) ?? '') case {
        'savedAt': final String savedAt,
        'timers': final List<Object?> timers,
      }) {
        final saved = DateTime.tryParse(savedAt);
        if (saved == null ||
            now.difference(saved).abs() > CookingProgress.lifetime) {
          return null;
        }
        return [for (final json in timers) ?CookingTimer.fromJson(json)];
      }
    } on FormatException {
      // Unreadable.
    }
    return null;
  }

  /// Saves [timers]; an empty list removes the entry.
  void writeTimers(int recipeId, List<CookingTimer> timers, DateTime now) {
    final key = '$_timersPrefix$recipeId';
    if (timers.isEmpty) return _store.delete(key);
    _store.write(
      key,
      jsonEncode({
        'savedAt': now.toUtc().toIso8601String(),
        'timers': [for (final timer in timers) timer.toJson()],
      }),
    );
  }

  /// Drops all progress and timers, on logout.
  void clear() => [..._keys, ..._timerKeys].forEach(_store.delete);
}

@Riverpod(keepAlive: true)
CookingProgressStore cookingProgressStore(Ref ref) =>
    CookingProgressStore(ref.watch(localStoreProvider));
