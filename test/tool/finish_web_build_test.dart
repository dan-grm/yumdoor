import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../tool/finish_web_build.dart';

void main() {
  late Directory dir;

  void write(String path, String content) => (File(
    p.join(dir.path, path),
  )..createSync(recursive: true)).writeAsStringSync(content);

  String bootstrap({String renderer = 'canvaskit'}) =>
      '_flutter.buildConfig = {"builds":[{"compileTarget":"dart2js",'
      '"renderer":"$renderer","mainJsPath":"main.dart.js"},{}]};\n'
      '_flutter.loader.load();';

  setUp(() {
    dir = Directory.systemTemp.createTempSync('finish_web_build_test');
    write('index.html', '<base href="/__BASE_PATH__/">');
    write('main.dart.js', 'main');
    write('flutter_bootstrap.js', bootstrap());
    write('version.json', '{"version":"0.1.0","build_number":"1"}');
    write('flutter_service_worker.js', 'deprecated');
    write('.last_build_id', 'abc');
    write('assets/fonts/My Font.ttf', 'font');
    for (final file in [
      'canvaskit/canvaskit.js',
      'canvaskit/canvaskit.wasm',
      'canvaskit/canvaskit.js.symbols',
      'canvaskit/chromium/canvaskit.js',
      'canvaskit/chromium/canvaskit.wasm',
      'canvaskit/webparagraph/canvaskit.js',
      'canvaskit/webparagraph/canvaskit.wasm',
      'canvaskit/skwasm.js',
      'canvaskit/skwasm_heavy.wasm',
      'canvaskit/wimp.wasm',
    ]) {
      write(file, file);
    }
    // The real worker from web/, as flutter build copies it.
    write(serviceWorkerPath, File('web/$serviceWorkerPath').readAsStringSync());
  });

  tearDown(() => dir.deleteSync(recursive: true));

  List<String> remaining() => [
    for (final entity in dir.listSync(recursive: true))
      if (entity is File)
        p.posix.joinAll(p.split(p.relative(entity.path, from: dir.path))),
  ]..sort();

  test('removes unused renderers and Flutter\'s service worker', () {
    finishWebBuild(dir);

    expect(remaining(), [
      'assets/fonts/My Font.ttf',
      'canvaskit/canvaskit.js',
      'canvaskit/canvaskit.wasm',
      'canvaskit/chromium/canvaskit.js',
      'canvaskit/chromium/canvaskit.wasm',
      'flutter_bootstrap.js',
      'index.html',
      'main.dart.js',
      serviceWorkerPath,
      'version.json',
    ]);
    expect(
      Directory(p.join(dir.path, 'canvaskit/webparagraph')).existsSync(),
      isFalse,
    );
  });

  test('stamps the build and the files into the service worker', () {
    final result = finishWebBuild(dir);

    final worker = File(p.join(dir.path, serviceWorkerPath)).readAsStringSync();
    expect(result.build, matches(RegExp(r'^0\.1\.0\+1-[0-9a-f]{12}$')));
    expect(worker, contains('const BUILD = ${jsonEncode(result.build)};'));
    expect(worker, isNot(contains('const FILES = null;')));
    // index.html is cached under the base path; the worker lists not itself.
    expect(result.files, contains(''));
    expect(result.files, isNot(contains('index.html')));
    expect(result.files, isNot(contains(serviceWorkerPath)));
    expect(result.files, contains('assets/fonts/My Font.ttf'));
    expect(result.files, contains('canvaskit/chromium/canvaskit.wasm'));
  });

  test('a changed file changes the build', () {
    final first = finishWebBuild(dir).build;
    write(serviceWorkerPath, File('web/$serviceWorkerPath').readAsStringSync());
    write('main.dart.js', 'changed');

    expect(finishWebBuild(dir).build, isNot(first));
  });

  test('refuses a build that is stamped already, without changing it', () {
    finishWebBuild(dir);
    write('flutter_service_worker.js', 'deprecated');

    expect(() => finishWebBuild(dir), throwsFormatException);
    expect(remaining(), contains('flutter_service_worker.js'));
  });

  test('refuses a build with another renderer', () {
    write('flutter_bootstrap.js', bootstrap(renderer: 'skwasm'));

    expect(() => finishWebBuild(dir), throwsFormatException);
    expect(File(p.join(dir.path, 'canvaskit/skwasm.js')).existsSync(), isTrue);
  });
}
