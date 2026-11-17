import 'dart:typed_data';

/// An image to upload as a recipe's photo: JPEG, PNG, WebP or GIF, checked
/// by content before it gets here.
final class ImageUpload {
  const ImageUpload({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
  });

  final Uint8List bytes;

  /// The name to send, with the extension that matches [mimeType]: Tandoor
  /// refuses a name without one of `.jpg`, `.jpeg`, `.png`, `.webp` or `.gif`
  /// (docs/TANDOOR_API.md#recipe-images).
  final String fileName;

  /// `image/jpeg`, `image/png`, `image/webp` or `image/gif`.
  final String mimeType;
}
