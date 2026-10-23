// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.

@ProviderFor(WakeLockHintShown)
final wakeLockHintShownProvider = WakeLockHintShownProvider._();

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.
final class WakeLockHintShownProvider
    extends $NotifierProvider<WakeLockHintShown, bool> {
  /// Whether cooking mode already told the user, in this app session, that the
  /// screen can't be kept on. The hint is shown once, not on every recipe.
  WakeLockHintShownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wakeLockHintShownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wakeLockHintShownHash();

  @$internal
  @override
  WakeLockHintShown create() => WakeLockHintShown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$wakeLockHintShownHash() => r'01412455520bb7823d41f323c1d236f9e2b117e8';

/// Whether cooking mode already told the user, in this app session, that the
/// screen can't be kept on. The hint is shown once, not on every recipe.

abstract class _$WakeLockHintShown extends $Notifier<bool> {
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
