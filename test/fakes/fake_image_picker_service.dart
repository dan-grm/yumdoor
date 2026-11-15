import 'dart:async';
import 'dart:typed_data';

import 'package:yumdoor/platform/image_picker/image_picker_service.dart';

/// [ImagePickerService] for tests. [nextPick] is what the next pick returns
/// (`null`: the user cancels); [drop] and [hover] play a file dragged onto the
/// window.
class FakeImagePickerService implements ImagePickerService {
  FakeImagePickerService({
    this.canUseCamera = false,
    this.supportsDrop = true,
    this.nextPick,
  });

  @override
  bool canUseCamera;

  @override
  bool supportsDrop;

  ImagePickResult? nextPick;

  /// The picks made, `camera` or `file`.
  final picks = <String>[];

  final _drops = StreamController<ImageDropEvent>.broadcast(sync: true);

  /// Whether something listens for drops, i.e. the window is a drop target.
  bool get isDropTarget => _drops.hasListener;

  @override
  Stream<ImageDropEvent> get drops => _drops.stream;

  @override
  Future<ImagePickResult?> pickFromCamera() async {
    picks.add('camera');
    return nextPick;
  }

  @override
  Future<ImagePickResult?> pickFile() async {
    picks.add('file');
    return nextPick;
  }

  bool _hovering = false;

  /// Files dragged over the window ([isOver]) or out of it. Like the real
  /// service, only changes are reported.
  void hover({required bool isOver}) {
    if (!isDropTarget || isOver == _hovering) return;
    _hovering = isOver;
    _drops.add(ImageDragHover(isOver: isOver));
  }

  /// Drops a file called [name] with [bytes], checked like a real one. Ends a
  /// hover first.
  void drop(String name, Uint8List bytes) {
    if (!isDropTarget) return;
    hover(isOver: false);
    _drops.add(ImageDropped(checkImage(name: name, bytes: bytes)));
  }

  @override
  void dispose() => unawaited(_drops.close());
}

/// The smallest valid PNG header, enough for [sniffImageType].
final pngBytes = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0, 0, 0, 13, 0x49, 0x48, 0x44, 0x52,
]);
