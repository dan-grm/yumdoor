import 'package:flutter_test/flutter_test.dart';

import '../../tool/fetch_schema.dart';

void main() {
  test('canonical JSON sorts keys at every level and keeps list order', () {
    final json = {
      'paths': {'/b/': 1, '/a/': 2},
      'info': {
        'version': '1',
        'tags': [
          {'z': 1, 'a': 2},
          'second',
        ],
      },
    };

    expect(
      canonicalJson(json),
      '{\n'
      '  "info": {\n'
      '    "tags": [\n'
      '      {\n'
      '        "a": 2,\n'
      '        "z": 1\n'
      '      },\n'
      '      "second"\n'
      '    ],\n'
      '    "version": "1"\n'
      '  },\n'
      '  "paths": {\n'
      '    "/a/": 2,\n'
      '    "/b/": 1\n'
      '  }\n'
      '}\n',
    );
  });
}
