import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'csrf_interceptor.dart';
import 'reachability_interceptor.dart';

/// A server and the token to use with it.
class TandoorConnection {
  const TandoorConnection(this.serverUrl, this.token);

  /// Where Tandoor is, possibly with a path (`https://example.com/tandoor`).
  final Uri serverUrl;
  final String token;

  @override
  bool operator ==(Object other) =>
      other is TandoorConnection &&
      other.serverUrl == serverUrl &&
      other.token == token;

  @override
  int get hashCode => Object.hash(serverUrl, token);

  // Never print the token itself.
  @override
  String toString() => 'TandoorConnection($serverUrl)';
}

/// A [Dio] for the Tandoor at [serverUrl], authenticated with [token] if given.
///
/// The generated client's paths start with `/api/`; Dio appends them to
/// [serverUrl], so a Tandoor under a subpath works. [csrfToken] reads the
/// browser's CSRF cookie (see [CsrfInterceptor]); [onUnauthorized] is called
/// whenever the server rejects [token]; [onReachable] learns after a request
/// whether the server answered (see [ReachabilityInterceptor]).
Dio createTandoorDio(
  Uri serverUrl, {
  String? token,
  String? Function()? csrfToken,
  void Function()? onUnauthorized,
  void Function(bool reachable)? onReachable,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: serverUrl.toString(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  if (csrfToken != null) dio.interceptors.add(CsrfInterceptor(csrfToken));
  if (token != null) {
    dio.interceptors.add(
      AuthInterceptor(token, onUnauthorized: onUnauthorized),
    );
  }
  if (onReachable != null) {
    dio.interceptors.add(ReachabilityInterceptor(onReachable));
  }
  return dio;
}
