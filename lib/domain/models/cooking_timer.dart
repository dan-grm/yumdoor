/// A kitchen timer in cooking mode.
///
/// It stores when it ends, not a countdown, so the remaining time is right
/// after the browser suspended the tab or the page was reloaded: it is
/// recomputed from the clock on every tick. A paused timer stores its
/// remaining time instead.
class CookingTimer {
  const CookingTimer._({
    required this.id,
    required this.label,
    required this.duration,
    required this.startedWith,
    this.stepId,
    this.endsAt,
    this.pausedRemaining,
    this.lastAlertAt,
  }) : assert((endsAt == null) != (pausedRemaining == null));

  /// A timer of [duration] that runs from [now].
  factory CookingTimer.start({
    required String id,
    required String label,
    required Duration duration,
    required DateTime now,
    int? stepId,
  }) => CookingTimer._(
    id: id,
    label: label,
    duration: duration,
    startedWith: duration,
    stepId: stepId,
    endsAt: now.add(duration),
  );

  final String id;

  /// Short name on the chip: "Rösten", "Schritt 2", "Timer".
  final String label;

  /// The length it was started with, plus added minutes.
  final Duration duration;

  /// The length it was started with: which of a step's durations it is for.
  final Duration startedWith;

  /// The step whose time started it; `null` for a manual timer.
  final int? stepId;

  /// When it ends while running; `null` while paused.
  final DateTime? endsAt;

  /// What is left while paused; `null` while running.
  final Duration? pausedRemaining;

  /// When the cook was last alerted that it finished.
  final DateTime? lastAlertAt;

  bool get isPaused => pausedRemaining != null;

  /// Time left at [now], never negative.
  Duration remaining(DateTime now) {
    final left = pausedRemaining ?? endsAt!.difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  bool isFinished(DateTime now) => remaining(now) == Duration.zero;

  /// Stops the clock; does nothing if paused or finished.
  CookingTimer pause(DateTime now) => isPaused || isFinished(now)
      ? this
      : _copy(endsAt: null, pausedRemaining: remaining(now));

  /// Runs again from [now] with the time that was left.
  CookingTimer resume(DateTime now) => isPaused
      ? _copy(endsAt: now.add(pausedRemaining!), pausedRemaining: null)
      : this;

  /// Adds [extra]; a finished timer runs again for [extra] from [now].
  CookingTimer extend(Duration extra, DateTime now) {
    if (isPaused) {
      return _copy(
        duration: duration + extra,
        pausedRemaining: pausedRemaining! + extra,
        endsAt: null,
      );
    }
    final base = isFinished(now) ? now : endsAt!;
    return _copy(
      duration: duration + extra,
      endsAt: base.add(extra),
      pausedRemaining: null,
      lastAlertAt: null,
      clearAlert: true,
    );
  }

  /// Whether a finished timer should alert at [now]: right when it finishes,
  /// then, with [repeat], every [alertInterval] until it is dismissed.
  bool needsAlert(DateTime now, {bool repeat = true}) =>
      isFinished(now) &&
      (lastAlertAt == null ||
          (repeat && now.difference(lastAlertAt!) >= alertInterval));

  /// How often a finished timer alerts again.
  static const alertInterval = Duration(seconds: 30);

  CookingTimer alerted(DateTime now) => _copy(lastAlertAt: now);

  CookingTimer _copy({
    Duration? duration,
    Object? endsAt = _keep,
    Object? pausedRemaining = _keep,
    DateTime? lastAlertAt,
    bool clearAlert = false,
  }) => CookingTimer._(
    id: id,
    label: label,
    stepId: stepId,
    duration: duration ?? this.duration,
    startedWith: startedWith,
    endsAt: endsAt == _keep ? this.endsAt : endsAt as DateTime?,
    pausedRemaining: pausedRemaining == _keep
        ? this.pausedRemaining
        : pausedRemaining as Duration?,
    lastAlertAt: clearAlert ? null : lastAlertAt ?? this.lastAlertAt,
  );

  static const _keep = Object();

  Map<String, Object?> toJson() => {
    'id': id,
    'label': label,
    'stepId': stepId,
    'durationMs': duration.inMilliseconds,
    'startedWithMs': startedWith.inMilliseconds,
    'endsAt': endsAt?.toUtc().toIso8601String(),
    'pausedMs': pausedRemaining?.inMilliseconds,
    'lastAlertAt': lastAlertAt?.toUtc().toIso8601String(),
  };

  /// Reads what [toJson] wrote; `null` if it isn't that.
  static CookingTimer? fromJson(Object? json) {
    if (json case {
      'id': final String id,
      'label': final String label,
      'durationMs': final int durationMs,
    }) {
      final stepId = json['stepId'];
      final endsAt = _date(json['endsAt']);
      final paused = json['pausedMs'];
      // Saved before it was stored: the current length is the best guess.
      final startedWith = json['startedWithMs'];
      if ((endsAt == null) == (paused is! int)) return null;
      return CookingTimer._(
        id: id,
        label: label,
        stepId: stepId is int ? stepId : null,
        duration: Duration(milliseconds: durationMs),
        startedWith: Duration(
          milliseconds: startedWith is int ? startedWith : durationMs,
        ),
        endsAt: endsAt,
        pausedRemaining: paused is int ? Duration(milliseconds: paused) : null,
        lastAlertAt: _date(json['lastAlertAt']),
      );
    }
    return null;
  }

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;
}
