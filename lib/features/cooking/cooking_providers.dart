import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/cooking_progress_store.dart';
import '../../app/locale.dart';
import '../../app/platform_providers.dart';
import '../../app/session.dart';
import '../../domain/models/cooking_progress.dart';
import '../../domain/models/cooking_timer.dart';
import '../../l10n/l10n.dart';
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
/// and a reload.
///
/// Kept alive for the app's lifetime, with its own ticker, so a timer still
/// alerts after cooking mode was closed with ×: once a second while timers
/// run or have finished, it alerts for each finished one
/// ([CookingTimer.needsAlert]) until it is turned off.
@Riverpod(keepAlive: true)
class CookingTimersController extends _$CookingTimersController {
  CookingProgressStore get _store => ref.read(cookingProgressStoreProvider);
  DateTime _now() => ref.read(clockProvider)();

  TimerAlertService get _alerts => ref.read(timerAlertServiceProvider);
  Timer? _ticker;
  var _nextId = 0;
  var _watchers = 0;
  String? _recipeName;

  @override
  List<CookingTimer> build(int recipeId) {
    ref.onDispose(() {
      _ticker?.cancel();
      _ticker = null;
    });
    // Logout ends the timers too: the next login may be someone else.
    ref.listen(sessionControllerProvider, (previous, next) {
      if (previous?.value != null && next.value == null) forget();
    });
    final timers = _store.readTimers(recipeId, _now());
    _keepTicking(timers);
    return timers;
  }

  /// Cooking mode for this recipe is on screen (TimerBar): finished timers
  /// alert again every 30 s until turned off. Elsewhere in the app they alert
  /// once, since only cooking mode can turn them off.
  void attach({required String recipeName}) {
    _watchers++;
    _recipeName = recipeName;
  }

  void detach() => _watchers--;

  /// The notification text in the app's language; outside a widget, so from
  /// the chosen or device locale.
  AppLocalizations get _l10n => lookupAppLocalizations(
    ref.read(localeOverrideProvider) ??
        resolveLocale(PlatformDispatcher.instance.locales),
  );

  void _set(List<CookingTimer> timers) {
    state = timers;
    _store.writeTimers(recipeId, timers, _now());
    _keepTicking(timers);
  }

  /// Ticks only while something can change: a running or finished timer.
  void _keepTicking(List<CookingTimer> timers) {
    final now = _now();
    final active = timers.any((t) => !t.isPaused || t.isFinished(now));
    if (active && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
    } else if (!active) {
      _ticker?.cancel();
      _ticker = null;
    }
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
        // Unique across recipes too: it tags the timer's notification.
        id: '$recipeId-${now.microsecondsSinceEpoch}-${_nextId++}',
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

  /// One more minute; a finished timer runs again and its notification
  /// goes.
  void addMinute(String id) {
    _update(id, (t) => t.extend(const Duration(minutes: 1), _now()));
    unawaited(_alerts.dismissAlerts(tag: id));
  }

  /// Cancels a running timer, or turns off a finished one.
  void remove(String id) {
    _set([
      for (final timer in state)
        if (timer.id != id) timer,
    ]);
    unawaited(_alerts.dismissAlerts(tag: id));
  }

  /// Alerts, all at once, for every finished timer that is due.
  Future<void> tick() async {
    final now = _now();
    final repeat = _watchers > 0;
    final due = [
      for (final timer in state)
        if (timer.needsAlert(now, repeat: repeat)) timer,
    ];
    if (due.isEmpty) return;
    final alerts = _alerts;
    final l10n = _l10n;
    _set([
      for (final timer in state)
        due.contains(timer) ? timer.alerted(now) : timer,
    ]);
    await Future.wait([
      for (final timer in due)
        alerts.alert(
          title: l10n.timerChipFinished(timer.label),
          body: _recipeName ?? l10n.appTitle,
          tag: timer.id,
        ),
    ]);
  }

  /// "Fertig": the timers stop and are forgotten, with their notifications.
  void forget() {
    final alerts = _alerts;
    final ids = [for (final timer in state) timer.id];
    _set(const []);
    for (final id in ids) {
      unawaited(alerts.dismissAlerts(tag: id));
    }
  }
}

/// Brings back the saved timers of every recipe at app start, so they keep
/// alerting after a reload without opening cooking mode again.
@Riverpod(keepAlive: true)
int restoredTimers(Ref ref) {
  final now = ref.read(clockProvider)();
  final ids = ref.read(cookingProgressStoreProvider).recipesWithTimers(now);
  for (final id in ids) {
    ref.read(cookingTimersControllerProvider(id));
  }
  return ids.length;
}
