import 'connectivity_service.dart';

/// Native placeholder until the native builds use `connectivity_plus`: always
/// online, so only failed requests mark the app offline.
class PlatformConnectivityService implements ConnectivityService {
  @override
  bool get isOnline => true;

  @override
  Stream<bool> get onlineChanges => const Stream.empty();

  @override
  void dispose() {}
}
