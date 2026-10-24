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
}
