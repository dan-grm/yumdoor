import 'local_store.dart';

/// Native placeholder until the native builds land: keeps values in memory
/// for the app's lifetime.
class PlatformLocalStore implements LocalStore {
  final _values = <String, String>{};

  @override
  String? read(String key) => _values[key];

  @override
  void write(String key, String value) => _values[key] = value;

  @override
  void delete(String key) => _values.remove(key);

  @override
  Iterable<String> get keys => _values.keys.toList();
}
