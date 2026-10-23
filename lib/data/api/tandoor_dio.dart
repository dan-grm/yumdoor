import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

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
/// [serverUrl], so a Tandoor under a subpath works.
Dio createTandoorDio(Uri serverUrl, {String? token}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: serverUrl.toString(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  if (token != null) dio.interceptors.add(AuthInterceptor(token));
  return dio;
}
