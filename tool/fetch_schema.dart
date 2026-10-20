// Downloads the OpenAPI schema from the local dev Tandoor and commits it as
// packages/tandoor_api/schema/openapi-<TANDOOR_VERSION>.json.
//
//   dart run tool/fetch_schema.dart [--url http://localhost:8080]
//
// The schema is pretty-printed with sorted keys so a re-fetch of the same
// Tandoor version produces no diff. Fails if the server does not run the
// version pinned in TANDOOR_VERSION. Then run `dart run tool/generate_api.dart`.

import 'dart:convert';
import 'dart:io';

const _usage =
    'Usage: dart run tool/fetch_schema.dart [--url http://localhost:8080]';

Future<void> main(List<String> args) async {
  var baseUrl = Uri.parse('http://localhost:8080');
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--url' when i + 1 < args.length:
        baseUrl = Uri.parse(args[++i]);
      case '-h' || '--help':
        stdout.writeln(_usage);
        return;
      default:
        stderr.writeln(_usage);
        exitCode = 64;
        return;
    }
  }

  final root = File.fromUri(Platform.script).parent.parent.path;
  final pinned = File('$root/TANDOOR_VERSION').readAsStringSync().trim();
  final client = HttpClient();
  try {
    final settings = await _getJson(
      client,
      baseUrl.resolve('/api/server-settings/current/'),
    );
    final version = (settings as Map<String, dynamic>)['version'];
    if (version != pinned) {
      stderr.writeln(
        'fetch_schema: server runs Tandoor $version, TANDOOR_VERSION is $pinned. '
        'Start the pinned version with '
        '`docker compose -f docker/tandoor/compose.yml up -d --wait`.',
      );
      exitCode = 1;
      return;
    }

    final schema = await _getJson(
      client,
      baseUrl.resolve('/openapi/?format=json'),
    );
    final file = File(schemaPath(root, pinned));
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(canonicalJson(schema));
    stdout.writeln('Wrote ${file.path}');
  } on SocketException {
    stderr.writeln(
      'fetch_schema: no Tandoor at $baseUrl. Start it with '
      '`docker compose -f docker/tandoor/compose.yml up -d --wait`.',
    );
    exitCode = 1;
  } on HttpException catch (e) {
    stderr.writeln('fetch_schema: ${e.message}');
    exitCode = 1;
  } finally {
    client.close();
  }
}

String schemaPath(String root, String version) =>
    '$root/packages/tandoor_api/schema/openapi-$version.json';

/// [json] with all object keys sorted, indented by two spaces, ending in a
/// newline.
String canonicalJson(Object? json) =>
    '${const JsonEncoder.withIndent('  ').convert(_sortKeys(json))}\n';

Object? _sortKeys(Object? json) => switch (json) {
  Map<String, dynamic>() => {
    for (final key in json.keys.toList()..sort()) key: _sortKeys(json[key]),
  },
  List<dynamic>() => [for (final item in json) _sortKeys(item)],
  _ => json,
};

Future<Object?> _getJson(HttpClient client, Uri url) async {
  final request = await client.getUrl(url);
  request.headers.set(HttpHeaders.acceptHeader, 'application/json');
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  if (response.statusCode != HttpStatus.ok) {
    throw HttpException('GET $url returned ${response.statusCode}', uri: url);
  }
  return jsonDecode(body);
}
