// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_simple.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IngredientSimple extends IngredientSimple {
  @override
  final double amount;
  @override
  final bool? checked;
  @override
  final FoodSimple? food;
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

  factory _$IngredientSimple([
    void Function(IngredientSimpleBuilder)? updates,
  ]) => (IngredientSimpleBuilder()..update(updates))._build();

  _$IngredientSimple._({
    required this.amount,
    this.checked,
    this.food,
    this.id,
    this.isHeader,
    this.noAmount,
    this.note,
    this.order,
    this.originalText,
    this.unit,
  }) : super._();
  @override
  IngredientSimple rebuild(void Function(IngredientSimpleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IngredientSimpleBuilder toBuilder() =>
      IngredientSimpleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IngredientSimple &&
        amount == other.amount &&
        checked == other.checked &&
        food == other.food &&
        id == other.id &&
        isHeader == other.isHeader &&
        noAmount == other.noAmount &&
        note == other.note &&
        order == other.order &&
        originalText == other.originalText &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, checked.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isHeader.hashCode);
    _$hash = $jc(_$hash, noAmount.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, originalText.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IngredientSimple')
          ..add('amount', amount)
          ..add('checked', checked)
          ..add('food', food)
          ..add('id', id)
          ..add('isHeader', isHeader)
          ..add('noAmount', noAmount)
          ..add('note', note)
          ..add('order', order)
          ..add('originalText', originalText)
          ..add('unit', unit))
        .toString();
  }
}

class IngredientSimpleBuilder
    implements Builder<IngredientSimple, IngredientSimpleBuilder> {
  _$IngredientSimple? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  bool? _checked;
  bool? get checked => _$this._checked;
  set checked(bool? checked) => _$this._checked = checked;

  FoodSimpleBuilder? _food;
  FoodSimpleBuilder get food => _$this._food ??= FoodSimpleBuilder();
  set food(FoodSimpleBuilder? food) => _$this._food = food;

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

  IngredientSimpleBuilder() {
    IngredientSimple._defaults(this);
  }

  IngredientSimpleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _checked = $v.checked;
      _food = $v.food?.toBuilder();
      _id = $v.id;
      _isHeader = $v.isHeader;
      _noAmount = $v.noAmount;
      _note = $v.note;
      _order = $v.order;
      _originalText = $v.originalText;
      _unit = $v.unit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IngredientSimple other) {
    _$v = other as _$IngredientSimple;
  }

  @override
  void update(void Function(IngredientSimpleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IngredientSimple build() => _build();

  _$IngredientSimple _build() {
    _$IngredientSimple _$result;
    try {
      _$result =
          _$v ??
          _$IngredientSimple._(
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'IngredientSimple',
              'amount',
            ),
            checked: checked,
            food: _food?.build(),
            id: id,
            isHeader: isHeader,
            noAmount: noAmount,
            note: note,
            order: order,
            originalText: originalText,
            unit: _unit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'food';
        _food?.build();

        _$failedField = 'unit';
        _unit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'IngredientSimple',
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
