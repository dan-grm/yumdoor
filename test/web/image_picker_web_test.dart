@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:web/web.dart' as web;
import 'package:yumdoor/platform/image_picker/image_picker_service.dart';
import 'package:yumdoor/platform/image_picker/image_picker_service_web.dart';

import '../platform/contracts.dart';

// The web ImagePickerService in a real browser:
//   flutter test --platform chrome test/web/
// The browser opens no picker for a click without a user gesture, so the tests
// play the user by setting the input's files and firing its events.

const _png = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 13];

web.File _file(String name, List<int> bytes, {String type = ''}) => web.File(
  [Uint8List.fromList(bytes).toJS].toJS,
  name,
  web.FilePropertyBag(type: type),
);

web.DataTransfer _transfer(List<web.File> files) {
  final transfer = web.DataTransfer();
  for (final file in files) {
    transfer.items.add(file);
  }
  return transfer;
}

web.HTMLInputElement? _input() => web.document.querySelector(
  'input[${PlatformImagePickerService.inputMarker}]',
) as web.HTMLInputElement?;

/// Plays the user choosing [files] in the open picker.
void _choose(List<web.File> files) {
  _input()!.files = _transfer(files).files;
  _input()!.dispatchEvent(web.Event('change'));
}

web.DragEvent _drag(String type, web.DataTransfer transfer) => web.DragEvent(
  type,
  web.DragEventInit(bubbles: true, cancelable: true, dataTransfer: transfer),
);

