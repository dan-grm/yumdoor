import 'dart:async';

import 'package:yumdoor/platform/connectivity/connectivity_service.dart';

/// [ConnectivityService] for tests; switch it with [isOnline].
class FakeConnectivityService implements ConnectivityService {
  FakeConnectivityService({this._isOnline = true});

  final _changes = StreamController<bool>.broadcast(sync: true);
  bool _isOnline;

  @override
  bool get isOnline => _isOnline;

  set isOnline(bool online) {
    if (online == _isOnline) return;
    _isOnline = online;
    _changes.add(online);
  }

  @override
  Stream<bool> get onlineChanges => _changes.stream;

  @override
  void dispose() => unawaited(_changes.close());
}
