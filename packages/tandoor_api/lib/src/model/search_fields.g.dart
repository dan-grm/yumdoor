// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_fields.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchFields extends SearchFields {
  @override
  final String? field;
  @override
  final int? id;
  @override
  final String? name;

  factory _$SearchFields([void Function(SearchFieldsBuilder)? updates]) =>
      (SearchFieldsBuilder()..update(updates))._build();

  _$SearchFields._({this.field, this.id, this.name}) : super._();
  @override
  SearchFields rebuild(void Function(SearchFieldsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchFieldsBuilder toBuilder() => SearchFieldsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchFields &&
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
    return (newBuiltValueToStringHelper(r'SearchFields')
          ..add('field', field)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SearchFieldsBuilder
    implements Builder<SearchFields, SearchFieldsBuilder> {
  _$SearchFields? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SearchFieldsBuilder() {
    SearchFields._defaults(this);
  }

  SearchFieldsBuilder get _$this {
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
  void replace(SearchFields other) {
    _$v = other as _$SearchFields;
  }

  @override
  void update(void Function(SearchFieldsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchFields build() => _build();

  _$SearchFields _build() {
    final _$result = _$v ?? _$SearchFields._(field: field, id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
