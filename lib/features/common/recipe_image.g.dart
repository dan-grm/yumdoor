// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_image.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
