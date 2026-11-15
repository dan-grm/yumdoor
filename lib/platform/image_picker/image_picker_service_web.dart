import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'image_picker_service.dart';

/// A hidden `<input type="file">` for picking (with `capture` for the camera)
/// and `drag*`/`drop` listeners on the window for dropping.
class PlatformImagePickerService implements ImagePickerService {
  PlatformImagePickerService() {
    _drops = StreamController<ImageDropEvent>.broadcast(
      onListen: _listenForDrops,
      onCancel: _stopListeningForDrops,
    );
  }

  /// The attribute on the file input, so tests can find it.
  static const inputMarker = 'data-yumdoor-image-picker';

  /// How long after the last `dragover` the files count as gone. Browsers
  /// fire `dragover` at least every 350 ms (±200 ms) while files are over the
  /// window; this ends a hover whose `dragleave` was lost.
  static const hoverTimeout = Duration(seconds: 1);

  late final StreamController<ImageDropEvent> _drops;
  final _dropListeners = <StreamSubscription<web.Event>>[];
  // Counts listen phases, so a drop read while its listener left isn't
  // delivered to the next one.
  int _dropGeneration = 0;
  // dragenter and dragleave fire for every element the pointer crosses; the
  // files have left the window when they balance out.
  int _dragDepth = 0;
  bool _hovering = false;
  final _sinceDragOver = Stopwatch();
  Timer? _hoverCheck;
  // Every pick not yet answered.
  final _pending = <_PendingPick>[];
  // Picks and drops are numbered as they start. Files are read
  // asynchronously, so a large one can finish after a newer, smaller one; it
  // is dropped then, so the newest image wins.
  int _started = 0;
  int _delivered = 0;

  @override
  bool get canUseCamera => web.window.matchMedia('(pointer: coarse)').matches;

  @override
  bool get supportsDrop => web.window.matchMedia('(any-pointer: fine)').matches;

  @override
  Stream<ImageDropEvent> get drops => _drops.stream;

  @override
  Future<ImagePickResult?> pickFromCamera() => _pick(camera: true);

  @override
  Future<ImagePickResult?> pickFile() => _pick(camera: false);

  Future<ImagePickResult?> _pick({required bool camera}) {
    // A pick still open without a choice was abandoned (or cancelled where the
    // `cancel` event is missing); one whose file is being read completes.
    for (final pending in [..._pending]) {
      if (!pending.chosen) pending.finish(null);
    }

    final input = (web.document.createElement('input') as web.HTMLInputElement)
      ..type = 'file'
      ..accept = acceptedImageTypes.join(',')
      ..setAttribute(inputMarker, '');
    // The rear camera; desktop browsers ignore it and show a file picker.
    if (camera) input.setAttribute('capture', 'environment');
    input.style.display = 'none';
    // In the document, because older Safari ignores clicks on detached inputs.
    web.document.body!.append(input);

    final pending = _PendingPick(input);
    final number = ++_started;
    _pending.add(pending);
    pending.subscriptions.addAll([
      web.EventStreamProviders.changeEvent.forTarget(input).listen((_) async {
        final file = input.files?.item(0);
        if (file == null) {
          pending.finish(null);
          return;
        }
        pending.chosen = true;
        final result = await _read(file);
        pending.finish(_isNewest(number) ? result : null);
      }),
      // Not fired before Chrome 113 and Safari 16.4; there the next pick
      // ends a cancelled one. Guessing a cancel from the window regaining
      // focus would lose files whose `change` comes late.
      web.EventStreamProviders.cancelEvent
          .forTarget(input)
          .listen((_) => pending.finish(null)),
    ]);
    input.click();
    return pending.completer.future.whenComplete(
      () => _pending.remove(pending),
    );
  }

