// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_shopping_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FoodShoppingUpdate extends FoodShoppingUpdate {
  @override
  final int? amount;
  @override
  final DeleteEnum? delete;
  @override
  final int? id;
  @override
  final int? unit;

  factory _$FoodShoppingUpdate([
    void Function(FoodShoppingUpdateBuilder)? updates,
  ]) => (FoodShoppingUpdateBuilder()..update(updates))._build();

  _$FoodShoppingUpdate._({this.amount, this.delete, this.id, this.unit})
    : super._();
  @override
  FoodShoppingUpdate rebuild(
    void Function(FoodShoppingUpdateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FoodShoppingUpdateBuilder toBuilder() =>
      FoodShoppingUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodShoppingUpdate &&
        amount == other.amount &&
        delete == other.delete &&
        id == other.id &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, delete.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FoodShoppingUpdate')
          ..add('amount', amount)
          ..add('delete', delete)
          ..add('id', id)
          ..add('unit', unit))
        .toString();
  }
}

class FoodShoppingUpdateBuilder
    implements Builder<FoodShoppingUpdate, FoodShoppingUpdateBuilder> {
  _$FoodShoppingUpdate? _$v;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  DeleteEnum? _delete;
  DeleteEnum? get delete => _$this._delete;
  set delete(DeleteEnum? delete) => _$this._delete = delete;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _unit;
  int? get unit => _$this._unit;
  set unit(int? unit) => _$this._unit = unit;

  FoodShoppingUpdateBuilder() {
    FoodShoppingUpdate._defaults(this);
  }

  FoodShoppingUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _delete = $v.delete;
      _id = $v.id;
      _unit = $v.unit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodShoppingUpdate other) {
    _$v = other as _$FoodShoppingUpdate;
  }

  @override
  void update(void Function(FoodShoppingUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodShoppingUpdate build() => _build();

  _$FoodShoppingUpdate _build() {
    final _$result =
        _$v ??
        _$FoodShoppingUpdate._(
          amount: amount,
          delete: delete,
          id: id,
          unit: unit,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
