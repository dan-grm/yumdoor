import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/api_failures.dart';

void main() {
  final request = RequestOptions(path: '/api/recipe/');

  DioException badResponse(int status, {Map<String, List<String>>? headers}) =>
      DioException.badResponse(
        statusCode: status,
        requestOptions: request,
        response: Response(
          requestOptions: request,
          statusCode: status,
          headers: Headers.fromMap(headers ?? {}),
        ),
      );

  group('failureFromDioException', () {
    test('maps connection problems and timeouts to OfflineFailure', () {
      for (final type in [
        DioExceptionType.connectionError,
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(
          failureFromDioException(
            DioException(requestOptions: request, type: type),
          ),
          isA<OfflineFailure>(),
          reason: '$type',
        );
      }
    });

    test('maps 401 and 403 to UnauthorizedFailure', () {
      expect(
        failureFromDioException(badResponse(401)),
        isA<UnauthorizedFailure>(),
      );
      expect(
        failureFromDioException(badResponse(403)),
        isA<UnauthorizedFailure>(),
      );
    });

    test('maps a cancelled request to CancelledFailure', () {
      expect(
        failureFromDioException(
          DioException.requestCancelled(requestOptions: request, reason: null),
        ),
        isA<CancelledFailure>(),
      );
    });

    test('maps 404 to NotFoundFailure', () {
      expect(failureFromDioException(badResponse(404)), isA<NotFoundFailure>());
    });

    test('maps 429 to ThrottledFailure with Retry-After', () {
      final failure = failureFromDioException(
        badResponse(
          429,
          headers: {
            'retry-after': ['3600'],
          },
        ),
      );

      expect(
        failure,
        isA<ThrottledFailure>().having(
          (f) => f.retryAfter,
          'retryAfter',
          const Duration(hours: 1),
        ),
      );
    });

    test('maps 429 without Retry-After', () {
      expect(
        failureFromDioException(badResponse(429)),
        isA<ThrottledFailure>().having((f) => f.retryAfter, 'retryAfter', null),
      );
    });

    test('maps other statuses to ServerFailure', () {
      for (final status in [400, 500, 502]) {
        expect(
          failureFromDioException(badResponse(status)),
          isA<ServerFailure>().having(
            (f) => f.statusCode,
            'statusCode',
            status,
          ),
        );
      }
    });

    test('maps an unreadable response to ServerFailure', () {
      final failure = failureFromDioException(
        DioException(
          requestOptions: request,
          response: Response(requestOptions: request, statusCode: 200),
          error: const FormatException('not JSON'),
        ),
      );

      expect(
        failure,
        isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 200),
      );
    });
  });

  group('guardRequest', () {
    test('returns the result', () async {
      expect(await guardRequest(() async => 42), 42);
    });

    test('throws a Failure for a DioException', () {
      expect(
        guardRequest<void>(() async => throw badResponse(404)),
        throwsA(isA<NotFoundFailure>()),
      );
    });

    test('throws a ServerFailure for a FormatException from a mapper', () {
      expect(
        guardRequest<void>(() async => throw const FormatException('no id')),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
