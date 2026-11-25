import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'browser_history.dart';

/// Makes the browser's back (the back button, Android's back, the swipe from
/// the edge in the installed app on iOS) do what back does in the app: close
/// the screen on top, so it follows the page hierarchy (#98).
///
/// go_router asks the web engine for one browser history entry per change of
/// the location. Back then walks through every location seen, including ones
/// already closed: after "Fertig gekocht" and closing the cook log, back on
/// the recipe led into the cook log or cooking mode again instead of to the
/// list. With a single history entry, which Flutter uses for apps without a
/// router, the engine instead hands each browser back to the app as a system
/// back ([WidgetsBinding.handlePopRoute]), like Android's back button. The
/// address bar still shows the current location, so links and reloads work.
///
/// Call [ensureInitialized] in `main` before `runApp`. Only the web is
/// affected; elsewhere it is the plain [WidgetsFlutterBinding].
class AppBinding extends WidgetsFlutterBinding {
  AppBinding._(this._history);

  final BrowserHistory _history;

  static WidgetsBinding ensureInitialized() {
    final history = BrowserHistory();
    if (history.supported) AppBinding._(history);
    return WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  BinaryMessenger createBinaryMessenger() =>
      SingleEntryHistoryMessenger(super.createBinaryMessenger(), _history);
}

/// Passes platform messages on to [_inner], except two to the web engine:
///
/// - The router's request for one history entry per location
///   (`selectMultiEntryHistory`) becomes a request for a single one.
/// - Leaving the app on back from its first screen (`SystemNavigator.pop`)
///   goes to [BrowserHistory.leaveApp] first. The engine's own exit removes
///   the app's history entries and then goes back one more; if there is
///   nothing to go back to, the app stays but no longer gets the browser's
///   back.
@visibleForTesting
class SingleEntryHistoryMessenger implements BinaryMessenger {
  SingleEntryHistoryMessenger(this._inner, this._history);

  final BinaryMessenger _inner;
  final BrowserHistory _history;

  static const _codec = JSONMethodCodec();

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
    if (message != null) {
      if (channel == SystemChannels.navigation.name &&
          _method(message) == 'selectMultiEntryHistory') {
        return _inner.send(
          channel,
          _codec.encodeMethodCall(const MethodCall('selectSingleEntryHistory')),
        );
      }
      if (channel == SystemChannels.platform.name &&
          _method(message) == 'SystemNavigator.pop') {
        if (_history.leaveApp()) {
          return Future.value(_codec.encodeSuccessEnvelope(null));
        }
      }
    }
    return _inner.send(channel, message);
  }

  static String _method(ByteData message) =>
      _codec.decodeMethodCall(message).method;

  @override
  void setMessageHandler(String channel, MessageHandler? handler) =>
      _inner.setMessageHandler(channel, handler);

  @override
  // The interface still declares it; the default messenger implements it the
  // same way.
  // ignore: deprecated_member_use
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? data,
    PlatformMessageResponseCallback? callback,
  ) =>
      // ignore: deprecated_member_use
      _inner.handlePlatformMessage(channel, data, callback);
}
