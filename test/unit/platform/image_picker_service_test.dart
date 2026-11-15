import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/image_picker/image_picker_service.dart';

Uint8List bytes(List<int> head, [int length = 32]) =>
    Uint8List(length)..setRange(0, head.length, head);

final jpeg = bytes(const [0xFF, 0xD8, 0xFF, 0xE0]);
final png = bytes(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
final webp = bytes([...'RIFF'.codeUnits, 0, 0, 0, 0, ...'WEBPVP8 '.codeUnits]);
final gif = bytes('GIF89a'.codeUnits);

void main() {
  group('sniffImageType', () {
    test('recognizes the accepted types by content', () {
      expect(sniffImageType(jpeg), 'image/jpeg');
      expect(sniffImageType(png), 'image/png');
      expect(sniffImageType(webp), 'image/webp');
      expect(sniffImageType(gif), 'image/gif');
      expect(sniffImageType(bytes('GIF87a'.codeUnits)), 'image/gif');
    });

    test('rejects everything else', () {
      expect(sniffImageType(Uint8List(0)), isNull);
      expect(sniffImageType(bytes(const [0xFF, 0xD8])), isNull);
      expect(sniffImageType(bytes('%PDF-1.7'.codeUnits)), isNull);
      expect(sniffImageType(bytes('<svg xmlns='.codeUnits)), isNull);
      // HEIC: ftyp box with brand heic.
      expect(
        sniffImageType(bytes([0, 0, 0, 24, ...'ftypheic'.codeUnits])),
        isNull,
      );
      // A RIFF file that isn't WebP (WAV).
      expect(
        sniffImageType(
          bytes([...'RIFF'.codeUnits, 0, 0, 0, 0, ...'WAVE'.codeUnits]),
        ),
        isNull,
      );
      // Truncated: the signature runs past the end.
      expect(sniffImageType(Uint8List.fromList(const [0x89, 0x50])), isNull);
    });
  });

  group('checkImage', () {
    test('accepts an image and takes the type from the content', () {
      final result = checkImage(name: 'photo.png', bytes: jpeg);

      expect(
        result,
        isA<PickedImage>()
            .having((i) => i.mimeType, 'mimeType', 'image/jpeg')
            .having((i) => i.name, 'name', 'photo.png')
            .having((i) => i.bytes, 'bytes', same(jpeg)),
      );
    });

    test('rejects a non-image', () {
      final result = checkImage(
        name: 'notes.txt',
        bytes: Uint8List.fromList('hello'.codeUnits),
      );

      expect(
        result,
        isA<RejectedImage>()
            .having((r) => r.reason, 'reason', ImageRejection.notAnImage)
            .having((r) => r.name, 'name', 'notes.txt'),
      );
    });

    test('accepts exactly the limit and rejects one byte more', () {
      final atLimit = bytes(jpeg.sublist(0, 4), maxImageBytes);
      final overLimit = bytes(jpeg.sublist(0, 4), maxImageBytes + 1);

      expect(checkImage(name: 'a.jpg', bytes: atLimit), isA<PickedImage>());
      expect(
        checkImage(name: 'b.jpg', bytes: overLimit),
        isA<RejectedImage>().having(
          (r) => r.reason,
          'reason',
          ImageRejection.tooLarge,
        ),
      );
      expect(isTooLargeImage(maxImageBytes), isFalse);
      expect(isTooLargeImage(maxImageBytes + 1), isTrue);
    });
  });

  group('PickedImage.fileName', () {
    String fileName(String name, Uint8List content) =>
        (checkImage(name: name, bytes: content) as PickedImage).fileName;

    test('keeps a matching extension and fixes a wrong one', () {
      expect(fileName('Kuchen.jpg', jpeg), 'Kuchen.jpg');
      expect(fileName('IMG_0001.HEIC', jpeg), 'IMG_0001.jpg');
      expect(fileName('scan.final.png', webp), 'scan.final.webp');
      expect(fileName('anim', gif), 'anim.gif');
    });

    test('names a nameless image', () {
      expect(fileName('', png), 'image.png');
      expect(fileName('  ', png), 'image.png');
      expect(fileName('.png', png), 'image.png');
    });
  });

  test('every accepted type has an extension', () {
    for (final type in acceptedImageTypes) {
      final image = PickedImage(name: 'x', bytes: png, mimeType: type);
      expect(image.fileName, isNot(contains('null')), reason: type);
    }
  });
}
