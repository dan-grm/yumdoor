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
class TimerAlertService {
  TimerAlertService.withChannels(this._channels);

  /// The service for the current platform.
  factory TimerAlertService() =>
      TimerAlertService.withChannels(PlatformAlertChannels());

  final AlertChannels _channels;
  bool _prepared = false;

  /// What the platform offers right now.
  TimerAlertCapabilities get capabilities => TimerAlertCapabilities(
    sound: _channels.canPlaySound,
    vibration: _channels.canVibrate,
    notifications: _channels.notificationAccess,
    backgroundAlerts:
        _channels.notificationAccess == NotificationAccess.granted &&
        _channels.runsInBackground,
  );

  /// Call when the first timer starts, from the user's tap: unlocks audio
  /// (browsers only allow it after a gesture) and asks for notification
  /// permission once, if it was never answered. Later calls do nothing.
  Future<TimerAlertCapabilities> prepare() async {
    if (!_prepared) {
      _prepared = true;
      await _attempt(_channels.unlockSound);
      if (_channels.notificationAccess == NotificationAccess.notAsked) {
        await _attempt(_channels.requestNotificationPermission);
      }
    }
    return capabilities;
  }

  /// Signals a finished timer on every channel that works, and returns which
  /// ones did. The notification is only shown while the app is hidden; in
  /// the foreground the screen itself shows the finished timer.
  Future<TimerAlertOutcome> alert({
    required String title,
    required String body,
  }) async {
    final sound = _channels.canPlaySound && await _attempt(_channels.playChime);
    final vibration = _channels.canVibrate && await _attempt(_channels.vibrate);
    final notification =
        !_channels.isVisible &&
        _channels.notificationAccess == NotificationAccess.granted &&
        await _attempt(() => _channels.showNotification(title, body));
    return TimerAlertOutcome(
      sound: sound,
      vibration: vibration,
      notification: notification,
    );
  }

  /// Runs [action]; a channel that throws counts as not delivered.
  static Future<bool> _attempt(Future<void> Function() action) async {
    try {
      await action();
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
  /// the screen is off. Not on iOS home-screen apps, which are suspended.
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
/// any action; [TimerAlertService] treats that as "not delivered".
abstract interface class AlertChannels {
  bool get canPlaySound;
  bool get canVibrate;
  NotificationAccess get notificationAccess;

  /// Whether the app keeps running (and can alert) while in the background.
  bool get runsInBackground;

  /// Whether the app is in the foreground.
  bool get isVisible;

  Future<void> unlockSound();
  Future<void> playChime();
  Future<void> vibrate();
  Future<void> requestNotificationPermission();
  Future<void> showNotification(String title, String body);
}
