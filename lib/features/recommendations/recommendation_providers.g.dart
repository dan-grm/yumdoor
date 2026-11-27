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

/// The suggestions for [day], best first, computed once per day: the start
/// screen and the list screen share them, and visiting either again doesn't
/// compute them again. Invalidate it to compute them anew (pull to refresh);
/// it also is when the seasonal keywords change, and once the server can be
/// reached again after a failure.
///
/// Failures aren't retried; the screens show them with a button.

@ProviderFor(recommendations)
final recommendationsProvider = RecommendationsFamily._();

/// The suggestions for [day], best first, computed once per day: the start
/// screen and the list screen share them, and visiting either again doesn't
/// compute them again. Invalidate it to compute them anew (pull to refresh);
/// it also is when the seasonal keywords change, and once the server can be
/// reached again after a failure.
///
/// Failures aren't retried; the screens show them with a button.

final class RecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recommendation>>,
          List<Recommendation>,
          FutureOr<List<Recommendation>>
        >
    with
        $FutureModifier<List<Recommendation>>,
        $FutureProvider<List<Recommendation>> {
  /// The suggestions for [day], best first, computed once per day: the start
  /// screen and the list screen share them, and visiting either again doesn't
  /// compute them again. Invalidate it to compute them anew (pull to refresh);
  /// it also is when the seasonal keywords change, and once the server can be
  /// reached again after a failure.
  ///
  /// Failures aren't retried; the screens show them with a button.
  RecommendationsProvider._({
    required RecommendationsFamily super.from,
    required CalendarDay super.argument,
  }) : super(
         retry: _noRetry,
         name: r'recommendationsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recommendationsHash();

  @override
  String toString() {
    return r'recommendationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Recommendation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recommendation>> create(Ref ref) {
    final argument = this.argument as CalendarDay;
    return recommendations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecommendationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recommendationsHash() => r'a0b5b2986df62da4c222fe1dd591eebe8563c5b1';

/// The suggestions for [day], best first, computed once per day: the start
/// screen and the list screen share them, and visiting either again doesn't
/// compute them again. Invalidate it to compute them anew (pull to refresh);
/// it also is when the seasonal keywords change, and once the server can be
/// reached again after a failure.
///
/// Failures aren't retried; the screens show them with a button.

final class RecommendationsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<Recommendation>>, CalendarDay> {
  RecommendationsFamily._()
    : super(
        retry: _noRetry,
        name: r'recommendationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The suggestions for [day], best first, computed once per day: the start
  /// screen and the list screen share them, and visiting either again doesn't
  /// compute them again. Invalidate it to compute them anew (pull to refresh);
  /// it also is when the seasonal keywords change, and once the server can be
  /// reached again after a failure.
  ///
  /// Failures aren't retried; the screens show them with a button.

  RecommendationsProvider call(CalendarDay day) =>
      RecommendationsProvider._(argument: day, from: this);

  @override
  String toString() => r'recommendationsProvider';
}

/// Whether the user dismissed the hint to set up seasonal keywords, kept on
/// this device.

@ProviderFor(SeasonalHintDismissed)
final seasonalHintDismissedProvider = SeasonalHintDismissedProvider._();

/// Whether the user dismissed the hint to set up seasonal keywords, kept on
/// this device.
final class SeasonalHintDismissedProvider
    extends $NotifierProvider<SeasonalHintDismissed, bool> {
  /// Whether the user dismissed the hint to set up seasonal keywords, kept on
  /// this device.
  SeasonalHintDismissedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalHintDismissedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalHintDismissedHash();

  @$internal
  @override
  SeasonalHintDismissed create() => SeasonalHintDismissed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$seasonalHintDismissedHash() =>
    r'f7f5f0ad145277fb3c524470717814ded3390329';

/// Whether the user dismissed the hint to set up seasonal keywords, kept on
/// this device.

abstract class _$SeasonalHintDismissed extends $Notifier<bool> {
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
