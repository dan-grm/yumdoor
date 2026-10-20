// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedUnit extends PatchedUnit {
  @override
  final String? baseUnit;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? openDataSlug;
  @override
  final String? pluralName;

  factory _$PatchedUnit([void Function(PatchedUnitBuilder)? updates]) =>
      (PatchedUnitBuilder()..update(updates))._build();

  _$PatchedUnit._({
    this.baseUnit,
    this.description,
    this.id,
    this.name,
    this.openDataSlug,
    this.pluralName,
  }) : super._();
  @override
  PatchedUnit rebuild(void Function(PatchedUnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedUnitBuilder toBuilder() => PatchedUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedUnit &&
        baseUnit == other.baseUnit &&
        description == other.description &&
        id == other.id &&
        name == other.name &&
        openDataSlug == other.openDataSlug &&
        pluralName == other.pluralName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseUnit.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, openDataSlug.hashCode);
    _$hash = $jc(_$hash, pluralName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedUnit')
          ..add('baseUnit', baseUnit)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug)
          ..add('pluralName', pluralName))
        .toString();
  }
}

class PatchedUnitBuilder implements Builder<PatchedUnit, PatchedUnitBuilder> {
  _$PatchedUnit? _$v;

  String? _baseUnit;
  String? get baseUnit => _$this._baseUnit;
  set baseUnit(String? baseUnit) => _$this._baseUnit = baseUnit;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _openDataSlug;
  String? get openDataSlug => _$this._openDataSlug;
  set openDataSlug(String? openDataSlug) => _$this._openDataSlug = openDataSlug;

  String? _pluralName;
  String? get pluralName => _$this._pluralName;
  set pluralName(String? pluralName) => _$this._pluralName = pluralName;

  PatchedUnitBuilder() {
    PatchedUnit._defaults(this);
  }

  PatchedUnitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseUnit = $v.baseUnit;
      _description = $v.description;
      _id = $v.id;
      _name = $v.name;
      _openDataSlug = $v.openDataSlug;
      _pluralName = $v.pluralName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedUnit other) {
    _$v = other as _$PatchedUnit;
  }

  @override
  void update(void Function(PatchedUnitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedUnit build() => _build();

  _$PatchedUnit _build() {
    final _$result =
        _$v ??
        _$PatchedUnit._(
          baseUnit: baseUnit,
          description: description,
          id: id,
          name: name,
          openDataSlug: openDataSlug,
          pluralName: pluralName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
