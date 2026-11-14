import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../domain/models/cooking_progress.dart';
import '../../platform/local_store/local_store.dart';

part 'cooking_providers.g.dart';

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.
@Riverpod(keepAlive: true)
class WakeLockHintShown extends _$WakeLockHintShown {
  @override
  bool build() => false;

  void markShown() => state = true;
}

/// The ingredients ticked off while cooking [recipeId], kept in the
/// [LocalStore] so they survive paging and a reload. Expired progress, of
/// this or any other recipe, is dropped when cooking mode opens.
@riverpod
class CookingProgressController extends _$CookingProgressController {
  static const _prefix = 'cooking-progress.';

  LocalStore get _store => ref.read(localStoreProvider);
  DateTime _now() => ref.read(clockProvider)();
  String get _key => '$_prefix$recipeId';

  @override
  CookingProgress build(int recipeId) {
    final now = _now();
    for (final key in _store.keys.where((k) => k.startsWith(_prefix))) {
      final saved = CookingProgress.fromJson(_store.read(key) ?? '');
      if (saved == null || saved.isExpired(now)) _store.delete(key);
    }
    final saved = _store.read(_key);
    return (saved == null ? null : CookingProgress.fromJson(saved)) ??
        CookingProgress.empty(now);
  }

  void toggle(IngredientOccurrence occurrence) {
    state = state.toggle(occurrence, _now());
    _store.write(_key, state.toJson());
  }

  /// Forgets the progress, after "Fertig".
  void clear() {
    _store.delete(_key);
    state = CookingProgress.empty(_now());
  }
}
