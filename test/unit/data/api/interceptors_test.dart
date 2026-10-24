import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/api_failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';

import '../../../fakes/fake_http_adapter.dart';

void main() {
  final serverUrl = Uri.parse('https://example.com');

  group('CSRF token', () {
    test('goes with unsafe requests only', () async {
      final adapter = FakeHttpAdapter((_) => jsonResponse({}));
      final dio = createTandoorDio(
        serverUrl,
        token: 't',
        csrfToken: () => 'csrf',
      )..httpClientAdapter = adapter;

      await dio.get<Object?>('/api/user/');
      await dio.post<Object?>('/api/access-token/');
      await dio.delete<Object?>('/api/access-token/1/');

      expect(adapter.requests.map((r) => r.headers['X-CSRFToken']), [
        null,
        'csrf',
        'csrf',
      ]);
    });

    test('is left out when there is no cookie', () async {
      final adapter = FakeHttpAdapter((_) => jsonResponse({}));
      final dio = createTandoorDio(serverUrl, csrfToken: () => null)
        ..httpClientAdapter = adapter;

      await dio.post<Object?>('/api-token-auth/');

      expect(adapter.requests.single.headers, isNot(contains('X-CSRFToken')));
    });
  });

  group('onUnauthorized', () {
    Future<int> rejectionsFor(int status) async {
      var calls = 0;
      final dio =
          createTandoorDio(serverUrl, token: 't', onUnauthorized: () => calls++)
            ..httpClientAdapter = FakeHttpAdapter(
              (_) => jsonResponse({'detail': 'x'}, status: status),
            );
      try {
        await guardRequest(() => dio.get<Object?>('/api/recipe/'));
      } on Failure {
        // Expected for every status here.
      }
      return calls;
    }

    test('is called for 401 and 403', () async {
      expect(await rejectionsFor(401), 1);
      expect(await rejectionsFor(403), 1);
    });

    test('is not called for other errors', () async {
      expect(await rejectionsFor(404), 0);
      expect(await rejectionsFor(500), 0);
    });
  });

  group('onReachable', () {
    Future<List<bool>> reportsFor(
      FutureOr<ResponseBody> Function(RequestOptions) respond,
    ) async {
      final reports = <bool>[];
      final dio = createTandoorDio(
        serverUrl,
        token: 't',
        onReachable: reports.add,
      )..httpClientAdapter = FakeHttpAdapter(respond);
      try {
        await guardRequest(() => dio.get<Object?>('/api/recipe/'));
      } on Failure {
        // Expected for the failing requests here.
      }
      return reports;
    }

    DioException connectionError(RequestOptions request) => DioException(
      requestOptions: request,
      type: DioExceptionType.connectionError,
    );

    test('reports any answer as reachable, errors included', () async {
      expect(await reportsFor((_) => jsonResponse({})), [true]);
      expect(await reportsFor((_) => jsonResponse({}, status: 500)), [true]);
    });

    test('reports a failed connection as unreachable', () async {
      expect(await reportsFor((request) => throw connectionError(request)), [
        false,
      ]);
    });
  });
}
