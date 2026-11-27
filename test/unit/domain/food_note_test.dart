import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/services/food_note.dart';

void main() {
  test('splits at the first ", "', () {
    expect(splitFoodNote('Burger Patties, von Vegetarian Butcher'), (
      name: 'Burger Patties',
      note: 'von Vegetarian Butcher',
    ));
    expect(splitFoodNote('Öl, kaltgepresst, bio'), (
      name: 'Öl',
      note: 'kaltgepresst, bio',
    ));
  });

  test('no note without ", " or with a name before it', () {
    expect(splitFoodNote('Zitrone'), (name: 'Zitrone', note: ''));
    expect(splitFoodNote('1,5 kg Mehl'), (name: '1,5 kg Mehl', note: ''));
    expect(splitFoodNote(', fein'), (name: ', fein', note: ''));
  });

  test('joins name and note', () {
    expect(joinFoodNote('Milch', ' laktosefrei '), 'Milch, laktosefrei');
    expect(joinFoodNote('Milch', ' '), 'Milch');
  });
}
