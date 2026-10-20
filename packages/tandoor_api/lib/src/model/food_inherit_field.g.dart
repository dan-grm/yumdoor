// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_inherit_field.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FoodInheritField extends FoodInheritField {
  @override
  final String? field;
  @override
  final int? id;
  @override
  final String? name;

  factory _$FoodInheritField([
    void Function(FoodInheritFieldBuilder)? updates,
  ]) => (FoodInheritFieldBuilder()..update(updates))._build();

  _$FoodInheritField._({this.field, this.id, this.name}) : super._();
  @override
  FoodInheritField rebuild(void Function(FoodInheritFieldBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodInheritFieldBuilder toBuilder() =>
      FoodInheritFieldBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodInheritField &&
        field == other.field &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FoodInheritField')
          ..add('field', field)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class FoodInheritFieldBuilder
    implements Builder<FoodInheritField, FoodInheritFieldBuilder> {
  _$FoodInheritField? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  FoodInheritFieldBuilder() {
    FoodInheritField._defaults(this);
  }

  FoodInheritFieldBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _field = $v.field;
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodInheritField other) {
    _$v = other as _$FoodInheritField;
  }

  @override
  void update(void Function(FoodInheritFieldBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodInheritField build() => _build();

  _$FoodInheritField _build() {
    final _$result =
        _$v ?? _$FoodInheritField._(field: field, id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
