/// What can go wrong when talking to Tandoor, independent of the HTTP client.
///
/// Repositories throw these; the UI switches over them to explain what
/// happened. `lib/data/api/api_failures.dart` maps HTTP errors to them.
sealed class Failure implements Exception {
  const Failure();
}

/// The server could not be reached: no network, DNS, refused connection or a
/// timeout. On the web this also covers requests the browser blocked, such as
/// a cross-origin server without CORS headers.
final class OfflineFailure extends Failure {
  const OfflineFailure();

  @override
  String toString() => 'OfflineFailure';
}

/// The token is missing, invalid or revoked, or it may not do this.
///
/// Tandoor answers both with 403 (see docs/TANDOOR_API.md#authentication), so
/// they can't be told apart.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();

  @override
  String toString() => 'UnauthorizedFailure';
}

/// The username or password is wrong.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();

  @override
  String toString() => 'InvalidCredentialsFailure';
}

/// Too many requests (HTTP 429), e.g. more than 10 password logins a day.
final class ThrottledFailure extends Failure {
  const ThrottledFailure({this.retryAfter});

  /// How long the server asks to wait, if it said so.
  final Duration? retryAfter;

  @override
  String toString() => 'ThrottledFailure(retryAfter: $retryAfter)';
}

/// The requested object does not exist, or the user can't see it.
final class NotFoundFailure extends Failure {
  const NotFoundFailure();

  @override
  String toString() => 'NotFoundFailure';
}

/// The caller cancelled the request with a `CancelSignal`.
final class CancelledFailure extends Failure {
  const CancelledFailure();

  @override
  String toString() => 'CancelledFailure';
}

/// The URL does not point to a Tandoor 2.x server.
final class IncompatibleServerFailure extends Failure {
  const IncompatibleServerFailure();

  @override
  String toString() => 'IncompatibleServerFailure';
}

/// The server answered with an error, or with something Yumdoor can't read.
final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode, this.cause});

  /// The HTTP status, if there was a response.
  final int? statusCode;

  /// What went wrong, for logs. Not for display.
  final Object? cause;

  @override
  String toString() => 'ServerFailure(statusCode: $statusCode, cause: $cause)';
}
