import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/failures.dart';
import '../../domain/models/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../api/api_failures.dart';
import '../api/tandoor_dio.dart';
import '../mappers/mapping.dart';

/// Creates the [Dio] for a request to [serverUrl], with [token] if given.
typedef TandoorDioFactory = Dio Function(Uri serverUrl, {String? token});

class TandoorAuthRepository implements AuthRepository {
  /// [csrfToken] reads the browser's CSRF cookie (see `CsrfInterceptor`);
  /// tests pass [dioFor] instead.
  TandoorAuthRepository({
    TandoorDioFactory? dioFor,
    String? Function()? csrfToken,
  }) : _dioFor =
           dioFor ??
           ((serverUrl, {token}) =>
               createTandoorDio(serverUrl, token: token, csrfToken: csrfToken));

  final TandoorDioFactory _dioFor;

  /// What the device token may do: everything but Tandoor's `app` scope.
  static const deviceTokenScope = 'read write';

  /// As long as the tokens `/api-token-auth/` hands out.
  static const deviceTokenLifetime = Duration(days: 5 * 365);

  @override
  Future<Session> loginWithPassword(
    Uri serverUrl, {
    required String username,
    required String password,
  }) async {
    // /api-token-auth/ returns the same token to every device that logs in
    // as this user, so it only serves to create a token of our own and is
    // neither stored nor revoked.
    final loginToken = await _obtainLoginToken(serverUrl, username, password);
    return _withClient(serverUrl, loginToken, (client) async {
      final created = requireBody(
        (await client.apiAccessTokenCreate(
          accessToken: api.AccessToken(
            (b) => b
              ..scope = deviceTokenScope
              ..expires = DateTime.now().toUtc().add(deviceTokenLifetime),
          ),
        )).data,
      );
      // The full token is only returned right after creation.
      final token = created.token;
      if (token == null || token.isEmpty) {
        throw const FormatException('Device token without a token');
      }
      return Session(
        serverUrl: serverUrl,
        token: token,
        deviceTokenId: requireId(created.id, 'AccessToken'),
      );
    });
  }

  Future<String> _obtainLoginToken(
    Uri serverUrl,
    String username,
    String password,
  ) async {
    final dio = _dioFor(serverUrl);
    try {
      // Not through the generated client: the schema declares the request
      // body as the response, but Tandoor answers
      // `{id, token, scope, expires, user_id}`.
      final response = await dio.post<Object?>(
        '/api-token-auth/',
        data: {'username': username, 'password': password},
      );
      final body = response.data;
      final token = body is Map ? body['token'] : null;
      if (token is! String || token.isEmpty) {
        throw ServerFailure(statusCode: response.statusCode);
      }
      return token;
    } on DioException catch (e) {
      // Wrong credentials are a 400 with `non_field_errors`. Never put the
      // request (it holds the password) into the failure.
      if (e.response?.statusCode == 400) {
        throw const InvalidCredentialsFailure();
      }
      throw failureFromDioException(e);
    } finally {
      dio.close();
    }
  }

  @override
  Future<Session> loginWithToken(Uri serverUrl, String token) async {
    final session = Session(serverUrl: serverUrl, token: token);
    await verify(session);
    return session;
  }

  @override
  Future<void> verify(Session session) =>
      _withClient(session.serverUrl, session.token, (client) async {
        // Small, needs a valid token, and every user may read their own.
        await client.apiUserPreferenceList();
      });

  @override
  Future<void> revoke(Session session) async {
    final id = session.deviceTokenId;
    if (id == null) return;
    try {
      await _withClient(session.serverUrl, session.token, (client) async {
        await client.apiAccessTokenDestroy(id: id);
      });
    } on NotFoundFailure {
      // Already deleted, e.g. in Tandoor's settings.
    } on UnauthorizedFailure {
      // The token no longer works, which is what revoking is for.
    }
  }

  Future<T> _withClient<T>(
    Uri serverUrl,
    String token,
    Future<T> Function(api.ApiApi client) request,
  ) async {
    final dio = _dioFor(serverUrl, token: token);
    final client = api.TandoorApi(dio: dio, interceptors: const []).getApiApi();
    try {
      return await guardRequest(() => request(client));
    } finally {
      dio.close();
    }
  }
}
