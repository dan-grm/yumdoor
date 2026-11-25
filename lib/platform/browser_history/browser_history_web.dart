import 'package:web/web.dart' as web;

import 'browser_history.dart';

/// `window.history`, with Flutter's single-entry history in it.
class PlatformBrowserHistory implements BrowserHistory {
  @override
  bool get supported => true;

  /// In single-entry mode the engine keeps two entries: an "origin" entry and
  /// the app's entry above it. By the time the app is asked to leave, the
  /// browser's back has landed on the origin entry and the engine has put
  /// the app's entry back on top, so the page before the app is two back.
  /// With nothing there (the installed app, a new tab), `go(-2)` does
  /// nothing, and the engine's entries stay intact for the next back. The
  /// engine's own exit would remove them first and then no longer hand back
  /// to the app.
  @override
  void leaveApp() => web.window.history.go(-2);
}
