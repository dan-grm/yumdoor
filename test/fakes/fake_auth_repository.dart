import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/session.dart';
import 'package:yumdoor/domain/repositories/auth_repository.dart';

/// [AuthRepository] that accepts [password] for [username] and [validToken],
/// and records what it was asked to do.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.username = 'anna',
    this.password = 'anna-dev-only',
    this.validToken = 'tda_pasted',
  });

  final String username;
  final String password;
  final String validToken;

  /// Thrown by every call instead of answering, if set.
  Failure? failure;

  /// The token [loginWithPassword] hands out.
  static const deviceToken = 'tda_device';
  static const deviceTokenId = 42;

  final revoked = <Session>[];
  final verified = <Session>[];

  /// Tokens [verify] rejects from now on, e.g. after they were revoked.
  final rejectedTokens = <String>{};

  @override
  Future<Session> loginWithPassword(
    Uri serverUrl, {
    required String username,
    required String password,
  }) async {
    if (failure case final failure?) throw failure;
    if (username != this.username || password != this.password) {
      throw const InvalidCredentialsFailure();
    }
    return Session(
      serverUrl: serverUrl,
      token: deviceToken,
      deviceTokenId: deviceTokenId,
    );
  }

  @override
  Future<Session> loginWithToken(Uri serverUrl, String token) async {
    final session = Session(serverUrl: serverUrl, token: token);
    await verify(session);
    return session;
  }

  @override
  Future<void> verify(Session session) async {
    verified.add(session);
    if (failure case final failure?) throw failure;
    if (rejectedTokens.contains(session.token) ||
        session.token != validToken && session.token != deviceToken) {
      throw const UnauthorizedFailure();
    }
  }

  @override
  Future<void> revoke(Session session) async {
    if (failure case final failure?) throw failure;
    revoked.add(session);
  }
}
