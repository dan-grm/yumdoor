import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/design/token_gallery.dart';

import 'fonts.dart';
import 'golden.dart';

void main() {
  setUpAll(loadBundledFonts);

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('token gallery in $name', tags: goldenTags, (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(390, 4000);
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const Align(
              alignment: Alignment.topCenter,
              child: TokenGallery(),
            ),
          ),
        );
        // Crop the view to the gallery.
        tester.view.physicalSize = Size(
          390,
          tester.getSize(find.byType(TokenGallery)).height,
        );
        await tester.pump();

        await expectLater(
          find.byType(TokenGallery),
          matchesGoldenFile('goldens/token_gallery_$name.png'),
        );
      });
    }
  });

  testWidgets('the switch toggles the gallery between both themes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: lightTheme, home: const TokenGalleryScreen()),
    );
    BuildContext gallery() => tester.element(find.byType(TokenGallery));
    expect(gallery().tokens, YumdoorTokens.light);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(gallery().tokens, YumdoorTokens.dark);
  });
}
