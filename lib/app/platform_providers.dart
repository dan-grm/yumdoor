import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../platform/connectivity/connectivity_service.dart';
import '../platform/csrf/csrf_token_source.dart';
import '../platform/token_store/secure_storage_token_store.dart';
import '../platform/token_store/token_store.dart';
import '../platform/wake_lock/wake_lock_service.dart';

part 'platform_providers.g.dart';

// Platform services for the whole app. Tests override these with the fakes in
// test/fakes/.

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureStorageTokenStore();

@Riverpod(keepAlive: true)
CsrfTokenSource csrfTokenSource(Ref ref) => CsrfTokenSource();

/// In the web build, the origin the app is served from. Tandoor sends no CORS
/// headers, so it is the only origin whose Tandoor the app can reach
/// (docs/TANDOOR_API.md#cors-and-deployment). `null` in native apps.
@Riverpod(keepAlive: true)
Uri? webOrigin(Ref ref) => kIsWeb ? Uri.parse(Uri.base.origin) : null;

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
