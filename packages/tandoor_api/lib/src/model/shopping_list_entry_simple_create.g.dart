// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_entry_simple_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ShoppingListEntrySimpleCreate extends ShoppingListEntrySimpleCreate {
  @override
  final double amount;
  @override
  final int? foodId;
  @override
  final int? ingredientId;
  @override
  final int? unitId;

  factory _$ShoppingListEntrySimpleCreate([
    void Function(ShoppingListEntrySimpleCreateBuilder)? updates,
  ]) => (ShoppingListEntrySimpleCreateBuilder()..update(updates))._build();

  _$ShoppingListEntrySimpleCreate._({
    required this.amount,
    this.foodId,
    this.ingredientId,
    this.unitId,
  }) : super._();
  @override
  ShoppingListEntrySimpleCreate rebuild(
    void Function(ShoppingListEntrySimpleCreateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ShoppingListEntrySimpleCreateBuilder toBuilder() =>
      ShoppingListEntrySimpleCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShoppingListEntrySimpleCreate &&
        amount == other.amount &&
        foodId == other.foodId &&
        ingredientId == other.ingredientId &&
        unitId == other.unitId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, foodId.hashCode);
    _$hash = $jc(_$hash, ingredientId.hashCode);
    _$hash = $jc(_$hash, unitId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShoppingListEntrySimpleCreate')
          ..add('amount', amount)
          ..add('foodId', foodId)
          ..add('ingredientId', ingredientId)
          ..add('unitId', unitId))
        .toString();
  }
}

class ShoppingListEntrySimpleCreateBuilder
    implements
        Builder<
          ShoppingListEntrySimpleCreate,
          ShoppingListEntrySimpleCreateBuilder
        > {
  _$ShoppingListEntrySimpleCreate? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  int? _foodId;
  int? get foodId => _$this._foodId;
  set foodId(int? foodId) => _$this._foodId = foodId;

  int? _ingredientId;
  int? get ingredientId => _$this._ingredientId;
  set ingredientId(int? ingredientId) => _$this._ingredientId = ingredientId;

  int? _unitId;
  int? get unitId => _$this._unitId;
  set unitId(int? unitId) => _$this._unitId = unitId;

  ShoppingListEntrySimpleCreateBuilder() {
    ShoppingListEntrySimpleCreate._defaults(this);
  }

  ShoppingListEntrySimpleCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _foodId = $v.foodId;
      _ingredientId = $v.ingredientId;
      _unitId = $v.unitId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShoppingListEntrySimpleCreate other) {
    _$v = other as _$ShoppingListEntrySimpleCreate;
  }

  @override
  void update(void Function(ShoppingListEntrySimpleCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShoppingListEntrySimpleCreate build() => _build();

  _$ShoppingListEntrySimpleCreate _build() {
    final _$result =
        _$v ??
        _$ShoppingListEntrySimpleCreate._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'ShoppingListEntrySimpleCreate',
            'amount',
          ),
          foodId: foodId,
          ingredientId: ingredientId,
          unitId: unitId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
