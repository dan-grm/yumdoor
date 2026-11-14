import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/services/text_match.dart';

void main() {
  test('ignores case and accents', () {
    expect(containsFolded('Crème brûlée', 'CREME'), isTrue);
    expect(containsFolded('Kartoffelpüree', 'puree'), isTrue);
    expect(containsFolded('Püree', 'Püree'), isTrue);
    expect(containsFolded('Weißkohl', 'weiss'), isTrue);
    expect(containsFolded('Karotte', 'Kartoffel'), isFalse);
  });

  test('folds to lower case without accents', () {
    expect(foldText('Crème Brûlée'), 'creme brulee');
  });
}
