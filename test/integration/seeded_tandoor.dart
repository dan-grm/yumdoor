import 'dart:convert';
import 'dart:io';

import '../../tool/seed.dart' show credentialsPath, isLocalTarget;
import '../../tool/seed/data.dart';

/// The local Tandoor from docker/tandoor/compose.yml, seeded with
/// `dart run tool/seed.dart`.
class SeededTandoor {
  SeededTandoor._(this.baseUrl, this._users);

  factory SeededTandoor.load() {
    final credentials = jsonDecode(
      File(credentialsPath).readAsStringSync(),
    ) as Map<String, dynamic>;
    final baseUrl = Uri.parse(credentials['base_url'] as String);
    if (!isLocalTarget(baseUrl)) {
      throw StateError('Integration tests only run against a local Tandoor.');
    }
    return SeededTandoor._(
      baseUrl,
      credentials['users'] as Map<String, dynamic>,
    );
  }

  final Uri baseUrl;
  final Map<String, dynamic> _users;

  /// The API token of a seeded user (`admin`, `anna`, `ben`).
  String token(String username) =>
      (_users[username] as Map<String, dynamic>)['token'] as String;
}

/// [food] and every food below it in the seeded food tree.
Set<String> seedFoodWithChildren(String food) {
  final names = {food};
  var grew = true;
  while (grew) {
    grew = false;
    for (final candidate in seedFoods) {
      if (names.contains(candidate.parent) && names.add(candidate.name)) {
        grew = true;
      }
    }
  }
  return names;
}

/// Names of the seeded recipes with an ingredient from [foods].
Set<String> seedRecipesWithAnyFood(Set<String> foods) => {
  for (final recipe in seedRecipes)
    if (recipe.steps.any(
      (step) => step.ingredients.any((i) => foods.contains(i.food)),
    ))
      recipe.name,
};
