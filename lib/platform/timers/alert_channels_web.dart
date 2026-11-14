import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'timer_alert_service.dart';

/// Browser channels: a chime generated with Web Audio (no audio file, no
/// third-party request), `navigator.vibrate`, and the Notification API.
class PlatformAlertChannels implements AlertChannels {
  web.AudioContext? _audio;

  static JSObject get _window => web.window as JSObject;
  static JSObject get _navigator => web.window.navigator as JSObject;

  @override
  bool get canPlaySound =>
      _window.has('AudioContext') || _window.has('webkitAudioContext');

  @override
  bool get canVibrate => _navigator.has('vibrate');

  @override
  NotificationAccess get notificationAccess {
    if (!_window.has('Notification')) return NotificationAccess.unsupported;
    return switch (web.Notification.permission) {
      'granted' => NotificationAccess.granted,
      'denied' => NotificationAccess.denied,
      _ => NotificationAccess.notAsked,
    };
  }

  /// iOS suspends home-screen apps and background tabs, so a timer can't
  /// fire there until the app is opened again. iPadOS reports itself as a
  /// Mac, but with touch.
  @override
  bool get runsInBackground {
    final navigator = web.window.navigator;
    final agent = navigator.userAgent;
    final iOS =
        agent.contains('iPhone') ||
        agent.contains('iPad') ||
        (agent.contains('Macintosh') && navigator.maxTouchPoints > 1);
    return !iOS;
  }

  @override
  bool get isVisible => web.document.visibilityState == 'visible';

  web.AudioContext _context() => _audio ??= web.AudioContext();

  @override
  Future<void> unlockSound() async {
    if (!canPlaySound) return;
    final context = _context();
    if (context.state == 'suspended') await context.resume().toDart;
  }

  /// Three soft two-tone dings, about 1.5 s in all.
  @override
  Future<void> playChime() async {
    final context = _context();
    if (context.state == 'suspended') await context.resume().toDart;
    final start = context.currentTime + 0.05;
    for (var ding = 0; ding < 3; ding++) {
      final at = start + ding * 0.5;
      for (final (frequency, delay) in [(880.0, 0.0), (1318.5, 0.12)]) {
        final oscillator = context.createOscillator()..type = 'sine';
        oscillator.frequency.value = frequency;
        final gain = context.createGain();
        gain.gain
          ..setValueAtTime(0.0001, at + delay)
          ..exponentialRampToValueAtTime(0.3, at + delay + 0.02)
          ..exponentialRampToValueAtTime(0.0001, at + delay + 0.4);
        oscillator
          ..connect(gain)
          ..start(at + delay)
          ..stop(at + delay + 0.45);
        gain.connect(context.destination);
      }
    }
  }

  @override
  Future<void> vibrate() async {
    final pattern = [400, 150, 400, 150, 400].map((ms) => ms.toJS).toList();
    if (!web.window.navigator.vibrate(pattern.toJS)) {
      throw StateError('vibration refused');
    }
  }

  @override
  Future<void> requestNotificationPermission() async {
    await web.Notification.requestPermission().toDart;
  }

  /// Through the service worker where there is one: Android's Chrome only
  /// allows notifications from a service worker, `new Notification()` throws
  /// there. Clicking it focuses the app (web/service_worker.js).
  @override
  Future<void> showNotification(String title, String body) async {
    final options = web.NotificationOptions(
      body: body,
      tag: 'yumdoor-timer',
      renotify: true,
      requireInteraction: true,
    );
    final container = web.window.navigator.serviceWorker;
    if (_navigator.has('serviceWorker') && container.controller != null) {
      final registration = await container.ready.toDart;
      await registration.showNotification(title, options).toDart;
      return;
    }
    web.Notification(title, options);
  }
}
