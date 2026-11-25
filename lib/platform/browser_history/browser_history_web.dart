import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

import 'browser_history.dart';

/// `window.history`, with Flutter's single-entry history in it.
///
/// In single-entry mode the engine keeps two entries: an "origin" entry and
/// the app's entry above it. By the time the app is asked to leave, the
/// browser's back has landed on the origin entry and the engine has put the
/// app's entry back on top, dropping any forward entries. So the app's entry
/// is the last one, and the page before the app is two back.
class PlatformBrowserHistory implements BrowserHistory {
  @override
  bool get supported => true;

  @override
  bool leaveApp() {
    final history = web.window.history;
    if (history.length > 2) {
      // An earlier load of the app in the same tab (a typed URL) also counts
      // as the page before; back from its first screen leads on from there.
      history.go(-2);
      return true;
    }
    // The installed app on iOS can't be left with back. The engine's exit
    // would remove its entries for nothing, and the swipe back would no
    // longer reach the app.
    return web.window.navigator['standalone']?.dartify() == true;
  }
}
