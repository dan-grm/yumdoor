// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the app is offline: the platform reports no network, or the last
/// request couldn't reach the server.
///
/// While offline, the app shows cached recipes and disables write actions.
/// Any answer from the server, or the network coming back, ends it.

@ProviderFor(IsOffline)
final isOfflineProvider = IsOfflineProvider._();

/// Whether the app is offline: the platform reports no network, or the last
/// request couldn't reach the server.
///
/// While offline, the app shows cached recipes and disables write actions.
/// Any answer from the server, or the network coming back, ends it.
final class IsOfflineProvider extends $NotifierProvider<IsOffline, bool> {
  /// Whether the app is offline: the platform reports no network, or the last
  /// request couldn't reach the server.
  ///
  /// While offline, the app shows cached recipes and disables write actions.
  /// Any answer from the server, or the network coming back, ends it.
  IsOfflineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOfflineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOfflineHash();

  @$internal
  @override
  IsOffline create() => IsOffline();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOfflineHash() => r'bc6410bb49de7118926df48550929fc17cf85496';

/// Whether the app is offline: the platform reports no network, or the last
/// request couldn't reach the server.
///
/// While offline, the app shows cached recipes and disables write actions.
/// Any answer from the server, or the network coming back, ends it.

abstract class _$IsOffline extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
