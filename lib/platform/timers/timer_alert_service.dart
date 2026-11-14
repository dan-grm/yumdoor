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

  /// Call when the first timer starts, from the user's tap: asks for
  /// notification permission once, if it was never answered, and unlocks
  /// audio (browsers only allow both after a gesture). Later calls return
  /// the first call's result.
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
}

/// [TimerAlertService] over the [AlertChannels] of a platform. The fallback
/// logic is plain Dart, so it is unit-tested with fake channels.
class ChannelTimerAlertService implements TimerAlertService {
  ChannelTimerAlertService(
    this._channels, {
    this.channelTimeout = const Duration(seconds: 5),
  });

  final AlertChannels _channels;
  Future<TimerAlertCapabilities>? _prepared;

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
  Future<TimerAlertCapabilities> prepare() => _prepared ??= _prepare();

  Future<TimerAlertCapabilities> _prepare() async {
    // Both start right away, while the tap still counts as a user gesture:
    // Safari ignores a permission request made after an await.
    await Future.wait([
      if (_channels.notificationAccess == NotificationAccess.notAsked)
        _attempt(_channels.requestNotificationPermission),
      _attempt(_channels.unlockSound),
    ]);
    return capabilities;
  }

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

  /// Runs [action]; a channel that throws, or hangs for longer than
  /// [channelTimeout], counts as not delivered.
  Future<bool> _attempt(Future<void> Function() action) async {
    try {
      await action().timeout(channelTimeout);
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

  /// Whether the app is in the foreground.
  bool get isVisible;

  Future<void> unlockSound();
  Future<void> playChime();
  Future<void> vibrate();
  Future<void> requestNotificationPermission();
  Future<void> showNotification(String title, String body, String tag);
}
