// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_property_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportPropertyType extends SourceImportPropertyType {
  @override
  final int? id;
  @override
  final String name;

  factory _$SourceImportPropertyType([
    void Function(SourceImportPropertyTypeBuilder)? updates,
  ]) => (SourceImportPropertyTypeBuilder()..update(updates))._build();

  _$SourceImportPropertyType._({this.id, required this.name}) : super._();
  @override
  SourceImportPropertyType rebuild(
    void Function(SourceImportPropertyTypeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SourceImportPropertyTypeBuilder toBuilder() =>
      SourceImportPropertyTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportPropertyType &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportPropertyType')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SourceImportPropertyTypeBuilder
    implements
        Builder<SourceImportPropertyType, SourceImportPropertyTypeBuilder> {
  _$SourceImportPropertyType? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SourceImportPropertyTypeBuilder() {
    SourceImportPropertyType._defaults(this);
  }

  SourceImportPropertyTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportPropertyType other) {
    _$v = other as _$SourceImportPropertyType;
  }

  @override
  void update(void Function(SourceImportPropertyTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportPropertyType build() => _build();

  _$SourceImportPropertyType _build() {
    final _$result =
        _$v ??
        _$SourceImportPropertyType._(
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SourceImportPropertyType',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
