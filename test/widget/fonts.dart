import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled Nunito so goldens show the real font, not Ahem, and the
/// Material icon font from the Flutter SDK so icons aren't boxes.
Future<void> loadBundledFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = FontLoader('Nunito');
  for (final weight in ['Regular', 'SemiBold', 'Bold', 'ExtraBold']) {
    final bytes = File('assets/fonts/nunito/Nunito-$weight.ttf')
        .readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();

  // `flutter test` bundles it because pubspec.yaml sets uses-material-design.
  await (FontLoader(
    'MaterialIcons',
  )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
}
