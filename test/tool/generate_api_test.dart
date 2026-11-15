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

  test('makenow on the recipe search becomes an integer', () {
    final schema = {
      'paths': {
        '/api/recipe/': {
          'get': {
            'parameters': [
              {
                'in': 'query',
                'name': 'makenow',
                'schema': {'type': 'boolean'},
              },
              {
                'in': 'query',
                'name': 'internal',
                'schema': {'type': 'boolean'},
              },
            ],
          },
        },
      },
      'components': {'schemas': <String, dynamic>{}},
    };

    final [makenow, internal] =
        (patchSchema(schema)['paths']
                as Map)['/api/recipe/']['get']['parameters']
            as List;

    expect(makenow['schema'], {'type': 'integer', 'minimum': 0});
    expect(internal['schema'], {'type': 'boolean'});
  });
}
