@Tags(['integration'])
library;

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;
import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/data/api/tandoor_dio.dart';
import 'package:yumdoor/data/repositories/tandoor_recipe_repository.dart';
import 'package:yumdoor/domain/models/image_upload.dart';
import 'package:yumdoor/domain/models/recipe_draft.dart';

import '../fixtures/images.dart';
import 'seeded_tandoor.dart';

/// Uploading and removing recipe photos (docs/TANDOOR_API.md#recipe-images),
/// on a private recipe the test creates as the admin and deletes again, so
/// the other integration tests never see it.
void main() {
  final tandoor = SeededTandoor.load();
  final tag = 'Yumdoor-Test ${DateTime.now().microsecondsSinceEpoch}';
  late Dio dio;
  late TandoorRecipeRepository recipes;
  late int recipe;

  setUpAll(() async {
    dio = createTandoorDio(tandoor.baseUrl, token: tandoor.token('admin'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'POST' && options.path == '/api/recipe/') {
              (options.data as Map)['private'] = true;
            }
            handler.next(options);
          },
        ),
      );
    recipes = TandoorRecipeRepository(
      api.TandoorApi(dio: dio, interceptors: const []).getApiApi(),
      dio: dio,
    );
    recipe = (await recipes.createRecipe(RecipeDraft(name: '$tag Foto'))).id;
  });

  tearDownAll(() async {
    await dio.delete<void>('/api/recipe/$recipe/');
    dio.close();
  });

  ImageUpload png(Uint8List bytes) =>
      ImageUpload(bytes: bytes, fileName: 'foto.png', mimeType: 'image/png');

  test('uploads an image and reads its URL back', () async {
    final image = await recipes.uploadImage(
      recipe,
      png(testPng(width: 400, height: 300)),
    );

    expect(image.path, matches(RegExp(r'/media/recipes/[^/]+_\d+\.png$')));
    // The URL from the upload is the one the recipe has.
    expect((await recipes.fetchRecipe(recipe)).image, image);
    // Media is served without the token.
    final file = await Dio().get<List<int>>(
      image.toString(),
      options: Options(responseType: ResponseType.bytes),
    );
    expect(file.data!.take(4), [0x89, 0x50, 0x4E, 0x47]);
  });

  test('a new upload replaces the image under a new URL', () async {
    final first = await recipes.uploadImage(recipe, png(testPng()));
    final second = await recipes.uploadImage(recipe, png(testPng()));

    expect(second, isNot(first));
    expect((await recipes.fetchRecipe(recipe)).image, second);
  });

  test('removes the image', () async {
    await recipes.uploadImage(recipe, png(testPng()));

    await recipes.removeImage(recipe);

    expect((await recipes.fetchRecipe(recipe)).image, isNull);
  });

  test('refuses a file that is not an image', () async {
    await expectLater(
      recipes.uploadImage(
        recipe,
        png(Uint8List.fromList('kein Bild'.codeUnits)),
      ),
      throwsA(isA<ServerFailure>().having((f) => f.statusCode, 'status', 400)),
    );
  });

  test('a missing recipe is a NotFoundFailure', () async {
    await expectLater(
      recipes.uploadImage(999999, png(testPng())),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}
