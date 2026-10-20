import 'dart:async';

import 'package:web/web.dart' as web;

import 'connectivity_service.dart';

/// `navigator.onLine` and the window's `online`/`offline` events.
///
/// Browsers report offline reliably (no network at all) but online loosely: a
/// captive portal or a dead router still counts as online.
class PlatformConnectivityService implements ConnectivityService {
  PlatformConnectivityService() {
    _subscriptions = [
      web.EventStreamProviders.onlineEvent
          .forTarget(web.window)
          .listen((_) => _set(true)),
      web.EventStreamProviders.offlineEvent
          .forTarget(web.window)
          .listen((_) => _set(false)),
    ];
  }

  final _changes = StreamController<bool>.broadcast();
  late final List<StreamSubscription<web.Event>> _subscriptions;
  bool _isOnline = web.window.navigator.onLine;

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get onlineChanges => _changes.stream;

  void _set(bool online) {
    if (online == _isOnline) return;
    _isOnline = online;
    _changes.add(online);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(_changes.close());
  }
}
