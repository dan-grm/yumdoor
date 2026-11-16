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
    // One character, two code points.
    expect(format('ab', 'ab\u{1F44D}\u{1F3FD}').text, 'ab');
    expect(format('a', 'a\u{1F44D}').text, 'a\u{1F44D}');
  });

  test('a too long text can still be shortened', () {
    expect(format('abcde', 'abcd').text, 'abcd');
    expect(format('abcde', 'abcdef').text, 'abcde');
  });
}
