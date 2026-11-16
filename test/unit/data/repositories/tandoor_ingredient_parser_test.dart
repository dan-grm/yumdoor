import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_ingredient_parser.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';

import '../../../fakes/fake_http_adapter.dart';
import '../../../fixtures/tandoor_fixtures.dart';

// The parser against canned responses: requests, and how lines Tandoor can't
// parse come back. Against a real Tandoor: test/integration/.
void main() {
  final serverUrl = Uri.parse('https://example.com/tandoor');

  TandoorIngredientParser parser(FakeHttpAdapter adapter) =>
      TandoorIngredientParser(
        api.TandoorApi(
          dio: createTandoorDio(serverUrl, token: 'tda_test')
            ..httpClientAdapter = adapter,
          interceptors: const [],
        ).getApiApi(),
      );

  /// The recorded parser result for [line].
  Map<String, dynamic> recorded(String line) =>
      ((tandoorFixture('ingredient_parser.json')!
                  as Map<String, dynamic>)['ingredients']
              as List)
          .cast<Map<String, dynamic>>()
          .singleWhere((i) => i['original_text'] == line);

  /// Answers like Tandoor's parser: each line from the recording, a 500 for
  /// a list or line that contains [unparseable].
  FakeHttpAdapter tandoor({String unparseable = 'etwas Liebe'}) =>
      FakeHttpAdapter((request) {
        final body = request.data as Map<String, dynamic>;
        final lines = [
          ?body['ingredient'] as String?,
          ...?(body['ingredients'] as List?)?.cast<String>(),
        ];
        if (lines.contains(unparseable)) {
          return htmlResponse('<h1>Server Error (500)</h1>', status: 500);
        }
        return jsonResponse({
          'ingredient': body.containsKey('ingredient')
              ? recorded(body['ingredient'] as String)
              : null,
          'ingredients': [
            for (final line in body['ingredients'] as List? ?? const [])
              recorded(line as String),
          ],
        });
      });

  const salz = ParsedIngredient(
    originalText: 'Salz, nach Geschmack',
    food: NamedRef(id: 141, name: 'Salz'),
    note: 'nach Geschmack',
  );
  const eier = ParsedIngredient(
    originalText: '2 Eier',
    food: NamedRef(id: 110, name: 'Ei'),
    amount: 2,
  );

  group('parse', () {
    test('posts the line to the parser', () async {
      final adapter = tandoor();

      expect(await parser(adapter).parse('Salz, nach Geschmack'), salz);

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/tandoor/api/ingredient-parser/post/');
      expect(request.data, {'ingredient': 'Salz, nach Geschmack'});
    });

    test('returns a line Tandoor fails on as unparsed', () async {
      expect(
        await parser(tandoor()).parse('etwas Liebe'),
        ParsedIngredient.unparsed('etwas Liebe'),
      );
    });

    test('returns a line Tandoor answers with a 400 as unparsed', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({
          'error': true,
          'msg': {
            'ingredient': ['This field may not be blank.'],
          },
        }, status: 400),
      );

      expect(
        await parser(adapter).parse(' x'),
        ParsedIngredient.unparsed(' x'),
      );
    });

    test('returns a line Tandoor finds blank as unparsed', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'ingredient': null, 'ingredients': <Object>[]}),
      );

      expect(
        await parser(adapter).parse('\u001c'),
        ParsedIngredient.unparsed('\u001c'),
      );
    });

    test('returns blank, symbol-only and too long lines unparsed, '
        'without a request', () async {
      final adapter = tandoor();
      final long = 'Salz ${'x' * 510}';

      for (final line in ['', '  ', ' -', ',.', long]) {
        expect(
          await parser(adapter).parse(line),
          ParsedIngredient.unparsed(line),
        );
      }
      expect(adapter.requests, isEmpty);
    });

    test('throws a failure when the request fails', () async {
      final forbidden = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'nope'}, status: 403),
      );
      final unavailable = FakeHttpAdapter(
        (_) => htmlResponse('Bad Gateway', status: 502),
      );
      final offline = FakeHttpAdapter(
        (request) => throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        ),
      );

      await expectLater(
        parser(forbidden).parse('2 Eier'),
        throwsA(isA<UnauthorizedFailure>()),
      );
      await expectLater(
        parser(unavailable).parse('2 Eier'),
        throwsA(isA<ServerFailure>()),
      );
      await expectLater(
        parser(offline).parse('2 Eier'),
        throwsA(isA<OfflineFailure>()),
      );
    });
  });

  group('parseAll', () {
    test('parses the non-blank lines in one request', () async {
      final adapter = tandoor();

      final parsed = await parser(adapter)
          .parseAll(['Salz, nach Geschmack', '', '  ', '2 Eier', '-']);

      expect(parsed, [salz, eier, ParsedIngredient.unparsed('-')]);
      expect(adapter.requests.single.data, {
        'ingredients': ['Salz, nach Geschmack', '2 Eier'],
      });
    });

    test('parses line by line when Tandoor fails on one', () async {
      final adapter = tandoor();

      final parsed = await parser(adapter)
          .parseAll(['Salz, nach Geschmack', 'etwas Liebe', '2 Eier']);

      expect(parsed, [salz, ParsedIngredient.unparsed('etwas Liebe'), eier]);
      expect(adapter.requests.map((r) => r.data), [
        {
          'ingredients': ['Salz, nach Geschmack', 'etwas Liebe', '2 Eier'],
        },
        {'ingredient': 'Salz, nach Geschmack'},
        {'ingredient': 'etwas Liebe'},
        {'ingredient': '2 Eier'},
      ]);
    });

    test('parses line by line when Tandoor leaves a line out', () async {
      // `\u001c` is blank to Python's strip(), not to Dart's trim().
      final adapter = FakeHttpAdapter((request) {
        final body = request.data as Map<String, dynamic>;
        return jsonResponse({
          'ingredient': switch (body['ingredient']) {
            '2 Eier' => recorded('2 Eier'),
            _ => null,
          },
          'ingredients': [
            if (body.containsKey('ingredients')) recorded('2 Eier'),
          ],
        });
      });

      expect(await parser(adapter).parseAll(['\u001c', '2 Eier']), [
        ParsedIngredient.unparsed('\u001c'),
        eier,
      ]);
      expect(adapter.requests, hasLength(3));
    });

    test('sends no request without lines to parse', () async {
      final adapter = tandoor();

      expect(await parser(adapter).parseAll(['', ' ', '#']), [
        ParsedIngredient.unparsed('#'),
      ]);
      expect(adapter.requests, isEmpty);
    });

    test('throws a failure when the request fails', () async {
      final adapter = FakeHttpAdapter(
        (_) => jsonResponse({'detail': 'nope'}, status: 403),
      );

      await expectLater(
        parser(adapter).parseAll(['2 Eier']),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });
}
