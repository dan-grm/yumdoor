import 'dart:typed_data';

/// Recipes and images kept on the device for offline use.
///
/// The recipe repository fills it and falls back to it; features only read
/// images from it and clear it.
abstract interface class OfflineCache {
  /// The stored bytes of the image at [url], or `null` if it isn't stored.
  Future<Uint8List?> image(Uri url);

  /// Deletes everything, e.g. on logout. With [keepShoppingQueue], the
  /// shopping check-offs not sent yet stay, for the next login to the same
  /// server (`ShoppingCheckQueue`).
  Future<void> clear({bool keepShoppingQueue = false});
}
