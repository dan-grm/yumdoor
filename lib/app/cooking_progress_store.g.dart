// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_progress_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cookingProgressStore)
final cookingProgressStoreProvider = CookingProgressStoreProvider._();

final class CookingProgressStoreProvider
    extends
        $FunctionalProvider<
          CookingProgressStore,
          CookingProgressStore,
          CookingProgressStore
        >
    with $Provider<CookingProgressStore> {
  CookingProgressStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookingProgressStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookingProgressStoreHash();

  @$internal
  @override
  $ProviderElement<CookingProgressStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CookingProgressStore create(Ref ref) {
    return cookingProgressStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookingProgressStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookingProgressStore>(value),
    );
  }
}

String _$cookingProgressStoreHash() =>
    r'02125580ae6166958e312ff4fb418f6f48d1fa93';
