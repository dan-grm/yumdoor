import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/features/editor/editor_field.dart';
import 'package:yumdoor/features/editor/editor_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';
import 'package:yumdoor/features/search/search_providers.dart';
import 'package:yumdoor/platform/image_picker/image_picker_service.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_image_picker_service.dart';
import '../../fakes/fake_offline_cache.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fixtures/images.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeKeywordRepository keywords;
  late FakeConnectivityService connectivity;
  late FakeImagePickerService picker;

  setUpAll(loadBundledFonts);

  setUp(() {
    recipes = FakeRecipeRepository([ofenkarotten]);
    keywords = FakeKeywordRepository(const [
      Keyword(id: 1, name: 'Vegetarisch'),
      Keyword(id: 2, name: 'Ofen'),
      Keyword(id: 3, name: 'Schnell'),
    ]);
    connectivity = FakeConnectivityService();
    picker = FakeImagePickerService();
  });

  /// [location] pushed over [below], like the app does.
  Future<GoRouter> pumpEditor(
    WidgetTester tester, {
    String below = '/recipe/7',
    String location = '/recipe/7/edit',
    ThemeData? theme,
  }) async {
    final router = await pumpRoutes(
      tester,
      location: below,
      theme: theme,
      overrides: [
        recipeRepositoryProvider.overrideWithValue(recipes),
        keywordRepositoryProvider.overrideWithValue(keywords),
        connectivityServiceProvider.overrideWithValue(connectivity),
        imagePickerServiceProvider.overrideWithValue(picker),
        offlineCacheProvider.overrideWithValue(FakeOfflineCache()),
      ],
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => const Text('search'),
        ),
        GoRoute(
          path: newRecipeLocation,
          builder: (context, state) => const EditorScreen(),
        ),
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) =>
              RecipeScreen(recipeId: int.parse(state.pathParameters['id']!)),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => EditorScreen(
                recipeId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
      ],
    );
    router.push<void>(location).ignore();
    await tester.pumpAndSettle();
    return router;
  }

  Finder field(String label) => find.descendant(
    of: find.widgetWithText(EditorField, label),
    matching: find.byType(TextField),
  );

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Types [text] into the open keyword picker and waits for its search.
  Future<void> typeInPicker(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField).last, text);
    await tester.pump(searchDebounce);
    await tester.pumpAndSettle();
  }

  TextButton saveButton(WidgetTester tester) => tester.widget<TextButton>(
    find.ancestor(
      of: find.text('Speichern'),
      matching: find.byType(TextButton),
    ),
  );

  testWidgets('shows the recipe in the Allgemein tab', (tester) async {
    await pumpEditor(tester);

    expect(find.text('Abbrechen'), findsOneWidget);
    expect(find.text('Bearbeiten'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsNWidgets(2));
    expect(find.text('Allgemein'), findsOneWidget);
    expect(find.text('Zutaten'), findsOneWidget);
    expect(find.text('Schritte'), findsOneWidget);
    expect(find.text('Süß, salzig und *knusprig*.'), findsOneWidget);
    expect(find.text('Vegetarisch'), findsOneWidget);
    expect(find.text('Ofen'), findsOneWidget);
    expect(tester.widget<TextField>(field('Portionen')).controller!.text, '2');
    expect(
      tester.widget<TextField>(field('Arbeitszeit (Min.)')).controller!.text,
      '15',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('edits name and keywords, saves and shows the saved recipe', (
    tester,
  ) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofenkarotten mit Ziegenkäse');
    // Remove "Ofen", add an existing keyword and a new one.
    await tap(tester, find.byTooltip('Ofen entfernen'));
    await tap(tester, find.byTooltip('Stichwort hinzufügen'));
    // Keywords the recipe has aren't offered again.
    Finder inSheet(String text) => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(text),
    );
    expect(inSheet('Schnell'), findsOneWidget);
    expect(inSheet('Vegetarisch'), findsNothing);
    await typeInPicker(tester, 'Schn');
    // Only offered for a name that doesn't exist yet.
    expect(find.text('„Schn“ anlegen'), findsOneWidget);
    await typeInPicker(tester, 'schnell');
    expect(find.text('„schnell“ anlegen'), findsNothing);
    await tap(tester, find.text('Schnell'));
    await tap(tester, find.byTooltip('Stichwort hinzufügen'));
    await typeInPicker(tester, 'Ofengericht');
    await tap(tester, find.text('„Ofengericht“ anlegen'));
    expect(keywords.created, ['Ofengericht']);

    await tap(tester, find.text('Speichern'));

    final save = recipes.saves.single;
    expect(save.id, 7);
    expect(save.draft.name, 'Ofenkarotten mit Ziegenkäse');
    expect(save.draft.keywords, const [
      NamedRef(id: 1, name: 'Vegetarisch'),
      NamedRef(id: 3, name: 'Schnell'),
      NamedRef(id: 4, name: 'Ofengericht'),
    ]);
    // Steps stay as they were.
    expect(save.draft.steps, RecipeDraft.fromRecipe(ofenkarotten).steps);

    expect(find.byType(EditorScreen), findsNothing);
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Rezept gespeichert'), findsOneWidget);
    expect(find.text('Ofenkarotten mit Ziegenkäse'), findsOneWidget);
    expect(find.text('Ofengericht'), findsOneWidget);
  });

  testWidgets('creates a new recipe from search', (tester) async {
    final router = await pumpEditor(
      tester,
      below: '/search',
      location: newRecipeLocation,
    );

    expect(find.text('Neues Rezept'), findsOneWidget);
    await tester.enterText(field('Name'), 'Linsensuppe');
    await tester.enterText(field('Portionen'), '4');
    await tester.enterText(field('Wartezeit (Min.)'), '30');
    await tap(tester, find.text('Speichern'));

    final save = recipes.saves.single;
    expect(save.id, isNull);
    expect(save.draft.name, 'Linsensuppe');
    expect(save.draft.servings, 4);
    expect(save.draft.waitingTime, const Duration(minutes: 30));
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Linsensuppe'), findsOneWidget);
    // The recipe took the editor's place: back leads to search.
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('search'), findsOneWidget);
  });

  testWidgets('the name is required', (tester) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), '  ');
    await tester.enterText(field('Portionen'), '');
    await tap(tester, find.text('Speichern'));

    expect(recipes.saves, isEmpty);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(find.text('Gib dem Rezept einen Namen.'), findsOneWidget);
    expect(find.text('Mindestens 1.'), findsOneWidget);
    expect(find.text('Bitte prüf die markierten Felder.'), findsOneWidget);

    // Fixing it clears the error at once.
    await tester.enterText(field('Name'), 'Karotten');
    await tester.pump();
    expect(find.text('Gib dem Rezept einen Namen.'), findsNothing);
  });

  testWidgets('a failed save keeps the edits and can be retried', (
    tester,
  ) async {
    await pumpEditor(tester);
    recipes.failure = const ServerFailure(statusCode: 500);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Speichern'));

    expect(
      find.text('Nicht gespeichert. Der Server hat einen Fehler gemeldet.'),
      findsOneWidget,
    );
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(find.text('Ofengemüse'), findsOneWidget);

    recipes.failure = null;
    await tap(tester, find.text('Nochmal versuchen'));

    expect(recipes.saves, hasLength(2));
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Ofengemüse'), findsOneWidget);
  });

  testWidgets('no permission (403) says so and keeps the edits', (
    tester,
  ) async {
    await pumpEditor(tester);
    recipes.failure = const UnauthorizedFailure();

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Speichern'));

    expect(
      find.text(
        'Nicht gespeichert: Du darfst dieses Rezept nicht ändern. '
        'Deine Änderungen sind noch da.',
      ),
      findsOneWidget,
    );
    // Asking again won't help.
    expect(find.text('Nochmal versuchen'), findsNothing);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Ofengemüse',
    );
  });

  testWidgets('offline, the editor does not open a cached copy', (
    tester,
  ) async {
    connectivity.isOnline = false;
    // The recipe screen below shows the stored copy; the editor gets none.
    recipes.offline = true;
    await pumpEditor(tester);

    expect(
      find.text(
        'Der Server ist gerade nicht erreichbar. Prüf deine Verbindung.',
      ),
      findsOneWidget,
    );
    expect(find.byType(EditorField), findsNothing);
    expect(saveButton(tester).onPressed, isNull);
  });

  testWidgets('going offline disables saving and explains it', (tester) async {
    await pumpEditor(tester);
    connectivity.isOnline = false;
    await tester.pumpAndSettle();

    expect(saveButton(tester).onPressed, isNull);
    expect(
      find.byTooltip(
        'Offline kannst du nichts ändern. Sobald du wieder verbunden bist, '
        'geht es weiter.',
      ),
      // "Speichern" and the photo buttons.
      findsNWidgets(2),
    );
    await tester.enterText(field('Name'), 'Ofengemüse');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();
    expect(recipes.saves, isEmpty);
  });

  testWidgets('Abbrechen returns without saving', (tester) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Abbrechen'));

    expect(recipes.saves, isEmpty);
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
  });

  testWidgets('the other tabs keep the draft', (tester) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Schritte'));
    expect(find.byType(EditorField), findsNothing);
    await tap(tester, find.text('Allgemein'));

    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Ofengemüse',
    );
  });

  testWidgets('a missing recipe explains itself', (tester) async {
    await pumpEditor(tester, location: '/recipe/99/edit');

    expect(find.text('Dieses Rezept gibt es nicht mehr.'), findsOneWidget);
    expect(saveButton(tester).onPressed, isNull);
  });

  group('image', () {
    final photo = testPng();
    final saved = Uri.parse('https://example.com/media/recipes/a_7.jpg');

    TextButton button(WidgetTester tester, String label) =>
        tester.widget<TextButton>(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(TextButton),
          ),
        );

    final preview = find.byWidgetPredicate(
      (w) => w is Image && w.image is MemoryImage,
    );

    testWidgets('picks an image, previews it and uploads it on save', (
      tester,
    ) async {
      await pumpEditor(tester);
      expect(find.text('Foto'), findsOneWidget);
      expect(find.text('Bild hierher ziehen'), findsOneWidget);
      // No camera on this device.
      expect(find.text('Foto aufnehmen'), findsNothing);
      expect(find.text('Entfernen'), findsNothing);

      picker.nextPick = checkImage(name: 'karotten.PNG', bytes: photo);
      await tap(tester, find.text('Bild auswählen'));

      expect(picker.picks, ['file']);
      expect(preview, findsOneWidget);
      expect(find.text('Wird beim Speichern hochgeladen.'), findsOneWidget);
      expect(find.text('Entfernen'), findsOneWidget);
      // Nothing is sent before saving.
      expect(recipes.imageChanges, isEmpty);

      await tap(tester, find.text('Speichern'));

      final upload = recipes.imageChanges.single;
      expect(upload.id, 7);
      expect(upload.image!.bytes, photo);
      expect(upload.image!.fileName, 'karotten.png');
      expect(upload.image!.mimeType, 'image/png');
      expect(recipes.saves.single.id, 7);
      expect(find.byType(RecipeScreen), findsOneWidget);
      expect(find.text('Rezept gespeichert'), findsOneWidget);
    });

    testWidgets('a cancelled pick changes nothing', (tester) async {
      await pumpEditor(tester);

      await tap(tester, find.text('Bild auswählen'));

      expect(picker.picks, ['file']);
      expect(preview, findsNothing);
      expect(find.text('Bild hierher ziehen'), findsOneWidget);
    });

    testWidgets('takes a photo where there is a camera', (tester) async {
      picker
        ..canUseCamera = true
        ..supportsDrop = false
        ..nextPick = checkImage(name: 'image.jpg', bytes: photo);
      await pumpEditor(tester);
      expect(find.text('Noch kein Foto'), findsOneWidget);
      expect(picker.isDropTarget, isFalse);

      await tap(tester, find.text('Foto aufnehmen'));

      expect(picker.picks, ['camera']);
      expect(preview, findsOneWidget);
    });

    testWidgets('explains a file that cannot be used', (tester) async {
      await pumpEditor(tester);

      picker.nextPick = checkImage(
        name: 'notiz.txt',
        bytes: Uint8List.fromList('Notiz'.codeUnits),
      );
      await tap(tester, find.text('Bild auswählen'));
      expect(
        find.text('Das ist kein Bild. Es gehen JPEG, PNG, WebP und GIF.'),
        findsOneWidget,
      );
      expect(preview, findsNothing);

      picker.nextPick = const RejectedImage(
        name: 'riesig.jpg',
        reason: ImageRejection.tooLarge,
      );
      await tap(tester, find.text('Bild auswählen'));
      expect(find.text('Das Bild ist größer als 20 MB.'), findsOneWidget);

      // A usable image clears the message.
      picker.nextPick = checkImage(name: 'karotten.png', bytes: photo);
      await tap(tester, find.text('Bild auswählen'));
      expect(find.text('Das Bild ist größer als 20 MB.'), findsNothing);
      expect(preview, findsOneWidget);
    });

    testWidgets('removes the saved image on save', (tester) async {
      recipes.recipes[7] = ofenkarotten.copyWith(image: saved);
      await pumpEditor(tester);
      expect(find.text('Bild hierher ziehen'), findsNothing);

      await tap(tester, find.text('Entfernen'));

      expect(find.text('Entfernen'), findsNothing);
      expect(
        find.text('Das Foto wird beim Speichern entfernt.'),
        findsOneWidget,
      );
      await tap(tester, find.text('Speichern'));
      expect(recipes.imageChanges.single, (id: 7, image: null));
      expect(recipes.recipes[7]!.image, isNull);
    });

    testWidgets('a dropped image lands in the Allgemein tab', (tester) async {
      final router = await pumpEditor(tester);
      expect(picker.isDropTarget, isTrue);

      picker.hover(isOver: true);
      await tester.pump();
      expect(find.text('Loslassen, um das Bild zu verwenden'), findsOneWidget);
      picker.hover(isOver: false);
      await tester.pump();
      expect(find.text('Bild hierher ziehen'), findsOneWidget);

      // On another tab too, so the browser doesn't open the file instead.
      await tap(tester, find.text('Schritte'));
      picker.drop('karotten.png', photo);
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(preview, findsOneWidget);
      expect(find.text('Wird beim Speichern hochgeladen.'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      expect(picker.isDropTarget, isFalse);
    });

    testWidgets('a failed upload keeps the saved recipe and says so', (
      tester,
    ) async {
      await pumpEditor(tester);
      recipes.imageFailure = const ServerFailure(statusCode: 500);

      await tester.enterText(field('Name'), 'Ofengemüse');
      picker.nextPick = checkImage(name: 'karotten.png', bytes: photo);
      await tap(tester, find.text('Bild auswählen'));
      await tap(tester, find.text('Speichern'));

      expect(recipes.saves.single.draft.name, 'Ofengemüse');
      expect(recipes.imageChanges, hasLength(1));
      expect(find.byType(RecipeScreen), findsOneWidget);
      expect(find.text('Ofengemüse'), findsOneWidget);
      expect(
        find.text(
          'Rezept gespeichert, das Foto aber nicht. '
          'Der Server hat einen Fehler gemeldet.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a size the server refuses is explained', (tester) async {
      await pumpEditor(tester);
      recipes.imageFailure = const ServerFailure(statusCode: 413);

      picker.nextPick = checkImage(name: 'karotten.png', bytes: photo);
      await tap(tester, find.text('Bild auswählen'));
      await tap(tester, find.text('Speichern'));

      expect(
        find.text(
          'Rezept gespeichert, das Foto aber nicht. '
          'Der Server nimmt so große Bilder nicht an.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a new recipe gets its photo right after it is created', (
      tester,
    ) async {
      await pumpEditor(tester, below: '/search', location: newRecipeLocation);

      await tester.enterText(field('Name'), 'Linsensuppe');
      picker.nextPick = checkImage(name: 'suppe.png', bytes: photo);
      await tap(tester, find.text('Bild auswählen'));
      await tap(tester, find.text('Speichern'));

      final id = recipes.recipes.values.last.id;
      expect(recipes.saves.single.id, isNull);
      expect(recipes.imageChanges.single.id, id);
      expect(recipes.recipes[id]!.image, isNotNull);
      expect(find.byType(RecipeScreen), findsOneWidget);
      expect(find.text('Rezept gespeichert'), findsOneWidget);
    });

    testWidgets('offline, the photo cannot be changed', (tester) async {
      recipes.recipes[7] = ofenkarotten.copyWith(image: saved);
      await pumpEditor(tester);
      connectivity.isOnline = false;
      await tester.pumpAndSettle();

      expect(button(tester, 'Bild auswählen').onPressed, isNull);
      expect(button(tester, 'Entfernen').onPressed, isNull);
      picker.hover(isOver: true);
      await tester.pump();
      expect(find.text('Loslassen, um das Bild zu verwenden'), findsNothing);
      picker.drop('karotten.png', photo);
      await tester.pumpAndSettle();
      expect(preview, findsNothing);

      await tester.tap(find.text('Bild auswählen'));
      await tester.pumpAndSettle();
      expect(picker.picks, isEmpty);
    });
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('Allgemein in $name', tags: goldenTags, (tester) async {
        await pumpEditor(tester, theme: theme);

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_general_$name.png'),
        );
      });

      testWidgets('a chosen image in $name', tags: goldenTags, (tester) async {
        final photo = testPng(width: 320, height: 180);
        picker
          ..canUseCamera = true
          ..nextPick = checkImage(name: 'karotten.jpg', bytes: photo);
        await pumpEditor(tester, theme: theme);
        // Visible already; `tap` would scroll.
        await tester.tap(find.text('Bild auswählen'));
        // Images decode outside the test's fake time.
        await tester.runAsync(
          () => precacheImage(
            MemoryImage(photo),
            tester.element(find.byType(EditorScreen)),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_image_$name.png'),
        );
      });

      testWidgets('an image dragged over in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpEditor(tester, theme: theme);
        picker.hover(isOver: true);
        await tester.pump();

        await expectLater(
          find.byType(EditorScreen),
          matchesGoldenFile('../goldens/editor_image_drop_$name.png'),
        );
      });
    }
  });
}
