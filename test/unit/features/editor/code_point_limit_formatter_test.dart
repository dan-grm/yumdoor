import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/features/editor/editor_field.dart';

void main() {
  final formatter = CodePointLimitFormatter(3);

  TextEditingValue format(String old, String next) =>
      formatter.formatEditUpdate(
        TextEditingValue(text: old),
        TextEditingValue(text: next),
      );

  test('lets text up to the limit through', () {
    expect(format('ab', 'abc').text, 'abc');
  });

  test('counts code points, not characters', () {
    expect(format('a', 'a\u{1F44D}').text, 'a\u{1F44D}');
    // One character, two code points: cut to the limit.
    expect(
      format('a', 'a\u{1F44D}\u{1F3FD}\u{1F44D}').text,
      'a\u{1F44D}\u{1F3FD}',
    );
  });

  test('a paste is cut to the limit; a full field takes no more', () {
    expect(format('', 'abcdef').text, 'abc');
    expect(format('abc', 'abxc').text, 'abc');
  });

  test('a composition is limited once it is committed', () {
    const composing = TextEditingValue(
      text: 'abcd',
      composing: TextRange(start: 2, end: 4),
    );
    expect(
      formatter.formatEditUpdate(const TextEditingValue(text: 'ab'), composing),
      composing,
    );
  });

  test('a too long text can still be shortened', () {
    expect(format('abcde', 'abcd').text, 'abcd');
    expect(format('abcde', 'abcdef').text, 'abcde');
  });
}
