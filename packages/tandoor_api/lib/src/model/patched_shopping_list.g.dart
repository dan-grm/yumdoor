// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_shopping_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedShoppingList extends PatchedShoppingList {
  @override
  final String? color;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String? name;

  factory _$PatchedShoppingList([
    void Function(PatchedShoppingListBuilder)? updates,
  ]) => (PatchedShoppingListBuilder()..update(updates))._build();

  _$PatchedShoppingList._({this.color, this.description, this.id, this.name})
    : super._();
  @override
  PatchedShoppingList rebuild(
    void Function(PatchedShoppingListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedShoppingListBuilder toBuilder() =>
      PatchedShoppingListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedShoppingList &&
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
    return (newBuiltValueToStringHelper(r'PatchedShoppingList')
          ..add('color', color)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class PatchedShoppingListBuilder
    implements Builder<PatchedShoppingList, PatchedShoppingListBuilder> {
  _$PatchedShoppingList? _$v;

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

  PatchedShoppingListBuilder() {
    PatchedShoppingList._defaults(this);
  }

  PatchedShoppingListBuilder get _$this {
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
  void replace(PatchedShoppingList other) {
    _$v = other as _$PatchedShoppingList;
  }

  @override
  void update(void Function(PatchedShoppingListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedShoppingList build() => _build();

  _$PatchedShoppingList _build() {
    final _$result =
        _$v ??
        _$PatchedShoppingList._(
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
