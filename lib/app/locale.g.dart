// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The locale chosen in settings, or `null` to follow the device (the
/// default). Kept on the device in the `LocalStore`, across restarts and
/// logout; unsupported values mean the device language.

@ProviderFor(LocaleOverride)
final localeOverrideProvider = LocaleOverrideProvider._();

/// The locale chosen in settings, or `null` to follow the device (the
/// default). Kept on the device in the `LocalStore`, across restarts and
/// logout; unsupported values mean the device language.
final class LocaleOverrideProvider
    extends $NotifierProvider<LocaleOverride, Locale?> {
  /// The locale chosen in settings, or `null` to follow the device (the
  /// default). Kept on the device in the `LocalStore`, across restarts and
  /// logout; unsupported values mean the device language.
  LocaleOverrideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeOverrideProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeOverrideHash();

  @$internal
  @override
  LocaleOverride create() => LocaleOverride();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeOverrideHash() => r'b08ddbb88be7948cf6762064c5e98ccacae3b201';

/// The locale chosen in settings, or `null` to follow the device (the
/// default). Kept on the device in the `LocalStore`, across restarts and
/// logout; unsupported values mean the device language.

abstract class _$LocaleOverride extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
