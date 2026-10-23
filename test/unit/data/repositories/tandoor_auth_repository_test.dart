import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_auth_repository.dart';
import 'package:yumdoor/domain/models/session.dart';

import '../../../fakes/fake_http_adapter.dart';

// TandoorAuthRepository against canned responses shaped like Tandoor 2.6.15's
// (checked with curl against the local Tandoor). The real thing is in
// test/integration/auth_repository_test.dart.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');
  const password = 'secret-password';

  late FakeHttpAdapter adapter;
  late ResponseBody Function(RequestOptions request) respond;
  late TandoorAuthRepository repository;

  setUp(() {
    respond = (_) => jsonResponse({});
    adapter = FakeHttpAdapter((request) => respond(request));
    repository = TandoorAuthRepository(
      dioFor: (url, {token}) =>
          createTandoorDio(url, token: token)..httpClientAdapter = adapter,
    );
  });

  ResponseBody tandoor(RequestOptions request) =>
      switch ((request.method, request.uri.path)) {
        ('POST', '/tandoor/api-token-auth/') => jsonResponse({
          'id': 8,
          'token': 'tda_login',
          'scope': 'read write',
          'expires': '2031-10-21T18:01:11.787557Z',
          'user_id': 8,
          'test': 8,
        }),
        ('POST', '/tandoor/api/access-token/') => jsonResponse({
          'id': 11,
          'token': 'tda_device',
          'expires': '2031-10-23T02:00:00+02:00',
          'scope': 'read write',
          'created': '2026-10-23T22:34:14.169606+02:00',
          'updated': '2026-10-23T22:34:14.169617+02:00',
        }, status: 201),
        _ => jsonResponse({'detail': 'Not found.'}, status: 404),
      };

  group('loginWithPassword', () {
    test('creates a device token with the login token', () async {
      respond = tandoor;

      final session = await repository.loginWithPassword(
        serverUrl,
        username: 'anna',
        password: password,
      );

      expect(
        session,
        Session(serverUrl: serverUrl, token: 'tda_device', deviceTokenId: 11),
      );
      final [login, create] = adapter.requests;
      expect(login.data, {'username': 'anna', 'password': password});
      expect(login.headers, isNot(contains('Authorization')));
      expect(create.headers['Authorization'], 'Bearer tda_login');
      final body = create.data as Map<String, dynamic>;
      expect(body['scope'], 'read write');
      final expires = DateTime.parse(body['expires'] as String);
      expect(
        expires.difference(DateTime.now()),
        greaterThan(const Duration(days: 4 * 365)),
      );
    });

    test('reports wrong credentials', () async {
      respond = (_) => jsonResponse({
        'non_field_errors': ['Unable to log in with provided credentials.'],
      }, status: 400);

      await expectLater(
        repository.loginWithPassword(
          serverUrl,
          username: 'anna',
          password: password,
        ),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
      expect(adapter.requests, hasLength(1));
    });

    test('reports throttling', () async {
      respond = (_) => ResponseBody.fromString(
        '{"detail": "Request was throttled."}',
        429,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          'retry-after': ['3600'],
        },
      );

      await expectLater(
        repository.loginWithPassword(
          serverUrl,
          username: 'anna',
          password: password,
        ),
        throwsA(
          isA<ThrottledFailure>().having(
            (f) => f.retryAfter,
            'retryAfter',
            const Duration(hours: 1),
          ),
        ),
      );
    });

    test('never puts the password into a failure', () async {
      respond = (_) => jsonResponse({'detail': 'boom'}, status: 500);

      final failure = await repository
          .loginWithPassword(serverUrl, username: 'anna', password: password)
          .then<Object?>((_) => null, onError: (Object e) => e);

      expect(failure, isA<ServerFailure>());
      expect(failure.toString(), isNot(contains(password)));
    });

    test('rejects a device token response without the token', () async {
      respond = (request) => request.uri.path.endsWith('/access-token/')
          ? jsonResponse(
              {
                'id': 11,
                'token': 'tda_****',
                'expires': '2031-10-23T02:00:00+02:00',
              }..remove('token'),
              status: 201,
            )
          : tandoor(request);

      await expectLater(
        repository.loginWithPassword(
          serverUrl,
          username: 'anna',
          password: password,
        ),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('loginWithToken', () {
    test('checks the token and does not own it', () async {
      respond = (_) => jsonResponse([]);

      final session = await repository.loginWithToken(serverUrl, 'tda_pasted');

      expect(session, Session(serverUrl: serverUrl, token: 'tda_pasted'));
      expect(session.ownsToken, isFalse);
      final request = adapter.requests.single;
      expect(request.uri.path, '/tandoor/api/user-preference/');
      expect(request.headers['Authorization'], 'Bearer tda_pasted');
    });

    test('reports a rejected token', () {
      respond = (_) => jsonResponse({
        'detail': 'Authentication credentials were not provided.',
      }, status: 403);

      expect(
        repository.loginWithToken(serverUrl, 'tda_wrong'),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });

  group('revoke', () {
    final device = Session(
      serverUrl: serverUrl,
      token: 'tda_device',
      deviceTokenId: 11,
    );

    test('deletes the device token with itself', () async {
      respond = (_) => ResponseBody.fromString('', 204);

      await repository.revoke(device);

      final request = adapter.requests.single;
      expect(request.method, 'DELETE');
      expect(request.uri.path, '/tandoor/api/access-token/11/');
      expect(request.headers['Authorization'], 'Bearer tda_device');
    });

    test('leaves a pasted token alone', () async {
      await repository.revoke(Session(serverUrl: serverUrl, token: 'tda_x'));

      expect(adapter.requests, isEmpty);
    });

    test('accepts a token that is already gone', () async {
      for (final status in [403, 404]) {
        respond = (_) => jsonResponse({'detail': 'x'}, status: status);
        await repository.revoke(device);
      }
    });

    test('reports being offline', () {
      respond = (request) => throw DioException.connectionError(
        requestOptions: request,
        reason: 'offline',
      );

      expect(repository.revoke(device), throwsA(isA<OfflineFailure>()));
    });
  });
}
