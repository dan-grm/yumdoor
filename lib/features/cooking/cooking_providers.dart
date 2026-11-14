import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/cooking_progress_store.dart';
import '../../app/platform_providers.dart';
import '../../domain/models/cooking_progress.dart';
import '../../domain/models/cooking_timer.dart';
import '../../platform/timers/timer_alert_service.dart';

part 'cooking_providers.g.dart';

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.
@Riverpod(keepAlive: true)
class WakeLockHintShown extends _$WakeLockHintShown {
  @override
  bool build() => false;

  void markShown() => state = true;
}

/// Whether cooking mode already said, in this app session, that timers can't
/// alert while the app is in the background.
@Riverpod(keepAlive: true)
class TimerBackgroundHintShown extends _$TimerBackgroundHintShown {
  @override
  bool build() => false;

  /// Whether the hint should show now; true only the first time.
  bool tryMark() {
    if (state) return false;
    state = true;
    return true;
  }
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

  bool _forgotten = false;

  void toggle(IngredientOccurrence occurrence) {
    state = state.toggle(occurrence, _now());
    if (!_forgotten) _store.write(recipeId, state);
  }

  /// Forgets the saved progress, after "Fertig". The ticks stay on screen
  /// while it closes, and a tap meanwhile isn't saved anymore.
  void forget() {
    _forgotten = true;
    _store.delete(recipeId);
  }
}

/// The timers running while cooking [recipeId], saved so they survive paging
/// and a reload. Cooking mode keeps it alive while open and calls [tick]
/// every second.
@riverpod
class CookingTimersController extends _$CookingTimersController {
  CookingProgressStore get _store => ref.read(cookingProgressStoreProvider);
  TimerAlertService get _alerts => ref.read(timerAlertServiceProvider);
  DateTime _now() => ref.read(clockProvider)();
  bool _forgotten = false;

  @override
  List<CookingTimer> build(int recipeId) => _store.readTimers(recipeId, _now());

  void _set(List<CookingTimer> timers) {
    state = timers;
    if (!_forgotten) _store.writeTimers(recipeId, timers, _now());
  }

  void _update(String id, CookingTimer Function(CookingTimer) change) =>
      _set([for (final timer in state) timer.id == id ? change(timer) : timer]);

  /// Starts a timer, from the user's tap: also prepares the alerts (unlocks
  /// audio, asks for notifications the first time). Returns what alerts can
  /// do, once the user has answered.
  Future<TimerAlertCapabilities> start({
    required String label,
    required Duration duration,
    int? stepId,
  }) {
    final now = _now();
    _set([
      ...state,
      CookingTimer.start(
        id: '${now.microsecondsSinceEpoch}',
        label: label,
        duration: duration,
        now: now,
        stepId: stepId,
      ),
    ]);
    return _alerts.prepare();
  }

  void pause(String id) => _update(id, (t) => t.pause(_now()));

  void resume(String id) => _update(id, (t) => t.resume(_now()));

  void addMinute(String id) =>
      _update(id, (t) => t.extend(const Duration(minutes: 1), _now()));

  /// Cancels a running timer, or turns off a finished one.
  void remove(String id) {
    _set([
      for (final timer in state)
        if (timer.id != id) timer,
    ]);
    final now = _now();
    if (!state.any((timer) => timer.isFinished(now))) {
      unawaited(_alerts.dismissAlerts());
    }
  }

  /// Alerts for every finished timer that is due ([CookingTimer.needsAlert]);
  /// [title] and [body] word the notification.
  Future<void> tick({
    required String Function(CookingTimer timer) title,
    required String body,
  }) async {
    final now = _now();
    final due = [
      for (final timer in state)
        if (timer.needsAlert(now)) timer,
    ];
    if (due.isEmpty) return;
    _set([
      for (final timer in state)
        due.contains(timer) ? timer.alerted(now) : timer,
    ]);
    for (final timer in due) {
      await _alerts.alert(title: title(timer), body: body, tag: timer.id);
    }
  }

  /// "Fertig": forgets the timers; they stay on screen while it closes.
  void forget() {
    _forgotten = true;
    _store.writeTimers(recipeId, const [], _now());
    unawaited(_alerts.dismissAlerts());
  }
}
