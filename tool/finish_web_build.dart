// Finishes `flutter build web` for deployment; run it right after the build.
//
//   flutter build web --release --no-web-resources-cdn --base-href /__BASE_PATH__/
//   dart run tool/finish_web_build.dart [build/web]
//
// - Removes renderer files the loader never requests for our build (dart2js +
//   CanvasKit, no --wasm): the skwasm, wimp and webparagraph variants and the
//   `.symbols` debug files. That halves the Docker image. It refuses to run on
//   a build that uses another renderer.
// - Removes Flutter's deprecated flutter_service_worker.js; flutter_bootstrap.js
//   registers our own web/service_worker.js instead.
// - Stamps service_worker.js with the build (version.json plus a hash of all
//   files, so every deploy installs a new worker) and the list of files it may
//   cache.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

const _usage = 'Usage: dart run tool/finish_web_build.dart [build-dir]';

void main(List<String> args) {
  if (args.length > 1) {
    stderr.writeln(_usage);
    exitCode = 64;
    return;
  }
  final dir = Directory(args.isEmpty ? 'build/web' : args.single);
  try {
    final result = finishWebBuild(dir);
    stdout.writeln(
      'Finished ${dir.path}: build ${result.build}, ${result.files.length} '
      'files, removed ${result.removed.length}',
    );
  } on FormatException catch (e) {
    stderr.writeln('finish_web_build: ${e.message}');
    exitCode = 1;
  }
}

/// What [finishWebBuild] did.
typedef FinishedBuild = ({
  String build,
  List<String> files,
  List<String> removed,
});

const serviceWorkerPath = 'service_worker.js';

/// Prunes, removes Flutter's service worker and stamps ours in [dir].
///
/// Throws a [FormatException] if [dir] is not a finished-able build: another
/// renderer, no version.json, or a service worker that is missing or stamped.
FinishedBuild finishWebBuild(Directory dir) {
  if (!dir.existsSync()) {
    throw FormatException('${dir.path} does not exist; run flutter build web');
  }
  _checkRenderers(_read(dir, 'flutter_bootstrap.js'));
  final worker = _read(dir, serviceWorkerPath);
  for (final placeholder in _placeholders.values) {
    if (placeholder.allMatches(worker).length != 1) {
      throw FormatException(
        '$serviceWorkerPath must contain `$placeholder` once; '
        'is it stamped already?',
      );
    }
  }

  final removed = <String>[];
  for (final (path, entity) in _entries(dir)) {
    // Files in a removed directory are gone already.
    if (_isUnused(path) && entity.existsSync()) {
      entity.deleteSync(recursive: true);
      removed.add(path);
    }
  }
  _deleteEmptyDirectories(dir);

  final files = [
    for (final (path, entity) in _entries(dir))
      if (entity is File && path != serviceWorkerPath) path,
  ];
  final hash = sha256.convert(
    utf8.encode(
      [
        for (final path in files)
          '$path ${sha256.convert(File(p.join(dir.path, path)).readAsBytesSync())}',
      ].join('\n'),
    ),
  );

  final version = jsonDecode(_read(dir, 'version.json')) as Map;
  final build =
      '${version['version']}+${version['build_number']}-'
      '${hash.toString().substring(0, 12)}';
  // index.html is cached as the scope URL itself, i.e. the base path.
  final cached = [for (final path in files) path == 'index.html' ? '' : path];

  final values = {
    'BUILD': jsonEncode(build),
    'FILES': const JsonEncoder.withIndent('  ').convert(cached),
  };
  File(p.join(dir.path, serviceWorkerPath)).writeAsStringSync(
    _placeholders.entries.fold(
      worker,
      (worker, placeholder) => worker.replaceFirst(
        placeholder.value,
        'const ${placeholder.key} = ${values[placeholder.key]};',
      ),
    ),
  );
  return (build: build, files: cached, removed: removed);
}

/// The lines of web/service_worker.js that are replaced, by constant name.
const _placeholders = {
  'BUILD': 'const BUILD = null;',
  'FILES': 'const FILES = null;',
};

/// Entries of the build with their path relative to [dir], `/`-separated,
/// sorted, so a directory comes before its contents. Directories end in `/`.
List<(String, FileSystemEntity)> _entries(Directory dir) => [
  for (final entity in dir.listSync(recursive: true))
    (
      p.posix.joinAll(p.split(p.relative(entity.path, from: dir.path))) +
          (entity is Directory ? '/' : ''),
      entity,
    ),
]..sort((a, b) => a.$1.compareTo(b.$1));

bool _isUnused(String path) =>
    path.endsWith('.symbols') ||
    path == '.last_build_id' ||
    path == 'flutter_service_worker.js' ||
    path.startsWith('canvaskit/skwasm') ||
    path.startsWith('canvaskit/wimp.') ||
    path == 'canvaskit/webparagraph/';

void _deleteEmptyDirectories(Directory dir) {
  for (final (_, entity) in _entries(dir).reversed) {
    if (entity is Directory && entity.listSync().isEmpty) entity.deleteSync();
  }
}

/// The loader picks skwasm/wimp only for `--wasm` builds, so pruning them is
/// safe only for CanvasKit builds. webparagraph is picked only with
/// `preferWebParagraph`, which web/flutter_bootstrap.js does not pass.
void _checkRenderers(String bootstrap) {
  final config = RegExp(r'_flutter\.buildConfig = (\{.*\});')
      .firstMatch(bootstrap)
      ?.group(1);
  if (config == null) {
    throw const FormatException(
      'no _flutter.buildConfig in flutter_bootstrap.js',
    );
  }
  final builds = (jsonDecode(config) as Map)['builds'] as List;
  final renderers = {
    for (final build in builds.cast<Map<String, dynamic>>())
      if (build['renderer'] case final String renderer) renderer,
  };
  if (renderers.length != 1 || renderers.single != 'canvaskit') {
    throw FormatException(
      'expected a CanvasKit-only build, got renderers $renderers; '
      'update the pruning in tool/finish_web_build.dart',
    );
  }
}

String _read(Directory dir, String path) {
  final file = File(p.join(dir.path, path));
  if (!file.existsSync()) {
    throw FormatException('${file.path} is missing');
  }
  return file.readAsStringSync();
}
