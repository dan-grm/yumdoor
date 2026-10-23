import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/csrf/csrf_token_source.dart';

void main() {
  test('finds csrftoken among other cookies', () {
    expect(csrfTokenFromCookies('a=1; csrftoken=abc123; b=2'), 'abc123');
    expect(csrfTokenFromCookies('csrftoken=abc123'), 'abc123');
  });

  test('is null without the cookie', () {
    expect(csrfTokenFromCookies(''), isNull);
    expect(csrfTokenFromCookies('xcsrftoken=abc; csrftoken='), isNull);
  });

  test('native apps have no CSRF token', () {
    expect(CsrfTokenSource().read(), isNull);
  });
}
