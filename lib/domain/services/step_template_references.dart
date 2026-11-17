/// Which ingredients of a step its text refers to by position
/// (`{{ ingredients[0] }}`, see `StepTemplate`).
///
/// Changing the order of a step's ingredients, or removing one, changes what
/// such a reference shows, so the editor warns about it.
abstract final class StepTemplateReferences {
  static final _reference = RegExp(
    r'\{\{\s*ingredients\s*\[\s*(-?\d{1,9})\s*\]',
  );

  /// Whether [text] refers to an ingredient by position.
  static bool hasAny(String text) => _reference.hasMatch(text);

  /// Whether a change at position [index] of the step's ingredients and
  /// after it (one removed, or swapped with its neighbor) changes what a
  /// reference in [text] shows: one to [index] or a later position, or from
  /// the end (negative), which counts from the other side.
  static bool shiftedBy(String text, int index) {
    for (final match in _reference.allMatches(text)) {
      final n = int.parse(match.group(1)!);
      if (n < 0 || n >= index) return true;
    }
    return false;
  }
}
