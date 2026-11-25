import 'browser_history_stub.dart'
    if (dart.library.js_interop) 'browser_history_web.dart';

/// The browser's history, on the web. Used by [AppBinding] to make back
/// follow the app's page hierarchy.
abstract interface class BrowserHistory {
  /// The history of the current platform.
  factory BrowserHistory() = PlatformBrowserHistory;

  /// Whether the app runs in a browser with a history. Native apps have none.
  bool get supported;

  /// Goes to the page before the app's history entries, if there is one
  /// (the site the app was opened from); otherwise nothing happens.
  void leaveApp();
}
