import 'unload_guard.dart';

/// Native placeholder: the system closes apps without asking, so this only
/// remembers [active].
class PlatformUnloadGuard implements UnloadGuard {
  @override
  bool active = false;

  @override
  void dispose() => active = false;
}
