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

  /// Only the standard `AudioContext`; the old prefixed one isn't used.
  @override
  bool get canPlaySound => _window.has('AudioContext');

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

  /// iOS suspends home-screen apps and background tabs, and Android's
  /// Chrome freezes them after a few minutes, so a timer can't fire there
  /// until the app is opened again. iPadOS reports itself as a Mac, but with
  /// touch. Browsers offer no capability check for this, so it goes by the
  /// user agent; a tablet in "desktop mode" is taken for a desktop.
  @override
  bool get runsInBackground {
    final navigator = web.window.navigator;
    final agent = navigator.userAgent;
    final mobile =
        agent.contains('iPhone') ||
        agent.contains('iPad') ||
        agent.contains('Android') ||
        agent.contains('Mobile') ||
        (agent.contains('Macintosh') && navigator.maxTouchPoints > 1);
    return !mobile;
  }

  @override
  bool get isVisible =>
      web.document.visibilityState == 'visible' && web.document.hasFocus();

  /// A closed context can't be resumed; a new one is made.
  web.AudioContext _context() {
    final audio = _audio;
    if (audio != null && audio.state != 'closed') return audio;
    return _audio = web.AudioContext();
  }

  @override
  Future<void> unlockSound() async {
    if (canPlaySound) await _running();
  }

  /// The audio context, resumed. Throws if it doesn't run: without a user
  /// gesture the browser keeps it suspended (and `resume()` may never
  /// settle), and iOS marks it `interrupted` after the app was in the
  /// background.
  Future<web.AudioContext> _running() async {
    final context = _context();
    if (context.state != 'running') {
      await context.resume().toDart.timeout(const Duration(seconds: 1));
    }
    if (context.state != 'running') {
      throw StateError('audio is ${context.state}');
    }
    return context;
  }

  /// Three soft two-tone dings, about 1.5 s in all.
  @override
  Future<void> playChime() async {
    final context = await _running();
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

  /// Through the service worker's registration where there is one, also
  /// when it doesn't control this page (yet, or after a hard reload):
  /// Android's Chrome only allows notifications from a service worker,
  /// `new Notification()` throws there. Clicking one focuses the app
  /// (web/service_worker.js, or the handler below).
  @override
  Future<void> showNotification(String title, String body, String tag) async {
    final options = web.NotificationOptions(
      body: body,
      tag: _tag(tag),
      renotify: true,
      requireInteraction: true,
    );
    if (_navigator.has('serviceWorker')) {
      final registration = await web.window.navigator.serviceWorker
          .getRegistration()
          .toDart;
      if (registration != null) {
        await registration.showNotification(title, options).toDart;
        return;
      }
    }
    // A re-alert replaces the timer's earlier notification.
    for (final old in _shown.where((n) => n.tag == _tag(tag)).toList()) {
      old.close();
      _shown.remove(old);
    }
    final notification = web.Notification(title, options);
    _shown.add(notification);
    notification.onclick = (web.Event _) {
      web.window.focus();
      notification.close();
    }.toJS;
  }

  /// Notifications shown without a service worker.
  final _shown = <web.Notification>[];

  static String _tag(String tag) => 'yumdoor-timer-$tag';

  @override
  Future<void> closeNotifications({String? tag}) async {
    bool ours(web.Notification notification) => tag == null
        ? notification.tag.startsWith(_tag(''))
        : notification.tag == _tag(tag);
    for (final notification in _shown.where(ours).toList()) {
      notification.close();
      _shown.remove(notification);
    }
    if (!_navigator.has('serviceWorker')) return;
    final registration = await web.window.navigator.serviceWorker
        .getRegistration()
        .toDart;
    if (registration == null) return;
    final open = await registration.getNotifications().toDart;
    for (final notification in open.toDart.where(ours)) {
      notification.close();
    }
  }
}
