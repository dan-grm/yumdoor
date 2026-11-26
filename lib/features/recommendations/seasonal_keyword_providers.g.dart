// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_keyword_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current account's month → keyword mapping, empty until the user sets
/// one up. Ids of keywords deleted on the server stay stored; drop them
/// where the mapping is read against the keyword list
/// ([SeasonalKeywords.retainKeywords]).

@ProviderFor(SeasonalKeywordMapping)
final seasonalKeywordMappingProvider = SeasonalKeywordMappingProvider._();

/// The current account's month → keyword mapping, empty until the user sets
/// one up. Ids of keywords deleted on the server stay stored; drop them
/// where the mapping is read against the keyword list
/// ([SeasonalKeywords.retainKeywords]).
final class SeasonalKeywordMappingProvider
    extends $AsyncNotifierProvider<SeasonalKeywordMapping, SeasonalKeywords> {
  /// The current account's month → keyword mapping, empty until the user sets
  /// one up. Ids of keywords deleted on the server stay stored; drop them
  /// where the mapping is read against the keyword list
  /// ([SeasonalKeywords.retainKeywords]).
  SeasonalKeywordMappingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalKeywordMappingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalKeywordMappingHash();

  @$internal
  @override
  SeasonalKeywordMapping create() => SeasonalKeywordMapping();
}

String _$seasonalKeywordMappingHash() =>
    r'ea4e301e3fc1ef736f4857b2ad198c612fc85ddc';

/// The current account's month → keyword mapping, empty until the user sets
/// one up. Ids of keywords deleted on the server stay stored; drop them
/// where the mapping is read against the keyword list
/// ([SeasonalKeywords.retainKeywords]).

abstract class _$SeasonalKeywordMapping
    extends $AsyncNotifier<SeasonalKeywords> {
  FutureOr<SeasonalKeywords> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SeasonalKeywords>, SeasonalKeywords>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SeasonalKeywords>, SeasonalKeywords>,
              AsyncValue<SeasonalKeywords>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
