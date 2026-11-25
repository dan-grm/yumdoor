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
  void leaveApp() {
    final history = web.window.history;
    // An earlier load of the app in the same tab (a typed URL) also counts
    // as the page before; back from its first screen leads on from there.
    if (history.length > 2) history.go(-2);
  }
}
