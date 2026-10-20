import 'wake_lock_service_stub.dart'
    if (dart.library.js_interop) 'wake_lock_service_web.dart';

/// Keeps the screen on while cooking.
///
/// [acquire] states the wish to keep the screen on until [release]; the
/// implementation reacquires the lock when the platform drops it (e.g. the
/// browser releases it whenever the tab is hidden).
abstract interface class WakeLockService {
  /// The wake lock for the current platform.
  factory WakeLockService() = PlatformWakeLockService;

  WakeLockStatus get status;

  /// Every change of [status].
  Stream<WakeLockStatus> get statusChanges;

  /// Requests the lock and returns the resulting [status].
  Future<WakeLockStatus> acquire();

  Future<void> release();

  void dispose();
}

enum WakeLockStatus {
  /// The screen stays on.
  active,

  /// Not requested, released, or dropped by the platform until the app is
  /// visible again.
  inactive,

  /// The platform has no wake lock; cooking mode shows a hint instead.
  unsupported,

  /// The platform refused the request (permissions policy, battery saver).
  denied,
}
