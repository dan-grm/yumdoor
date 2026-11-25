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

  /// Back from the app's first screen: goes to the page before the app if
  /// there is one; otherwise nothing happens and the app stays as it is.
  ///
  /// With nothing before the app (the installed app, a tab opened on it),
  /// Flutter's engine would remove the app's history entries and then no
  /// longer hand the browser's back to the app for the rest of the session.
  /// So back can't close the installed app on Android.
  void leaveApp();
}
