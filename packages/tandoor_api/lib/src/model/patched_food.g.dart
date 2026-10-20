// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_food.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedFood extends PatchedFood {
  @override
  final BuiltList<FoodInheritField>? childInheritFields;
  @override
  final String? description;
  @override
  final int? fdcId;
  @override
  final bool? foodOnhand;
  @override
  final String? fullName;
  @override
  final int? id;
  @override
  final bool? ignoreShopping;
  @override
  final BuiltList<FoodInheritField>? inheritFields;
  @override
  final String? name;
  @override
  final int? numchild;
  @override
  final String? openDataSlug;
  @override
  final int? parent;
  @override
  final String? pluralName;
  @override
  final BuiltList<Property>? properties;
  @override
  final double? propertiesFoodAmount;
  @override
  final Unit? propertiesFoodUnit;
  @override
  final RecipeSimple? recipe;
  @override
  final String? shopping;
  @override
  final BuiltList<ShoppingList>? shoppingLists;
  @override
  final BuiltList<FoodSimple>? substitute;
  @override
  final bool? substituteChildren;
  @override
  final bool? substituteOnhand;
  @override
  final bool? substituteSiblings;
  @override
  final SupermarketCategory? supermarketCategory;
  @override
  final String? url;

  factory _$PatchedFood([void Function(PatchedFoodBuilder)? updates]) =>
      (PatchedFoodBuilder()..update(updates))._build();

  _$PatchedFood._({
    this.childInheritFields,
    this.description,
    this.fdcId,
    this.foodOnhand,
    this.fullName,
    this.id,
    this.ignoreShopping,
    this.inheritFields,
    this.name,
    this.numchild,
    this.openDataSlug,
    this.parent,
    this.pluralName,
    this.properties,
    this.propertiesFoodAmount,
    this.propertiesFoodUnit,
    this.recipe,
    this.shopping,
    this.shoppingLists,
    this.substitute,
    this.substituteChildren,
    this.substituteOnhand,
    this.substituteSiblings,
    this.supermarketCategory,
    this.url,
  }) : super._();
  @override
  PatchedFood rebuild(void Function(PatchedFoodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedFoodBuilder toBuilder() => PatchedFoodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedFood &&
        childInheritFields == other.childInheritFields &&
        description == other.description &&
        fdcId == other.fdcId &&
        foodOnhand == other.foodOnhand &&
        fullName == other.fullName &&
        id == other.id &&
        ignoreShopping == other.ignoreShopping &&
        inheritFields == other.inheritFields &&
        name == other.name &&
        numchild == other.numchild &&
        openDataSlug == other.openDataSlug &&
        parent == other.parent &&
        pluralName == other.pluralName &&
        properties == other.properties &&
        propertiesFoodAmount == other.propertiesFoodAmount &&
        propertiesFoodUnit == other.propertiesFoodUnit &&
        recipe == other.recipe &&
        shopping == other.shopping &&
        shoppingLists == other.shoppingLists &&
        substitute == other.substitute &&
        substituteChildren == other.substituteChildren &&
        substituteOnhand == other.substituteOnhand &&
        substituteSiblings == other.substituteSiblings &&
        supermarketCategory == other.supermarketCategory &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, childInheritFields.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, fdcId.hashCode);
    _$hash = $jc(_$hash, foodOnhand.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ignoreShopping.hashCode);
    _$hash = $jc(_$hash, inheritFields.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, numchild.hashCode);
    _$hash = $jc(_$hash, openDataSlug.hashCode);
    _$hash = $jc(_$hash, parent.hashCode);
    _$hash = $jc(_$hash, pluralName.hashCode);
    _$hash = $jc(_$hash, properties.hashCode);
    _$hash = $jc(_$hash, propertiesFoodAmount.hashCode);
    _$hash = $jc(_$hash, propertiesFoodUnit.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jc(_$hash, shopping.hashCode);
    _$hash = $jc(_$hash, shoppingLists.hashCode);
    _$hash = $jc(_$hash, substitute.hashCode);
    _$hash = $jc(_$hash, substituteChildren.hashCode);
    _$hash = $jc(_$hash, substituteOnhand.hashCode);
    _$hash = $jc(_$hash, substituteSiblings.hashCode);
    _$hash = $jc(_$hash, supermarketCategory.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedFood')
          ..add('childInheritFields', childInheritFields)
          ..add('description', description)
          ..add('fdcId', fdcId)
          ..add('foodOnhand', foodOnhand)
          ..add('fullName', fullName)
          ..add('id', id)
          ..add('ignoreShopping', ignoreShopping)
          ..add('inheritFields', inheritFields)
          ..add('name', name)
          ..add('numchild', numchild)
          ..add('openDataSlug', openDataSlug)
          ..add('parent', parent)
          ..add('pluralName', pluralName)
          ..add('properties', properties)
          ..add('propertiesFoodAmount', propertiesFoodAmount)
          ..add('propertiesFoodUnit', propertiesFoodUnit)
          ..add('recipe', recipe)
          ..add('shopping', shopping)
          ..add('shoppingLists', shoppingLists)
          ..add('substitute', substitute)
          ..add('substituteChildren', substituteChildren)
          ..add('substituteOnhand', substituteOnhand)
          ..add('substituteSiblings', substituteSiblings)
          ..add('supermarketCategory', supermarketCategory)
          ..add('url', url))
        .toString();
  }
}

