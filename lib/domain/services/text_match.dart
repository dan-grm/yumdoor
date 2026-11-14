/// Whether [text] contains [part], ignoring case and common accents
/// ("Püree" contains "puree"), roughly like Tandoor's `unaccent` lookups.
bool containsFolded(String text, String part) =>
    foldText(text).contains(foldText(part));

/// [text] in lower case without accents: "Crème brûlée" → "creme brulee".
String foldText(String text) {
  final lower = text.toLowerCase();
  final out = StringBuffer();
  for (final char in lower.split('')) {
    out.write(_folds[char] ?? char);
  }
  return out.toString();
}

const _folds = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'æ': 'ae', //
  'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ì': 'i', 'í': 'i', //
  'î': 'i', 'ï': 'i', 'ñ': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', //
  'ö': 'o', 'ø': 'o', 'œ': 'oe', 'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', //
  'ý': 'y', 'ÿ': 'y', 'ß': 'ss',
};
