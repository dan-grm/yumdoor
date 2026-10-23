import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/app/router.dart';
import 'package:yumdoor/domain/models/session.dart';

void main() {
  final session = AsyncData<Session?>(
    Session(serverUrl: Uri.parse('https://example.com'), token: 'tda_x'),
  );
  const loggedOut = AsyncData<Session?>(null);
  const loading = AsyncLoading<Session?>();

  String? redirect(AsyncValue<Session?> state, String location) =>
      sessionRedirect(state, Uri.parse(location));

  test('waits on the loading route and remembers where it was going', () {
    expect(redirect(loading, '/recipe/5'), '/loading?from=%2Frecipe%2F5');
    expect(redirect(loading, '/loading?from=/x'), isNull);
  });

  test('sends everyone without a session to login', () {
    expect(redirect(loggedOut, '/'), '/login');
    expect(redirect(loggedOut, '/loading?from=/recipe/5'), '/login');
    expect(redirect(loggedOut, '/login'), isNull);
    expect(redirect(AsyncError<Session?>('', StackTrace.empty), '/'), '/login');
  });

  test('sends a session away from login and loading', () {
    expect(redirect(session, '/login'), '/');
    expect(redirect(session, '/loading?from=/recipe/5'), '/recipe/5');
    expect(redirect(session, '/loading'), '/');
    expect(redirect(session, '/'), isNull);
  });

  test('only continues to paths inside the app', () {
    expect(redirect(session, '/loading?from=//evil.example.com'), '/');
    expect(redirect(session, '/loading?from=https://evil.example.com'), '/');
  });

  test('leaves debug routes alone', () {
    expect(redirect(loggedOut, '/debug/tokens'), isNull);
  });
}
