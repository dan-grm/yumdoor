import 'package:web/web.dart' as web;

import 'local_store.dart';

/// `window.localStorage`, with keys prefixed by `yumdoor.` so they don't mix
/// with Tandoor's own frontend on the same origin.
///
/// Every access is guarded: browsers throw when storage is disabled, and on a
/// full quota.
class PlatformLocalStore implements LocalStore {
  static const _prefix = 'yumdoor.';

  @override
  String? read(String key) {
    try {
      return web.window.localStorage.getItem('$_prefix$key');
    } catch (_) {
      return null;
    }
  }

  @override
  void write(String key, String value) {
    try {
      web.window.localStorage.setItem('$_prefix$key', value);
    } catch (_) {
      // Quota exceeded or storage disabled: the state stays in memory only.
    }
  }

  @override
  void delete(String key) {
    try {
      web.window.localStorage.removeItem('$_prefix$key');
    } catch (_) {}
  }

  @override
  Iterable<String> get keys {
    try {
      final storage = web.window.localStorage;
      return [
        for (var i = 0; i < storage.length; i++)
          if (storage.key(i) case final key? when key.startsWith(_prefix))
            key.substring(_prefix.length),
      ];
    } catch (_) {
      return const [];
    }
  }
}
