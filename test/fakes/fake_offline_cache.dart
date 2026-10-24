import 'dart:typed_data';

import 'package:yumdoor/domain/repositories/offline_cache.dart';

/// [OfflineCache] for tests: answers from [images] and counts [clear] calls.
class FakeOfflineCache implements OfflineCache {
  FakeOfflineCache({Map<Uri, Uint8List>? images}) : images = images ?? {};

  final Map<Uri, Uint8List> images;
  int clearCount = 0;

  @override
  Future<Uint8List?> image(Uri url) async => images[url];

  @override
  Future<void> clear() async {
    clearCount++;
    images.clear();
  }
}
