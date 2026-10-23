import 'package:dio/dio.dart';

/// Sends Django's CSRF token with unsafe requests.
///
/// On the web, the browser sends Tandoor's session cookie with every request
/// if the user is also logged into Tandoor in this browser. Tandoor then
/// authenticates by session before looking at the bearer token and rejects
/// every POST, PUT, PATCH and DELETE without a CSRF token with 403 (see
/// docs/TANDOOR_API.md#authentication). Like Tandoor's own frontend, this
/// copies the `csrftoken` cookie into the `X-CSRFToken` header.
class CsrfInterceptor extends Interceptor {
  CsrfInterceptor(this._csrfToken);

  /// The current `csrftoken` cookie, or `null` if there is none.
  final String? Function() _csrfToken;

  static const _safeMethods = {'GET', 'HEAD', 'OPTIONS', 'TRACE'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_safeMethods.contains(options.method.toUpperCase())) {
      final token = _csrfToken();
      if (token != null) options.headers['X-CSRFToken'] = token;
    }
    handler.next(options);
  }
}
