import 'package:dio/dio.dart';

/// Sends the API token as `Authorization: Bearer <token>` and reports
/// rejected requests to [onUnauthorized].
///
/// Used instead of the generated client's `ApiKeyAuthInterceptor`, which
/// would need the whole header value set on every `TandoorApi`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._token, {this.onUnauthorized});

  final String _token;

  /// Called for every 401 or 403. Tandoor answers both an invalid token and a
  /// missing permission with 403, so this is a hint to check the token, not
  /// proof that it is invalid.
  final void Function()? onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    if (status == 401 || status == 403) onUnauthorized?.call();
    handler.next(err);
  }
}
