import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/services/amount_input.dart';

void main() {
  test('reads whole and decimal numbers with comma or point', () {
    expect(parseAmount('200'), 200);
    expect(parseAmount('1,5'), 1.5);
    expect(parseAmount('1.5'), 1.5);
    expect(parseAmount(' 0,25 '), 0.25);
    expect(parseAmount('0,125'), 0.125);
    expect(parseAmount('12,25'), 12.25);
  });

  test('three decimals after a number other than 0 are ambiguous', () {
    // A thousands separator or a decimal one? Either reading may be wrong.
    expect(parseAmount('1.000'), isNull);
    expect(parseAmount('1,250'), isNull);
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
      '99999999999999999999/2',
      '1/99999999999999999999',
      '1234567',
      '1/2½',
      '1 1/2 ½',
    ]) {
      expect(parseAmount(text), isNull, reason: text);
    }
  });
}
