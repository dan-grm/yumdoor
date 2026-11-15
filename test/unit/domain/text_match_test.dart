import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/services/text_match.dart';

void main() {
  test('ignores case and accents', () {
    bool contains(String name, String text) => TextMatcher(text).contains(name);

    expect(contains('Crème brûlée', 'CREME'), isTrue);
    expect(contains('Kartoffelpüree', 'puree'), isTrue);
    expect(contains('Püree', 'Püree'), isTrue);
    expect(contains('Weißkohl', 'weiss'), isTrue);
    expect(contains('Ćevapčići', 'cevapcici'), isTrue);
    // Decomposed: "u" followed by a combining diaeresis.
    expect(contains('Pu\u0308ree', 'püree'), isTrue);
    expect(contains('Karotte', 'Kartoffel'), isFalse);
  });

  test('matches foods by name or plural, and keywords by name', () {
    final matcher = TextMatcher(' karotten ');

    expect(matcher.food(const Food(id: 1, name: 'Karotte')), isFalse);
    expect(
      matcher.food(const Food(id: 1, name: 'Karotte', pluralName: 'Karotten')),
      isTrue,
    );
    expect(matcher.keyword(const Keyword(id: 1, name: 'Karottenzeit')), isTrue);
  });

  test('matches units by name or plural', () {
    final matcher = TextMatcher('löffel');

    expect(matcher.unit(const Unit(id: 1, name: 'EL')), isFalse);
    expect(
      matcher.unit(const Unit(id: 1, name: 'EL', pluralName: 'Esslöffel')),
      isTrue,
    );
    expect(matcher.unit(const Unit(id: 1, name: 'Teelöffel')), isTrue);
  });

  test('an empty text matches everything', () {
    expect(TextMatcher('  ').isEmpty, isTrue);
    expect(TextMatcher('').contains('Suppe'), isTrue);
  });

  test('folds to lower case without accents', () {
    expect(foldText('Crème Brûlée'), 'creme brulee');
  });
}
