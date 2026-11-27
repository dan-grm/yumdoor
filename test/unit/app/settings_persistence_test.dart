import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/locale.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/theme_mode.dart';

import '../../fakes/in_memory_local_store.dart';

void main() {
  late InMemoryLocalStore local;

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [localStoreProvider.overrideWithValue(local)],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() => local = InMemoryLocalStore());

  test('default to system theme and device language', () {
    final c = container();
    expect(c.read(themeModeSettingProvider), ThemeMode.system);
    expect(c.read(localeOverrideProvider), isNull);
  });

  test('save and restore the theme', () {
    container().read(themeModeSettingProvider.notifier).set(ThemeMode.dark);
    expect(container().read(themeModeSettingProvider), ThemeMode.dark);
  });

  test('save and restore the language, and going back to the device', () {
    container().read(localeOverrideProvider.notifier).set(const Locale('en'));
    expect(container().read(localeOverrideProvider), const Locale('en'));

    container().read(localeOverrideProvider.notifier).set(null);
    expect(container().read(localeOverrideProvider), isNull);
  });

  test('corrupt values fall back to the defaults', () {
    local.write('settings.theme-mode', 'purple');
    local.write('settings.language', 'klingon');
    final c = container();
    expect(c.read(themeModeSettingProvider), ThemeMode.system);
    expect(c.read(localeOverrideProvider), isNull);
  });
}
