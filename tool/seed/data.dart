// Synthetic seed data for tool/seed.dart. Fictional people, made-up recipes.
//
// German and English recipes share one space, as they would on a real
// multilingual server. Carrots (Karotte / carrot) appear in eight recipes;
// both sit in a food tree so `include_children` can be tested from the root.

/// Users created by the bootstrap. `role` is a Tandoor group.
const seedUsers = <SeedUser>[
  SeedUser('admin', 'Admin', 'admin', household: false),
  SeedUser('anna', 'Anna', 'user', household: true),
  SeedUser('ben', 'Ben', 'user', household: true),
];

const seedSpace = 'Yumdoor Dev';
const seedHousehold = 'Anna & Ben';

class SeedUser {
  const SeedUser(
    this.username,
    this.firstName,
    this.role, {
    required this.household,
  });

  final String username;
  final String firstName;
  final String role;
  final bool household;

  String get password => '$username-dev-only';
  String get email => '$username@example.com';

  Map<String, Object> toBootstrapArgs() => {
    'username': username,
    'first_name': firstName,
    'email': email,
    'password': password,
    'role': role,
    'household': household,
  };
}

/// Supermarket categories in the order of the seeded supermarket.
const seedCategories = <String>[
  'Obst & Gemüse',
  'Brot & Backwaren',
  'Kühlregal',
  'Fleisch & Fisch',
  'Trockenwaren',
  'Konserven',
  'Gewürze & Öle',
  'Tiefkühl',
];

const seedSupermarket = 'Nachbarschaftsmarkt';

class SeedFood {
  const SeedFood(
    this.name, {
    this.plural,
    this.category,
    this.parent,
    this.onHand = false,
    this.ignoreShopping = false,
  });

  final String name;
  final String? plural;
  final String? category;
  final String? parent;

  /// Marked on hand for the household (by Anna).
  final bool onHand;
  final bool ignoreShopping;
}

const _veg = 'Obst & Gemüse';
const _bread = 'Brot & Backwaren';
const _chilled = 'Kühlregal';
const _meat = 'Fleisch & Fisch';
const _dry = 'Trockenwaren';
const _cans = 'Konserven';
const _spice = 'Gewürze & Öle';

