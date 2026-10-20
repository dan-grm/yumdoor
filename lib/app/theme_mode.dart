import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode.g.dart';

/// Light, dark or following the system (the default); set from settings later.
@Riverpod(keepAlive: true)
class ThemeModeSetting extends _$ThemeModeSetting {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}
