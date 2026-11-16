import 'dart:async';

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

  /// The lines of a request.
  List<String> sent(RequestOptions request) =>
      ((request.data as Map<String, dynamic>)['ingredients'] as List)
          .cast<String>();

  /// The answer to the request that checks whether the server works.
  ResponseBody settings(RequestOptions request) {
    expect(request.uri.path, '/tandoor/api/server-settings/current/');
    return jsonResponse(tandoorFixture('server_settings.json'));
  }

  /// Answers like Tandoor's parser: each line from the recording, a 500 for
  /// a list that contains [unparseable].
  FakeHttpAdapter tandoor({String unparseable = 'etwas Liebe'}) =>
      FakeHttpAdapter((request) {
        if (request.method == 'GET') return settings(request);
        final lines = sent(request);
        if (lines.contains(unparseable)) {
          return htmlResponse('<h1>Server Error (500)</h1>', status: 500);
        }
        return jsonResponse({
          'ingredient': null,
          'ingredients': [for (final line in lines) recorded(line)],
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
  const oil = ParsedIngredient(
    originalText: '2 tbsp olive oil',
    food: NamedRef(id: 169, name: 'olive oil'),
    unit: NamedRef(id: 36, name: 'tbsp'),
    amount: 2,
  );

  final forbidden = FakeHttpAdapter(
    (_) => jsonResponse({'detail': 'nope'}, status: 403),
  );

  group('parse', () {
    test('posts the line to the parser', () async {
      final adapter = tandoor();

      expect(await parser(adapter).parse('Salz, nach Geschmack'), salz);

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/tandoor/api/ingredient-parser/post/');
      expect(request.data, {
        'ingredients': ['Salz, nach Geschmack'],
      });
    });

    test('returns a line Tandoor fails on as unparsed', () async {
      final adapter = tandoor();

      expect(
        await parser(adapter).parse('etwas Liebe'),
        ParsedIngredient.unparsed('etwas Liebe'),
      );
      expect(adapter.requests.map((r) => r.method), ['POST', 'GET']);
    });

    test('throws when the server fails other requests too', () async {
      final adapter = FakeHttpAdapter(
        (_) => htmlResponse('<h1>Server Error (500)</h1>', status: 500),
      );

      await expectLater(
        parser(adapter).parse('2 Eier'),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'status', 500),
        ),
      );
      await expectLater(
        parser(adapter).parseAll(['2 Eier', 'Salz, nach Geschmack']),
        throwsA(isA<ServerFailure>()),
      );
      // One parser request and one check each.
      expect(adapter.requests, hasLength(4));
    });

    test('returns a line Tandoor leaves out as unparsed', () async {
      // `\u001c` is blank to Python's strip(), not to Dart's trim().
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

    test('counts the length in code points, like Tandoor', () async {
      // 300 code points, 600 UTF-16 code units.
      final line = '🥕' * 300;
      final adapter = tandoor(unparseable: line);

      await parser(adapter).parse(line);

      expect(adapter.requests, isNotEmpty);
    });

    test('throws a failure when the request fails', () async {
      final unavailable = FakeHttpAdapter(
        (_) => htmlResponse('Bad Gateway', status: 502),
      );
      final offline = FakeHttpAdapter(
        (request) => throw DioException.connectionError(
          requestOptions: request,
          reason: 'offline',
        ),
      );
      final noId = FakeHttpAdapter(
        (_) => jsonResponse({
          'ingredient': null,
          'ingredients': [
            {
              ...recorded('2 Eier'),
              'food': {'name': 'Ei'},
            },
          ],
        }),
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
      await expectLater(
        parser(noId).parse('2 Eier'),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('sends one request at a time', () async {
      final answers = <Completer<ResponseBody>>[];
      final adapter = FakeHttpAdapter((_) {
        final answer = Completer<ResponseBody>();
        answers.add(answer);
        return answer.future;
      });
      final ingredientParser = parser(adapter);

      final first = ingredientParser.parse('2 Eier');
      final second = ingredientParser.parseAll(['Salz, nach Geschmack']);
      await pumpEventQueue();
      expect(adapter.requests, hasLength(1));

      answers.single.complete(
        jsonResponse({
          'ingredient': null,
          'ingredients': [recorded('2 Eier')],
        }),
      );
      expect(await first, eier);
      await pumpEventQueue();
      expect(adapter.requests, hasLength(2));

      answers.last.complete(
        jsonResponse({
          'ingredient': null,
          'ingredients': [recorded('Salz, nach Geschmack')],
        }),
      );
      expect(await second, [salz]);
    });

    test('goes on after a call that failed', () async {
      var fail = true;
      final adapter = FakeHttpAdapter((request) {
        if (fail) {
          fail = false;
          return jsonResponse({'detail': 'nope'}, status: 403);
        }
        return jsonResponse({
          'ingredient': null,
          'ingredients': [recorded('2 Eier')],
        });
      });
      final ingredientParser = parser(adapter);

      await expectLater(
        ingredientParser.parse('2 Eier'),
        throwsA(isA<UnauthorizedFailure>()),
      );
      expect(await ingredientParser.parse('2 Eier'), eier);
    });
  });

  group('parseAll', () {
    test('parses the non-blank lines in one request', () async {
      final adapter = tandoor();

      final parsed = await parser(adapter)
          .parseAll(['Salz, nach Geschmack', '', '  ', '2 Eier', '-']);

      expect(parsed, [salz, eier, ParsedIngredient.unparsed('-')]);
      expect(adapter.requests.map(sent), [
        ['Salz, nach Geschmack', '2 Eier'],
      ]);
    });

    test('splits a list Tandoor fails on until it finds the line', () async {
      final adapter = tandoor();

      final parsed = await parser(adapter).parseAll([
        'Salz, nach Geschmack',
        '2 Eier',
        'etwas Liebe',
        '2 tbsp olive oil',
      ]);

      expect(parsed, [
        salz,
        eier,
        ParsedIngredient.unparsed('etwas Liebe'),
        oil,
      ]);
      // The server is checked once, after the first 500.
      expect(adapter.requests.map((r) => r.method), [
        'POST',
        'GET',
        ...List.filled(4, 'POST'),
      ]);
      expect(adapter.requests.where((r) => r.method == 'POST').map(sent), [
        ['Salz, nach Geschmack', '2 Eier', 'etwas Liebe', '2 tbsp olive oil'],
        ['Salz, nach Geschmack', '2 Eier'],
        ['etwas Liebe', '2 tbsp olive oil'],
        ['etwas Liebe'],
        ['2 tbsp olive oil'],
      ]);
    });

    test('splits a list when Tandoor leaves a line out', () async {
      // `\u001c` is blank to Python's strip(), not to Dart's trim().
      final adapter = FakeHttpAdapter(
        (request) => jsonResponse({
          'ingredient': null,
          'ingredients': [
            for (final line in sent(request))
              if (line == '2 Eier') recorded(line),
          ],
        }),
      );

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
      expect(await parser(adapter).parseAll([]), isEmpty);
      expect(adapter.requests, isEmpty);
    });

    test('throws a failure when the request fails', () async {
      await expectLater(
        parser(forbidden).parseAll(['2 Eier']),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });
  });
}
