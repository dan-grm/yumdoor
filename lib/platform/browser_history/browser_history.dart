import 'browser_history_stub.dart'
    if (dart.library.js_interop) 'browser_history_web.dart';

/// The browser's history, on the web. Used by [AppBinding] to make back
/// follow the app's page hierarchy.
///
/// Not a provider like the other platform services: the binding uses it
/// before `runApp`, outside any [ProviderScope].
abstract interface class BrowserHistory {
  /// The history of the current platform.
  factory BrowserHistory() = PlatformBrowserHistory;

  /// Whether the app runs in a browser with a history. Native apps have none.
  bool get supported;

  /// Back from the app's first screen. Goes to the page before the app if
  /// there is one, or does nothing where the browser can't leave the app
  /// (the installed app on iOS); `true` then. `false` leaves it to Flutter's
  /// engine, which steps out of the app's history entries so that the next
  /// back closes the installed app or returns to the app that opened the tab
  /// (Android).
  bool leaveApp();
}
