import 'dart:async';

import 'wake_lock_service.dart';

/// Native placeholder until the native builds use `wakelock_plus`: reports
/// [WakeLockStatus.unsupported].
class PlatformWakeLockService implements WakeLockService {
  @override
  WakeLockStatus get status => WakeLockStatus.unsupported;

  @override
  Stream<WakeLockStatus> get statusChanges => const Stream.empty();

  @override
  Future<WakeLockStatus> acquire() async => status;

  @override
  Future<void> release() async {}

  @override
  void dispose() {}
}
