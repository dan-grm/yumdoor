import 'package:dio/dio.dart';

import '../../core/failures.dart';

/// Runs [request] and throws a [Failure] for whatever goes wrong, including
/// the `FormatException`s the mappers throw for responses they can't use.
Future<T> guardRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (e) {
    throw failureFromDioException(e);
  } on FormatException catch (e) {
    throw ServerFailure(cause: e);
  }
}

/// The [Failure] for a failed request.
Failure failureFromDioException(DioException e) {
  final response = e.response;
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const OfflineFailure(),
    DioExceptionType.badResponse => _failureForStatus(response!),
    // A response the generated client could not deserialize ends up here,
    // with the response attached.
    DioExceptionType.unknown ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.badCertificate ||
    DioExceptionType.cancel => ServerFailure(
      statusCode: response?.statusCode,
      cause: e.error ?? e.type,
    ),
  };
}

Failure _failureForStatus(Response<Object?> response) {
  final status = response.statusCode;
  return switch (status) {
    // Tandoor sends 403, not 401, for a missing or invalid token.
    401 || 403 => const UnauthorizedFailure(),
    404 => const NotFoundFailure(),
    429 => ThrottledFailure(retryAfter: _retryAfter(response)),
    _ => ServerFailure(statusCode: status, cause: response.data),
  };
}

/// Django REST framework sends `Retry-After` in seconds.
Duration? _retryAfter(Response<Object?> response) {
  final seconds = int.tryParse(response.headers.value('retry-after') ?? '');
  return seconds == null ? null : Duration(seconds: seconds);
}
