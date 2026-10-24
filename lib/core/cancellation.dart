import 'dart:async';

/// Lets the caller of a repository method abandon a request it no longer
/// needs, such as a search the user has already typed past.
///
/// A cancelled call throws [CancelledFailure] (`failures.dart`); callers that
/// cancel have stopped listening, so it is never shown.
final class CancelSignal {
  final _cancelled = Completer<void>();

  bool get isCancelled => _cancelled.isCompleted;

  /// Completes when [cancel] is called.
  Future<void> get whenCancelled => _cancelled.future;

  void cancel() {
    if (!_cancelled.isCompleted) _cancelled.complete();
  }
}
