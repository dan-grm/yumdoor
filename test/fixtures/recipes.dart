import 'package:yumdoor/domain/models/food.dart';
import 'package:yumdoor/domain/models/ingredient.dart';
import 'package:yumdoor/domain/models/keyword.dart';
import 'package:yumdoor/domain/models/recipe.dart';
import 'package:yumdoor/domain/models/recipe_step.dart';
import 'package:yumdoor/domain/models/unit.dart';

const _gram = Unit(id: 1, name: 'g');
const _tbsp = Unit(id: 2, name: 'EL');
const _tsp = Unit(id: 3, name: 'TL');
const _bunch = Unit(id: 4, name: 'Bund');

/// The recipe of the mockups, for 2 servings, with three steps.
const ofenkarotten = Recipe(
  id: 7,
  name: 'Ofenkarotten mit Feta',
  description: 'Süß, salzig und knusprig.',
  servings: 2,
  workingTime: Duration(minutes: 15),
  waitingTime: Duration(minutes: 20),
  rating: 4.5,
  keywords: [
    Keyword(id: 1, name: 'Vegetarisch'),
    Keyword(id: 2, name: 'Ofen'),
  ],
  steps: [
    RecipeStep(id: 1, instruction: 'Den Ofen auf 200 °C vorheizen.'),
    RecipeStep(
      id: 2,
      instruction:
          'Karotten schräg in 1 cm dicke Scheiben schneiden, mit Öl, Honig '
          'und Kreuzkümmel mischen und 25 Minuten rösten.',
      ingredients: [
        Ingredient(
          id: 1,
          food: Food(id: 1, name: 'Karotte', pluralName: 'Karotten'),
          unit: _gram,
          amount: 300,
        ),
        Ingredient(
          id: 2,
          food: Food(id: 2, name: 'Olivenöl'),
          unit: _tbsp,
          amount: 1,
        ),
        Ingredient(
          id: 3,
          food: Food(id: 3, name: 'Kreuzkümmel, gemahlen'),
          unit: _tsp,
          amount: 0.5,
        ),
        Ingredient(id: 4, food: Food(id: 4, name: 'Salz'), noAmount: true),
      ],
    ),
    RecipeStep(
      id: 3,
      name: 'Anrichten',
      instruction: 'Feta darüberbröseln und mit Petersilie bestreuen.',
      ingredients: [
        Ingredient(
          id: 5,
          food: Food(id: 5, name: 'Feta'),
          unit: _gram,
          amount: 100,
        ),
        Ingredient(
          id: 6,
          food: Food(id: 6, name: 'Petersilie'),
          unit: _bunch,
          amount: 0.25,
        ),
      ],
    ),
  ],
);

/// A recipe with long German names and amounts, for layout tests.
const longNames = Recipe(
  id: 8,
  name: 'Rote-Bete-Carpaccio mit Meerrettich-Schmand und Walnusskrokant',
  servings: 4,
  steps: [
    RecipeStep(
      id: 10,
      name: 'Vorbereitung der Rote-Bete-Knollen',
      instruction: 'Alles vorbereiten.',
      ingredients: [
        Ingredient(
          id: 10,
          food: Food(
            id: 10,
            name:
                'Rote Bete, vorgegart, vakuumverpackt und in hauchdünne '
                'Scheiben geschnitten',
          ),
          unit: Unit(id: 10, name: 'Vakuumpackungen à 500 Gramm'),
          amount: 1234.5,
          note: 'am besten aus dem Kühlregal',
        ),
        Ingredient(
          id: 11,
          food: Food(id: 11, name: 'Meerrettich'),
          unit: Unit(id: 11, name: 'Messerspitze'),
          amount: 1,
        ),
      ],
    ),
    RecipeStep(
      id: 11,
      instruction: 'Anrichten.',
      ingredients: [
        Ingredient(
          id: 12,
          isHeader: true,
          noAmount: true,
          note: 'Für den Walnusskrokant mit Ahornsirup',
        ),
        Ingredient(
          id: 13,
          food: Food(id: 12, name: 'Walnusskerne'),
          unit: _gram,
          amount: 50,
        ),
      ],
    ),
  ],
);
