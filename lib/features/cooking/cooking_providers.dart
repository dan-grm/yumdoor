import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/platform_providers.dart';
import '../../domain/models/cooking_progress.dart';
import '../../app/cooking_progress_store.dart';

part 'cooking_providers.g.dart';

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.
@Riverpod(keepAlive: true)
class WakeLockHintShown extends _$WakeLockHintShown {
  @override
  bool build() => false;

  void markShown() => state = true;
}

/// The ingredients ticked off while cooking [recipeId], saved so they survive
/// paging and a reload. Cooking mode watches it while open, so a failed save
/// still keeps the ticks in memory until the screen closes.
@riverpod
class CookingProgressController extends _$CookingProgressController {
  CookingProgressStore get _store => ref.read(cookingProgressStoreProvider);
  DateTime _now() => ref.read(clockProvider)();

  @override
  CookingProgress build(int recipeId) {
    final now = _now();
    _store.prune(now);
    return _store.read(recipeId, now) ?? CookingProgress.empty(now);
  }

  void toggle(IngredientOccurrence occurrence) {
    state = state.toggle(occurrence, _now());
    _store.write(recipeId, state);
  }

  /// Forgets the saved progress, after "Fertig". The ticks stay on screen
  /// while it closes.
  void forget() => _store.delete(recipeId);
}
