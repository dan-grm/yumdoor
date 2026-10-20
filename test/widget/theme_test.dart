import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/app/theme_mode.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/home/home_screen.dart';

void main() {
  Future<YumdoorTokens> activeTokens(
    WidgetTester tester, {
    required Brightness system,
    ThemeMode? mode,
  }) async {
    tester.platformDispatcher.platformBrightnessTestValue = system;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    if (mode != null) {
      container.read(themeModeSettingProvider.notifier).set(mode);
    }
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const YumdoorApp(),
      ),
    );
    await tester.pumpAndSettle();
    return tester.element(find.byType(HomeScreen)).tokens;
  }

  testWidgets('follows a light system', (tester) async {
    expect(
      await activeTokens(tester, system: Brightness.light),
      YumdoorTokens.light,
    );
  });

  testWidgets('follows a dark system', (tester) async {
    expect(
      await activeTokens(tester, system: Brightness.dark),
      YumdoorTokens.dark,
    );
  });

  testWidgets('the setting overrides the system', (tester) async {
    expect(
      await activeTokens(
        tester,
        system: Brightness.dark,
        mode: ThemeMode.light,
      ),
      YumdoorTokens.light,
    );
  });

  test('Material colors and text come from the tokens', () {
    expect(lightTheme.scaffoldBackgroundColor, YumdoorTokens.light.bg);
    expect(darkTheme.colorScheme.primary, YumdoorTokens.dark.sage);
    expect(lightTheme.textTheme.bodyMedium?.fontFamily, 'Nunito');
    expect(darkTheme.textTheme.bodyMedium?.color, YumdoorTokens.dark.ink);
  });

  test('tokens lerp and copy', () {
    const light = YumdoorTokens.light;
    const dark = YumdoorTokens.dark;
    expect(light.lerp(dark, 0).sage, light.sage);
    expect(light.lerp(dark, 1).sage, dark.sage);
    expect(light.lerp(dark, 0.5).bg, Color.lerp(light.bg, dark.bg, 0.5));
    expect(light.copyWith(sage: dark.sage).sage, dark.sage);
  });
}
