import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the bundled Nunito so goldens show the real font, not Ahem.
Future<void> loadBundledFonts() async {
  final loader = FontLoader('Nunito');
  for (final weight in ['Regular', 'SemiBold', 'Bold', 'ExtraBold']) {
    final bytes = File('assets/fonts/nunito/Nunito-$weight.ttf')
        .readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}
