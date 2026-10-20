// Enforces the layer rules from CLAUDE.md and docs/ARCHITECTURE.md.
//
//   dart run tool/check_imports.dart [project-root]
//
// Scans every `import` and `export` under `lib/` (including the URIs of
// conditional imports) and exits with 1, printing `path:line:column` for each
// forbidden one. The root defaults to the current directory.

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  if (args.length > 1) {
    stderr.writeln('Usage: dart run tool/check_imports.dart [project-root]');
    exitCode = 64;
    return;
  }
  final root = args.isEmpty ? Directory.current.path : args.single;

  final List<Violation> violations;
  try {
    violations = checkImports(root);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    exitCode = 2;
    return;
  }

  if (violations.isEmpty) {
    stdout.writeln('check_imports: no forbidden imports.');
    return;
  }
  violations.forEach(stderr.writeln);
  stderr.writeln(
    'check_imports: ${violations.length} forbidden import(s). See docs/ARCHITECTURE.md#layers.',
  );
  exitCode = 1;
}

/// A forbidden `import` or `export` directive.
class Violation {
  const Violation({
    required this.path,
    required this.line,
    required this.column,
    required this.uri,
    required this.reason,
  });

  /// File path relative to the project root, with `/` separators.
  final String path;
  final int line;
  final int column;

  /// The URI as written in the directive.
  final String uri;
  final String reason;

  @override
  String toString() => '$path:$line:$column: $uri: $reason';
}

/// Checks every Dart file under `<root>/lib/` and returns the violations,
/// sorted by path and line.
///
/// Throws a [FormatException] if `<root>/pubspec.yaml` is missing or has no
/// `name`.
List<Violation> checkImports(String root) {
  final packageName = _readPackageName(root);
  final lib = Directory(p.join(root, 'lib'));
  if (!lib.existsSync()) return const [];

  final files =
      lib
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .map((f) => p.split(p.relative(f.path, from: root)).join('/'))
          .toList()
        ..sort();

  return [
    for (final path in files)
      ..._checkFile(
        path,
        File(p.join(root, path)).readAsStringSync(),
        packageName,
      ),
  ];
}

class _Rule {
  const _Rule(this.reason, {required this.appliesTo, required this.forbids});

  final String reason;

  /// Whether the rule covers the importing file (project-relative path).
  final bool Function(String path) appliesTo;

  /// Whether the rule forbids the target, given as `lib/…` for app files and
  /// as the plain URI otherwise.
  final bool Function(String target) forbids;
}

const _platformOnlyLibraries = {
  'dart:html',
  'dart:io',
  'dart:js',
  'dart:js_interop',
  'dart:js_interop_unsafe',
  'dart:js_util',
};

final _rules = [
  _Rule(
    'only lib/data/ may import the generated Tandoor client',
    appliesTo: (path) => !_isUnder(path, 'lib/data'),
    forbids: (target) => _isPackage(target, 'tandoor_api'),
  ),
  _Rule(
    'lib/domain/ is pure Dart: no Flutter, Dio, Drift, data, platform or features',
    appliesTo: (path) => _isUnder(path, 'lib/domain'),
    forbids: (target) =>
        target == 'dart:ui' ||
        _isPackageFamily(target, 'flutter') ||
        _isPackageFamily(target, 'dio') ||
        _isPackageFamily(target, 'drift') ||
        _isUnder(target, 'lib/data') ||
        _isUnder(target, 'lib/platform') ||
        _isUnder(target, 'lib/features'),
  ),
  _Rule(
    'lib/features/ must go through providers, not data, Dio or Drift',
    appliesTo: (path) => _isUnder(path, 'lib/features'),
    forbids: (target) =>
        _isUnder(target, 'lib/data') ||
        _isPackageFamily(target, 'dio') ||
        _isPackageFamily(target, 'drift'),
  ),
  _Rule(
    'platform libraries belong behind an interface in lib/platform/',
    appliesTo: (path) => !_isUnder(path, 'lib/platform'),
    forbids: (target) =>
        _platformOnlyLibraries.contains(target) || _isPackage(target, 'web'),
  ),
];

Iterable<Violation> _checkFile(
  String path,
  String source,
  String packageName,
) sync* {
  final result = parseString(
    content: source,
    path: path,
    throwIfDiagnostics: false,
  );
  for (final directive
      in result.unit.directives.whereType<NamespaceDirective>()) {
    final uris = [
      directive.uri,
      for (final configuration in directive.configurations) configuration.uri,
    ];
    for (final uri in uris) {
      final written = uri.stringValue;
      // Interpolated URIs are a compile error anyway.
      if (written == null) continue;
      final target = _resolve(written, from: path, packageName: packageName);
      for (final rule in _rules) {
        if (rule.appliesTo(path) && rule.forbids(target)) {
          final location = result.lineInfo.getLocation(uri.offset);
          yield Violation(
            path: path,
            line: location.lineNumber,
            column: location.columnNumber,
            uri: written,
            reason: rule.reason,
          );
        }
      }
    }
  }
}

/// Maps relative and `package:<own package>/` URIs to `lib/…` paths; returns
/// other URIs unchanged.
String _resolve(
  String uri, {
  required String from,
  required String packageName,
}) {
  final ownPrefix = 'package:$packageName/';
  if (uri.startsWith(ownPrefix)) {
    return 'lib/${uri.substring(ownPrefix.length)}';
  }
  if (Uri.parse(uri).hasScheme) return uri;
  return p.url.normalize(p.url.join(p.url.dirname(from), uri));
}

bool _isUnder(String path, String dir) => path.startsWith('$dir/');

bool _isPackage(String uri, String name) => uri.startsWith('package:$name/');

/// `name` itself and its satellite packages such as `name_annotation` or
/// `flutter_riverpod`.
bool _isPackageFamily(String uri, String name) =>
    _isPackage(uri, name) || uri.startsWith('package:${name}_');

String _readPackageName(String root) {
  final pubspec = File(p.join(root, 'pubspec.yaml'));
  if (!pubspec.existsSync()) throw FormatException('No pubspec.yaml in $root');
  final match = RegExp(
    r'^name:\s*(\w+)',
    multiLine: true,
  ).firstMatch(pubspec.readAsStringSync());
  if (match == null) {
    throw FormatException('No package name in ${pubspec.path}');
  }
  return match.group(1)!;
}
