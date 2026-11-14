import 'dart:async';

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
    this.permissionAnswer,
  });

  /// Completes when the user answers the prompt; right away if `null`.
  final Future<void>? permissionAnswer;

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
  final notifications = <(String, String, String)>[];

  /// A sound channel that never answers, like a browser promise left
  /// pending.
  bool soundHangs = false;

  @override
  Future<void> unlockSound() async => unlocks++;

  @override
  Future<void> playChime() {
    if (soundHangs) return Completer<void>().future;
    if (soundFails) throw StateError('audio blocked');
    chimes++;
    return Future.value();
  }

  @override
  Future<void> vibrate() async {
    if (vibrationFails) throw StateError('vibration refused');
    vibrations++;
  }

  @override
  Future<void> requestNotificationPermission() async {
    permissionRequests++;
    await permissionAnswer;
    notificationAccess = answer;
  }

  int closes = 0;

  @override
  Future<void> closeNotifications({String? tag}) async {
    closes++;
    notifications.removeWhere((n) => tag == null || n.$3 == tag);
  }

  @override
  Future<void> showNotification(String title, String body, String tag) async {
    if (notificationFails) throw StateError('notification failed');
    notifications.add((title, body, tag));
  }
}
