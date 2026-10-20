import 'connectivity_service_stub.dart'
    if (dart.library.js_interop) 'connectivity_service_web.dart';

/// Whether the device has a network connection, as far as the platform knows.
///
/// "Online" only means a network is there, not that Tandoor answers: the
/// offline state also takes failed requests into account (#14).
abstract interface class ConnectivityService {
  /// The connectivity service for the current platform.
  factory ConnectivityService() = PlatformConnectivityService;

  bool get isOnline;

  /// Emits when [isOnline] changes.
  Stream<bool> get onlineChanges;

  void dispose();
}
