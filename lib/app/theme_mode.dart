import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'platform_providers.dart';

part 'theme_mode.g.dart';

const _key = 'settings.theme-mode';

/// Light, dark or following the system (the default). Kept on the device in
/// the [LocalStore], across restarts and logout; unknown values mean system.
@Riverpod(keepAlive: true)
class ThemeModeSetting extends _$ThemeModeSetting {
  @override
  ThemeMode build() {
    final saved = ref.watch(localStoreProvider).read(_key);
    return ThemeMode.values.where((m) => m.name == saved).firstOrNull ??
        ThemeMode.system;
  }

  void set(ThemeMode mode) {
    state = mode;
    ref.read(localStoreProvider).write(_key, mode.name);
  }
}
