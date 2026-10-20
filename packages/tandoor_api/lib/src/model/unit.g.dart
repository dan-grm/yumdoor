// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Unit extends Unit {
  @override
  final String? baseUnit;
  @override
  final String? description;
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? openDataSlug;
  @override
  final String? pluralName;

  factory _$Unit([void Function(UnitBuilder)? updates]) =>
      (UnitBuilder()..update(updates))._build();

  _$Unit._({
    this.baseUnit,
    this.description,
    this.id,
    required this.name,
    this.openDataSlug,
    this.pluralName,
  }) : super._();
  @override
  Unit rebuild(void Function(UnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnitBuilder toBuilder() => UnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Unit &&
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
    return (newBuiltValueToStringHelper(r'Unit')
          ..add('baseUnit', baseUnit)
          ..add('description', description)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug)
          ..add('pluralName', pluralName))
        .toString();
  }
}

class UnitBuilder implements Builder<Unit, UnitBuilder> {
  _$Unit? _$v;

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

  UnitBuilder() {
    Unit._defaults(this);
  }

  UnitBuilder get _$this {
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
  void replace(Unit other) {
    _$v = other as _$Unit;
  }

  @override
  void update(void Function(UnitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Unit build() => _build();

  _$Unit _build() {
    final _$result =
        _$v ??
        _$Unit._(
          baseUnit: baseUnit,
          description: description,
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(name, r'Unit', 'name'),
          openDataSlug: openDataSlug,
          pluralName: pluralName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
