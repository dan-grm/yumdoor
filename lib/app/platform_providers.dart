import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../platform/connectivity/connectivity_service.dart';
import '../platform/token_store/secure_storage_token_store.dart';
import '../platform/token_store/token_store.dart';
import '../platform/wake_lock/wake_lock_service.dart';

part 'platform_providers.g.dart';

// Platform services for the whole app. Tests override these with the fakes in
// test/fakes/.

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureStorageTokenStore();

@Riverpod(keepAlive: true)
WakeLockService wakeLockService(Ref ref) {
  final service = WakeLockService();
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
}
