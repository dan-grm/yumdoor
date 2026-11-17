import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/repository_providers.dart';

part 'recipe_image.g.dart';

/// The bytes of the image at [url] from the offline cache, `null` if it
/// isn't stored.
@Riverpod(retry: _noRetry)
Future<Uint8List?> cachedImage(Ref ref, Uri url) =>
    ref.watch(offlineCacheProvider).image(url);

Duration? _noRetry(int retryCount, Object error) => null;

/// A recipe's photo at [url], covering its box; a copy from the offline
/// cache is preferred over the network. [placeholder] shows when there is no
/// usable URL or the image can't be loaded; nothing while the cache is read.
class RecipeImage extends ConsumerWidget {
  const RecipeImage({super.key, required this.url, required this.placeholder});

  final Uri? url;
  final Widget placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = this.url;
    if (url == null || !(url.isScheme('https') || url.isScheme('http'))) {
      return placeholder;
    }
    return switch (ref.watch(cachedImageProvider(url))) {
      AsyncData(value: final bytes?) => Image.memory(
        bytes,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => placeholder,
      ),
      // Reading the cache takes a moment; the background shows meanwhile.
      AsyncLoading() => const SizedBox.shrink(),
      _ => Image.network(
        url.toString(),
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => placeholder,
      ),
    };
  }
}
