import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the web image builds with the pinned Flutter version', () {
    final pinned = RegExp(
      r'^  flutter: (\S+)$',
      multiLine: true,
    ).firstMatch(File('pubspec.yaml').readAsStringSync())?.group(1);
    final dockerfile = File('docker/web/Dockerfile').readAsStringSync();

    final version = RegExp(
      r'^ARG FLUTTER_VERSION=(\S+)$',
      multiLine: true,
    ).firstMatch(dockerfile)?.group(1);

    expect(pinned, isNotNull);
    expect(
      version,
      pinned,
      reason:
          'Update FLUTTER_VERSION and FLUTTER_SHA256 in docker/web/Dockerfile',
    );
  });

  test('the manifest colors are the light bg and sage tokens', () {
    final manifest =
        jsonDecode(File('web/manifest.json').readAsStringSync()) as Map;
    final tokens =
        jsonDecode(File('docs/design/tokens.json').readAsStringSync()) as Map;
    final colors = ((tokens['color'] as Map)['tokens'] as List)
        .cast<Map<String, dynamic>>();
    String light(String name) {
      final token = colors.singleWhere((token) => token['name'] == name);
      return (token['value'] as Map)['light'] as String;
    }

    expect(manifest['background_color'], light('bg'));
    expect(manifest['theme_color'], light('sage'));
  });

  test('index.html keeps the base href placeholder for the entrypoint', () {
    // flutter build replaces $FLUTTER_BASE_HREF with --base-href; the image's
    // 05-yumdoor-base-path.envsh then replaces /__BASE_PATH__/ with BASE_PATH.
    expect(
      File('web/index.html').readAsStringSync(),
      contains(r'<base href="$FLUTTER_BASE_HREF">'),
    );
    expect(
      File('docker/web/Dockerfile').readAsStringSync(),
      contains('--base-href /__BASE_PATH__/'),
    );
    expect(
      File('.github/workflows/ci.yml').readAsStringSync(),
      contains('--base-href /__BASE_PATH__/'),
    );
  });

  test('files the build generates are revalidated on every load', () {
    // flutter build web tree-shakes assets/fonts/MaterialIcons-Regular.otf to
    // the icons the app uses, so it changes with every new icon under the same
    // URL, like the other generated files. A max-age kept the old font on
    // devices and new icons rendered blank (#162). Only files copied unchanged
    // from web/ (the app icons) may be cached longer.
    final nginx = File('docker/web/yumdoor.conf.template')
        .readAsLinesSync()
        .where((line) => !line.trimLeft().startsWith('#'))
        .join('\n');
    final map = RegExp(
      r'map \$yumdoor_file \$yumdoor_cache_control \{(.*?)\}',
      dotAll: true,
    ).firstMatch(nginx)?.group(1);
    expect(map, isNotNull);
    final entries = RegExp(
      r'^\s*(\S+)\s+"([^"]*)";$',
      multiLine: true,
    ).allMatches(map!).map((match) => (match.group(1)!, match.group(2)!));
    expect(entries, contains(('default', 'no-cache')));
    final longCached = [
      for (final (pattern, value) in entries)
        if (value != 'no-cache') RegExp(pattern.substring(1)),
    ];

    const generated = [
      'assets/fonts/MaterialIcons-Regular.otf',
      'assets/fonts/fallback/Roboto-Regular.ttf',
      'assets/assets/fonts/nunito/Nunito-Regular.ttf',
      'assets/FontManifest.json',
      'assets/AssetManifest.bin',
      'assets/NOTICES',
      'main.dart.js',
      'flutter_bootstrap.js',
      'flutter.js',
      'version.json',
      'manifest.json',
      'service_worker.js',
      'canvaskit/canvaskit.js',
      'canvaskit/canvaskit.wasm',
    ];
    for (final path in generated) {
      for (final pattern in longCached) {
        expect(pattern.hasMatch(path), isFalse, reason: '$path: $pattern');
      }
    }
    for (final pattern in longCached) {
      expect(pattern.pattern, startsWith('^'));
      expect(pattern.pattern, isNot(contains('assets')));
    }

    // index.html and the SPA fallback.
    expect(
      RegExp(r'add_header Cache-Control "([^"]*)"')
          .allMatches(nginx)
          .map((match) => match.group(1)),
      everyElement('no-cache'),
    );
  });

  test('the service worker bypasses the HTTP cache for files of the build', () {
    // Devices still hold files that an older image served with a 30-day
    // max-age; the worker's network fetch must not answer from that.
    final worker = File('web/service_worker.js').readAsStringSync();
    final networkFirst = RegExp(
      r'\nasync function networkFirst\(.*?\n\}',
      dotAll: true,
    ).firstMatch(worker)?.group(0);
    expect(networkFirst, isNotNull);
    expect(networkFirst, contains("cache: 'no-cache'"));
    expect(networkFirst, isNot(contains('fetch(request)')));
  });
}
