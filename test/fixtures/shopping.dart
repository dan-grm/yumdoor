import 'package:yumdoor/domain/models/shopping.dart';
import 'package:yumdoor/domain/models/unit.dart';
import 'package:yumdoor/domain/models/user_ref.dart';

/// The shopping list of mockup 12-einkaufsliste, for tests.

const produce = SupermarketCategory(id: 1, name: 'Obst und Gemüse');
const chilled = SupermarketCategory(id: 2, name: 'Kühlregal');
const pantry = SupermarketCategory(id: 3, name: 'Vorrat');

/// Walks through the store from fruit and vegetables to the pantry.
const marketAmEck = Supermarket(
  id: 7,
  name: 'Markt am Eck',
  categoryIds: [1, 2, 3],
);
const bioladen = Supermarket(id: 8, name: 'Bioladen', categoryIds: [3, 2, 1]);

const anna = UserRef(id: 1, name: 'Anna');
const lena = UserRef(id: 2, name: 'Lena');

const _gram = Unit(id: 10, name: 'g');
const _kilo = Unit(id: 11, name: 'kg');
const _bunch = Unit(id: 12, name: 'Bund');
const _piece = Unit(id: 13, name: 'Stück');

const _carrot = ShoppingFood(
  id: 1,
  name: 'Karotte',
  pluralName: 'Karotten',
  category: produce,
);
const _pumpkin = ShoppingFood(
  id: 2,
  name: 'Hokkaido-Kürbis',
  category: produce,
);
const _parsley = ShoppingFood(id: 3, name: 'Petersilie', category: produce);
const _feta = ShoppingFood(id: 4, name: 'Feta', category: chilled);
const _parmesan = ShoppingFood(id: 5, name: 'Parmesan', category: chilled);
const _rice = ShoppingFood(id: 6, name: 'Risottoreis', category: pantry);
const _lemon = ShoppingFood(
  id: 7,
  name: 'Zitrone',
  pluralName: 'Zitronen',
  category: pantry,
);
const _oil = ShoppingFood(id: 8, name: 'Olivenöl', category: pantry);
const _onion = ShoppingFood(
  id: 9,
  name: 'Zwiebel',
  pluralName: 'Zwiebeln',
  category: produce,
);
const _milk = ShoppingFood(id: 10, name: 'Milch', category: chilled);

final _added = DateTime.utc(2026, 11, 16, 9);
final _bought = DateTime.utc(2026, 11, 17, 18);

ShoppingEntrySource _recipe(int id, String name) => ShoppingEntrySource(
  listRecipeId: id,
  recipeId: id,
  recipeName: name,
  servings: 4,
);

ShoppingEntry _entry(
  int id,
  ShoppingFood food,
  double amount, {
  Unit? unit,
  ShoppingEntrySource? source,
  UserRef createdBy = anna,
  bool checked = false,
}) => ShoppingEntry(
  id: id,
  food: food,
  unit: unit,
  amount: amount,
  checked: checked,
  completedAt: checked ? _bought : null,
  updatedAt: checked ? _bought : _added,
  createdBy: createdBy,
  source: source,
);

final _ofenkarotten = _recipe(1, 'Ofenkarotten');
final _bolognese = _recipe(2, 'Linsen-Bolognese');
final _risotto = _recipe(3, 'Kürbis-Risotto');

/// Seven open rows (two entries of carrots merge into "1,1 kg") and three
/// checked off.
List<ShoppingEntry> mockupShoppingList() => [
  _entry(101, _carrot, 0.6, unit: _kilo, source: _ofenkarotten),
  _entry(102, _carrot, 0.5, unit: _kilo, source: _bolognese),
  _entry(103, _pumpkin, 1, unit: _piece, source: _risotto),
  _entry(104, _parsley, 0.5, unit: _bunch, source: _ofenkarotten),
  _entry(105, _feta, 200, unit: _gram, source: _ofenkarotten),
  _entry(106, _parmesan, 80, unit: _gram, source: _risotto),
  _entry(107, _rice, 320, unit: _gram, source: _risotto),
  _entry(108, _lemon, 2, createdBy: lena),
  _entry(109, _oil, 0, checked: true),
  _entry(110, _onion, 2, source: _bolognese, checked: true),
  _entry(111, _milk, 1, checked: true, createdBy: lena),
];
