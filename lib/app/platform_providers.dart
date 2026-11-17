import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../platform/connectivity/connectivity_service.dart';
import '../platform/csrf/csrf_token_source.dart';
import '../platform/image_picker/image_picker_service.dart';
import '../platform/link_opener/link_opener.dart';
import '../platform/local_store/local_store.dart';
import '../platform/timers/timer_alert_service.dart';
import '../platform/token_store/secure_storage_token_store.dart';
import '../platform/token_store/token_store.dart';
import '../platform/unload_guard/unload_guard.dart';
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

@Riverpod(keepAlive: true)
LinkOpener linkOpener(Ref ref) => LinkOpener();

@Riverpod(keepAlive: true)
ImagePickerService imagePickerService(Ref ref) {
  final service = ImagePickerService();
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
LocalStore localStore(Ref ref) => LocalStore();

/// The current time; tests override it to move the clock.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@Riverpod(keepAlive: true)
TimerAlertService timerAlertService(Ref ref) => TimerAlertService();

@Riverpod(keepAlive: true)
UnloadGuard unloadGuard(Ref ref) {
  final guard = UnloadGuard();
  ref.onDispose(guard.dispose);
  return guard;
}
