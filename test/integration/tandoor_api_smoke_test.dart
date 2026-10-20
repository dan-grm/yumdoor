@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tandoor_api/tandoor_api.dart';

import '../../tool/seed.dart' show credentialsPath, isLocalTarget;

/// The generated client against the local Tandoor from
/// docker/tandoor/compose.yml, seeded with `dart run tool/seed.dart`.
void main() {
  final credentials = jsonDecode(
    File(credentialsPath).readAsStringSync(),
  ) as Map<String, dynamic>;
  final baseUrl = Uri.parse(credentials['base_url'] as String);
  if (!isLocalTarget(baseUrl)) {
    throw StateError('Integration tests only run against a local Tandoor.');
  }

  TandoorApi client({String? token}) {
    final api = TandoorApi(basePathOverride: baseUrl.toString());
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
    final users = credentials['users'] as Map<String, dynamic>;
    final anna = users['anna'] as Map<String, dynamic>;
    final api = client(token: anna['token'] as String).getApiApi();

    final list = await api.apiRecipeList(pageSize: 100);
    expect(list.data!.count, greaterThan(0));

    for (final overview in list.data!.results) {
      final recipe = await api.apiRecipeRetrieve(id: overview.id!);
      expect(recipe.data!.name, overview.name);
      expect(recipe.data!.steps, isNotEmpty);
    }
  });
}
