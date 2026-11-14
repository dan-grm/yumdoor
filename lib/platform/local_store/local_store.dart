import 'local_store_stub.dart'
    if (dart.library.js_interop) 'local_store_web.dart';

/// Small, non-sensitive app state that should survive a reload, such as the
/// ingredients ticked off in cooking mode. Keys are namespaced by the
/// implementation. Never put tokens or server content here.
abstract interface class LocalStore {
  /// The store for the current platform.
  factory LocalStore() = PlatformLocalStore;

  /// The value of [key], or `null` if there is none or the platform refuses
  /// access (private mode, storage disabled).
  String? read(String key);

  /// Stores [value]; does nothing if the platform refuses (quota, disabled).
  void write(String key, String value);

  void delete(String key);

  /// Every key written by the app, without the namespace.
  Iterable<String> get keys;
}
