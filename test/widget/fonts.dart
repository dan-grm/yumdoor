import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the bundled Nunito so goldens show the real font, not Ahem, and the
/// Material icon font from the Flutter SDK so icons aren't boxes.
Future<void> loadBundledFonts() async {
  final loader = FontLoader('Nunito');
  for (final weight in ['Regular', 'SemiBold', 'Bold', 'ExtraBold']) {
    final bytes = File('assets/fonts/nunito/Nunito-$weight.ttf')
        .readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();

  final icons = File(
    '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/'
    'material_fonts/materialicons-regular.otf',
  );
  await (FontLoader('MaterialIcons')
        ..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync()))))
      .load();
}
