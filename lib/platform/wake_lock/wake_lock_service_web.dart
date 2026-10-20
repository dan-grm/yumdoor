import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'wake_lock_service.dart';

/// Screen Wake Lock API.
///
/// Browsers release the lock whenever the page is hidden, so it is requested
/// again on `visibilitychange` while [acquire] is in effect. iOS home-screen
/// PWAs ignored the lock before iOS 18.4 according to WebKit's notes: the API
/// is there, but the screen still dims.
class PlatformWakeLockService implements WakeLockService {
  PlatformWakeLockService() {
    if (!_supported) {
      _status = WakeLockStatus.unsupported;
      return;
    }
    _visibility = web.CustomEventProviders.visibilityChangeEvent
        .forTarget(web.document)
        .listen((_) {
          if (_wanted && web.document.visibilityState == 'visible') {
            unawaited(_request());
          }
        });
  }

  static bool get _supported =>
      (web.window.navigator as JSObject).has('wakeLock');

  final _changes = StreamController<WakeLockStatus>.broadcast();
  StreamSubscription<web.Event>? _visibility;
  web.WakeLockSentinel? _sentinel;
  WakeLockStatus _status = WakeLockStatus.inactive;
  bool _wanted = false;

  @override
  WakeLockStatus get status => _status;

  @override
  Stream<WakeLockStatus> get statusChanges => _changes.stream;

  @override
  Future<WakeLockStatus> acquire() async {
    if (_status == WakeLockStatus.unsupported) return _status;
    _wanted = true;
    if (_sentinel == null || _sentinel!.released) await _request();
    return _status;
  }

  @override
  Future<void> release() async {
    _wanted = false;
    final sentinel = _sentinel;
    _sentinel = null;
    if (sentinel != null && !sentinel.released) {
      await sentinel.release().toDart;
    }
    if (_status != WakeLockStatus.unsupported) _set(WakeLockStatus.inactive);
  }

  Future<void> _request() async {
    try {
      final sentinel = await web.window.navigator.wakeLock
          .request('screen')
          .toDart;
      if (!_wanted) {
        // release() was called while the request was pending.
        await sentinel.release().toDart;
        return;
      }
      _sentinel = sentinel;
      sentinel.onrelease = (web.Event _) {
        if (identical(_sentinel, sentinel)) _set(WakeLockStatus.inactive);
      }.toJS;
      _set(WakeLockStatus.active);
    } catch (_) {
      // NotAllowedError. A hidden page is retried on the next
      // visibilitychange; a visible one was refused by the permissions policy
      // or battery saver.
      _set(
        web.document.visibilityState == 'visible'
            ? WakeLockStatus.denied
            : WakeLockStatus.inactive,
      );
    }
  }

  void _set(WakeLockStatus status) {
    if (status == _status) return;
    _status = status;
    _changes.add(status);
  }

  @override
  void dispose() {
    unawaited(release());
    unawaited(_visibility?.cancel());
    unawaited(_changes.close());
  }
}
