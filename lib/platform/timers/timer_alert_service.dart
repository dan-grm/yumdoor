import 'alert_channels_stub.dart'
    if (dart.library.js_interop) 'alert_channels_web.dart';

/// Alerts the cook when a timer finishes: a chime, vibration and, while the
/// app is in the background, a system notification (docs/ARCHITECTURE.md,
/// Platform abstraction).
///
/// Each channel may be missing or refused; the service uses what is there and
/// reports what it can do, so the UI can say once when background alerts
/// aren't possible. Timers themselves (end times, ticking) live elsewhere;
/// this only signals.
abstract interface class TimerAlertService {
  /// The service for the current platform.
  factory TimerAlertService() =>
      ChannelTimerAlertService(PlatformAlertChannels());

  /// What the platform offers right now.
  TimerAlertCapabilities get capabilities;

  /// Call whenever a timer starts, from the user's tap, without awaiting it
  /// before the timer runs: unlocks audio (again, if the platform suspended
  /// it) and asks for notification permission once, if it was never
  /// answered. Browsers allow both only during a gesture. Resolves when the
  /// user has answered the prompt.
  Future<TimerAlertCapabilities> prepare();

  /// Signals a finished timer on every channel that works, at the same time,
  /// and returns which ones did. The notification is only shown while the app
  /// is hidden; in the foreground the screen itself shows the finished timer.
  /// [tag] identifies the timer, so two finished timers get two
  /// notifications.
  Future<TimerAlertOutcome> alert({
    required String title,
    required String body,
    required String tag,
  });

  /// Closes the notifications of finished timers, once the cook is back in
  /// the app; they stay until then.
  Future<void> dismissAlerts();
}

/// [TimerAlertService] over the [AlertChannels] of a platform. The fallback
/// logic is plain Dart, so it is unit-tested with fake channels.
class ChannelTimerAlertService implements TimerAlertService {
  ChannelTimerAlertService(
    this._channels, {
    this.channelTimeout = const Duration(seconds: 5),
  });

  final AlertChannels _channels;
  Future<bool>? _permission;

  /// How long one channel may take. Browsers can leave audio or permission
  /// promises pending (no user gesture), which must not block the rest.
  final Duration channelTimeout;

  @override
  TimerAlertCapabilities get capabilities => TimerAlertCapabilities(
    sound: _channels.canPlaySound,
    vibration: _channels.canVibrate,
    notifications: _channels.notificationAccess,
    backgroundAlerts:
        _channels.notificationAccess == NotificationAccess.granted &&
        _channels.runsInBackground,
  );

  @override
  Future<TimerAlertCapabilities> prepare() async {
    // Both start right away, while the tap still counts as a user gesture:
    // Safari ignores a permission request made after an await. The prompt
    // has no timeout; the user may take their time.
    if (_channels.notificationAccess == NotificationAccess.notAsked) {
      _permission ??= _attempt(
        _channels.requestNotificationPermission,
        timed: false,
      );
    }
    await Future.wait([?_permission, _attempt(_channels.unlockSound)]);
    return capabilities;
  }

  @override
  Future<void> dismissAlerts() => _attempt(_channels.closeNotifications);

  @override
  Future<TimerAlertOutcome> alert({
    required String title,
    required String body,
    required String tag,
  }) async {
    // At the same time, so a slow channel can't hold up the others.
    final notify =
        !_channels.isVisible &&
        _channels.notificationAccess == NotificationAccess.granted;
    final [sound, vibration, notification] = await Future.wait([
      _channels.canPlaySound ? _attempt(_channels.playChime) : _no(),
      _channels.canVibrate ? _attempt(_channels.vibrate) : _no(),
      notify
          ? _attempt(() => _channels.showNotification(title, body, tag))
          : _no(),
    ]);
    return TimerAlertOutcome(
      sound: sound,
      vibration: vibration,
      notification: notification,
    );
  }

  static Future<bool> _no() async => false;

  /// Runs [action]; a channel that throws, or (if [timed]) hangs for longer
  /// than [channelTimeout], counts as not delivered.
  Future<bool> _attempt(
    Future<void> Function() action, {
    bool timed = true,
  }) async {
    try {
      final done = action();
      await (timed ? done.timeout(channelTimeout) : done);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Whether the user allows system notifications.
enum NotificationAccess {
  /// Never asked; [TimerAlertService.prepare] asks.
  notAsked,
  granted,
  denied,

  /// The platform has no notifications.
  unsupported,
}

/// What [TimerAlertService] can do on this device.
class TimerAlertCapabilities {
  const TimerAlertCapabilities({
    required this.sound,
    required this.vibration,
    required this.notifications,
    required this.backgroundAlerts,
  });

  final bool sound;
  final bool vibration;
  final NotificationAccess notifications;

  /// Whether a timer can still alert while the app is in the background or
  /// the screen is off. Not on mobile browsers and home-screen apps, which
  /// suspend or freeze hidden pages; only on desktop.
  final bool backgroundAlerts;

  @override
  bool operator ==(Object other) =>
      other is TimerAlertCapabilities &&
      other.sound == sound &&
      other.vibration == vibration &&
      other.notifications == notifications &&
      other.backgroundAlerts == backgroundAlerts;

  @override
  int get hashCode =>
      Object.hash(sound, vibration, notifications, backgroundAlerts);

  @override
  String toString() =>
      'TimerAlertCapabilities(sound: $sound, vibration: $vibration, '
      'notifications: $notifications, backgroundAlerts: $backgroundAlerts)';
}

/// Which channels delivered an alert.
class TimerAlertOutcome {
  const TimerAlertOutcome({
    required this.sound,
    required this.vibration,
    required this.notification,
  });

  final bool sound;
  final bool vibration;
  final bool notification;

  /// Nothing reached the cook; the UI is the only signal left.
  bool get silent => !sound && !vibration && !notification;

  @override
  String toString() =>
      'TimerAlertOutcome(sound: $sound, vibration: $vibration, '
      'notification: $notification)';
}

/// The low-level channels of one platform. Implementations may throw from
/// any action; [ChannelTimerAlertService] treats that as "not delivered".
abstract interface class AlertChannels {
  bool get canPlaySound;
  bool get canVibrate;
  NotificationAccess get notificationAccess;

  /// Whether the app keeps running (and can alert) while in the background.
  /// Mobile browsers suspend or freeze hidden pages, so only desktop does.
  bool get runsInBackground;

  /// Whether the cook is looking at the app: visible and focused. A window
  /// covered by another app may still count as visible, but not focused.
  bool get isVisible;

  Future<void> unlockSound();
  Future<void> playChime();
  Future<void> vibrate();
  Future<void> requestNotificationPermission();
  Future<void> showNotification(String title, String body, String tag);

  /// Closes the notifications [showNotification] put up.
  Future<void> closeNotifications();
}
