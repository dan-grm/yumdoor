@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:web/web.dart' as web;
import 'package:yumdoor/platform/unload_guard/unload_guard.dart';

import '../platform/contracts.dart';

// The web UnloadGuard in a real browser:
//   flutter test --platform chrome test/web/
// A real close would end the test, so the tests fire `beforeunload` themselves
// and check whether the guard cancelled it (which is what makes the browser
// ask).

/// Fires a cancelable `beforeunload` at the window; returns whether a
/// listener cancelled it.
bool _unloadCancelled() {
  final event = web.Event('beforeunload', web.EventInit(cancelable: true));
  web.window.dispatchEvent(event);
  return event.defaultPrevented;
}

void main() {
  group('web UnloadGuard', () => unloadGuardContract(UnloadGuard.new));

  test('cancels closing the tab only while active', () {
    final guard = UnloadGuard();
    addTearDown(guard.dispose);
    expect(_unloadCancelled(), isFalse);

    guard.active = true;
    expect(_unloadCancelled(), isTrue);

    guard.active = false;
    expect(_unloadCancelled(), isFalse);

    guard.active = true;
    guard.dispose();
    expect(_unloadCancelled(), isFalse);
  });
}
