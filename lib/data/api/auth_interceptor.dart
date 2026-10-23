import 'package:dio/dio.dart';

/// Sends the API token as `Authorization: Bearer <token>`.
///
/// Used instead of the generated client's `ApiKeyAuthInterceptor`, which
/// would need the whole header value set on every `TandoorApi`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._token);

  final String _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_token';
    handler.next(options);
  }
}