class PatchedFoodBuilder implements Builder<PatchedFood, PatchedFoodBuilder> {
  _$PatchedFood? _$v;

  ListBuilder<FoodInheritField>? _childInheritFields;
  ListBuilder<FoodInheritField> get childInheritFields =>
      _$this._childInheritFields ??= ListBuilder<FoodInheritField>();
  set childInheritFields(ListBuilder<FoodInheritField>? childInheritFields) =>
      _$this._childInheritFields = childInheritFields;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _fdcId;
  int? get fdcId => _$this._fdcId;
  set fdcId(int? fdcId) => _$this._fdcId = fdcId;

  bool? _foodOnhand;
  bool? get foodOnhand => _$this._foodOnhand;
  set foodOnhand(bool? foodOnhand) => _$this._foodOnhand = foodOnhand;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _ignoreShopping;
  bool? get ignoreShopping => _$this._ignoreShopping;
  set ignoreShopping(bool? ignoreShopping) =>
      _$this._ignoreShopping = ignoreShopping;

  ListBuilder<FoodInheritField>? _inheritFields;
  ListBuilder<FoodInheritField> get inheritFields =>
      _$this._inheritFields ??= ListBuilder<FoodInheritField>();
  set inheritFields(ListBuilder<FoodInheritField>? inheritFields) =>
      _$this._inheritFields = inheritFields;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _numchild;
  int? get numchild => _$this._numchild;
  set numchild(int? numchild) => _$this._numchild = numchild;

  String? _openDataSlug;
  String? get openDataSlug => _$this._openDataSlug;
  set openDataSlug(String? openDataSlug) => _$this._openDataSlug = openDataSlug;

  int? _parent;
  int? get parent => _$this._parent;
  set parent(int? parent) => _$this._parent = parent;

  String? _pluralName;
  String? get pluralName => _$this._pluralName;
  set pluralName(String? pluralName) => _$this._pluralName = pluralName;

  ListBuilder<Property>? _properties;
  ListBuilder<Property> get properties =>
      _$this._properties ??= ListBuilder<Property>();
  set properties(ListBuilder<Property>? properties) =>
      _$this._properties = properties;

  double? _propertiesFoodAmount;
  double? get propertiesFoodAmount => _$this._propertiesFoodAmount;
  set propertiesFoodAmount(double? propertiesFoodAmount) =>
      _$this._propertiesFoodAmount = propertiesFoodAmount;

  UnitBuilder? _propertiesFoodUnit;
  UnitBuilder get propertiesFoodUnit =>
      _$this._propertiesFoodUnit ??= UnitBuilder();
  set propertiesFoodUnit(UnitBuilder? propertiesFoodUnit) =>
      _$this._propertiesFoodUnit = propertiesFoodUnit;

  RecipeSimpleBuilder? _recipe;
  RecipeSimpleBuilder get recipe => _$this._recipe ??= RecipeSimpleBuilder();
  set recipe(RecipeSimpleBuilder? recipe) => _$this._recipe = recipe;

  String? _shopping;
  String? get shopping => _$this._shopping;
  set shopping(String? shopping) => _$this._shopping = shopping;

  ListBuilder<ShoppingList>? _shoppingLists;
  ListBuilder<ShoppingList> get shoppingLists =>
      _$this._shoppingLists ??= ListBuilder<ShoppingList>();
  set shoppingLists(ListBuilder<ShoppingList>? shoppingLists) =>
      _$this._shoppingLists = shoppingLists;

