import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_api.dart';

void main() {
  test('read-only properties become optional and nullable', () {
    final schema = {
      'components': {
        'schemas': {
          'Food': {
            'properties': {
              'name': {'type': 'string'},
              'parent': {'type': 'integer', 'readOnly': true},
              'supermarket_category': {
                'allOf': [
                  {r'$ref': '#/components/schemas/SupermarketCategory'},
                ],
                'readOnly': true,
              },
            },
            'required': ['name', 'parent', 'supermarket_category'],
          },
          'KeywordModeEnum': {
            'enum': ['or', 'and'],
            'type': 'string',
          },
        },
      },
    };

    final food =
        (patchSchema(schema)['components'] as Map)['schemas']['Food'] as Map;

    expect(food['required'], ['name']);
    expect(food['properties']['name'], {'type': 'string'});
    expect(food['properties']['parent']['nullable'], isTrue);
    expect(food['properties']['supermarket_category']['nullable'], isTrue);
  });
}
