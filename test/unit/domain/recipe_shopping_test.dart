import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/services/recipe_shopping.dart';

void main() {
  const carrot = Food(id: 1, name: 'Karotte');
  const onion = Food(id: 2, name: 'Zwiebel');
  const salt = Food(id: 3, name: 'Salz', ignoreShopping: true);
  const butter = Food(id: 4, name: 'Butter', onHand: true);
  const pepper = Food(id: 5, name: 'Pfeffer');
  const gram = Unit(id: 10, name: 'g');

  Recipe recipe(List<Ingredient> ingredients, {int servings = 2}) => Recipe(
    id: 1,
    name: 'Suppe',
    servings: servings,
    steps: [
      RecipeStep(id: 1, ingredients: ingredients.take(2).toList()),
      RecipeStep(id: 2, ingredients: ingredients.skip(2).toList()),
    ],
  );

  test('scales amounts to the chosen servings and keeps ids', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: carrot, unit: gram, amount: 300),
        const Ingredient(id: 101, food: onion, amount: 1),
        const Ingredient(id: 102, food: pepper, unit: gram, amount: 5),
      ]),
      servings: 3,
    );
    expect(result.entries, const [
      ShoppingEntryDraft(ingredientId: 100, foodId: 1, unitId: 10, amount: 450),
      ShoppingEntryDraft(
        ingredientId: 101,
        foodId: 2,
        unitId: null,
        amount: 1.5,
      ),
      ShoppingEntryDraft(ingredientId: 102, foodId: 5, unitId: 10, amount: 7.5),
    ]);
    expect(result.neededCount, 3);
    expect(result.onHandCount, 0);
  });

  test('keeps amounts unrounded', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: carrot, unit: gram, amount: 100),
      ], servings: 3),
      servings: 1,
    );
    expect(result.entries.single.amount, closeTo(33.333, 0.001));
  });

  test('a recipe without servings counts as 1 serving', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: carrot, unit: gram, amount: 100),
      ], servings: 0),
      servings: 2,
    );
    expect(result.entries.single.amount, 200);
  });

  test('skips headers', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, isHeader: true, note: 'Für den Teig'),
        const Ingredient(id: 101, food: carrot, amount: 1),
      ]),
      servings: 2,
    );
    expect(result.entries.map((e) => e.ingredientId), [101]);
    expect(result.neededCount, 1);
  });

  test('skips ingredients without a food', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, note: 'etwas Wasser'),
        const Ingredient(id: 101, food: carrot, amount: 1),
      ]),
      servings: 2,
    );
    expect(result.entries.map((e) => e.ingredientId), [101]);
    expect(result.onHandCount, 0);
  });

  test('skips foods marked ignoreShopping without counting them', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: salt, unit: gram, amount: 5),
        const Ingredient(id: 101, food: carrot, amount: 1),
      ]),
      servings: 2,
    );
    expect(result.entries.map((e) => e.ingredientId), [101]);
    expect(result.onHandCount, 0);
  });

  test('skips foods on hand and counts them', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: butter, unit: gram, amount: 50),
        const Ingredient(id: 101, food: carrot, amount: 1),
        const Ingredient(id: 102, food: butter, unit: gram, amount: 20),
      ]),
      servings: 2,
    );
    expect(result.entries.map((e) => e.ingredientId), [101]);
    expect(result.neededCount, 1);
    expect(result.onHandCount, 2);
  });

  test('an on-hand food marked ignoreShopping is not counted', () {
    final result = buildRecipeShopping(
      recipe([
        Ingredient(
          id: 100,
          food: salt.copyWith(onHand: true),
          unit: gram,
          amount: 5,
        ),
      ]),
      servings: 2,
    );
    expect(result.isEmpty, isTrue);
    expect(result.onHandCount, 0);
  });

  test('adds noAmount ingredients with amount 0', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: pepper, amount: 3, noAmount: true),
        const Ingredient(id: 101, food: carrot, unit: gram, amount: 0),
      ]),
      servings: 4,
    );
    expect(result.entries.map((e) => e.amount), [0, 0]);
    expect(result.neededCount, 2);
  });

  test('an empty recipe has nothing to add', () {
    final result = buildRecipeShopping(
      const Recipe(id: 1, name: 'Leer'),
      servings: 2,
    );
    expect(result.entries, isEmpty);
    expect(result.isEmpty, isTrue);
    expect(result.neededCount, 0);
    expect(result.onHandCount, 0);
  });

  test('a recipe with everything on hand has nothing to add', () {
    final result = buildRecipeShopping(
      recipe([
        const Ingredient(id: 100, food: butter, unit: gram, amount: 50),
        Ingredient(id: 101, food: carrot.copyWith(onHand: true), amount: 2),
      ]),
      servings: 2,
    );
    expect(result.isEmpty, isTrue);
    expect(result.neededCount, 0);
    expect(result.onHandCount, 2);
  });
}
