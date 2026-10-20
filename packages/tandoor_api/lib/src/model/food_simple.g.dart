// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_simple.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FoodSimple extends FoodSimple {
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? pluralName;

  factory _$FoodSimple([void Function(FoodSimpleBuilder)? updates]) =>
      (FoodSimpleBuilder()..update(updates))._build();

  _$FoodSimple._({this.id, required this.name, this.pluralName}) : super._();
  @override
  FoodSimple rebuild(void Function(FoodSimpleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodSimpleBuilder toBuilder() => FoodSimpleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodSimple &&
        id == other.id &&
        name == other.name &&
        pluralName == other.pluralName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, pluralName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FoodSimple')
          ..add('id', id)
          ..add('name', name)
          ..add('pluralName', pluralName))
        .toString();
  }
}

class FoodSimpleBuilder implements Builder<FoodSimple, FoodSimpleBuilder> {
  _$FoodSimple? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _pluralName;
  String? get pluralName => _$this._pluralName;
  set pluralName(String? pluralName) => _$this._pluralName = pluralName;

  FoodSimpleBuilder() {
    FoodSimple._defaults(this);
  }

  FoodSimpleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _pluralName = $v.pluralName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodSimple other) {
    _$v = other as _$FoodSimple;
  }

  @override
  void update(void Function(FoodSimpleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodSimple build() => _build();

  _$FoodSimple _build() {
    final _$result =
        _$v ??
        _$FoodSimple._(
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'FoodSimple',
            'name',
          ),
          pluralName: pluralName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