  ListBuilder<FoodSimple>? _substitute;
  ListBuilder<FoodSimple> get substitute =>
      _$this._substitute ??= ListBuilder<FoodSimple>();
  set substitute(ListBuilder<FoodSimple>? substitute) =>
      _$this._substitute = substitute;

  bool? _substituteChildren;
  bool? get substituteChildren => _$this._substituteChildren;
  set substituteChildren(bool? substituteChildren) =>
      _$this._substituteChildren = substituteChildren;

  bool? _substituteOnhand;
  bool? get substituteOnhand => _$this._substituteOnhand;
  set substituteOnhand(bool? substituteOnhand) =>
      _$this._substituteOnhand = substituteOnhand;

  bool? _substituteSiblings;
  bool? get substituteSiblings => _$this._substituteSiblings;
  set substituteSiblings(bool? substituteSiblings) =>
      _$this._substituteSiblings = substituteSiblings;

  SupermarketCategoryBuilder? _supermarketCategory;
  SupermarketCategoryBuilder get supermarketCategory =>
      _$this._supermarketCategory ??= SupermarketCategoryBuilder();
  set supermarketCategory(SupermarketCategoryBuilder? supermarketCategory) =>
      _$this._supermarketCategory = supermarketCategory;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  PatchedFoodBuilder() {
    PatchedFood._defaults(this);
  }

  PatchedFoodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _childInheritFields = $v.childInheritFields?.toBuilder();
      _description = $v.description;
      _fdcId = $v.fdcId;
      _foodOnhand = $v.foodOnhand;
      _fullName = $v.fullName;
      _id = $v.id;
      _ignoreShopping = $v.ignoreShopping;
      _inheritFields = $v.inheritFields?.toBuilder();
      _name = $v.name;
      _numchild = $v.numchild;
      _openDataSlug = $v.openDataSlug;
      _parent = $v.parent;
      _pluralName = $v.pluralName;
      _properties = $v.properties?.toBuilder();
      _propertiesFoodAmount = $v.propertiesFoodAmount;
      _propertiesFoodUnit = $v.propertiesFoodUnit?.toBuilder();
      _recipe = $v.recipe?.toBuilder();
      _shopping = $v.shopping;
      _shoppingLists = $v.shoppingLists?.toBuilder();
      _substitute = $v.substitute?.toBuilder();
      _substituteChildren = $v.substituteChildren;
      _substituteOnhand = $v.substituteOnhand;
      _substituteSiblings = $v.substituteSiblings;
      _supermarketCategory = $v.supermarketCategory?.toBuilder();
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedFood other) {
    _$v = other as _$PatchedFood;
  }

  @override
  void update(void Function(PatchedFoodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedFood build() => _build();

  _$PatchedFood _build() {
    _$PatchedFood _$result;
    try {
      _$result =
          _$v ??
          _$PatchedFood._(
            childInheritFields: _childInheritFields?.build(),
            description: description,
            fdcId: fdcId,
            foodOnhand: foodOnhand,
            fullName: fullName,
            id: id,
            ignoreShopping: ignoreShopping,
            inheritFields: _inheritFields?.build(),
            name: name,
            numchild: numchild,
            openDataSlug: openDataSlug,
            parent: parent,
            pluralName: pluralName,
            properties: _properties?.build(),
            propertiesFoodAmount: propertiesFoodAmount,
            propertiesFoodUnit: _propertiesFoodUnit?.build(),
            recipe: _recipe?.build(),
            shopping: shopping,
            shoppingLists: _shoppingLists?.build(),
            substitute: _substitute?.build(),
            substituteChildren: substituteChildren,
            substituteOnhand: substituteOnhand,
            substituteSiblings: substituteSiblings,
            supermarketCategory: _supermarketCategory?.build(),
            url: url,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'childInheritFields';
        _childInheritFields?.build();

        _$failedField = 'inheritFields';
        _inheritFields?.build();

        _$failedField = 'properties';
        _properties?.build();

        _$failedField = 'propertiesFoodUnit';
        _propertiesFoodUnit?.build();
        _$failedField = 'recipe';
        _recipe?.build();

        _$failedField = 'shoppingLists';
        _shoppingLists?.build();
        _$failedField = 'substitute';
        _substitute?.build();

        _$failedField = 'supermarketCategory';
        _supermarketCategory?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedFood',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
