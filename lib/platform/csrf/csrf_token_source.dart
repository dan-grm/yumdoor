import 'csrf_token_source_stub.dart'
    if (dart.library.js_interop) 'csrf_token_source_web.dart';

/// Django's CSRF token from the browser's `csrftoken` cookie.
///
/// Only the web build shares cookies with Tandoor, and only when the user is
/// also logged into Tandoor in the same browser (see
/// `lib/data/api/csrf_interceptor.dart`).
abstract interface class CsrfTokenSource {
  /// The CSRF token source for the current platform.
  factory CsrfTokenSource() = PlatformCsrfTokenSource;

  /// The current token, or `null` if there is none.
  String? read();
}

/// The value of the `csrftoken` cookie in a `document.cookie` string.
String? csrfTokenFromCookies(String cookies) {
  for (final cookie in cookies.split(';')) {
    final separator = cookie.indexOf('=');
    if (separator < 0) continue;
    if (cookie.substring(0, separator).trim() == 'csrftoken') {
      final value = cookie.substring(separator + 1).trim();
      return value.isEmpty ? null : value;
    }
  }
  return null;
}
