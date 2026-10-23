import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/app/locale.dart';
import 'package:yumdoor/features/home/home_screen.dart';

import '../fakes/app_overrides.dart';

void main() {
  Future<Locale> activeLocale(
    WidgetTester tester, {
    required List<Locale> device,
    Locale? override,
  }) async {
    tester.platformDispatcher.localesTestValue = device;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final container = ProviderContainer(
      overrides: appOverrides(tokenStore: loggedInTokenStore()),
    );
    addTearDown(container.dispose);
    if (override != null) {
      container.read(localeOverrideProvider.notifier).set(override);
    }
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const YumdoorApp(),
      ),
    );
    await tester.pumpAndSettle();
    return Localizations.localeOf(tester.element(find.byType(HomeScreen)));
  }

  testWidgets('follows an English device', (tester) async {
    expect(
      await activeLocale(tester, device: const [Locale('en', 'US')]),
      const Locale('en'),
    );
  });

  testWidgets('follows a German device', (tester) async {
    expect(
      await activeLocale(tester, device: const [Locale('de', 'AT')]),
      const Locale('de'),
    );
  });

  testWidgets('takes the first supported device language', (tester) async {
    expect(
      await activeLocale(
        tester,
        device: const [Locale('fr'), Locale('en'), Locale('de')],
      ),
      const Locale('en'),
    );
  });

  testWidgets('falls back to German for unsupported languages', (tester) async {
    expect(
      await activeLocale(tester, device: const [Locale('fr'), Locale('ja')]),
      const Locale('de'),
    );
  });

  testWidgets('the override wins over the device', (tester) async {
    expect(
      await activeLocale(
        tester,
        device: const [Locale('de')],
        override: const Locale('en'),
      ),
      const Locale('en'),
    );
  });
}
