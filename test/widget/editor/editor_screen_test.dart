import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/app/repository_providers.dart';
import 'package:yumdoor/app/session.dart';
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/domain/models/image_upload.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';
import 'package:yumdoor/domain/models/stored_draft.dart';
import 'package:yumdoor/features/editor/editor_controller.dart';
import 'package:yumdoor/features/editor/editor_field.dart';
import 'package:yumdoor/features/editor/editor_screen.dart';
import 'package:yumdoor/features/recipe/recipe_screen.dart';
import 'package:yumdoor/features/search/search_providers.dart';
import 'package:yumdoor/platform/image_picker/image_picker_service.dart';

import '../../fakes/fake_connectivity_service.dart';
import '../../fakes/fake_draft_store.dart';
import '../../fakes/fake_food_keyword_repositories.dart';
import '../../fakes/fake_image_picker_service.dart';
import '../../fakes/fake_offline_cache.dart';
import '../../fakes/fake_recipe_repository.dart';
import '../../fakes/fake_unload_guard.dart';
import '../../fakes/in_memory_token_store.dart';
import '../../fixtures/images.dart';
import '../../fixtures/recipes.dart';
import '../fonts.dart';
import '../golden.dart';
import '../harness.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeKeywordRepository keywords;
  late FakeConnectivityService connectivity;
  late FakeDraftStore drafts;
  late FakeUnloadGuard unloadGuard;
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
    drafts = FakeDraftStore();
    unloadGuard = FakeUnloadGuard();
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
        draftStoreProvider.overrideWithValue(drafts),
        unloadGuardProvider.overrideWithValue(unloadGuard),
        imagePickerServiceProvider.overrideWithValue(picker),
        offlineCacheProvider.overrideWithValue(FakeOfflineCache()),
        // Nobody logged in, unless a test logs in.
        tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      ],
      routes: [
        GoRoute(path: '/', redirect: (context, state) => '/search'),
        GoRoute(
          path: '/search',
          builder: (context, state) => const Scaffold(body: Text('search')),
        ),
        GoRoute(
          path: newRecipeLocation,
          builder: (context, state) => const EditorScreen(),
          onExit: confirmEditorExit,
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
              onExit: confirmEditorExit,
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
      // "Speichern", the photo buttons and "Rezept löschen".
      findsNWidgets(3),
    );
    await tester.enterText(field('Name'), 'Ofengemüse');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();
    expect(recipes.saves, isEmpty);
  });

  testWidgets('offline, editing goes on; the draft waits to be saved', (
    tester,
  ) async {
    await pumpEditor(tester);
    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Schritte'));

    // The offline banner appearing doesn't rebuild the screen.
    connectivity.isOnline = false;
    await tester.pumpAndSettle();
    expect(find.byType(EditorField), findsNothing);
    await tap(tester, find.text('Allgemein'));
    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Ofengemüse',
    );
    await tester.enterText(field('Beschreibung'), 'Offline geschrieben');
    await tester.pump(RecipeEditor.draftDelay);
    expect(drafts.drafts[7]!.draft.description, 'Offline geschrieben');
    expect(saveButton(tester).onPressed, isNull);

    connectivity.isOnline = true;
    await tester.pumpAndSettle();
    await tap(tester, find.text('Speichern'));
    expect(recipes.saves.single.draft.name, 'Ofengemüse');
    expect(drafts.drafts, isEmpty);
  });

  group('deleting', () {
    Future<void> openDialog(WidgetTester tester) async {
      await tap(tester, find.text('Rezept löschen'));
      expect(find.text('Rezept löschen?'), findsOneWidget);
    }

    testWidgets('only an existing recipe has the button', (tester) async {
      await pumpEditor(tester, location: newRecipeLocation);

      expect(find.text('Rezept löschen'), findsNothing);
    });

    testWidgets('the dialog names the recipe and what goes with it', (
      tester,
    ) async {
      await pumpEditor(tester);

      await openDialog(tester);

      expect(find.textContaining('„Ofenkarotten mit Feta“'), findsOneWidget);
      expect(
        find.textContaining(
          'Kochprotokoll, im Essensplan, in Büchern und in Einkaufslisten',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Behalten closes the dialog and deletes nothing', (
      tester,
    ) async {
      await pumpEditor(tester);

      await openDialog(tester);
      await tap(tester, find.text('Behalten'));

      expect(find.text('Rezept löschen?'), findsNothing);
      expect(find.byType(EditorScreen), findsOneWidget);
      expect(recipes.deletions, isEmpty);
    });

    testWidgets('confirming deletes, returns to search and says so', (
      tester,
    ) async {
      await pumpEditor(tester);
      // Unsaved changes and a stored draft go with the recipe.
      await tester.enterText(field('Name'), 'Ofengemüse');
      await tester.pump(const Duration(seconds: 5));

      await openDialog(tester);
      await tap(tester, find.text('Endgültig löschen'));

      expect(recipes.deletions, [7]);
      expect(find.text('Änderungen verwerfen?'), findsNothing);
      expect(find.byType(EditorScreen), findsNothing);
      expect(find.byType(RecipeScreen), findsNothing);
      expect(find.text('search'), findsOneWidget);
      expect(find.text('Rezept gelöscht'), findsOneWidget);
      expect(drafts.drafts, isEmpty);
    });

    testWidgets('no permission (403) says so and stays in the editor', (
      tester,
    ) async {
      await pumpEditor(tester);
      recipes.failure = const UnauthorizedFailure();

      await openDialog(tester);
      await tap(tester, find.text('Endgültig löschen'));

      expect(
        find.text('Nicht gelöscht: Du darfst dieses Rezept nicht löschen.'),
        findsOneWidget,
      );
      expect(find.byType(EditorScreen), findsOneWidget);
      // Can be tried again.
      expect(find.text('Rezept löschen'), findsOneWidget);
    });

    testWidgets('a server error hints at a recipe used as a step', (
      tester,
    ) async {
      await pumpEditor(tester);
      recipes.failure = const ServerFailure(statusCode: 500);

      await openDialog(tester);
      await tap(tester, find.text('Endgültig löschen'));

      expect(
        find.textContaining('in einem anderen Rezept als Schritt'),
        findsOneWidget,
      );
      expect(find.byType(EditorScreen), findsOneWidget);
    });

    testWidgets('offline, the button is disabled and says why', (tester) async {
      await pumpEditor(tester);
      connectivity.isOnline = false;
      await tester.pumpAndSettle();
      final button = find.ancestor(
        of: find.text('Rezept löschen'),
        matching: find.bySubtype<ButtonStyleButton>(),
      );
      await tester.ensureVisible(button);

      expect(tester.widget<ButtonStyleButton>(button).onPressed, isNull);
      await tester.tap(find.text('Rezept löschen'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Rezept löschen?'), findsNothing);
      expect(recipes.deletions, isEmpty);
    });
  });

  testWidgets('Abbrechen without changes returns right away', (tester) async {
    await pumpEditor(tester);

    await tap(tester, find.text('Abbrechen'));

    expect(find.text('Änderungen verwerfen?'), findsNothing);
    expect(find.byType(RecipeScreen), findsOneWidget);
  });

  testWidgets('Abbrechen with changes asks, then returns without saving', (
    tester,
  ) async {
    await pumpEditor(tester);

    await tester.enterText(field('Name'), 'Ofengemüse');
    await tap(tester, find.text('Abbrechen'));
    expect(find.text('Änderungen verwerfen?'), findsOneWidget);

    // Staying keeps the changes.
    await tap(tester, find.text('Weiter bearbeiten'));
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Ofengemüse',
    );

    await tap(tester, find.text('Abbrechen'));
    await tap(tester, find.text('Verwerfen'));

    expect(recipes.saves, isEmpty);
    expect(find.byType(EditorScreen), findsNothing);
    expect(find.byType(RecipeScreen), findsOneWidget);
    expect(find.text('Ofenkarotten mit Feta'), findsOneWidget);
    // Nothing is offered next time.
    expect(drafts.drafts, isEmpty);
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
      (w) => w is Image && w.image is ResizeImage,
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
      // The new photo is a change too.
      await tap(tester, find.text('Verwerfen'));
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

    testWidgets('an upload cut off after the save hints at the size', (
      tester,
    ) async {
      await pumpEditor(tester);
      recipes.imageFailure = const UploadInterruptedFailure();

      picker.nextPick = checkImage(name: 'karotten.png', bytes: photo);
      await tap(tester, find.text('Bild auswählen'));
      await tap(tester, find.text('Speichern'));

      expect(
        find.text(
          'Rezept gespeichert, das Foto aber nicht. Die Verbindung brach beim '
          'Hochladen ab. Vielleicht ist das Bild zu groß für den Server.',
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

    testWidgets('offline, the empty area does not invite dropping', (
      tester,
    ) async {
      await pumpEditor(tester);
      connectivity.isOnline = false;
      await tester.pumpAndSettle();

      expect(find.text('Bild hierher ziehen'), findsNothing);
      expect(find.text('Noch kein Foto'), findsOneWidget);
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

  group('unsaved changes', () {
    const discardTitle = 'Änderungen verwerfen?';
    const draftTitle = 'Ungespeicherter Entwurf';
    final photo = testPng();
    final preview = find.byWidgetPredicate(
      (w) => w is Image && w.image is ResizeImage,
    );
    final savedAt = DateTime(2026, 11, 16, 18, 30);
    const staleText =
        'Das Rezept wurde danach auf dem Server geändert. Speicherst du den '
        'Entwurf, überschreibt er diese Änderungen.';

    String nameText(WidgetTester tester) =>
        tester.widget<TextField>(field('Name')).controller!.text;

    testWidgets('back with changes asks; Verwerfen leaves', (tester) async {
      await pumpEditor(tester);
      await tester.enterText(field('Name'), 'Ofengemüse');
      await tester.pump();
      expect(unloadGuard.active, isTrue);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text(discardTitle), findsOneWidget);
      await tap(tester, find.text('Verwerfen'));

      expect(find.byType(EditorScreen), findsNothing);
      expect(find.byType(RecipeScreen), findsOneWidget);
      expect(unloadGuard.active, isFalse);
      expect(drafts.drafts, isEmpty);
    });

    testWidgets('back without changes leaves right away', (tester) async {
      await pumpEditor(tester);
      expect(unloadGuard.active, isFalse);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text(discardTitle), findsNothing);
      expect(find.byType(RecipeScreen), findsOneWidget);
    });

    testWidgets('another route asks too, and can be refused', (tester) async {
      final router = await pumpEditor(tester);
      await tester.enterText(field('Name'), 'Ofengemüse');

      router.go('/search');
      await tester.pumpAndSettle();
      expect(find.text(discardTitle), findsOneWidget);
      await tap(tester, find.text('Weiter bearbeiten'));

      expect(find.byType(EditorScreen), findsOneWidget);
      expect(nameText(tester), 'Ofengemüse');
    });

    testWidgets('a line typed but not added asks too', (tester) async {
      await pumpEditor(tester);
      await tap(tester, find.text('Zutaten'));
      await tester.enterText(
        find.widgetWithText(TextField, 'z. B. 200 g Karotten, geschält'),
        '200 g Mehl',
      );

      await tap(tester, find.text('Abbrechen'));

      expect(find.text(discardTitle), findsOneWidget);
    });

    testWidgets('after logout, leaves without asking and keeps no draft', (
      tester,
    ) async {
      final router = await pumpEditor(tester);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(EditorScreen)),
      );
      await tester.runAsync(
        () => container.read(sessionControllerProvider.future),
      );
      await tester.enterText(field('Name'), 'Ofengemüse');

      router.go('/search');
      await tester.pumpAndSettle();

      expect(find.text(discardTitle), findsNothing);
      expect(find.text('search'), findsOneWidget);
      expect(drafts.drafts, isEmpty);
    });

    testWidgets('a photo dropped while a draft is offered is ignored', (
      tester,
    ) async {
      drafts.drafts[7] = StoredDraft(
        draft: RecipeDraft.fromRecipe(ofenkarotten)
            .copyWith(name: 'Ofengemüse'),
        savedAt: savedAt,
      );
      await pumpEditor(tester);

      picker.drop('karotten.png', photo);
      await tester.pumpAndSettle();
      await tap(tester, find.text('Verwerfen'));

      expect(find.text('Wird beim Speichern hochgeladen.'), findsNothing);
      expect(unloadGuard.active, isFalse);
    });

    testWidgets('changing a value back to the saved one is no change', (
      tester,
    ) async {
      await pumpEditor(tester);
      await tester.enterText(field('Name'), 'Ofengemüse');
      await tester.enterText(field('Name'), 'Ofenkarotten mit Feta');
      await tester.pump(RecipeEditor.draftDelay);

      expect(unloadGuard.active, isFalse);
      expect(drafts.drafts, isEmpty);
      await tap(tester, find.text('Abbrechen'));
      expect(find.text(discardTitle), findsNothing);
      expect(find.byType(RecipeScreen), findsOneWidget);
    });

    testWidgets('keeps a draft of every tab and the photo', (tester) async {
      picker.nextPick = checkImage(name: 'karotten.png', bytes: photo);
      await pumpEditor(tester);

      await tester.enterText(field('Name'), 'Ofengemüse');
      await tap(tester, find.text('Bild auswählen'));
      await tap(tester, find.text('Schritte'));
      await tap(tester, find.text('Schritt hinzufügen'));
      await tester.pump(RecipeEditor.draftDelay);

      final stored = drafts.drafts[7]!;
      expect(stored.draft.name, 'Ofengemüse');
      expect(stored.draft.steps, hasLength(ofenkarotten.steps.length + 1));
      expect(stored.newImage!.fileName, 'karotten.png');
      expect(stored.newImage!.bytes, photo);
    });

    testWidgets('offers a stored draft and restores it', (tester) async {
      drafts.drafts[7] = StoredDraft(
        draft: RecipeDraft.fromRecipe(ofenkarotten)
            .copyWith(name: 'Ofengemüse'),
        newImage: ImageUpload(
          bytes: photo,
          fileName: 'karotten.png',
          mimeType: 'image/png',
        ),
        savedAt: savedAt,
      );
      await pumpEditor(tester);

      expect(find.text(draftTitle), findsOneWidget);
      expect(
        find.text(
          'Du hast hier am 16. Nov. 2026 um 18:30 Änderungen gemacht, die '
          'nicht gespeichert sind.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('auf dem Server geändert'), findsNothing);
      await tap(tester, find.text('Entwurf wiederherstellen'));

      expect(nameText(tester), 'Ofengemüse');
      expect(preview, findsOneWidget);
      expect(unloadGuard.active, isTrue);
      // Still there until it is saved.
      expect(drafts.drafts, contains(7));

      await tap(tester, find.text('Speichern'));
      expect(recipes.saves.single.draft.name, 'Ofengemüse');
      expect(recipes.imageChanges.single.id, 7);
      expect(drafts.drafts, isEmpty);
      expect(unloadGuard.active, isFalse);
    });

    testWidgets('a discarded draft is deleted', (tester) async {
      drafts.drafts[7] = StoredDraft(
        draft: RecipeDraft.fromRecipe(ofenkarotten)
            .copyWith(name: 'Ofengemüse'),
        savedAt: savedAt,
      );
      await pumpEditor(tester);

      await tap(tester, find.text('Verwerfen'));

      expect(nameText(tester), 'Ofenkarotten mit Feta');
      expect(drafts.drafts, isEmpty);
      await tap(tester, find.text('Abbrechen'));
      expect(find.byType(RecipeScreen), findsOneWidget);
    });

    testWidgets('says when the recipe changed after the draft', (tester) async {
      recipes = FakeRecipeRepository([
        ofenkarotten.copyWith(updatedAt: savedAt.add(const Duration(hours: 1))),
      ]);
      drafts.drafts[7] = StoredDraft(
        draft: RecipeDraft.fromRecipe(ofenkarotten)
            .copyWith(name: 'Ofengemüse'),
        savedAt: savedAt,
      );
      await pumpEditor(tester);

      expect(find.textContaining(staleText), findsOneWidget);
    });

    testWidgets('a draft without changes is not offered', (tester) async {
      drafts.drafts[7] = StoredDraft(
        draft: RecipeDraft.fromRecipe(ofenkarotten),
        savedAt: savedAt,
      );
      await pumpEditor(tester);

      expect(find.text(draftTitle), findsNothing);
      expect(drafts.drafts, isEmpty);
    });

    testWidgets('a new recipe has its own draft', (tester) async {
      drafts.drafts[7] = StoredDraft(
        draft: const RecipeDraft(name: 'Anderes Rezept'),
        savedAt: savedAt,
      );
      await pumpEditor(tester, below: '/search', location: newRecipeLocation);
      expect(find.text(draftTitle), findsNothing);

      await tester.enterText(field('Name'), 'Linsensuppe');
      await tester.pump(RecipeEditor.draftDelay);
      expect(drafts.drafts[null]!.draft.name, 'Linsensuppe');

      await tap(tester, find.text('Speichern'));
      expect(drafts.drafts.keys, [7]);
    });

    testWidgets('a draft is kept when the editor closes right away', (
      tester,
    ) async {
      await pumpEditor(tester, below: '/search', location: newRecipeLocation);
      await tester.enterText(field('Name'), 'Linsensuppe');

      // Like the app being closed: no time for the delay, no question.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      expect(drafts.drafts[null]!.draft.name, 'Linsensuppe');
    });
  });

  group('goldens', skip: goldenSkip, () {
    for (final (name, theme) in [('light', lightTheme), ('dark', darkTheme)]) {
      testWidgets('draft offered in $name', tags: goldenTags, (tester) async {
        recipes = FakeRecipeRepository([
          ofenkarotten.copyWith(updatedAt: DateTime(2026, 11, 17, 9)),
        ]);
        drafts.drafts[7] = StoredDraft(
          draft: RecipeDraft.fromRecipe(ofenkarotten)
              .copyWith(name: 'Ofengemüse'),
          savedAt: DateTime(2026, 11, 16, 18, 30),
        );
        await pumpEditor(tester, theme: theme);

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/editor_draft_$name.png'),
        );
      });

      testWidgets('leaving with changes in $name', tags: goldenTags, (
        tester,
      ) async {
        await pumpEditor(tester, theme: theme);
        await tester.enterText(field('Name'), 'Ofengemüse');
        await tap(tester, find.text('Abbrechen'));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/editor_discard_$name.png'),
        );
      });
      testWidgets('deleting in $name', tags: goldenTags, (tester) async {
        await pumpEditor(tester, theme: theme);
        await tap(tester, find.text('Rezept löschen'));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../goldens/editor_delete_$name.png'),
        );
      });

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
        await tester.pump();
        // Images decode outside the test's fake time.
        await tester.runAsync(
          () => precacheImage(
            tester
                .widget<Image>(
                  find.byWidgetPredicate(
                    (w) => w is Image && w.image is ResizeImage,
                  ),
                )
                .image,
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
