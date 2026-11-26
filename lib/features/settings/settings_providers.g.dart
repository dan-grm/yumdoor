// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The logged-in user, or `null` if the space doesn't list them. Fails while
/// the server can't be reached, loaded again once it can.

@ProviderFor(currentAccount)
final currentAccountProvider = CurrentAccountProvider._();

/// The logged-in user, or `null` if the space doesn't list them. Fails while
/// the server can't be reached, loaded again once it can.

final class CurrentAccountProvider
    extends
        $FunctionalProvider<AsyncValue<UserRef?>, UserRef?, FutureOr<UserRef?>>
    with $FutureModifier<UserRef?>, $FutureProvider<UserRef?> {
  /// The logged-in user, or `null` if the space doesn't list them. Fails while
  /// the server can't be reached, loaded again once it can.
  CurrentAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'currentAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAccountHash();

  @$internal
  @override
  $FutureProviderElement<UserRef?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserRef?> create(Ref ref) {
    return currentAccount(ref);
  }
}

String _$currentAccountHash() => r'7f6547a4fef26bb57bc1a8e34c429da79077b3ab';

/// The Tandoor version of the session's server. Fails while the server can't
/// be reached, loaded again once it can.

@ProviderFor(serverVersion)
final serverVersionProvider = ServerVersionProvider._();

/// The Tandoor version of the session's server. Fails while the server can't
/// be reached, loaded again once it can.

final class ServerVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// The Tandoor version of the session's server. Fails while the server can't
  /// be reached, loaded again once it can.
  ServerVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'serverVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return serverVersion(ref);
  }
}

String _$serverVersionHash() => r'ce1cad545d3d25e9ceeb8f4238c740b50acf378a';
