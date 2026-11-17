import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'unload_guard.dart';

/// A `beforeunload` listener that cancels the event, so the browser asks
/// before closing or reloading the tab.
///
/// Registered only while [active]: a `beforeunload` listener keeps some
/// browsers from putting the page in the back/forward cache. Browsers show
/// the prompt only after the user has interacted with the page.
class PlatformUnloadGuard implements UnloadGuard {
  late final JSFunction _listener = _onBeforeUnload.toJS;
  bool _active = false;

  @override
  bool get active => _active;

  @override
  set active(bool value) {
    if (value == _active) return;
    _active = value;
    if (value) {
      web.window.addEventListener('beforeunload', _listener);
    } else {
      web.window.removeEventListener('beforeunload', _listener);
    }
  }

  void _onBeforeUnload(web.Event event) {
    event.preventDefault();
    // Older browsers need a truthy returnValue as well. Its text isn't shown.
    if (event.isA<web.BeforeUnloadEvent>()) {
      (event as web.BeforeUnloadEvent).returnValue = 'unsaved';
    }
  }

  @override
  void dispose() => active = false;
}
