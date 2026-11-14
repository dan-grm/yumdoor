import 'package:yumdoor/platform/timers/timer_alert_service.dart';

/// [AlertChannels] for tests: each channel can be missing ([canPlaySound],
/// …), or present but failing ([soundFails], …). Records what was used.
class FakeAlertChannels implements AlertChannels {
  FakeAlertChannels({
    this.canPlaySound = true,
    this.canVibrate = true,
    this.notificationAccess = NotificationAccess.notAsked,
    this.answer = NotificationAccess.granted,
    this.runsInBackground = true,
    this.isVisible = true,
  });

  @override
  bool canPlaySound;
  @override
  bool canVibrate;
  @override
  NotificationAccess notificationAccess;
  @override
  bool runsInBackground;
  @override
  bool isVisible;

  /// What the user answers to the permission prompt.
  NotificationAccess answer;

  bool soundFails = false;
  bool vibrationFails = false;
  bool notificationFails = false;

  int unlocks = 0;
  int chimes = 0;
  int vibrations = 0;
  int permissionRequests = 0;
  final notifications = <(String, String)>[];

  @override
  Future<void> unlockSound() async => unlocks++;

  @override
  Future<void> playChime() async {
    if (soundFails) throw StateError('audio blocked');
    chimes++;
  }

  @override
  Future<void> vibrate() async {
    if (vibrationFails) throw StateError('vibration refused');
    vibrations++;
  }

  @override
  Future<void> requestNotificationPermission() async {
    permissionRequests++;
    notificationAccess = answer;
  }

  @override
  Future<void> showNotification(String title, String body) async {
    if (notificationFails) throw StateError('notification failed');
    notifications.add((title, body));
  }
}
