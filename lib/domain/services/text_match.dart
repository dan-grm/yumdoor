import '../models/food.dart';
import '../models/keyword.dart';
import '../models/unit.dart';

/// Matches names against a search text, ignoring case and accents ("Püree"
/// matches "puree"), roughly like Tandoor's `icontains` with `unaccent`.
class TextMatcher {
  TextMatcher(String text) : _text = foldText(text.trim());

  final String _text;

  /// Whether there is no text, which [contains] everything.
  bool get isEmpty => _text.isEmpty;

  bool contains(String name) => foldText(name).contains(_text);

  /// The food's name or plural name contains the text.
  bool food(Food food) =>
      contains(food.name) ||
      (food.pluralName != null && contains(food.pluralName!));

  bool keyword(Keyword keyword) => contains(keyword.name);

  /// The unit's name or plural name contains the text.
  bool unit(Unit unit) =>
      contains(unit.name) ||
      (unit.pluralName != null && contains(unit.pluralName!));
}

/// [text] in lower case without accents: "Crème Brûlée" → "creme brulee".
String foldText(String text) {
  final out = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    // Combining marks, as in decomposed "ü".
    if (rune >= 0x300 && rune <= 0x36f) continue;
    final char = String.fromCharCode(rune);
    out.write(_folds[char] ?? char);
  }
  return out.toString();
}

/// Latin letters with diacritics and their base letters.
const _folds = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'ā': 'a', //
  'ă': 'a', 'ą': 'a', 'æ': 'ae', 'ç': 'c', 'ć': 'c', 'č': 'c', 'ĉ': 'c', //
  'ď': 'd', 'đ': 'd', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ē': 'e', //
  'ė': 'e', 'ę': 'e', 'ě': 'e', 'ğ': 'g', 'ì': 'i', 'í': 'i', 'î': 'i', //
  'ï': 'i', 'ī': 'i', 'į': 'i', 'ı': 'i', 'ł': 'l', 'ľ': 'l', 'ĺ': 'l', //
  'ñ': 'n', 'ń': 'n', 'ň': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', //
  'ö': 'o', 'ø': 'o', 'ō': 'o', 'ő': 'o', 'œ': 'oe', 'ŕ': 'r', 'ř': 'r', //
  'ś': 's', 'š': 's', 'ş': 's', 'ș': 's', 'ß': 'ss', 'ť': 't', 'ţ': 't', //
  'ț': 't', 'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ū': 'u', 'ů': 'u', //
  'ű': 'u', 'ų': 'u', 'ý': 'y', 'ÿ': 'y', 'ź': 'z', 'ż': 'z', 'ž': 'z', //
};
