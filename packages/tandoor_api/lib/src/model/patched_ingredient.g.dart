// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_ingredient.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedIngredient extends PatchedIngredient {
  @override
  final double? amount;
  @override
  final bool? checked;
  @override
  final BuiltList<JsonObject?>? conversions;
  @override
  final Food? food;
  @override
  final int? id;
  @override
  final bool? isHeader;
  @override
  final bool? noAmount;
  @override
  final String? note;
  @override
  final int? order;
  @override
  final String? originalText;
  @override
  final Unit? unit;
  @override
  final BuiltList<JsonObject?>? usedInRecipes;

  factory _$PatchedIngredient([
    void Function(PatchedIngredientBuilder)? updates,
  ]) => (PatchedIngredientBuilder()..update(updates))._build();

  _$PatchedIngredient._({
    this.amount,
    this.checked,
    this.conversions,
    this.food,
    this.id,
    this.isHeader,
    this.noAmount,
    this.note,
    this.order,
    this.originalText,
    this.unit,
    this.usedInRecipes,
  }) : super._();
  @override
  PatchedIngredient rebuild(void Function(PatchedIngredientBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedIngredientBuilder toBuilder() =>
      PatchedIngredientBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedIngredient &&
        amount == other.amount &&
        checked == other.checked &&
        conversions == other.conversions &&
        food == other.food &&
        id == other.id &&
        isHeader == other.isHeader &&
        noAmount == other.noAmount &&
        note == other.note &&
        order == other.order &&
        originalText == other.originalText &&
        unit == other.unit &&
        usedInRecipes == other.usedInRecipes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, checked.hashCode);
    _$hash = $jc(_$hash, conversions.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isHeader.hashCode);
    _$hash = $jc(_$hash, noAmount.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, originalText.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jc(_$hash, usedInRecipes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedIngredient')
          ..add('amount', amount)
          ..add('checked', checked)
          ..add('conversions', conversions)
          ..add('food', food)
          ..add('id', id)
          ..add('isHeader', isHeader)
          ..add('noAmount', noAmount)
          ..add('note', note)
          ..add('order', order)
          ..add('originalText', originalText)
          ..add('unit', unit)
          ..add('usedInRecipes', usedInRecipes))
        .toString();
  }
}

class PatchedIngredientBuilder
    implements Builder<PatchedIngredient, PatchedIngredientBuilder> {
  _$PatchedIngredient? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  bool? _checked;
  bool? get checked => _$this._checked;
  set checked(bool? checked) => _$this._checked = checked;

  ListBuilder<JsonObject?>? _conversions;
  ListBuilder<JsonObject?> get conversions =>
      _$this._conversions ??= ListBuilder<JsonObject?>();
  set conversions(ListBuilder<JsonObject?>? conversions) =>
      _$this._conversions = conversions;

  FoodBuilder? _food;
  FoodBuilder get food => _$this._food ??= FoodBuilder();
  set food(FoodBuilder? food) => _$this._food = food;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _isHeader;
  bool? get isHeader => _$this._isHeader;
  set isHeader(bool? isHeader) => _$this._isHeader = isHeader;

  bool? _noAmount;
  bool? get noAmount => _$this._noAmount;
  set noAmount(bool? noAmount) => _$this._noAmount = noAmount;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  String? _originalText;
  String? get originalText => _$this._originalText;
  set originalText(String? originalText) => _$this._originalText = originalText;

  UnitBuilder? _unit;
  UnitBuilder get unit => _$this._unit ??= UnitBuilder();
  set unit(UnitBuilder? unit) => _$this._unit = unit;

  ListBuilder<JsonObject?>? _usedInRecipes;
  ListBuilder<JsonObject?> get usedInRecipes =>
      _$this._usedInRecipes ??= ListBuilder<JsonObject?>();
  set usedInRecipes(ListBuilder<JsonObject?>? usedInRecipes) =>
      _$this._usedInRecipes = usedInRecipes;

  PatchedIngredientBuilder() {
    PatchedIngredient._defaults(this);
  }

  PatchedIngredientBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _checked = $v.checked;
      _conversions = $v.conversions?.toBuilder();
      _food = $v.food?.toBuilder();
      _id = $v.id;
      _isHeader = $v.isHeader;
      _noAmount = $v.noAmount;
      _note = $v.note;
      _order = $v.order;
      _originalText = $v.originalText;
      _unit = $v.unit?.toBuilder();
      _usedInRecipes = $v.usedInRecipes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedIngredient other) {
    _$v = other as _$PatchedIngredient;
  }

  @override
  void update(void Function(PatchedIngredientBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedIngredient build() => _build();

  _$PatchedIngredient _build() {
    _$PatchedIngredient _$result;
    try {
      _$result =
          _$v ??
          _$PatchedIngredient._(
            amount: amount,
            checked: checked,
            conversions: _conversions?.build(),
            food: _food?.build(),
            id: id,
            isHeader: isHeader,
            noAmount: noAmount,
            note: note,
            order: order,
            originalText: originalText,
            unit: _unit?.build(),
            usedInRecipes: _usedInRecipes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversions';
        _conversions?.build();
        _$failedField = 'food';
        _food?.build();

        _$failedField = 'unit';
        _unit?.build();
        _$failedField = 'usedInRecipes';
        _usedInRecipes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedIngredient',
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
