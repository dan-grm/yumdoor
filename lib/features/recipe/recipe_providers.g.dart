// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recipe with its steps, shared by the recipe screen and cooking mode.
///
/// Failures are shown with a retry button instead of retrying on their own.

@ProviderFor(recipe)
final recipeProvider = RecipeFamily._();

/// The recipe with its steps, shared by the recipe screen and cooking mode.
///
/// Failures are shown with a retry button instead of retrying on their own.

final class RecipeProvider
    extends $FunctionalProvider<AsyncValue<Recipe>, Recipe, FutureOr<Recipe>>
    with $FutureModifier<Recipe>, $FutureProvider<Recipe> {
  /// The recipe with its steps, shared by the recipe screen and cooking mode.
  ///
  /// Failures are shown with a retry button instead of retrying on their own.
  RecipeProvider._({
    required RecipeFamily super.from,
    required int super.argument,
  }) : super(
         retry: _noRetry,
         name: r'recipeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeHash();

  @override
  String toString() {
    return r'recipeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Recipe> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Recipe> create(Ref ref) {
    final argument = this.argument as int;
    return recipe(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeHash() => r'e909fdcafdbb278743449e0ddfc2c0a3e94da2f0';

/// The recipe with its steps, shared by the recipe screen and cooking mode.
///
/// Failures are shown with a retry button instead of retrying on their own.

final class RecipeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Recipe>, int> {
  RecipeFamily._()
    : super(
        retry: _noRetry,
        name: r'recipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The recipe with its steps, shared by the recipe screen and cooking mode.
  ///
  /// Failures are shown with a retry button instead of retrying on their own.

  RecipeProvider call(int id) => RecipeProvider._(argument: id, from: this);

  @override
  String toString() => r'recipeProvider';
}

/// The bytes of the image at [url] from the offline cache, `null` if it
/// isn't stored.

@ProviderFor(cachedImage)
final cachedImageProvider = CachedImageFamily._();

/// The bytes of the image at [url] from the offline cache, `null` if it
/// isn't stored.

final class CachedImageProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  /// The bytes of the image at [url] from the offline cache, `null` if it
  /// isn't stored.
  CachedImageProvider._({
    required CachedImageFamily super.from,
    required Uri super.argument,
  }) : super(
         retry: _noRetry,
         name: r'cachedImageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cachedImageHash();

  @override
  String toString() {
    return r'cachedImageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as Uri;
    return cachedImage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CachedImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cachedImageHash() => r'10dbf884ce9a74de3eb52976cef19cfced60143c';

/// The bytes of the image at [url] from the offline cache, `null` if it
/// isn't stored.

final class CachedImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Uri> {
  CachedImageFamily._()
    : super(
        retry: _noRetry,
        name: r'cachedImageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The bytes of the image at [url] from the offline cache, `null` if it
  /// isn't stored.

  CachedImageProvider call(Uri url) =>
      CachedImageProvider._(argument: url, from: this);

  @override
  String toString() => r'cachedImageProvider';
}
