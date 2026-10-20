// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tokenStore)
final tokenStoreProvider = TokenStoreProvider._();

final class TokenStoreProvider
    extends $FunctionalProvider<TokenStore, TokenStore, TokenStore>
    with $Provider<TokenStore> {
  TokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStoreHash();

  @$internal
  @override
  $ProviderElement<TokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStore create(Ref ref) {
    return tokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStore>(value),
    );
  }
}

String _$tokenStoreHash() => r'4f22ee87dd2d663815a7b5f069d8ff055eac1c8b';

@ProviderFor(wakeLockService)
final wakeLockServiceProvider = WakeLockServiceProvider._();

final class WakeLockServiceProvider
    extends
        $FunctionalProvider<WakeLockService, WakeLockService, WakeLockService>
    with $Provider<WakeLockService> {
  WakeLockServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wakeLockServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wakeLockServiceHash();

  @$internal
  @override
  $ProviderElement<WakeLockService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WakeLockService create(Ref ref) {
    return wakeLockService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WakeLockService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WakeLockService>(value),
    );
  }
}

String _$wakeLockServiceHash() => r'b5ef1ea6d37dfe47d23d39ed28c5f01bfd1d3d58';

@ProviderFor(connectivityService)
final connectivityServiceProvider = ConnectivityServiceProvider._();

final class ConnectivityServiceProvider
    extends
        $FunctionalProvider<
          ConnectivityService,
          ConnectivityService,
          ConnectivityService
        >
    with $Provider<ConnectivityService> {
  ConnectivityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityServiceHash();

  @$internal
  @override
  $ProviderElement<ConnectivityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectivityService create(Ref ref) {
    return connectivityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityService>(value),
    );
  }
}

String _$connectivityServiceHash() =>
    r'8aad782a54ee2cf5a02eced6652ee1a3bb1b3acd';