/// Every food used by a recipe, in creation order (parents before children).
const seedFoods = <SeedFood>[
  // Tree roots (no category; they are only for filtering).
  SeedFood('Gemüse'),
  SeedFood('Wurzelgemüse', parent: 'Gemüse'),
  SeedFood('vegetables'),

  // German foods
  SeedFood(
    'Karotte',
    plural: 'Karotten',
    category: _veg,
    parent: 'Wurzelgemüse',
  ),
  SeedFood(
    'Kartoffel',
    plural: 'Kartoffeln',
    category: _veg,
    parent: 'Wurzelgemüse',
  ),
  SeedFood(
    'Zwiebel',
    plural: 'Zwiebeln',
    category: _veg,
    parent: 'Gemüse',
    onHand: true,
  ),
  SeedFood('Knoblauch', category: _veg, parent: 'Gemüse', onHand: true),
  SeedFood('Ingwer', category: _veg),
  SeedFood('Tomate', plural: 'Tomaten', category: _veg, parent: 'Gemüse'),
  SeedFood('Paprika', category: _veg, parent: 'Gemüse'),
  SeedFood('Zucchini', category: _veg, parent: 'Gemüse'),
  SeedFood('Hokkaido-Kürbis', category: _veg, parent: 'Gemüse'),
  SeedFood('Spargel', category: _veg, parent: 'Gemüse'),
  SeedFood('Staudensellerie', category: _veg, parent: 'Gemüse'),
  SeedFood('Apfel', plural: 'Äpfel', category: _veg),
  SeedFood('Zitrone', plural: 'Zitronen', category: _veg),
  SeedFood('Petersilie', category: _veg),
  SeedFood('Schnittlauch', category: _veg),
  SeedFood('Basilikum', category: _veg),
  SeedFood('Butter', category: _chilled),
  SeedFood('Milch', category: _chilled),
  SeedFood('Sahne', category: _chilled),
  SeedFood('Ei', plural: 'Eier', category: _chilled),
  SeedFood('Mozzarella', category: _chilled),
  SeedFood('Parmesan', category: _chilled),
  SeedFood('Joghurt', category: _chilled),
  SeedFood('Speck', category: _chilled),
  SeedFood('Rindergulasch', category: _meat),
  SeedFood('Rinderhackfleisch', category: _meat),
  SeedFood('Hähnchenbrust', category: _meat),
  SeedFood('Schinken', category: _meat),
  SeedFood('Mehl', category: _dry, onHand: true),
  SeedFood('Zucker', category: _dry, onHand: true),
  SeedFood('Backpulver', category: _dry),
  SeedFood('Hefe', category: _bread),
  SeedFood('Haferflocken', category: _dry),
  SeedFood('rote Linsen', category: _dry),
  SeedFood('Spaghetti', category: _dry),
  SeedFood('Risottoreis', category: _dry),
  SeedFood('Basmatireis', category: _dry),
  SeedFood('Gemüsebrühe', category: _dry),
  SeedFood('Kokosmilch', category: _cans),
  SeedFood('gehackte Tomaten', category: _cans),
  SeedFood('Tomatenmark', category: _cans),
  SeedFood('Weißwein', category: _cans),
  SeedFood('Olivenöl', category: _spice, onHand: true),
  SeedFood('Rapsöl', category: _spice),
  SeedFood('Essig', category: _spice),
  SeedFood('Senf', category: _spice),
  SeedFood('Paprikapulver', category: _spice),
  SeedFood('Currypulver', category: _spice),
  SeedFood('Kreuzkümmel', category: _spice),
  SeedFood('Zimt', category: _spice),
  SeedFood('Salz', category: _spice, ignoreShopping: true),
  SeedFood('Pfeffer', category: _spice, ignoreShopping: true),
  SeedFood('Wasser', ignoreShopping: true),

  // English foods
  SeedFood('carrot', plural: 'carrots', category: _veg, parent: 'vegetables'),
  SeedFood('onion', plural: 'onions', category: _veg, parent: 'vegetables'),
  SeedFood('garlic', category: _veg, parent: 'vegetables'),
  SeedFood('celery', category: _veg, parent: 'vegetables'),
  SeedFood(
    'mushroom',
    plural: 'mushrooms',
    category: _veg,
    parent: 'vegetables',
  ),
  SeedFood('avocado', plural: 'avocados', category: _veg),
  SeedFood('lime', plural: 'limes', category: _veg),
  SeedFood('lemon', plural: 'lemons', category: _veg),
  SeedFood('banana', plural: 'bananas', category: _veg),
  SeedFood(
    'bell pepper',
    plural: 'bell peppers',
    category: _veg,
    parent: 'vegetables',
  ),
  SeedFood('cilantro', category: _veg),
  SeedFood('egg', plural: 'eggs', category: _chilled),
  SeedFood('sour cream', category: _chilled),
  SeedFood('cream cheese', category: _chilled),
  SeedFood('chicken thigh', plural: 'chicken thighs', category: _meat),
  SeedFood('flour', category: _dry),
  SeedFood('sugar', category: _dry),
  SeedFood('honey', category: _dry),
  SeedFood('baking soda', category: _dry),
  SeedFood('walnuts', category: _dry),
  SeedFood('egg noodles', category: _dry),
  SeedFood('pasta', category: _dry),
  SeedFood('white beans', category: _cans),
  SeedFood('canned tomatoes', category: _cans),
  SeedFood('stock', category: _dry),
  SeedFood('olive oil', category: _spice),
  SeedFood('cumin', category: _spice),
  SeedFood('cinnamon', category: _spice),
  SeedFood('thyme', category: _spice),
  SeedFood('salt', category: _spice, ignoreShopping: true),
  SeedFood('pepper', category: _spice, ignoreShopping: true),
];

/// Meal types of the space, created by Anna (meal types are space-wide).
const seedMealTypes = <SeedMealType>[
  SeedMealType('Frühstück', order: 0, time: '08:00:00', color: '#e8b04a'),
  SeedMealType('Mittagessen', order: 1, time: '12:30:00', color: '#6f9a5b'),
  SeedMealType('Abendessen', order: 2, time: '18:30:00', color: '#c26a4a'),
];

class SeedMealType {
  const SeedMealType(
    this.name, {
    required this.order,
    required this.time,
    required this.color,
  });

  final String name;
  final int order;
  final String time;
  final String color;
}

class SeedIngredient {
  const SeedIngredient(this.amount, this.unit, this.food, {this.note})
    : noAmount = false,
      isHeader = false;

  /// "Salz und Pfeffer" style ingredients without an amount.
  const SeedIngredient.noAmount(this.food, {this.note})
    : amount = 0,
      unit = null,
      noAmount = true,
      isHeader = false;

  /// A heading inside the ingredient list ("Für den Teig").
  const SeedIngredient.header(String title)
    : amount = 0,
      unit = null,
      food = null,
      note = title,
      noAmount = true,
      isHeader = true;

  final num amount;
  final String? unit;
  final String? food;
  final String? note;
  final bool noAmount;
  final bool isHeader;
}

class SeedStep {
  const SeedStep(
    this.instruction, [
    this.ingredients = const [],
    this.time = 0,
    this.name = '',
  ]);

  final String instruction;
  final List<SeedIngredient> ingredients;

  /// Explicit duration in minutes (`Step.time`), 0 if none.
  final int time;
  final String name;
}

class SeedRecipe {
  const SeedRecipe(
    this.name, {
    required this.author,
    required this.servings,
    required this.keywords,
    required this.steps,
    this.description = '',
    this.workingTime = 0,
    this.waitingTime = 0,
  });

  final String name;

