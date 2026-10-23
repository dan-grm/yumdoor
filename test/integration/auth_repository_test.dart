@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/repositories/tandoor_auth_repository.dart';
import 'package:yumdoor/domain/models/session.dart';

import 'seeded_tandoor.dart';

void main() {
  final tandoor = SeededTandoor.load();
  final repository = TandoorAuthRepository();

  Future<bool> works(String token) async {
    try {
      await repository.verify(
        Session(serverUrl: tandoor.baseUrl, token: token),
      );
      return true;
    } on UnauthorizedFailure {
      return false;
    }
  }

  // /api-token-auth/ allows 10 requests per day and IP, so this is the only
  // password login in the suite. It hands out the user's existing token,
  // which is the one the seed created.
  test('password login → device token → logout revokes only that', () async {
    final session = await repository.loginWithPassword(
      tandoor.baseUrl,
      username: 'ben',
      password: tandoor.password('ben'),
    );

    expect(session.ownsToken, isTrue);
    expect(session.token, isNot(tandoor.token('ben')));
    expect(await works(session.token), isTrue);

    await repository.revoke(session);

    expect(await works(session.token), isFalse);
    expect(await works(tandoor.token('ben')), isTrue);
    // Revoking again is harmless.
    await repository.revoke(session);
  });

  test('token login accepts a valid token and rejects others', () async {
    final session = await repository.loginWithToken(
      tandoor.baseUrl,
      tandoor.token('anna'),
    );
    expect(session.ownsToken, isFalse);

    await expectLater(
      repository.loginWithToken(tandoor.baseUrl, 'tda_not_a_token'),
      throwsA(isA<UnauthorizedFailure>()),
    );
  });

  test('revoke leaves a pasted token alone', () async {
    final pasted = Session(
      serverUrl: tandoor.baseUrl,
      token: tandoor.token('anna'),
    );

    await repository.revoke(pasted);

    expect(await works(pasted.token), isTrue);
  });
}
