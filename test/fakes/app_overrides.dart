import 'package:flutter_riverpod/misc.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/platform/token_store/token_store.dart';

import 'fake_auth_repository.dart';
import 'fake_connectivity_service.dart';
import 'fake_server_repository.dart';
import 'in_memory_token_store.dart';

final testServerUrl = Uri.parse('https://tandoor.example.com');

/// A token store with a session from an earlier password login.
InMemoryTokenStore loggedInTokenStore() => InMemoryTokenStore(
  serverUrl: testServerUrl,
  token: const StoredToken(
    FakeAuthRepository.deviceToken,
    id: FakeAuthRepository.deviceTokenId,
  ),
);

/// Overrides every provider that would touch the platform or the network.
List<Override> appOverrides({
  TokenStore? tokenStore,
  FakeAuthRepository? auth,
  FakeServerRepository? server,
  FakeConnectivityService? connectivity,
  Uri? webOrigin,
}) => [
  tokenStoreProvider.overrideWithValue(tokenStore ?? InMemoryTokenStore()),
  authRepositoryProvider.overrideWithValue(auth ?? FakeAuthRepository()),
  serverRepositoryProvider.overrideWithValue(server ?? FakeServerRepository()),
  connectivityServiceProvider.overrideWithValue(
    connectivity ?? FakeConnectivityService(),
  ),
  webOriginProvider.overrideWithValue(webOrigin),
];