  /// Username of the creator.
  final String author;
  final int servings;
  final List<String> keywords;
  final List<SeedStep> steps;
  final String description;
  final int workingTime;
  final int waitingTime;
}

typedef _I = SeedIngredient;
typedef _S = SeedStep;

const seedRecipes = <SeedRecipe>[
  // ---------------------------------------------------------------- German
  SeedRecipe(
    'Karottensuppe mit Ingwer',
    author: 'anna',
    servings: 4,
    keywords: ['Suppe', 'Vegetarisch', 'Herbst'],
    description: 'Cremig, wärmend und in einer halben Stunde fertig.',
    workingTime: 15,
    waitingTime: 20,
    steps: [
      _S(
        '{{ ingredients[0] }} schälen und in Scheiben schneiden. Zwiebel und Ingwer fein würfeln.',
        [
          _I(600, 'g', 'Karotte'),
          _I(1, 'Stück', 'Zwiebel'),
          _I(20, 'g', 'Ingwer'),
        ],
      ),
      _S(
        'Butter in einem Topf erhitzen, das Gemüse darin 5 Minuten andünsten. Mit Brühe ablöschen und '
        '20 Minuten köcheln lassen, bis die Karotten weich sind.',
        [_I(2, 'EL', 'Butter'), _I(800, 'ml', 'Gemüsebrühe')],
        20,
      ),
      _S(
        'Kokosmilch zugeben, fein pürieren und mit Salz und Pfeffer abschmecken.',
        [
          _I(200, 'ml', 'Kokosmilch'),
          _I.noAmount('Salz'),
          _I.noAmount('Pfeffer'),
        ],
      ),
    ],
  ),
  SeedRecipe(
    'Linsen-Dal mit Karotten',
    author: 'ben',
    servings: 4,
    keywords: ['Vegan', 'Hauptgericht', 'Winter'],
    workingTime: 15,
    waitingTime: 25,
    steps: [
      _S('Zwiebel, Knoblauch und Ingwer fein hacken, Karotten klein würfeln.', [
        _I(1, 'Stück', 'Zwiebel'),
        _I(2, 'Zehe', 'Knoblauch'),
        _I(15, 'g', 'Ingwer'),
        _I(2, 'Stück', 'Karotte'),
      ]),
      _S('Im Öl mit Curry und Kreuzkümmel 3-4 Minuten anschwitzen.', [
        _I(2, 'EL', 'Rapsöl'),
        _I(2, 'TL', 'Currypulver'),
        _I(1, 'TL', 'Kreuzkümmel'),
      ]),
      _S(
        'Linsen, Tomaten und {{ ingredients[2].amount }} {{ ingredients[2].unit }} Wasser zugeben. '
        'Zugedeckt 25 Minuten köcheln, gelegentlich umrühren.',
        [
          _I(250, 'g', 'rote Linsen'),
          _I(1, 'Dose', 'gehackte Tomaten'),
          _I(600, 'ml', 'Wasser'),
        ],
        25,
      ),
      _S('Kokosmilch unterrühren, salzen und mit Basmatireis servieren.', [
        _I(400, 'ml', 'Kokosmilch'),
        _I(250, 'g', 'Basmatireis'),
        _I.noAmount('Salz'),
      ]),
    ],
  ),
  SeedRecipe(
    'Rindergulasch',
    author: 'anna',
    servings: 6,
    keywords: ['Hauptgericht', 'Winter'],
    description: 'Am besten am Vortag kochen.',
    workingTime: 30,
    waitingTime: 150,
    steps: [
      _S('Fleisch in Würfel schneiden, Zwiebeln in Streifen.', [
        _I(1.2, 'kg', 'Rindergulasch'),
        _I(4, 'Stück', 'Zwiebel'),
      ]),
      _S('Fleisch portionsweise in heißem Öl scharf anbraten, herausnehmen.', [
        _I(3, 'EL', 'Rapsöl'),
      ]),
      _S(
        'Zwiebeln 10 Minuten goldbraun braten. Tomatenmark und Paprikapulver kurz mitrösten.',
        [_I(2, 'EL', 'Tomatenmark'), _I(2, 'EL', 'Paprikapulver')],
      ),
      _S(
        'Fleisch zurückgeben, mit Wein und Brühe ablöschen und zugedeckt 2 Stunden schmoren. '
        'Danach ohne Deckel noch 30 Minuten einkochen.',
        [
          _I(200, 'ml', 'Weißwein'),
          _I(500, 'ml', 'Gemüsebrühe'),
          _I.noAmount('Salz'),
          _I.noAmount('Pfeffer'),
        ],
        150,
      ),
    ],
  ),
  SeedRecipe(
    'Schwäbischer Kartoffelsalat',
    author: 'anna',
    servings: 4,
    keywords: ['Beilage', 'Vegetarisch', 'Sommer'],
    workingTime: 20,
    waitingTime: 50,
    steps: [
      _S(
        'Kartoffeln in der Schale ca. 20 Minuten kochen, pellen und noch warm in Scheiben schneiden.',
        [_I(1, 'kg', 'Kartoffel', note: 'festkochend')],
        20,
      ),
      _S(
        'Zwiebel fein würfeln und in der Brühe aufkochen. Mit Essig, Senf, Öl, Salz und Pfeffer verrühren.',
        [
          _I(1, 'Stück', 'Zwiebel'),
          _I(250, 'ml', 'Gemüsebrühe'),
          _I(4, 'EL', 'Essig'),
          _I(1, 'TL', 'Senf'),
          _I(4, 'EL', 'Rapsöl'),
          _I.noAmount('Salz'),
          _I.noAmount('Pfeffer'),
        ],
      ),
      _S(
        'Über die Kartoffeln gießen, mindestens 30 Minuten ziehen lassen. Mit Schnittlauch servieren.',
        [_I(1, 'Bund', 'Schnittlauch')],
        30,
      ),
    ],
  ),
  SeedRecipe(
    'Spaghetti Bolognese',
    author: 'ben',
    servings: 4,
    keywords: ['Hauptgericht'],
    workingTime: 25,
    waitingTime: 60,
    steps: [
      _S('Zwiebel, Karotte und Sellerie sehr fein würfeln.', [
        _I(1, 'Stück', 'Zwiebel'),
        _I(1, 'Stück', 'Karotte'),
        _I(1, 'Stange', 'Staudensellerie'),
      ]),
      _S(
        'Hackfleisch in Olivenöl krümelig braten, Gemüse zugeben und 5 Minuten mitbraten.',
        [_I(500, 'g', 'Rinderhackfleisch'), _I(2, 'EL', 'Olivenöl')],
      ),
      _S(
        'Tomatenmark anrösten, mit Tomaten ablöschen und 1 Stunde leise köcheln lassen.',
        [_I(1, 'EL', 'Tomatenmark'), _I(2, 'Dose', 'gehackte Tomaten')],
        60,
      ),
      _S('Spaghetti nach Packungsangabe kochen. Mit Parmesan servieren.', [
        _I(400, 'g', 'Spaghetti'),
        _I(50, 'g', 'Parmesan'),
      ]),
    ],
  ),
  SeedRecipe(
    'Gemüsepfanne mit Reis',
    author: 'anna',
    servings: 2,
    keywords: ['Vegetarisch', 'Schnell', 'Sommer'],
    workingTime: 25,
    steps: [
      _S('Reis in der doppelten Menge Wasser 15 Minuten garen.', [
        _I(150, 'g', 'Basmatireis'),
      ], 15),
      _S('Karotten, Paprika und Zucchini in Streifen schneiden.', [
        _I(2, 'Stück', 'Karotte'),
        _I(1, 'Stück', 'Paprika'),
        _I(1, 'Stück', 'Zucchini'),
      ]),
      _S(
        'Gemüse in Öl 5-7 min scharf anbraten, mit Curry, Salz und Pfeffer würzen.',
        [
          _I(2, 'EL', 'Rapsöl'),
          _I(1, 'TL', 'Currypulver'),
          _I.noAmount('Salz'),
          _I.noAmount('Pfeffer'),
        ],
      ),
    ],
  ),
  SeedRecipe(
    'Pfannkuchen',
    author: 'ben',
    servings: 4,
    keywords: ['Frühstück', 'Vegetarisch', 'Schnell'],
    workingTime: 30,
    steps: [
      _S(
        'Mehl, Milch, Eier und eine Prise Salz glatt rühren. Den Teig 10 Minuten quellen lassen.',
        [
          _I(250, 'g', 'Mehl'),
          _I(500, 'ml', 'Milch'),
          _I(3, 'Stück', 'Ei'),
          _I(1, 'Prise', 'Salz'),
        ],
        10,
      ),
      _S(
        'In einer Pfanne mit etwas Butter nacheinander dünne Pfannkuchen backen, je Seite etwa 1 Minute.',
        [_I(30, 'g', 'Butter')],
      ),
    ],
  ),
  SeedRecipe(
    'Apfelkuchen vom Blech',
    author: 'anna',
    servings: 12,
    keywords: ['Backen', 'Dessert', 'Herbst'],
    workingTime: 30,
    waitingTime: 40,
    steps: [
      _S(
        'Für den Teig alles verkneten und auf einem gefetteten Blech ({{ scale(30) }} × 40 cm) verteilen.',
        [
          _I.header('Für den Teig'),
          _I(300, 'g', 'Mehl'),
          _I(150, 'g', 'Zucker'),
          _I(150, 'g', 'Butter', note: 'weich'),
          _I(3, 'Stück', 'Ei'),
          _I(2, 'TL', 'Backpulver'),
        ],
      ),
      _S(
        'Äpfel schälen, in Spalten schneiden und auf den Teig legen. Mit Zimt und Zucker bestreuen.',
        [
          _I.header('Für den Belag'),
          _I(1, 'kg', 'Apfel'),
          _I(1, 'TL', 'Zimt'),
          _I(2, 'EL', 'Zucker'),
        ],
      ),
      _S('Bei 180 °C etwa 40 Minuten backen.', [], 40),
    ],
  ),
  SeedRecipe(
    'Spargel mit Schinken und Butterkartoffeln',
    author: 'anna',
    servings: 2,
    keywords: ['Hauptgericht', 'Frühling'],
    workingTime: 20,
    waitingTime: 20,
    steps: [
      _S('Kartoffeln schälen und 20 Minuten in Salzwasser kochen.', [
        _I(500, 'g', 'Kartoffel'),
      ], 20),
      _S(
        'Spargel schälen und in Wasser mit etwas Zucker und Butter 12-15 Minuten garen.',
        [_I(1, 'kg', 'Spargel'), _I(1, 'TL', 'Zucker'), _I(20, 'g', 'Butter')],
      ),
      _S(
        'Mit Schinken und zerlassener Butter servieren, Petersilie darüberstreuen.',
        [
          _I(150, 'g', 'Schinken'),
          _I(60, 'g', 'Butter'),
          _I(0.5, 'Bund', 'Petersilie'),
        ],
      ),
    ],
  ),
  SeedRecipe(
    'Kürbisrisotto',
    author: 'ben',
    servings: 4,
    keywords: ['Vegetarisch', 'Hauptgericht', 'Herbst'],
    workingTime: 40,
    steps: [
      _S(
        'Kürbis entkernen und in kleine Würfel schneiden, die Zwiebel fein hacken.',
        [_I(600, 'g', 'Hokkaido-Kürbis'), _I(1, 'Stück', 'Zwiebel')],
      ),
      _S(
        'Zwiebel in Butter glasig dünsten, Reis zugeben und mit Wein ablöschen.',
        [
          _I(2, 'EL', 'Butter'),
          _I(300, 'g', 'Risottoreis'),
          _I(100, 'ml', 'Weißwein'),
        ],
      ),
      _S(
        'Kürbis zugeben und nach und nach die heiße Brühe angießen. Unter Rühren etwa 20 Minuten garen.',
        [_I(1, 'l', 'Gemüsebrühe')],
        20,
      ),
      _S('Parmesan und restliche Butter unterziehen, abschmecken.', [
        _I(60, 'g', 'Parmesan'),
        _I(1, 'EL', 'Butter'),
        _I.noAmount('Salz'),
        _I.noAmount('Pfeffer'),
      ]),
    ],
  ),
  SeedRecipe(
    'Kartoffelgratin',
    author: 'anna',
    servings: 4,
    keywords: ['Beilage', 'Vegetarisch', 'Winter'],
    workingTime: 20,
    waitingTime: 50,
    steps: [
      _S(
        'Kartoffeln schälen und in dünne Scheiben hobeln, in eine gefettete Form schichten.',
        [_I(1, 'kg', 'Kartoffel'), _I(1, 'TL', 'Butter')],
      ),
      _S(
        'Sahne und Milch mit Knoblauch, Salz und Pfeffer erhitzen und über die Kartoffeln gießen.',
        [
          _I(200, 'ml', 'Sahne'),
          _I(200, 'ml', 'Milch'),
          _I(1, 'Zehe', 'Knoblauch'),
          _I.noAmount('Salz'),
          _I.noAmount('Pfeffer'),
        ],
      ),
      _S('Bei 180 °C 50 Minuten goldbraun backen.', [], 50),
    ],
  ),
  SeedRecipe(
    'Tomaten-Mozzarella-Salat',
    author: 'ben',
    servings: 2,
    keywords: ['Vegetarisch', 'Schnell', 'Sommer'],
    workingTime: 10,
    steps: [
      _S(
        'Tomaten und Mozzarella in Scheiben schneiden und abwechselnd anrichten.',
        [_I(4, 'Stück', 'Tomate'), _I(1, 'Stück', 'Mozzarella')],
      ),
      _S('Mit Basilikum, Olivenöl, Salz und Pfeffer anmachen.', [
        _I(0.5, 'Bund', 'Basilikum'),
        _I(3, 'EL', 'Olivenöl'),
        _I.noAmount('Salz'),
        _I.noAmount('Pfeffer'),
      ]),
    ],
  ),
  SeedRecipe(
    'Overnight Oats mit Apfel',
    author: 'anna',
    servings: 1,
    keywords: ['Frühstück', 'Vegetarisch'],
    workingTime: 5,
    steps: [
      _S(
        'Haferflocken mit Milch und Joghurt verrühren und über Nacht im Kühlschrank quellen lassen.',
        [
          _I(50, 'g', 'Haferflocken'),
          _I(100, 'ml', 'Milch'),
          _I(100, 'g', 'Joghurt'),
        ],
      ),
      _S('Morgens den Apfel reiben und mit Zimt unterheben.', [
        _I(1, 'Stück', 'Apfel'),
        _I(1, 'Prise', 'Zimt'),
      ]),
    ],
  ),
  SeedRecipe(
    'Hähnchen-Curry',
    author: 'ben',
    servings: 4,
    keywords: ['Hauptgericht', 'Schnell'],
    workingTime: 30,
    steps: [
      _S(
        'Hähnchen in mundgerechte Stücke schneiden, Paprika und Zwiebel würfeln.',
        [
          _I(500, 'g', 'Hähnchenbrust'),
          _I(1, 'Stück', 'Paprika'),
          _I(1, 'Stück', 'Zwiebel'),
        ],
      ),
      _S('Hähnchen in Öl 5 Minuten anbraten, Gemüse und Currypulver zugeben.', [
        _I(2, 'EL', 'Rapsöl'),
        _I(2, 'EL', 'Currypulver'),
      ]),
      _S(
        'Mit Kokosmilch ablöschen und 10 Minuten köcheln lassen. Mit Reis servieren.',
        [_I(400, 'ml', 'Kokosmilch'), _I(250, 'g', 'Basmatireis')],
        10,
      ),
    ],
  ),
  SeedRecipe(
    'Zwiebelkuchen',
    author: 'anna',
    servings: 8,
    keywords: ['Backen', 'Herbst'],
    workingTime: 40,
    waitingTime: 105,
    steps: [
      _S(
        'Hefeteig aus Mehl, Hefe, lauwarmer Milch, Butter und Salz kneten und 1 Stunde gehen lassen.',
        [
          _I(300, 'g', 'Mehl'),
          _I(0.5, 'Würfel', 'Hefe'),
          _I(150, 'ml', 'Milch'),
          _I(50, 'g', 'Butter'),
          _I(1, 'Prise', 'Salz'),
        ],
        60,
      ),
      _S(
        'Zwiebeln in Ringe schneiden und mit dem Speck 15 Minuten glasig dünsten.',
        [_I(1, 'kg', 'Zwiebel'), _I(100, 'g', 'Speck')],
      ),
      _S(
        'Eier mit Sahne verquirlen, mit den Zwiebeln auf dem Teig verteilen. Bei 200 °C 45 Minuten backen.',
        [_I(3, 'Stück', 'Ei'), _I(200, 'ml', 'Sahne')],
        45,
      ),
    ],
  ),
  SeedRecipe(
    'Zitronen-Joghurt-Kuchen',
    author: 'ben',
    servings: 10,
    keywords: ['Backen', 'Dessert', 'Frühling'],
    workingTime: 15,
    waitingTime: 50,
    steps: [
      _S(
        'Joghurt, Zucker, Öl und Eier verrühren. Abrieb und Saft der Zitrone zugeben.',
        [
          _I(250, 'g', 'Joghurt'),
          _I(200, 'g', 'Zucker'),
          _I(100, 'ml', 'Rapsöl'),
          _I(3, 'Stück', 'Ei'),
          _I(1, 'Stück', 'Zitrone'),
        ],
      ),
      _S(
        'Mehl und Backpulver unterheben, in eine Kastenform füllen und 50 Minuten bei 175 °C backen.',
        [_I(300, 'g', 'Mehl'), _I(1, 'Päckchen', 'Backpulver')],
        50,
      ),
    ],
  ),

  // --------------------------------------------------------------- English
  SeedRecipe(
    'Carrot Cake',
    author: 'ben',
    servings: 12,
    keywords: ['Baking', 'Dessert'],
    description: 'Moist, spiced and topped with cream cheese frosting.',
    workingTime: 30,
    waitingTime: 50,
    steps: [
      _S('Grate the carrots and chop the walnuts.', [
        _I(300, 'g', 'carrot'),
        _I(100, 'g', 'walnuts'),
      ]),
      _S(
        'Whisk eggs, sugar and oil, then fold in flour, baking soda, cinnamon and the carrots.',
        [
          _I(3, 'piece', 'egg'),
          _I(200, 'g', 'sugar'),
          _I(180, 'ml', 'olive oil', note: 'or any neutral oil'),
          _I(250, 'g', 'flour'),
          _I(1, 'tsp', 'baking soda'),
          _I(2, 'tsp', 'cinnamon'),
        ],
      ),
      _S('Bake in a {{ scale(23) }} cm tin at 175 °C for 50 minutes.', [], 50),
      _S('Beat cream cheese with honey and spread over the cooled cake.', [
        _I(200, 'g', 'cream cheese'),
        _I(3, 'tbsp', 'honey'),
      ]),
    ],
  ),
  SeedRecipe(
    'Honey Roasted Carrots',
    author: 'anna',
    servings: 4,
    keywords: ['Vegetarian', 'Quick', 'Autumn'],
    workingTime: 10,
    waitingTime: 25,
    steps: [
      _S(
        'Halve the carrots lengthwise and toss with olive oil, honey, thyme, salt and pepper.',
        [
          _I(800, 'g', 'carrot'),
          _I(2, 'tbsp', 'olive oil'),
          _I(2, 'tbsp', 'honey'),
          _I(1, 'tsp', 'thyme'),
          _I.noAmount('salt'),
          _I.noAmount('pepper'),
        ],
      ),
      _S('Roast at 200 °C for 25 minutes, turning once.', [], 25),
    ],
  ),
  SeedRecipe(
    'Minestrone',
    author: 'ben',
    servings: 6,
    keywords: ['Soup', 'Vegetarian', 'Winter'],
    workingTime: 20,
    waitingTime: 35,
    steps: [
      _S(
        'Dice {{ ingredients[0] }}, {{ ingredients[1] }} and {{ ingredients[2] }}.',
        [
          _I(1, 'piece', 'onion'),
          _I(2, 'piece', 'carrot'),
          _I(2, 'piece', 'celery', note: 'stalks'),
        ],
      ),
      _S('Sweat the vegetables in olive oil for 10 minutes.', [
        _I(3, 'tbsp', 'olive oil'),
      ], 10),
      _S(
        'Add tomatoes, stock and beans and simmer for 20 minutes. Add the pasta for the last 10 minutes.',
        [
          _I(1, 'can', 'canned tomatoes'),
          _I(1.5, 'l', 'stock'),
          _I(1, 'can', 'white beans'),
          _I(100, 'g', 'pasta'),
        ],
        20,
      ),
    ],
  ),
  SeedRecipe(
    'Chicken Noodle Soup',
    author: 'ben',
    servings: 4,
    keywords: ['Soup', 'Winter'],
    workingTime: 15,
    waitingTime: 60,
    steps: [
      _S(
        'Put chicken, onion, carrots and celery in a pot with the stock. Simmer for 1 hour.',
        [
          _I(600, 'g', 'chicken thigh'),
          _I(1, 'piece', 'onion'),
          _I(3, 'piece', 'carrot'),
          _I(2, 'piece', 'celery'),
          _I(2, 'l', 'stock'),
        ],
        60,
      ),
      _S(
        'Shred the chicken, return it to the pot and cook the noodles in the soup for 8 minutes.',
        [
          _I(200, 'g', 'egg noodles'),
          _I.noAmount('salt'),
          _I.noAmount('pepper'),
        ],
        8,
      ),
    ],
  ),
  SeedRecipe(
    'Shakshuka',
    author: 'anna',
    servings: 2,
    keywords: ['Breakfast', 'Vegetarian'],
    workingTime: 30,
    steps: [
      _S(
        'Fry onion, bell pepper and garlic in olive oil for 5 minutes. Add cumin.',
        [
          _I(1, 'piece', 'onion'),
          _I(1, 'piece', 'bell pepper'),
          _I(2, 'clove', 'garlic'),
          _I(2, 'tbsp', 'olive oil'),
          _I(1, 'tsp', 'cumin'),
        ],
      ),
      _S('Add the tomatoes and simmer for 10 minutes.', [
        _I(1, 'can', 'canned tomatoes'),
      ], 10),
      _S(
        'Make wells, crack in the eggs and cook covered for 6-8 minutes. Top with cilantro.',
        [_I(4, 'piece', 'egg'), _I.noAmount('cilantro')],
      ),
    ],
  ),
  SeedRecipe(
    'Banana Bread',
    author: 'ben',
    servings: 10,
    keywords: ['Baking', 'Breakfast'],
    workingTime: 15,
    waitingTime: 60,
    steps: [
      _S('Mash the bananas and mix with sugar, eggs and melted butter.', [
        _I(3, 'piece', 'banana', note: 'very ripe'),
        _I(120, 'g', 'sugar'),
        _I(2, 'piece', 'egg'),
        _I(80, 'g', 'Butter'),
      ]),
      _S(
        'Stir in flour, baking soda and cinnamon. Bake at 175 °C for 1 hour.',
        [
          _I(220, 'g', 'flour'),
          _I(1, 'tsp', 'baking soda'),
          _I(1, 'tsp', 'cinnamon'),
        ],
        60,
      ),
    ],
  ),
  SeedRecipe(
    'Guacamole',
    author: 'anna',
    servings: 4,
    keywords: ['Vegan', 'Quick', 'Summer'],
    workingTime: 10,
    steps: [
      _S(
        'Mash the avocados with lime juice and salt. Fold in finely chopped onion and cilantro.',
        [
          _I(3, 'piece', 'avocado'),
          _I(1, 'piece', 'lime'),
          _I(0.5, 'piece', 'onion'),
          _I.noAmount('cilantro'),
          _I.noAmount('salt'),
        ],
      ),
    ],
  ),
  SeedRecipe(
    'Mushroom Stroganoff',
    author: 'ben',
    servings: 4,
    keywords: ['Vegetarian', 'Main'],
    workingTime: 30,
    steps: [
      _S(
        'Slice the mushrooms and onion. Fry in batches until golden, about 8 minutes.',
        [
          _I(600, 'g', 'mushroom'),
          _I(1, 'piece', 'onion'),
          _I(2, 'tbsp', 'olive oil'),
        ],
      ),
      _S(
        'Add garlic and stock, reduce by half, then stir in sour cream. Serve with egg noodles.',
        [
          _I(2, 'clove', 'garlic'),
          _I(200, 'ml', 'stock'),
          _I(150, 'g', 'sour cream'),
          _I(300, 'g', 'egg noodles'),
        ],
      ),
    ],
  ),
  SeedRecipe(
    'Lemon Pasta',
    author: 'anna',
    servings: 2,
    keywords: ['Quick', 'Vegetarian', 'Spring'],
    workingTime: 15,
    steps: [
      _S('Cook the pasta. Keep a cup of the cooking water.', [
        _I(200, 'g', 'pasta'),
      ], 10),
      _S(
        'Toss with lemon zest and juice, Parmesan, olive oil and enough pasta water to make it glossy.',
        [
          _I(1, 'piece', 'lemon'),
          _I(40, 'g', 'Parmesan'),
          _I(2, 'tbsp', 'olive oil'),
          _I.noAmount('pepper'),
        ],
      ),
    ],
  ),
];

