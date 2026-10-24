import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'platform_providers.dart';

part 'offline.g.dart';

/// Whether the app is offline: the platform reports no network, or the last
/// request couldn't reach the server.
///
/// While offline, the app shows cached recipes and disables write actions.
/// Any answer from the server, or the network coming back, ends it.
@Riverpod(keepAlive: true)
class IsOffline extends _$IsOffline {
  var _unreachable = false;

  @override
  bool build() {
    final connectivity = ref.watch(connectivityServiceProvider);
    final subscription = connectivity.onlineChanges.listen((online) {
      // A new network is worth trying the server again.
      if (online) _unreachable = false;
      state = _offline;
    });
    ref.onDispose(() => unawaited(subscription.cancel()));
    return _offline;
  }

  bool get _offline =>
      !ref.read(connectivityServiceProvider).isOnline || _unreachable;

  /// Called after each request with whether the server answered.
  void reportServerReachable(bool reachable) {
    _unreachable = !reachable;
    state = _offline;
  }
}
