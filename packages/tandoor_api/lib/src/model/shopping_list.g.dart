// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ShoppingList extends ShoppingList {
  @override
  final String? color;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String? name;

  factory _$ShoppingList([void Function(ShoppingListBuilder)? updates]) =>
      (ShoppingListBuilder()..update(updates))._build();

  _$ShoppingList._({this.color, this.description, this.id, this.name})
    : super._();
  @override
  ShoppingList rebuild(void Function(ShoppingListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShoppingListBuilder toBuilder() => ShoppingListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShoppingList &&
        color == other.color &&
        description == other.description &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShoppingList')
          ..add('color', color)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class ShoppingListBuilder
    implements Builder<ShoppingList, ShoppingListBuilder> {
  _$ShoppingList? _$v;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ShoppingListBuilder() {
    ShoppingList._defaults(this);
  }

  ShoppingListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _color = $v.color;
      _description = $v.description;
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShoppingList other) {
    _$v = other as _$ShoppingList;
  }

  @override
  void update(void Function(ShoppingListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShoppingList build() => _build();

  _$ShoppingList _build() {
    final _$result =
        _$v ??
        _$ShoppingList._(
          color: color,
          description: description,
          id: id,
          name: name,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
