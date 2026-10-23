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
    };

    for (final MapEntry(key: file, value: path) in fixtures.entries) {
      final response = await client.get(path);
      File('$root/$fixturesDir/$file')
        ..createSync(recursive: true)
        ..writeAsStringSync(
          '${const JsonEncoder.withIndent('  ').convert(response)}\n',
        );
      stdout.writeln('$fixturesDir/$file ← GET $path');
    }
  } on SeedException catch (e) {
    stderr.writeln('record_fixtures: ${e.message}');
    exitCode = 1;
  } finally {
    client.close();
  }
}
