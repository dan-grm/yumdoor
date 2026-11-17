import 'package:yumdoor/platform/unload_guard/unload_guard.dart';

/// [UnloadGuard] for tests: only remembers [active].
class FakeUnloadGuard implements UnloadGuard {
  @override
  bool active = false;

  @override
  void dispose() => active = false;
}
