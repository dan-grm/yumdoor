// Regenerates packages/tandoor_api/lib/ from the committed schema
// (packages/tandoor_api/schema/openapi-<TANDOOR_VERSION>.json).
//
//   dart run tool/generate_api.dart
//
// 1. openapi-generator `dart-dio` in a pinned Docker image (built_value
//    serialization, see docs/ARCHITECTURE.md#api-client).
// 2. build_runner for the built_value serializers.
// 3. dart format, so the output passes the format check in CI.
//
// lib/ is deleted first, so models removed from the schema disappear. The
// package's pubspec and README are maintained by hand
// (packages/tandoor_api/.openapi-generator-ignore). Needs Docker; no Tandoor.

import 'dart:convert';
import 'dart:io';

/// Bump deliberately: a new generator version changes the generated code.
const generatorImage =
    'openapitools/openapi-generator-cli:v7.26.0'
    '@sha256:a304ddf1e2e5f24f68fa3153568d6174cea4959d09aa8e3db6d526fd0782326d';

const generatorProperties = {
  'pubName': 'tandoor_api',
  'pubLibrary': 'tandoor_api',
  // Enum values added by a newer Tandoor parse as `unknownDefaultOpenApi`
  // instead of failing the whole response.
  'enumUnknownDefaultCase': 'true',
};

Future<void> main(List<String> args) async {
  if (args.isNotEmpty) {
    stdout.writeln('Usage: dart run tool/generate_api.dart');
    exitCode = args.first == '-h' || args.first == '--help' ? 0 : 64;
    return;
  }

  final root = File.fromUri(Platform.script).parent.parent.path;
  final version = File('$root/TANDOOR_VERSION').readAsStringSync().trim();
  final package = Directory('$root/packages/tandoor_api').absolute.path;
  final schema = 'schema/openapi-$version.json';
  if (!File('$package/$schema').existsSync()) {
    stderr.writeln(
      'generate_api: packages/tandoor_api/$schema is missing. '
      'Run `dart run tool/fetch_schema.dart` first.',
    );
    exitCode = 1;
    return;
  }

  // The committed schema stays exactly as fetched; the patched copy is
  // written inside the package so the container can read it.
  const patched = '.dart_tool/openapi-patched.json';
  final spec = jsonDecode(
    File('$package/$schema').readAsStringSync(),
  ) as Map<String, dynamic>;
  File('$package/$patched')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(jsonEncode(patchSchema(spec)));

  try {
    for (final generated in ['lib', '.openapi-generator']) {
      final dir = Directory('$package/$generated');
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    }

    stdout.writeln('Generating from $schema with $generatorImage…');
    await _run('docker', [
      'run',
      '--rm',
      // On Linux the container would otherwise write the files as root.
      if (!Platform.isWindows) ...['--user', await _hostUser()],
      '-v',
      '$package:/local',
      generatorImage,
      'generate',
      '--input-spec',
      '/local/$patched',
      '--generator-name',
      'dart-dio',
      '--output',
      '/local',
      '--global-property',
      'apiDocs=false,modelDocs=false,apiTests=false,modelTests=false',
      '--additional-properties',
      [for (final e in generatorProperties.entries) '${e.key}=${e.value}']
          .join(','),
    ]);
    Directory('$package/.openapi-generator').deleteSync(recursive: true);

    stdout.writeln('Running build_runner…');
    await _run(Platform.resolvedExecutable, [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ], workingDirectory: package);

    await _run(Platform.resolvedExecutable, ['format', '$package/lib']);
  } on ProcessException catch (e) {
    stderr.writeln('generate_api: ${e.executable}: ${e.message}');
    exitCode = 1;
    return;
  }

  stdout.writeln('Generated packages/tandoor_api/lib/ for Tandoor $version.');
}

/// Makes every read-only property of [schema]'s components optional and
/// nullable, in place, and returns [schema].
///
/// drf-spectacular declares read-only fields required and non-null, but
/// Tandoor sends null for many of them (`Food.parent` of a root food,
/// `MealPlan.recipe_name` without a recipe) and leaves some out
/// (`RecipeOverview.recent` without `num_recent`). Read-only fields only
/// occur in responses, so this changes no request. The mappers in lib/data/
/// decide what a missing value means. See docs/TANDOOR_API.md#schema.
Map<String, dynamic> patchSchema(Map<String, dynamic> schema) {
  final components = schema['components'] as Map<String, dynamic>;
  final schemas = components['schemas'] as Map<String, dynamic>;
  for (final component in schemas.values.cast<Map<String, dynamic>>()) {
    final properties = component['properties'] as Map<String, dynamic>?;
    if (properties == null) continue;
    final required = component['required'] as List<dynamic>?;
    for (final MapEntry(key: name, value: property) in properties.entries) {
      if ((property as Map<String, dynamic>)['readOnly'] != true) continue;
      property['nullable'] = true;
      required?.remove(name);
    }
  }
  return schema;
}

/// Runs a command and shows its output only if it fails; openapi-generator
/// logs a line per file.
Future<void> _run(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
}) async {
  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode != 0) {
    stderr
      ..write(result.stdout)
      ..write(result.stderr);
    throw ProcessException(
      executable,
      arguments,
      'exited with ${result.exitCode}',
      result.exitCode,
    );
  }
}

Future<String> _hostUser() async {
  final uid = await Process.run('id', ['-u']);
  final gid = await Process.run('id', ['-g']);
  return '${(uid.stdout as String).trim()}:${(gid.stdout as String).trim()}';
}
