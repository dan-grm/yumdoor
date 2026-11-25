import 'browser_history.dart';

/// Native placeholder: no browser history; the system's back closes the app.
class PlatformBrowserHistory implements BrowserHistory {
  @override
  bool get supported => false;

  @override
  bool leaveApp() => false;
}