void main() {
  group('web ImagePickerService', () {
    imagePickerContract(ImagePickerService.new);

    late PlatformImagePickerService picker;
    setUp(() => picker = PlatformImagePickerService());
    tearDown(() => picker.dispose());

    test('pickFile offers the accepted types and returns the image', () async {
      final pick = picker.pickFile();

      final input = _input()!;
      expect(input.type, 'file');
      expect(input.accept, acceptedImageTypes.join(','));
      expect(input.hasAttribute('capture'), isFalse);
      _choose([_file('Kuchen.png', _png, type: 'image/png')]);

      expect(
        await pick,
        isA<PickedImage>()
            .having((i) => i.name, 'name', 'Kuchen.png')
            .having((i) => i.mimeType, 'mimeType', 'image/png')
            .having((i) => i.bytes, 'bytes', _png),
      );
      expect(_input(), isNull, reason: 'the input is removed');
    });

    test('pickFromCamera asks for the rear camera', () async {
      final pick = picker.pickFromCamera();

      expect(_input()!.getAttribute('capture'), 'environment');
      _choose([
        _file('image.jpg', const [0xFF, 0xD8, 0xFF, 0xE0]),
      ]);

      expect(
        await pick,
        isA<PickedImage>().having((i) => i.mimeType, 'mimeType', 'image/jpeg'),
      );
    });

    test('cancel returns null', () async {
      final pick = picker.pickFile();
      _input()!.dispatchEvent(web.Event('cancel'));

      expect(await pick, isNull);
      expect(_input(), isNull);
    });

    test('a new pick ends one that was never answered', () async {
      final first = picker.pickFile();
      final second = picker.pickFile();

      expect(await first, isNull);
      expect(
        web.document
            .querySelectorAll(
              'input[${PlatformImagePickerService.inputMarker}]',
            )
            .length,
        1,
      );
      _choose([_file('a.png', _png)]);
      expect(await second, isA<PickedImage>());
    });

    test('rejects a non-image whatever its name and type say', () async {
      final pick = picker.pickFile();
      _choose([_file('fake.png', 'not a png'.codeUnits, type: 'image/png')]);

      expect(
        await pick,
        isA<RejectedImage>()
            .having((r) => r.reason, 'reason', ImageRejection.notAnImage)
            .having((r) => r.name, 'name', 'fake.png'),
      );
    });

    test('rejects a file above the limit', () async {
      final pick = picker.pickFile();
      _choose([
        _file('huge.png', Uint8List(maxImageBytes + 1)..setAll(0, _png)),
      ]);

      expect(
        await pick,
        isA<RejectedImage>().having(
          (r) => r.reason,
          'reason',
          ImageRejection.tooLarge,
        ),
      );
    });

    test('dispose ends an open pick', () async {
      final pick = picker.pickFile();
      picker.dispose();

      expect(await pick, isNull);
      expect(_input(), isNull);
    });

    group('drop target', () {
      test('reports hovering and delivers the first dropped file', () async {
        final events = <ImageDropEvent>[];
        final subscription = picker.drops.listen(events.add);
        addTearDown(subscription.cancel);
        final transfer = _transfer([
          _file('a.png', _png),
          _file('b.txt', 'text'.codeUnits),
        ]);
        final dropped = picker.drops.firstWhere((e) => e is ImageDropped);

        web.document.body!.dispatchEvent(_drag('dragenter', transfer));
        // Crossing into a child element and back out of the first.
        web.document.body!.dispatchEvent(_drag('dragenter', transfer));
        web.document.body!.dispatchEvent(_drag('dragleave', transfer));
        final over = _drag('dragover', transfer);
        web.document.body!.dispatchEvent(over);
        final drop = _drag('drop', transfer);
        web.document.body!.dispatchEvent(drop);
        await dropped;

        expect(over.defaultPrevented, isTrue, reason: 'allows the drop');
        expect(drop.defaultPrevented, isTrue, reason: 'keeps the app open');
        expect(events, [
          isA<ImageDragHover>().having((e) => e.isOver, 'isOver', isTrue),
          isA<ImageDragHover>().having((e) => e.isOver, 'isOver', isFalse),
          isA<ImageDropped>().having(
            (e) => e.result,
            'result',
            isA<PickedImage>().having((i) => i.name, 'name', 'a.png'),
          ),
        ]);
      });

      test('reports files dragged out of the window', () async {
        final events = <ImageDropEvent>[];
        final subscription = picker.drops.listen(events.add);
        addTearDown(subscription.cancel);
        final transfer = _transfer([_file('a.png', _png)]);

        web.document.body!.dispatchEvent(_drag('dragenter', transfer));
        web.document.body!.dispatchEvent(_drag('dragleave', transfer));
        await pumpEventQueue();

        expect(events.map((e) => (e as ImageDragHover).isOver), [true, false]);
      });

      test('delivers a rejected drop', () async {
        final subscription = picker.drops.listen((_) {});
        addTearDown(subscription.cancel);
        final dropped = picker.drops.firstWhere((e) => e is ImageDropped);

        final transfer = _transfer([_file('notes.txt', 'text'.codeUnits)]);
        web.document.body!.dispatchEvent(_drag('drop', transfer));

        expect(
          ((await dropped) as ImageDropped).result,
          isA<RejectedImage>().having(
            (r) => r.reason,
            'reason',
            ImageRejection.notAnImage,
          ),
        );
      });

      test('ignores drags without files', () async {
        final events = <ImageDropEvent>[];
        final subscription = picker.drops.listen(events.add);
        addTearDown(subscription.cancel);
        final transfer = web.DataTransfer()..setData('text/plain', 'Zucker');

        web.document.body!.dispatchEvent(_drag('dragenter', transfer));
        final drop = _drag('drop', transfer);
        web.document.body!.dispatchEvent(drop);
        await pumpEventQueue();

        expect(events, isEmpty);
        expect(drop.defaultPrevented, isFalse);
      });

      test('is no drop target without a listener', () async {
        final subscription = picker.drops.listen((_) {});
        await subscription.cancel();

        final over = _drag('dragover', _transfer([_file('a.png', _png)]));
        web.document.body!.dispatchEvent(over);

        expect(over.defaultPrevented, isFalse);
      });
    });
  });
}
