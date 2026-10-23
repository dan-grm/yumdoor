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

@ProviderFor(csrfTokenSource)
final csrfTokenSourceProvider = CsrfTokenSourceProvider._();

final class CsrfTokenSourceProvider
    extends
        $FunctionalProvider<CsrfTokenSource, CsrfTokenSource, CsrfTokenSource>
    with $Provider<CsrfTokenSource> {
  CsrfTokenSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'csrfTokenSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$csrfTokenSourceHash();

  @$internal
  @override
  $ProviderElement<CsrfTokenSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CsrfTokenSource create(Ref ref) {
    return csrfTokenSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CsrfTokenSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CsrfTokenSource>(value),
    );
  }
}

String _$csrfTokenSourceHash() => r'6dc4dece0002a1d99b36926d7811b5933f56ef67';

/// In the web build, the origin the app is served from. Tandoor sends no CORS
/// headers, so it is the only origin whose Tandoor the app can reach
/// (docs/TANDOOR_API.md#cors-and-deployment). `null` in native apps.

@ProviderFor(webOrigin)
final webOriginProvider = WebOriginProvider._();

/// In the web build, the origin the app is served from. Tandoor sends no CORS
/// headers, so it is the only origin whose Tandoor the app can reach
/// (docs/TANDOOR_API.md#cors-and-deployment). `null` in native apps.

final class WebOriginProvider extends $FunctionalProvider<Uri?, Uri?, Uri?>
    with $Provider<Uri?> {
  /// In the web build, the origin the app is served from. Tandoor sends no CORS
  /// headers, so it is the only origin whose Tandoor the app can reach
  /// (docs/TANDOOR_API.md#cors-and-deployment). `null` in native apps.
  WebOriginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webOriginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webOriginHash();

  @$internal
  @override
  $ProviderElement<Uri?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Uri? create(Ref ref) {
    return webOrigin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Uri? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Uri?>(value),
    );
  }
}

String _$webOriginHash() => r'3c77ccb83bd0eb3ec2edec68b3bb9d2d09d32b20';

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
