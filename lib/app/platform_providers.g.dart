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

@ProviderFor(linkOpener)
final linkOpenerProvider = LinkOpenerProvider._();

final class LinkOpenerProvider
    extends $FunctionalProvider<LinkOpener, LinkOpener, LinkOpener>
    with $Provider<LinkOpener> {
  LinkOpenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkOpenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkOpenerHash();

  @$internal
  @override
  $ProviderElement<LinkOpener> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkOpener create(Ref ref) {
    return linkOpener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkOpener value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkOpener>(value),
    );
  }
}

String _$linkOpenerHash() => r'efd9c315d7fb7cc807c1bd63702ed7ca7b37b862';

@ProviderFor(imagePickerService)
final imagePickerServiceProvider = ImagePickerServiceProvider._();

final class ImagePickerServiceProvider
    extends
        $FunctionalProvider<
          ImagePickerService,
          ImagePickerService,
          ImagePickerService
        >
    with $Provider<ImagePickerService> {
  ImagePickerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imagePickerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imagePickerServiceHash();

  @$internal
  @override
  $ProviderElement<ImagePickerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImagePickerService create(Ref ref) {
    return imagePickerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImagePickerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImagePickerService>(value),
    );
  }
}

String _$imagePickerServiceHash() =>
    r'a47c0836f38a5cdd70a2cd4d912cb6b5cc7f2ad9';

@ProviderFor(localStore)
final localStoreProvider = LocalStoreProvider._();

final class LocalStoreProvider
    extends $FunctionalProvider<LocalStore, LocalStore, LocalStore>
    with $Provider<LocalStore> {
  LocalStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStoreHash();

  @$internal
  @override
  $ProviderElement<LocalStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalStore create(Ref ref) {
    return localStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStore>(value),
    );
  }
}

String _$localStoreHash() => r'a74858d5c66d3e3c7055281e69c4b83c2e449a87';

/// The current time; tests override it to move the clock.

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The current time; tests override it to move the clock.

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// The current time; tests override it to move the clock.
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

@ProviderFor(timerAlertService)
final timerAlertServiceProvider = TimerAlertServiceProvider._();

final class TimerAlertServiceProvider
    extends
        $FunctionalProvider<
          TimerAlertService,
          TimerAlertService,
          TimerAlertService
        >
    with $Provider<TimerAlertService> {
  TimerAlertServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerAlertServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerAlertServiceHash();

  @$internal
  @override
  $ProviderElement<TimerAlertService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimerAlertService create(Ref ref) {
    return timerAlertService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerAlertService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerAlertService>(value),
    );
  }
}

String _$timerAlertServiceHash() => r'7384ce5287b84000649723ee26714c7e6f19a253';
