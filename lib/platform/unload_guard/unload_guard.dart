import 'unload_guard_stub.dart'
    if (dart.library.js_interop) 'unload_guard_web.dart';

/// Asks before the app is closed or reloaded while there are unsaved
/// changes.
///
/// On the web, while [active], closing or reloading the tab shows the
/// browser's own "Leave site?" prompt; its text can't be changed. Native apps
/// have nothing to ask (the editor's draft is kept on the device instead).
abstract interface class UnloadGuard {
  /// The guard for the current platform.
  factory UnloadGuard() = PlatformUnloadGuard;

  /// Whether leaving the app asks first.
  bool get active;
  set active(bool value);

  void dispose();
}
