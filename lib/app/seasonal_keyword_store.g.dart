// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_keyword_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The store of the logged-in account. Fails while nobody is logged in, and
/// when the user can't be read (offline at the first start).

@ProviderFor(seasonalKeywordStore)
final seasonalKeywordStoreProvider = SeasonalKeywordStoreProvider._();

/// The store of the logged-in account. Fails while nobody is logged in, and
/// when the user can't be read (offline at the first start).

final class SeasonalKeywordStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeasonalKeywordStore>,
          SeasonalKeywordStore,
          FutureOr<SeasonalKeywordStore>
        >
    with
        $FutureModifier<SeasonalKeywordStore>,
        $FutureProvider<SeasonalKeywordStore> {
  /// The store of the logged-in account. Fails while nobody is logged in, and
  /// when the user can't be read (offline at the first start).
  SeasonalKeywordStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalKeywordStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalKeywordStoreHash();

  @$internal
  @override
  $FutureProviderElement<SeasonalKeywordStore> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeasonalKeywordStore> create(Ref ref) {
    return seasonalKeywordStore(ref);
  }
}

String _$seasonalKeywordStoreHash() =>
    r'4f3ba3ba523fd1dc37e004ac11041f08d7ecc3b5';
