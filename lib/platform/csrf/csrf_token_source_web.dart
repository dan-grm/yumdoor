import 'package:web/web.dart' as web;

import 'csrf_token_source.dart';

/// Reads `csrftoken` from `document.cookie`. Django doesn't mark it HttpOnly
/// by default (`CSRF_COOKIE_HTTPONLY`), and Tandoor's frontend reads it too.
class PlatformCsrfTokenSource implements CsrfTokenSource {
  @override
  String? read() => csrfTokenFromCookies(web.document.cookie);
}