  void _listenForDrops() {
    final generation = ++_dropGeneration;
    final window = web.window;
    _dropListeners.addAll([
      web.EventStreamProviders.dragEnterEvent.forTarget(window).listen((event) {
        if (!_hasFiles(event)) return;
        _dragDepth++;
        _hover();
      }),
      web.EventStreamProviders.dragOverEvent.forTarget(window).listen((event) {
        if (!_hasFiles(event)) return;
        // Cancelling dragover is what makes the window a drop target.
        event.preventDefault();
        (event as web.DragEvent).dataTransfer?.dropEffect = 'copy';
        _hover();
      }),
      web.EventStreamProviders.dragLeaveEvent.forTarget(window).listen((event) {
        if (!_hasFiles(event) || _dragDepth == 0) return;
        if (--_dragDepth == 0) _endHover();
      }),
      web.EventStreamProviders.dropEvent.forTarget(window).listen((
        event,
      ) async {
        if (!_hasFiles(event)) return;
        // Keeps the browser from opening the file in place of the app.
        event.preventDefault();
        _endHover();
        final number = ++_started;
        final files = (event as web.DragEvent).dataTransfer?.files;
        final file = files == null ? null : _firstImage(files);
        // A folder, or an image dragged from another tab that the browser
        // offers without a file.
        final result = file == null
            ? const RejectedImage(name: '', reason: ImageRejection.unreadable)
            : await _read(file);
        if (generation == _dropGeneration && _isNewest(number)) {
          _drops.add(ImageDropped(result));
        }
      }),
    ]);
  }

  /// Whether the pick or drop [number] is newer than any delivered so far;
  /// if so, it is delivered.
  bool _isNewest(int number) {
    if (number < _delivered) return false;
    _delivered = number;
    return true;
  }

  /// The first file the browser calls an image, else the first file (to be
  /// rejected with a reason).
  static web.File? _firstImage(web.FileList files) {
    for (var i = 0; i < files.length; i++) {
      final file = files.item(i)!;
      if (file.type.startsWith('image/')) return file;
    }
    return files.item(0);
  }

  void _hover() {
    _sinceDragOver
      ..reset()
      ..start();
    _hoverCheck ??= Timer.periodic(hoverTimeout ~/ 4, (_) {
      if (_sinceDragOver.elapsed > hoverTimeout) _endHover();
    });
    if (_hovering) return;
    _hovering = true;
    _drops.add(const ImageDragHover(isOver: true));
  }

  void _endHover() {
    final wasHovering = _hovering;
    _resetHover();
    if (wasHovering) {
      _drops.add(const ImageDragHover(isOver: false));
    }
  }

  void _resetHover() {
    _dragDepth = 0;
    _hovering = false;
    _hoverCheck?.cancel();
    _hoverCheck = null;
  }

  void _stopListeningForDrops() {
    // Invalidates drops still being read.
    _dropGeneration++;
    for (final listener in _dropListeners) {
      unawaited(listener.cancel());
    }
    _dropListeners.clear();
    _resetHover();
  }

  static bool _hasFiles(web.Event event) {
    final types = (event as web.DragEvent).dataTransfer?.types.toDart;
    return types != null && types.any((type) => type.toDart == 'Files');
  }

  static Future<ImagePickResult> _read(web.File file) async {
    // Checked before reading, so a huge file is never loaded into memory.
    if (isTooLargeImage(file.size)) {
      return RejectedImage(name: file.name, reason: ImageRejection.tooLarge);
    }
    try {
      final buffer = await file.arrayBuffer().toDart;
      return checkImage(name: file.name, bytes: buffer.toDart.asUint8List());
    } catch (_) {
      // NotReadableError: the file was moved or access was revoked.
      return RejectedImage(name: file.name, reason: ImageRejection.unreadable);
    }
  }

  @override
  void dispose() {
    for (final pending in [..._pending]) {
      pending.finish(null);
    }
    _stopListeningForDrops();
    unawaited(_drops.close());
  }
}

class _PendingPick {
  _PendingPick(this.input);

  final web.HTMLInputElement input;
  final completer = Completer<ImagePickResult?>();
  final subscriptions = <StreamSubscription<web.Event>>[];

  /// The user chose a file, which is being read.
  bool chosen = false;

  void finish(ImagePickResult? result) {
    if (completer.isCompleted) return;
    for (final subscription in subscriptions) {
      unawaited(subscription.cancel());
    }
    input.remove();
    completer.complete(result);
  }
}
