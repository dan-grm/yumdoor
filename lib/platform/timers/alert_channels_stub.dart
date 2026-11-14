import 'timer_alert_service.dart';

/// Native placeholder until the native builds land (local notifications are
/// planned there): no channel is available.
class PlatformAlertChannels implements AlertChannels {
  @override
  bool get canPlaySound => false;

  @override
  bool get canVibrate => false;

  @override
  NotificationAccess get notificationAccess => NotificationAccess.unsupported;

  @override
  bool get runsInBackground => false;

  @override
  bool get isVisible => true;

  @override
  Future<void> unlockSound() async {}

  @override
  Future<void> playChime() => throw UnsupportedError('no sound');

  @override
  Future<void> vibrate() => throw UnsupportedError('no vibration');

  @override
  Future<void> requestNotificationPermission() async {}

  @override
  Future<void> closeNotifications({String? tag}) async {}

  @override
  Future<void> showNotification(String title, String body, String tag) =>
      throw UnsupportedError('no notifications');
}
