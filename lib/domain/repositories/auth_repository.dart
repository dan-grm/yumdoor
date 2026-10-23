import '../../core/failures.dart';
import '../models/session.dart';

/// Logs into a Tandoor server and out again. Methods throw a [Failure].
///
/// Only talks to the server; keeping the session across app starts is the
/// session controller's job.
abstract interface class AuthRepository {
  /// Exchanges [username] and [password] for a new token for this device.
  ///
  /// Throws [InvalidCredentialsFailure] for a wrong username or password and
  /// [ThrottledFailure] after too many password logins (Tandoor allows 10 a
  /// day per IP address).
  Future<Session> loginWithPassword(
    Uri serverUrl, {
    required String username,
    required String password,
  });

  /// Checks a token the user pasted with a cheap authenticated request.
  ///
  /// Throws [UnauthorizedFailure] if the server rejects it.
  Future<Session> loginWithToken(Uri serverUrl, String token);

  /// Throws [UnauthorizedFailure] if the server no longer accepts the
  /// session's token.
  Future<void> verify(Session session);

  /// Deletes the session's token on the server if Yumdoor created it, so it
  /// stops working; does nothing for a pasted token.
  Future<void> revoke(Session session);
}
