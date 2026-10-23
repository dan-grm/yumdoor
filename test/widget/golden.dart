import 'dart:io';

/// Tags for golden tests (`--tags golden`, see dart_test.yaml).
const goldenTags = ['golden'];

/// Goldens are rendered and compared on Linux, the CI platform: text
/// rasterizes differently on Windows and macOS. Elsewhere golden tests are
/// skipped, so `--update-goldens` can't commit images CI would reject.
final String? goldenSkip = Platform.isLinux
    ? null
    : 'Goldens are rendered on Linux; CI checks them '
          '(update them with the "Update goldens" workflow).';
