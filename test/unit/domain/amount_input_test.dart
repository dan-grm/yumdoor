import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/services/amount_input.dart';

void main() {
  test('reads whole and decimal numbers with comma or point', () {
    expect(parseAmount('200'), 200);
    expect(parseAmount('1,5'), 1.5);
    expect(parseAmount('1.5'), 1.5);
    expect(parseAmount(' 0,25 '), 0.25);
    // A point is never a thousands separator.
    expect(parseAmount('1.000'), 1);
  });

  test('reads fractions and glyphs', () {
    expect(parseAmount('½'), 0.5);
    expect(parseAmount('1½'), 1.5);
    expect(parseAmount('1 ½'), 1.5);
    expect(parseAmount('¾'), 0.75);
    expect(parseAmount('1/2'), 0.5);
    expect(parseAmount('1 1/2'), 1.5);
    expect(parseAmount('2 3/4'), 2.75);
  });

  test('empty is no amount', () {
    expect(parseAmount(''), 0);
    expect(parseAmount('   '), 0);
  });

  test('anything else is not an amount', () {
    for (final text in [
      'viel',
      '-1',
      '1 2',
      '1/0',
      '1,5 1/2',
      '1,5½',
      '200 g',
      '1,2,3',
      '/2',
    ]) {
      expect(parseAmount(text), isNull, reason: text);
    }
  });
}
