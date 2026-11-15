import 'dart:typed_data';

import 'image_picker_service_stub.dart'
    if (dart.library.js_interop) 'image_picker_service_web.dart';

/// Gets an image for a recipe: from the camera, a file picker, or a file
/// dropped onto the window.
///
/// Every file is checked with [checkImage]: only JPEG, PNG, WebP and GIF up to
/// [maxImageBytes] become a [PickedImage]; anything else is a [RejectedImage]
/// the UI can explain.
abstract interface class ImagePickerService {
  /// The image picker for the current platform.
  factory ImagePickerService() = PlatformImagePickerService;

  /// Whether to offer "Foto aufnehmen": on devices whose main pointer is touch
  /// (phones, tablets), where a file input can open the camera.
  bool get canUseCamera;

  /// Whether to show a drop zone: on devices with a mouse or trackpad.
  bool get supportsDrop;

  /// Opens the camera (where the platform has none, its image picker).
  /// `null` when the user cancels. Call it directly from a tap handler:
  /// browsers only open pickers in response to a user gesture.
  Future<ImagePickResult?> pickFromCamera();

  /// Opens a file picker for images. `null` when the user cancels. Call it
  /// directly from a tap handler, like [pickFromCamera].
  Future<ImagePickResult?> pickFile();

  /// Files dragged over and dropped onto the window. The window is a drop
  /// target only while this stream has a listener; otherwise the platform's
  /// default applies (a browser opens a dropped file in place of the app).
  Stream<ImageDropEvent> get drops;

  void dispose();
}

/// The outcome of a pick or a drop.
sealed class ImagePickResult {
  const ImagePickResult(this.name);

  /// The file name as the platform reported it.
  final String name;
}

/// An accepted image.
final class PickedImage extends ImagePickResult {
  const PickedImage({
    required String name,
    required this.bytes,
    required this.mimeType,
  }) : super(name);

  final Uint8List bytes;

  /// The type read from the content, one of [acceptedImageTypes].
  final String mimeType;

  /// [name] with the extension that matches [mimeType], for servers that go by
  /// the extension (`photo.HEIC` that is really a JPEG becomes `photo.jpg`).
  String get fileName {
    final trimmed = name.trim();
    final dot = trimmed.lastIndexOf('.');
    final stem = dot >= 0 ? trimmed.substring(0, dot) : trimmed;
    return '${stem.isEmpty ? 'image' : stem}.${_extensions[mimeType]}';
  }
}

/// A file that can't be used, with the reason.
final class RejectedImage extends ImagePickResult {
  const RejectedImage({required String name, required this.reason})
    : super(name);

  final ImageRejection reason;
}

enum ImageRejection {
  /// Not a JPEG, PNG, WebP or GIF image (by content, not by name).
  notAnImage,

  /// Larger than [maxImageBytes].
  tooLarge,

  /// The platform couldn't read the file (moved, access revoked).
  unreadable,
}

/// What the drop target reports.
sealed class ImageDropEvent {
  const ImageDropEvent();
}

/// Files are being dragged over the window ([isOver]), or no longer are (they
/// left the window or were dropped).
final class ImageDragHover extends ImageDropEvent {
  const ImageDragHover({required this.isOver});

  final bool isOver;
}

/// Files were dropped; [result] is for the first of them.
final class ImageDropped extends ImageDropEvent {
  const ImageDropped(this.result);

  final ImagePickResult result;
}

/// The largest image accepted: 20 MiB. Phone camera photos are 2–8 MB.
///
/// Provisional until #82 verifies Tandoor 2.6.15's upload limit.
const maxImageBytes = 20 * 1024 * 1024;

/// The image types accepted, as a file picker should list them.
const acceptedImageTypes = [
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
];

const _extensions = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
  'image/gif': 'gif',
};

/// Whether a file of [size] bytes is too large to be read at all.
bool isTooLargeImage(int size) => size > maxImageBytes;

/// Checks [bytes] read from a file called [name]. The type comes from the
/// content: the platform's MIME type and the name can't be trusted.
ImagePickResult checkImage({required String name, required Uint8List bytes}) {
  if (isTooLargeImage(bytes.length)) {
    return RejectedImage(name: name, reason: ImageRejection.tooLarge);
  }
  final mimeType = sniffImageType(bytes);
  if (mimeType == null) {
    return RejectedImage(name: name, reason: ImageRejection.notAnImage);
  }
  return PickedImage(name: name, bytes: bytes, mimeType: mimeType);
}

/// The type of image [bytes] start with, if one of [acceptedImageTypes].
String? sniffImageType(Uint8List bytes) {
  bool has(List<int> signature, [int offset = 0]) {
    if (bytes.length < offset + signature.length) return false;
    for (var i = 0; i < signature.length; i++) {
      if (bytes[offset + i] != signature[i]) return false;
    }
    return true;
  }

  if (has(const [0xFF, 0xD8, 0xFF])) return 'image/jpeg';
  if (has(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
    return 'image/png';
  }
  if (has('RIFF'.codeUnits) && has('WEBP'.codeUnits, 8)) return 'image/webp';
  if (has('GIF87a'.codeUnits) || has('GIF89a'.codeUnits)) return 'image/gif';
  return null;
}
