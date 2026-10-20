import 'package:flutter_test/flutter_test.dart';

import '../../tool/seed.dart';
import '../../tool/seed/data.dart';

void main() {
  test('seed data references only foods, recipes and users it defines', () {
    expect(seedDataProblems(), isEmpty);
  });

  test('carrots are in at least six recipes', () {
    final carrotRecipes = seedRecipes.where(
      (recipe) => recipe.steps.any(
        (step) => step.ingredients.any(
          (i) => i.food == 'Karotte' || i.food == 'carrot',
        ),
      ),
    );
    expect(carrotRecipes.length, greaterThanOrEqualTo(6));
  });

  test('only writes to the local dev Tandoor', () {
    expect(isLocalTarget(Uri.parse('http://localhost:8080')), isTrue);
    expect(isLocalTarget(Uri.parse('http://127.0.0.1:8080')), isTrue);
    expect(isLocalTarget(Uri.parse('http://web_recipes')), isTrue);
    expect(isLocalTarget(Uri.parse('https://recipes.example.com')), isFalse);
    expect(isLocalTarget(Uri.parse('http://localhost.example.com')), isFalse);
  });
}