class SeedBook {
  const SeedBook(
    this.name, {
    required this.owner,
    required this.recipes,
    this.sharedWith = const [],
    this.description = '',
  });

  final String name;
  final String owner;
  final List<String> sharedWith;
  final List<String> recipes;
  final String description;
}

const seedBooks = <SeedBook>[
  SeedBook(
    'Unsere Lieblingsrezepte',
    owner: 'anna',
    sharedWith: ['ben'],
    description: 'Was bei uns immer wieder auf den Tisch kommt.',
    recipes: [
      'Karottensuppe mit Ingwer',
      'Rindergulasch',
      'Pfannkuchen',
      'Kürbisrisotto',
      'Lemon Pasta',
      'Carrot Cake',
    ],
  ),
  SeedBook(
    "Ben's baking",
    owner: 'ben',
    recipes: [
      'Carrot Cake',
      'Banana Bread',
      'Zitronen-Joghurt-Kuchen',
      'Apfelkuchen vom Blech',
    ],
  ),
];

/// Comments for cook logs; picked deterministically.
const seedComments = <String?>[
  'Sehr lecker, gerne wieder!',
  'Etwas mehr Salz nächstes Mal.',
  null,
  'Kinder fanden es super.',
  'Took longer than expected, but worth it.',
  null,
  'Mit doppelter Menge Knoblauch noch besser.',
  'A bit bland, needs more spice.',
  'Perfekt für einen kalten Abend.',
  null,
  'Great for meal prep.',
  'Reste am nächsten Tag waren sogar besser.',
];

