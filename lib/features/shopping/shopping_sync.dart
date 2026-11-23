import 'dart:async';
import 'dart:math';

/// How often the open shopping list asks Tandoor what changed.
const shoppingPollInterval = Duration(seconds: 5);

/// How often the open shopping list is read in full instead, to notice
/// deleted entries: Tandoor's `updated_after` doesn't report them
/// (docs/TANDOOR_API.md#shopping-list).
const shoppingReloadInterval = Duration(minutes: 3);

/// Keeps the shopping list in sync while it is in view, so two people
/// shopping together see each other's ticks within seconds. Tandoor has no
/// push channel, so this polls.
///
/// While [active], it calls [poll] (an incremental read) every
/// [pollInterval] and, every [reloadInterval] instead, [reload] (a full
/// read). Each read starts [pollInterval] after the previous one ended, so
/// reads never overlap. Becoming active again (back on screen, the app in
/// front again, back online) catches up at once with [reload], with
/// `catchingUp` set; so does [catchUp].
///
/// Failures of [poll] and [reload] are theirs to handle; one that throws
/// anyway doesn't stop the sync.
class ShoppingSync {
  ShoppingSync({
    required this.poll,
    required this.reload,
    this.pollInterval = shoppingPollInterval,
    this.reloadInterval = shoppingReloadInterval,
  }) : assert(pollInterval > Duration.zero, 'pollInterval must be positive');

  final Future<void> Function() poll;
  final Future<void> Function({required bool catchingUp}) reload;
  final Duration pollInterval;
  final Duration reloadInterval;

  var _active = false;
  var _disposed = false;
  Timer? _timer;

  /// Counts activations, so a read that ends after a pause doesn't schedule
  /// the next one.
  var _generation = 0;

  /// Polls since the last full read.
  var _polls = 0;

  /// Whether a read is running.
  var _running = false;

  /// Whether the list is being kept in sync.
  bool get active => _active;

  /// Polls per full read.
  int get _pollsPerReload =>
      max(1, reloadInterval.inMicroseconds ~/ pollInterval.inMicroseconds);

  /// Starts ([active] `true`) or pauses the sync. Starting catches up with a
  /// full read right away, unless [catchUp] is `false` (the list was just
  /// read anyway).
  void setActive(bool active, {bool catchUp = true}) {
    if (_disposed || active == _active) return;
    _active = active;
    _generation++;
    _timer?.cancel();
    _timer = null;
    if (!active) return;
    if (catchUp) {
      unawaited(_run(full: true, catchingUp: true));
    } else {
      _polls = 0;
      _schedule();
    }
  }

  /// Catches up with a full read now, if [active] (the server answers
  /// again, say).
  void catchUp() {
    if (!_active) return;
    _generation++;
    _timer?.cancel();
    _timer = null;
    unawaited(_run(full: true, catchingUp: true));
  }

  /// The list was just read in full elsewhere (pull to refresh): the next
  /// full read can wait.
  void didReload() => _polls = 0;

  void dispose() {
    _disposed = true;
    _active = false;
    _generation++;
    _timer?.cancel();
    _timer = null;
  }

  void _schedule() {
    final generation = _generation;
    _timer = Timer(pollInterval, () {
      if (generation != _generation) return;
      unawaited(_run(full: _polls + 1 >= _pollsPerReload));
    });
  }

  Future<void> _run({required bool full, bool catchingUp = false}) async {
    final generation = _generation;
    if (_running) {
      // A read from before a pause is still running; this one takes over
      // once it ends.
      await _idle;
      if (generation != _generation) return;
    }
    _running = true;
    try {
      if (full) {
        _polls = 0;
        await reload(catchingUp: catchingUp);
      } else {
        _polls++;
        await poll();
      }
    } on Object {
      // Theirs to report; the next read tries again.
    } finally {
      _running = false;
      _idleCompleter?.complete();
      _idleCompleter = null;
    }
    if (generation == _generation && _active) _schedule();
  }

  Completer<void>? _idleCompleter;

  Future<void> get _idle => (_idleCompleter ??= Completer<void>()).future;
}
