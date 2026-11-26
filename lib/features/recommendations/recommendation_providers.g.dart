// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where recipe suggestions come from: the rules for now. Rebuilt when the
/// session or the seasonal keyword mapping changes.

@ProviderFor(recommender)
final recommenderProvider = RecommenderProvider._();

/// Where recipe suggestions come from: the rules for now. Rebuilt when the
/// session or the seasonal keyword mapping changes.

final class RecommenderProvider
    extends
        $FunctionalProvider<
          RecommendationProvider,
          RecommendationProvider,
          RecommendationProvider
        >
    with $Provider<RecommendationProvider> {
  /// Where recipe suggestions come from: the rules for now. Rebuilt when the
  /// session or the seasonal keyword mapping changes.
  RecommenderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommenderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommenderHash();

  @$internal
  @override
  $ProviderElement<RecommendationProvider> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecommendationProvider create(Ref ref) {
    return recommender(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecommendationProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecommendationProvider>(value),
    );
  }
}

String _$recommenderHash() => r'aac9ac73ea628f1e466a20dab90be77936b888b1';
