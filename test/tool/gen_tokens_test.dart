import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen_tokens.dart';

void main() {
  Map<String, dynamic> committedJson() =>
      jsonDecode(File(tokensJsonPath).readAsStringSync())
          as Map<String, dynamic>;

  test('lib/design/tokens.g.dart is up to date with tokens.json', () {
    expect(
      generateTokens(committedJson()),
      File(tokensDartPath).readAsStringSync(),
      reason: 'Run `dart run tool/gen_tokens.dart`.',
    );
  });

  test('a changed value in tokens.json changes the generated tokens', () {
    final json = committedJson();
    final bg = ((json['color'] as Map)['tokens'] as List).first as Map;
    bg['value'] = {'light': '#000000', 'dark': '#ffffff'};

    final dart = generateTokens(json);

    expect(dart, contains('bg: Color(0xFF000000)'));
    expect(dart, contains('bg: Color(0xFFFFFFFF)'));
  });

  Map<String, dynamic> minimal({
    List<Map<String, dynamic>> colors = const [],
    List<Map<String, dynamic>> shadows = const [],
  }) => {
    'name': 'Test',
    'color': {
      'themes': [
        {'id': 'light'},
        {'id': 'dark'},
      ],
      'tokens': colors,
    },
    'type': {'families': <String, dynamic>{}, 'groups': <dynamic>[]},
    'spacing': {'tokens': <dynamic>[]},
    'radius': {'tokens': <dynamic>[]},
    'size': {'tokens': <dynamic>[]},
    'shadow': {'tokens': shadows},
  };

  test('references resolve per theme and kebab names become camelCase', () {
    final dart = generateTokens(
      minimal(
        colors: [
          {
            'name': 'brand-main',
            'value': {'light': '#112233', 'dark': '#445566'},
            'usage': 'Brand.',
          },
          {'name': 'focus-ring', 'value': '{brand-main}', 'usage': 'Focus.'},
        ],
      ),
    );

    expect(dart, contains('final Color focusRing;'));
    expect(dart, contains('focusRing: Color(0xFF112233)'));
    expect(dart, contains('focusRing: Color(0xFF445566)'));
  });

  test('CSS box shadows become BoxShadow lists', () {
    final dart = generateTokens(
      minimal(
        shadows: [
          {
            'name': 'lift',
            'value': '0 8px 24px rgba(35, 38, 30, 0.18), 0 1px 2px 1px #000000',
            'usage': 'Lift.',
          },
        ],
      ),
    );

    expect(
      dart.replaceAll(RegExp(r'\s+'), ' '),
      contains(
        'BoxShadow( offset: Offset(0, 8), blurRadius: 24, '
        'color: Color.fromRGBO(35, 38, 30, 0.18), ), '
        'BoxShadow( offset: Offset(0, 1), blurRadius: 2, spreadRadius: 1, '
        'color: Color(0xFF000000), )',
      ),
    );
  });

  test('unsupported values and circular references fail', () {
    expect(
      () => generateTokens(
        minimal(
          colors: [
            {'name': 'bg', 'value': 'hsl(0 0% 0%)', 'usage': ''},
          ],
        ),
      ),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => generateTokens(
        minimal(
          colors: [
            {'name': 'a', 'value': '{b}', 'usage': ''},
            {'name': 'b', 'value': '{a}', 'usage': ''},
          ],
        ),
      ),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('circular'),
        ),
      ),
    );
  });
}