/// Meal plans for the current week: weekday (1 = Monday), meal type, recipe or
/// title, servings, creator. `shopping` marks plans whose ingredients go on
/// the shopping list.
class SeedMealPlan {
  const SeedMealPlan(
    this.weekday,
    this.mealType, {
    required this.by,
    required this.servings,
    this.recipe,
    this.title = '',
    this.note = '',
    this.shopping = false,
  });

  final int weekday;
  final String mealType;
  final String by;
  final num servings;
  final String? recipe;
  final String title;
  final String note;
  final bool shopping;
}

const seedMealPlans = <SeedMealPlan>[
  SeedMealPlan(
    1,
    'Abendessen',
    by: 'anna',
    servings: 2,
    recipe: 'Gemüsepfanne mit Reis',
  ),
  SeedMealPlan(
    2,
    'Abendessen',
    by: 'ben',
    servings: 4,
    recipe: 'Linsen-Dal mit Karotten',
    shopping: true,
  ),
  SeedMealPlan(
    3,
    'Abendessen',
    by: 'anna',
    servings: 4,
    recipe: 'Karottensuppe mit Ingwer',
    shopping: true,
  ),
  SeedMealPlan(
    4,
    'Mittagessen',
    by: 'anna',
    servings: 2,
    title: 'Reste vom Mittwoch',
    note: 'Suppe aufwärmen',
  ),
  SeedMealPlan(
    4,
    'Abendessen',
    by: 'ben',
    servings: 2,
    recipe: 'Mushroom Stroganoff',
    shopping: true,
  ),
  SeedMealPlan(
    5,
    'Abendessen',
    by: 'ben',
    servings: 2,
    title: 'Pizza bestellen',
  ),
  SeedMealPlan(6, 'Frühstück', by: 'ben', servings: 2, recipe: 'Pfannkuchen'),
  SeedMealPlan(
    6,
    'Abendessen',
    by: 'anna',
    servings: 6,
    recipe: 'Rindergulasch',
    note: 'Besuch von Freunden',
  ),
  SeedMealPlan(7, 'Frühstück', by: 'anna', servings: 2, recipe: 'Shakshuka'),
];

/// Extra shopping entries not tied to a recipe: food, amount, unit, creator.
const seedLooseShopping = <(String, num, String?, String)>[
  ('Milch', 2, 'l', 'anna'),
  ('Haferflocken', 500, 'g', 'ben'),
  ('Zitrone', 3, 'Stück', 'anna'),
];
