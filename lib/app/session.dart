import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/failures.dart';
import '../domain/models/session.dart';
import '../platform/token_store/token_store.dart';
import 'platform_providers.dart';
import 'repository_providers.dart';

part 'session.g.dart';

/// The current login, kept across app starts in the [TokenStore]; `null`
/// while nobody is logged in.
///
/// Only the token is stored, never the password. Starting the app reads the
/// stored session without asking the server, so it also starts offline.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  Future<void>? _tokenCheck;

  @override
  Future<Session?> build() async {
    final store = ref.watch(tokenStoreProvider);
    final serverUrl = await store.readServerUrl();
    final token = await store.readToken();
    if (serverUrl == null || token == null) return null;
    return Session(
      serverUrl: serverUrl,
      token: token.token,
      deviceTokenId: token.id,
    );
  }

  /// Logs in with username and password. Throws a [Failure] and leaves the
  /// session as it was if that fails.
  Future<void> loginWithPassword(
    Uri serverUrl, {
    required String username,
    required String password,
  }) async => _start(
    await ref
        .read(authRepositoryProvider)
        .loginWithPassword(serverUrl, username: username, password: password),
  );

  /// Logs in with a pasted API token. Throws a [Failure] and leaves the
  /// session as it was if the server rejects it.
  Future<void> loginWithToken(Uri serverUrl, String token) async => _start(
    await ref.read(authRepositoryProvider).loginWithToken(serverUrl, token),
  );

  Future<void> _start(Session session) async {
    final store = ref.read(tokenStoreProvider);
    await store.writeServerUrl(session.serverUrl);
    await store.writeToken(
      StoredToken(session.token, id: session.deviceTokenId),
    );
    state = AsyncData(session);
  }

  /// Deletes Yumdoor's device token on the server if online, then forgets
  /// the token and clears the offline cache.
  ///
  /// Logging out never fails: if the server can't be reached, the device
  /// token stays valid on the server until it expires or the user deletes it
  /// in Tandoor's settings.
  Future<void> logout() async {
    final session = state.value;
    if (session == null) return;
    if (session.ownsToken && ref.read(connectivityServiceProvider).isOnline) {
      try {
        await ref.read(authRepositoryProvider).revoke(session);
      } on Failure {
        // Offline after all, or a server error: log out locally anyway.
      }
    }
    await _end(session);
  }

  /// Checks the token after the server rejected a request, and ends the
  /// session if the token no longer works.
  ///
  /// Tandoor answers a missing permission with the same 403 as an invalid
  /// token, so one rejected request is not enough to log out.
  Future<void> checkToken() =>
      _tokenCheck ??= _checkToken().whenComplete(() => _tokenCheck = null);

  Future<void> _checkToken() async {
    final session = state.value;
    if (session == null) return;
    try {
      await ref.read(authRepositoryProvider).verify(session);
    } on UnauthorizedFailure {
      await _end(session);
    } on Failure {
      // Offline or a server error says nothing about the token.
    }
  }

  Future<void> _end(Session session) async {
    // Someone logged in again meanwhile.
    if (state.value != session) return;
    // The server URL stays, so login can prefill it. The offline cache goes:
    // the next login may be someone else, or another server.
    await ref.read(offlineCacheProvider).clear();
    await ref.read(tokenStoreProvider).clearToken();
    state = const AsyncData(null);
  }
}

/// The server of the last session, to prefill login.
@riverpod
Future<Uri?> savedServerUrl(Ref ref) =>
    ref.watch(tokenStoreProvider).readServerUrl();
