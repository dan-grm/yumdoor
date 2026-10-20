import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dev compose defaults to the pinned Tandoor version', () {
    final pinned = File('TANDOOR_VERSION').readAsStringSync().trim();
    final compose = File('docker/tandoor/compose.yml').readAsStringSync();

    final tag = RegExp(r'vabene1111/recipes:\$\{TANDOOR_VERSION:-([^}]+)\}')
        .firstMatch(compose)
        ?.group(1);

    expect(
      tag,
      pinned,
      reason: 'Update the default tag in docker/tandoor/compose.yml',
    );
  });

  test('the committed schema is the one for the pinned version', () {
    final pinned = File('TANDOOR_VERSION').readAsStringSync().trim();
    final schemas = Directory('packages/tandoor_api/schema')
        .listSync()
        .map((file) => file.uri.pathSegments.last);

    expect(
      schemas,
      ['openapi-$pinned.json'],
      reason:
          'Run tool/fetch_schema.dart and tool/generate_api.dart, '
          'and delete the old schema',
    );
  });
}
