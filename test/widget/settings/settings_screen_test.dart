import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/app/app_info.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/features/auth/login_screen.dart';
import 'package:yumdoor/features/home/home_screen.dart';
import 'package:yumdoor/features/settings/settings_screen.dart';

import '../../fakes/app_overrides.dart';
import '../../fakes/fake_book_user_repositories.dart';
import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_link_opener.dart';
import '../../fakes/fake_server_repository.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeUserRepository users;
  late FakeServerRepository server;
  late FakeConnectivityService connectivity;
  late FakeLinkOpener linkOpener;

  setUpAll(loadBundledFonts);

  setUp(() {
    users = FakeUserRepository(const [
      UserRef(id: 2, name: 'Ben Beispiel', username: 'ben'),
      UserRef(id: 1, name: 'Anna Beispiel', username: 'anna'),
    ]);
    server = FakeServerRepository();
    connectivity = FakeConnectivityService();
    linkOpener = FakeLinkOpener();
  });

  List<Override> overrides() => appOverrides(
    tokenStore: loggedInTokenStore(),
    users: users,
    server: server,
    connectivity: connectivity,
    linkOpener: linkOpener,
  );

  /// The whole app on the start screen, at phone size.
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = phoneSize;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.localesTestValue = const [Locale('de')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      ProviderScope(overrides: overrides(), child: const YumdoorApp()),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openSettings(WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Einstellungen'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens from the start screen header and shows the account', (
    tester,
  ) async {
    await openSettings(tester);

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Anna Beispiel'), findsOneWidget);
    expect(find.text('anna'), findsOneWidget);
    expect(find.text('tandoor.example.com'), findsOneWidget);
    expect(find.text('2.6.15'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('AGPL-3.0'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(appVersion), findsOneWidget);
    expect(find.text('AGPL-3.0'), findsOneWidget);
    expect(find.textContaining('nie dein Passwort'), findsOneWidget);
  });

  testWidgets('back returns to the start screen', (tester) async {
    await openSettings(tester);

    await tester.tap(find.byTooltip('Zurück'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('switches the theme', (tester) async {
    await openSettings(tester);
    Brightness brightness() =>
        Theme.of(tester.element(find.byType(SettingsScreen))).brightness;
    final system = tester.platformDispatcher.platformBrightness;

    await tester.tap(find.text('Dunkel'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);

    await tester.tap(find.text('Hell'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);

    await tester.tap(find.text('System').first);
    await tester.pumpAndSettle();
    expect(brightness(), system);
  });

  testWidgets('switches the language', (tester) async {
    await openSettings(tester);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Einstellungen'), findsOneWidget);
  });

  testWidgets('logging out ends the session and opens login', (tester) async {
    await openSettings(tester);

    await tester.tap(find.text('Abmelden'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);
  });

  testWidgets('opens the source code link', (tester) async {
    await openSettings(tester);

    await tester.scrollUntilVisible(
      find.text('github.com/dan-grm/yumdoor'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('github.com/dan-grm/yumdoor'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('github.com/dan-grm/yumdoor'));
    await tester.pump();

    expect(linkOpener.opened, [sourceCodeUrl]);
  });

  testWidgets('works offline and says what it cannot show', (tester) async {
    users.failure = const OfflineFailure();
    server.failure = const OfflineFailure();
    connectivity.isOnline = false;
    await openSettings(tester);

    expect(find.text('tandoor.example.com'), findsOneWidget);
    expect(find.text('nicht verfügbar'), findsNWidgets(3));
    expect(find.text(appVersion), findsOneWidget);
    // Not disabled: logging out works offline.
    await tester.tap(find.text('Abmelden'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('has no overflow with large text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openSettings(tester);

    expect(tester.takeException(), isNull);
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('settings in $name', tags: goldenTags, (tester) async {
        await pumpRoutes(
          tester,
          location: settingsPath,
          theme: theme,
          overrides: overrides(),
          routes: [
            GoRoute(
              path: settingsPath,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        );

        await expectLater(
          find.byType(SettingsScreen),
          matchesGoldenFile('../goldens/settings_$name.png'),
        );
      });
    }
  });
}
