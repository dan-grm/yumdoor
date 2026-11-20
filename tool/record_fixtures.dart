// Records Tandoor API responses from the seeded local Tandoor as JSON fixtures
// for the mapper tests (test/fixtures/tandoor/).
//
//   dart run tool/record_fixtures.dart
//
// Needs the local Tandoor and `dart run tool/seed.dart`; reads the tokens from
// .seed/credentials.json and refuses to talk to anything but the local
// Tandoor. Re-record after bumping the Tandoor version. Ids and timestamps
// change with every seed, so recording again on a fresh seed shows a diff.

import 'dart:convert';
import 'dart:io';

import 'seed.dart'
    show TandoorClient, SeedException, credentialsPath, isLocalTarget;

const fixturesDir = 'test/fixtures/tandoor';

Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent.path;
  final credentials = File('$root/$credentialsPath');
  if (!credentials.existsSync()) {
    stderr.writeln(
      'record_fixtures: $credentialsPath is missing. Run `dart run tool/seed.dart` first.',
    );
    exitCode = 1;
    return;
  }
  final json =
      jsonDecode(credentials.readAsStringSync()) as Map<String, dynamic>;
  final baseUrl = Uri.parse(json['base_url'] as String);
  if (!isLocalTarget(baseUrl)) {
    stderr.writeln('record_fixtures: refusing to read from ${baseUrl.host}.');
    exitCode = 2;
    return;
  }
  final users = json['users'] as Map<String, dynamic>;
  final token = (users['anna'] as Map<String, dynamic>)['token'] as String;

  final client = TandoorClient(baseUrl, token);
  void save(String file, Object? response, String request) {
    File('$root/$fixturesDir/$file')
      ..createSync(recursive: true)
      ..writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(response)}\n',
      );
    stdout.writeln('$fixturesDir/$file ← $request');
  }

  final today = DateTime.now();
  final monday = DateTime(
    today.year,
    today.month,
    today.day - today.weekday + 1,
  );

  try {
    Future<int> recipeId(String name) async {
      final page = await client.get(
        '/api/recipe/?query=${Uri.encodeQueryComponent(name)}',
      );
      final results = (page! as Map<String, dynamic>)['results'] as List;
      return (results.cast<Map<String, dynamic>>().singleWhere(
            (r) => r['name'] == name,
          ))['id']
          as int;
    }

    final fixtures = <String, String>{
      'server_settings.json': '/api/server-settings/current/',
      'recipe_list.json': '/api/recipe/?page_size=3',
      // Ingredient headers, a note, `{{ scale() }}` and an explicit step time.
      'recipe_apfelkuchen.json':
          '/api/recipe/${await recipeId('Apfelkuchen vom Blech')}/',
      // `{{ ingredients[0] }}`, ingredients without an amount, a food tree.
      'recipe_karottensuppe.json':
          '/api/recipe/${await recipeId('Karottensuppe mit Ingwer')}/',
      'food_list.json': '/api/food/?query=Karotte&page_size=5',
      'keyword_list.json': '/api/keyword/?query=Suppe&page_size=5',
      'unit_list.json': '/api/unit/?query=l&page_size=5',
      // The space's oldest entries, by Anna and Ben, with and without a
      // rating and a comment.
      'cook_log_list.json': '/api/cook-log/?page_size=3',
      // Anna's own book, shared with Ben.
      'recipe_book_list.json': '/api/recipe-book/',
      // Anna's saved searches and Ben's shared with her: one the chips can
      // show, one they can't.
      'custom_filter_list.json': '/api/custom-filter/',
      // Not paginated; `display_name` with a trailing space.
      'user_list.json': '/api/user/',
      // The seeded week of Anna's household: plans by Anna and Ben, with and
      // without a recipe, one over two days, some on the shopping list.
      'meal_plan_list.json':
          '/api/meal-plan/?from_date=${_day(monday)}'
          '&to_date=${_day(DateTime(monday.year, monday.month, monday.day + 6))}',
      'meal_type_list.json': '/api/meal-type/',
      // The household's list: entries for Ben's and Anna's meal plans, items
      // added by hand (one checked, one without a unit, one whose food has no
      // category).
      'shopping_list_entry_list.json': '/api/shopping-list-entry/',
      'supermarket_list.json': '/api/supermarket/',
    };

    for (final MapEntry(key: file, value: path) in fixtures.entries) {
      final response = await client.get(path);
      save(file, response, 'GET $path');
    }

    // Only foods and units the seed has: Tandoor's parser creates the ones it
    // doesn't know (docs/TANDOOR_API.md#ingredient-parser).
    final postFixtures = <String, (String, Object)>{
      // DE and EN lines: plural food names, a note after a comma or in
      // brackets, fractions, a decimal comma, no unit, no amount. The blank
      // line is left out of the response.
      'ingredient_parser.json': (
        '/api/ingredient-parser/post/',
        {
          'ingredients': [
            '200 g Karotten, geschält',
            '½ TL Salz',
            '1,5 l Gemüsebrühe',
            '1 ½ EL Butter',
            '2 Eier',
            'Salz, nach Geschmack',
            '',
            'Butter (weich)',
            '2 tbsp olive oil',
            '1 1/2 tsp cinnamon',
            '1/2 tsp cumin',
            '2 carrots, peeled and diced',
          ],
        },
      ),
    };
    for (final MapEntry(key: file, value: (path, body))
        in postFixtures.entries) {
      final response = await client.post(path, body);
      save(file, response, 'POST $path');
    }
  } on SeedException catch (e) {
    stderr.writeln('record_fixtures: ${e.message}');
    exitCode = 1;
  } finally {
    client.close();
  }
}

String _day(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';
