import 'dart:async';

import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

/// [WakeLockService] for tests. [outcome] is what the platform grants on
/// [acquire]; [dropByPlatform] and [resume] play the browser hiding and
/// showing the tab.
class FakeWakeLockService implements WakeLockService {
  FakeWakeLockService({this.outcome = WakeLockStatus.active})
    : _status = outcome == WakeLockStatus.unsupported
          ? WakeLockStatus.unsupported
          : WakeLockStatus.inactive;

  WakeLockStatus outcome;
  final _changes = StreamController<WakeLockStatus>.broadcast(sync: true);
  WakeLockStatus _status;
  bool _wanted = false;

  @override
  WakeLockStatus get status => _status;

  @override
  Stream<WakeLockStatus> get statusChanges => _changes.stream;

  @override
  Future<WakeLockStatus> acquire() async {
    if (_status == WakeLockStatus.unsupported) return _status;
    _wanted = true;
    _set(outcome);
    return _status;
  }

  @override
  Future<void> release() async {
    _wanted = false;
    if (_status != WakeLockStatus.unsupported) _set(WakeLockStatus.inactive);
  }

  /// The platform released the lock, e.g. because the tab was hidden.
  void dropByPlatform() {
    if (_status == WakeLockStatus.active) _set(WakeLockStatus.inactive);
  }

  /// The app is visible again: the lock is reacquired if still wanted.
  void resume() {
    if (_wanted) _set(outcome);
  }

  void _set(WakeLockStatus status) {
    if (status == _status) return;
    _status = status;
    _changes.add(status);
  }

  @override
  void dispose() => unawaited(_changes.close());
}
