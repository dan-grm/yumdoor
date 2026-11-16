/// Reads an ingredient amount as typed into the editor: `200`, `1,5`, `1.5`,
/// `½`, `1½`, `1 ½`, `1/2` or `1 1/2`. Surrounding spaces are ignored.
///
/// Returns 0 for an empty text (no amount) and `null` for anything else that
/// isn't a non-negative amount. A point is a decimal separator like a comma,
/// never a thousands separator: `1.000` is 1.
double? parseAmount(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 0;
  final match = _amount.firstMatch(trimmed);
  if (match == null) return null;
  final whole = match.group(1);
  final numerator = match.group(2);
  final denominator = match.group(3);
  final glyph = match.group(4);
  if (whole == null && numerator == null && glyph == null) return null;
  var value = whole == null ? 0.0 : double.parse(whole.replaceFirst(',', '.'));
  if (numerator != null) {
    // A decimal before a fraction ("1,5 1/2") isn't an amount.
    if (whole != null && whole.contains(RegExp('[.,]'))) return null;
    final bottom = int.parse(denominator!);
    if (bottom == 0) return null;
    value += int.parse(numerator) / bottom;
  }
  if (glyph != null) {
    if (whole != null && whole.contains(RegExp('[.,]'))) return null;
    value += _glyphs[glyph]!;
  }
  return value.isFinite ? value : null;
}

/// A whole or decimal number, then optionally a fraction `1/2` or a glyph
/// `½`, the fraction after a space or directly after the number.
final _amount = RegExp(
  r'^(\d+(?:[.,]\d+)?)?'
  r'(?:(?:(?<=\d)\s+|^)(\d+)\s*/\s*(\d+))?'
  r'\s*([½¼¾⅓⅔⅛])?$',
);

const _glyphs = {
  '½': 1 / 2,
  '¼': 1 / 4,
  '¾': 3 / 4,
  '⅓': 1 / 3,
  '⅔': 2 / 3,
  '⅛': 1 / 8,
};
