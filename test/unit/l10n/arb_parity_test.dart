import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final template = _readArb('lib/l10n/app_de.arb');
  final english = _readArb('lib/l10n/app_en.arb');

  test('app_en.arb has exactly the keys of app_de.arb', () {
    expect(_messageKeys(english), _messageKeys(template));
  });

  test('every translation uses the placeholders of the German original', () {
    for (final key in _messageKeys(template)) {
      final declared =
          ((template['@$key'] as Map<String, dynamic>?)?['placeholders']
                  as Map<String, dynamic>?)
              ?.keys
              .toSet() ??
          <String>{};
      expect(
        placeholdersIn(template[key] as String),
        declared,
        reason: 'app_de.arb "$key" must use exactly its declared placeholders',
      );
      expect(
        placeholdersIn(english[key] as String),
        declared,
        reason: 'app_en.arb "$key" must use the placeholders of app_de.arb',
      );
    }
  });

  test('placeholdersIn finds simple, plural and nested placeholders', () {
    expect(placeholdersIn('Hallo'), <String>{});
    expect(placeholdersIn('{count} Portionen für {name}'), {'count', 'name'});
    expect(
      placeholdersIn('{count, plural, =1{1 Portion} other{{count} Portionen}}'),
      {'count'},
    );
  });
}

/// Names of the ICU arguments in an ARB message, e.g. `count` in `{count}` and
/// in `{count, plural, …}`. Plural and select branches (`=1{…}`, `other{…}`)
/// are not arguments.
Set<String> placeholdersIn(String message) => {
  for (final match in RegExp(r'\{\s*(\w+)\s*[,}]').allMatches(message))
    match.group(1)!,
};

Map<String, dynamic> _readArb(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();
