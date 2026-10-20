// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The locale chosen in settings, or `null` to follow the device.

@ProviderFor(LocaleOverride)
final localeOverrideProvider = LocaleOverrideProvider._();

/// The locale chosen in settings, or `null` to follow the device.
final class LocaleOverrideProvider
    extends $NotifierProvider<LocaleOverride, Locale?> {
  /// The locale chosen in settings, or `null` to follow the device.
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

String _$localeOverrideHash() => r'2b635884191df5c00e50949d690af2d117dee780';

/// The locale chosen in settings, or `null` to follow the device.

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
