/// Reads an ingredient amount as typed into the editor: `200`, `1,5`, `1.5`,
/// `0,125`, `½`, `1½`, `1 ½`, `1/2` or `1 1/2`. Surrounding spaces are
/// ignored.
///
/// Returns 0 for an empty text (no amount) and `null` for anything else that
/// isn't a non-negative amount. A point or comma is a decimal separator. One
/// followed by exactly three digits after a number other than 0 (`1.000`,
/// `1,250`) is `null` too: it could be a thousands separator, and reading it
/// wrong would be off by a factor of 1000.
double? parseAmount(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 0;
  final match = _amount.firstMatch(trimmed);
  if (match == null) return null;
  final whole = match.group(1);
  final decimals = match.group(2);
  final numerator = match.group(3);
  final denominator = match.group(4);
  final glyph = match.group(5);
  if (whole == null && numerator == null && glyph == null) return null;
  // "1/2½" isn't an amount.
  if (numerator != null && glyph != null) return null;
  if (decimals != null) {
    // "1,5 1/2" and "1,5½" aren't amounts.
    if (numerator != null || glyph != null) return null;
    if (decimals.length == 3 && int.parse(whole!) != 0) return null;
  }
  var value = whole == null
      ? 0.0
      : double.parse(decimals == null ? whole : '$whole.$decimals');
  if (numerator != null) {
    final bottom = int.parse(denominator!);
    if (bottom == 0) return null;
    value += int.parse(numerator) / bottom;
  }
  if (glyph != null) value += _glyphs[glyph]!;
  return value;
}

/// A whole number with optional decimals, then optionally a fraction `1/2`
/// (after a space) or a glyph `½`. Digits are limited so that every number
/// parses.
final _amount = RegExp(
  r'^(?:(\d{1,6})(?:[.,](\d{1,6}))?)?'
  r'(?:(?:(?<=\d)\s+|^)(\d{1,3})\s*/\s*(\d{1,3}))?'
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
