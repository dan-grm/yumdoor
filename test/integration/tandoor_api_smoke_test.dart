@Tags(['integration'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart';

import 'seeded_tandoor.dart';

/// The generated client against the local Tandoor from
/// docker/tandoor/compose.yml, seeded with `dart run tool/seed.dart`.
void main() {
  final tandoor = SeededTandoor.load();

  TandoorApi client({String? token}) {
    final api = TandoorApi(basePathOverride: tandoor.baseUrl.toString());
    // The generated default of 3 s is too short while other integration
    // tests load the dev server.
    api.dio.options.receiveTimeout = const Duration(seconds: 30);
    if (token != null) api.setApiKey('ApiKeyAuth', 'Bearer $token');
    return api;
  }

  test('reads the server version without logging in', () async {
    final response = await client()
        .getApiApi()
        .apiServerSettingsCurrentRetrieve();

    expect(
      response.data!.version,
      File('TANDOOR_VERSION').readAsStringSync().trim(),
    );
  });

  test('deserializes seeded recipes', () async {
    final api = client(token: tandoor.token('anna')).getApiApi();

    final list = await api.apiRecipeList(pageSize: 100);
    expect(list.data!.count, greaterThan(0));

    for (final overview in list.data!.results) {
      final recipe = await api.apiRecipeRetrieve(id: overview.id!);
      expect(recipe.data!.name, overview.name);
      expect(recipe.data!.steps, isNotEmpty);
    }
  });
}
