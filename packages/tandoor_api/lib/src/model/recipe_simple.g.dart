// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_simple.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeSimple extends RecipeSimple {
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? url;

  factory _$RecipeSimple([void Function(RecipeSimpleBuilder)? updates]) =>
      (RecipeSimpleBuilder()..update(updates))._build();

  _$RecipeSimple._({this.id, required this.name, this.url}) : super._();
  @override
  RecipeSimple rebuild(void Function(RecipeSimpleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeSimpleBuilder toBuilder() => RecipeSimpleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeSimple &&
        id == other.id &&
        name == other.name &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeSimple')
          ..add('id', id)
          ..add('name', name)
          ..add('url', url))
        .toString();
  }
}

class RecipeSimpleBuilder
    implements Builder<RecipeSimple, RecipeSimpleBuilder> {
  _$RecipeSimple? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  RecipeSimpleBuilder() {
    RecipeSimple._defaults(this);
  }

  RecipeSimpleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeSimple other) {
    _$v = other as _$RecipeSimple;
  }

  @override
  void update(void Function(RecipeSimpleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeSimple build() => _build();

  _$RecipeSimple _build() {
    final _$result =
        _$v ??
        _$RecipeSimple._(
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'RecipeSimple',
            'name',
          ),
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
