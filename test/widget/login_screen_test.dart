import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/app.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/features/auth/login_screen.dart';
import 'package:yumdoor/features/search/search_screen.dart';

import '../fakes/app_overrides.dart';
import '../fakes/fake_auth_repository.dart';
import '../fakes/fake_server_repository.dart';
import '../fakes/in_memory_token_store.dart';

void main() {
  late InMemoryTokenStore store;
  late FakeAuthRepository auth;
  late FakeServerRepository server;

  setUp(() {
    store = InMemoryTokenStore(serverUrl: testServerUrl);
    auth = FakeAuthRepository();
    server = FakeServerRepository();
  });

  /// The app without a session, in German on a 390 px phone.
  Future<void> pumpLogin(WidgetTester tester, {Uri? webOrigin}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.localesTestValue = const [Locale('de')];
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: appOverrides(
          tokenStore: store,
          auth: auth,
          server: server,
          webOrigin: webOrigin,
        ),
        child: const YumdoorApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String key) => find.byKey(ValueKey(key));
  final serverField = find.byType(TextFormField).first;

  Future<void> typeServer(WidgetTester tester, String url) async {
    await tester.enterText(serverField, url);
    await tester.pump(LoginScreen.serverCheckDelay);
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Anmelden'));
    await tester.pumpAndSettle();
  }

  Future<void> logInWithPassword(
    WidgetTester tester, {
    String password = 'anna-dev-only',
  }) async {
    await tester.enterText(field('username'), 'anna');
    await tester.enterText(field('password'), password);
    await submit(tester);
  }

  group('server check', () {
    testWidgets('checks the last server and shows its version', (tester) async {
      await pumpLogin(tester);

      expect(
        tester.widget<TextFormField>(serverField).controller!.text,
        testServerUrl.toString(),
      );
      expect(server.requested, [testServerUrl]);
      expect(find.text('Tandoor 2.6.15 gefunden'), findsOneWidget);
    });

    testWidgets('defaults to the app origin on the web', (tester) async {
      store = InMemoryTokenStore();
      final origin = Uri.parse('https://rezepte.example.de');

      await pumpLogin(tester, webOrigin: origin);

      expect(
        tester.widget<TextFormField>(serverField).controller!.text,
        origin.toString(),
      );
      expect(server.requested, [origin]);
    });

    testWidgets('explains that the web app only reaches its own origin', (
      tester,
    ) async {
      store = InMemoryTokenStore();
      await pumpLogin(tester, webOrigin: Uri.parse('https://app.example.de'));
      server.requested.clear();

      await typeServer(tester, 'https://tandoor.example.com');

      expect(
        find.textContaining(
          'nur den Tandoor-Server unter https://app.example.de',
        ),
        findsOneWidget,
      );
      expect(server.requested, isEmpty);
    });

    testWidgets('rejects an unsupported Tandoor version', (tester) async {
      server.version = '1.5.24';
      await pumpLogin(tester);

      expect(
        find.text(
          'Tandoor 1.5.24 wird nicht unterstützt. Yumdoor braucht Tandoor 2.x.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tells when there is no Tandoor at the address', (
      tester,
    ) async {
      server.failure = const IncompatibleServerFailure();
      await pumpLogin(tester);

      expect(
        find.text('Unter dieser Adresse läuft kein Tandoor 2.x.'),
        findsOneWidget,
      );
    });

    testWidgets('tells when the server is unreachable', (tester) async {
      server.failure = const OfflineFailure();
      await pumpLogin(tester);

      expect(find.textContaining('nicht erreichbar'), findsOneWidget);
    });

    testWidgets('does not log in to a server that failed the check', (
      tester,
    ) async {
      server.failure = const IncompatibleServerFailure();
      await pumpLogin(tester);

      await logInWithPassword(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(store.token, isNull);
    });
  });

  group('password login', () {
    testWidgets('asks for empty fields', (tester) async {
      await pumpLogin(tester);

      await submit(tester);

      expect(find.text('Gib deinen Benutzernamen ein.'), findsOneWidget);
      expect(find.text('Gib dein Passwort ein.'), findsOneWidget);
    });

    testWidgets('reports wrong credentials', (tester) async {
      await pumpLogin(tester);

      await logInWithPassword(tester, password: 'wrong');

      expect(
        find.text('Benutzername oder Passwort stimmt nicht.'),
        findsOneWidget,
      );
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('explains the daily login limit', (tester) async {
      await pumpLogin(tester);
      auth.failure = const ThrottledFailure();

      await logInWithPassword(tester);

      expect(find.textContaining('Tandoor erlaubt zehn pro Tag'), findsOne);
    });

    testWidgets('reports a lost connection', (tester) async {
      await pumpLogin(tester);
      auth.failure = const OfflineFailure();

      await logInWithPassword(tester);

      expect(find.textContaining('nicht erreichbar'), findsOneWidget);
    });

    testWidgets('shows and hides the password', (tester) async {
      await pumpLogin(tester);
      bool obscured() => tester
          .widget<EditableText>(
            find.descendant(
              of: field('password'),
              matching: find.byType(EditableText),
            ),
          )
          .obscureText;

      expect(obscured(), isTrue);
      await tester.tap(find.byTooltip('Passwort anzeigen'));
      await tester.pump();
      expect(obscured(), isFalse);
      await tester.tap(find.byTooltip('Passwort verbergen'));
      await tester.pump();
      expect(obscured(), isTrue);
    });

    testWidgets('logs in, and logout returns to login', (tester) async {
      await pumpLogin(tester);

      await logInWithPassword(tester);

      expect(find.byType(SearchScreen), findsOneWidget);
      expect(store.token?.token, FakeAuthRepository.deviceToken);

      await tester.tap(find.byTooltip('Abmelden'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(
        auth.revoked.single.deviceTokenId,
        FakeAuthRepository.deviceTokenId,
      );
      expect(store.token, isNull);
      expect(
        tester.widget<TextFormField>(serverField).controller!.text,
        testServerUrl.toString(),
      );
    });
  });

  group('token login', () {
    Future<void> switchToToken(WidgetTester tester) async {
      await tester.tap(find.text('API-Token').first);
      await tester.pumpAndSettle();
    }

    testWidgets('asks for a token', (tester) async {
      await pumpLogin(tester);
      await switchToToken(tester);

      await submit(tester);

      expect(find.text('Füge dein API-Token ein.'), findsOneWidget);
    });

    testWidgets('reports a rejected token', (tester) async {
      await pumpLogin(tester);
      await switchToToken(tester);

      await tester.enterText(field('token'), 'tda_wrong');
      await submit(tester);

      expect(find.textContaining('dieses Token nicht angenommen'), findsOne);
    });

    testWidgets('logs in with a pasted bearer token', (tester) async {
      await pumpLogin(tester);
      await switchToToken(tester);

      await tester.enterText(field('token'), '  Bearer tda_pasted ');
      await submit(tester);

      expect(find.byType(SearchScreen), findsOneWidget);
      expect(store.token?.token, 'tda_pasted');
      expect(store.token?.id, isNull);
    });
  });

  test('cleanToken strips whitespace and a Bearer prefix', () {
    expect(cleanToken(' tda_x \n'), 'tda_x');
    expect(cleanToken('bearer tda_x'), 'tda_x');
    expect(cleanToken('tda_bearer'), 'tda_bearer');
  });
}
