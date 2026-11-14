import 'package:yumdoor/platform/local_store/local_store.dart';

/// [LocalStore] for tests. Share one instance between two pumps to play a
/// page reload.
class InMemoryLocalStore implements LocalStore {
  final values = <String, String>{};

  @override
  String? read(String key) => values[key];

  @override
  void write(String key, String value) => values[key] = value;

  @override
  void delete(String key) => values.remove(key);

  @override
  Iterable<String> get keys => values.keys.toList();
}
