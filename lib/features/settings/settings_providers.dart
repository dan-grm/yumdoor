import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/offline.dart';
import '../../app/repository_providers.dart';
import '../../app/session.dart';
import '../../domain/models/user_ref.dart';

part 'settings_providers.g.dart';

/// The logged-in user, or `null` if the space doesn't list them. Fails while
/// the server can't be reached, loaded again once it can.
@Riverpod(retry: _noRetry)
Future<UserRef?> currentAccount(Ref ref) async {
  ref.listen(isOfflineProvider, (was, offline) {
    if (was == true && !offline) ref.invalidateSelf();
  });
  final users = ref.watch(userRepositoryProvider);
  final id = await users.currentUserId();
  return (await users.users()).where((user) => user.id == id).firstOrNull;
}

/// The Tandoor version of the session's server. Fails while the server can't
/// be reached, loaded again once it can.
@Riverpod(retry: _noRetry)
Future<String> serverVersion(Ref ref) async {
  ref.listen(isOfflineProvider, (was, offline) {
    if (was == true && !offline) ref.invalidateSelf();
  });
  final session = await ref.watch(sessionControllerProvider.future);
  if (session == null) throw StateError('Not logged in');
  final info = await ref
      .watch(serverRepositoryProvider)
      .fetchServerInfo(session.serverUrl);
  return info.version;
}

Duration? _noRetry(int retryCount, Object error) => null;
