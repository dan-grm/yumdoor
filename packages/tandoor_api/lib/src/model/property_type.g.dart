// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PropertyType extends PropertyType {
  @override
  final String? description;
  @override
  final int? fdcId;
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? openDataSlug;
  @override
  final int? order;
  @override
  final String? unit;

  factory _$PropertyType([void Function(PropertyTypeBuilder)? updates]) =>
      (PropertyTypeBuilder()..update(updates))._build();

  _$PropertyType._({
    this.description,
    this.fdcId,
    this.id,
    required this.name,
    this.openDataSlug,
    this.order,
    this.unit,
  }) : super._();
  @override
  PropertyType rebuild(void Function(PropertyTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PropertyTypeBuilder toBuilder() => PropertyTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PropertyType &&
        description == other.description &&
        fdcId == other.fdcId &&
        id == other.id &&
        name == other.name &&
        openDataSlug == other.openDataSlug &&
        order == other.order &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, fdcId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, openDataSlug.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PropertyType')
          ..add('description', description)
          ..add('fdcId', fdcId)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug)
          ..add('order', order)
          ..add('unit', unit))
        .toString();
  }
}

class PropertyTypeBuilder
    implements Builder<PropertyType, PropertyTypeBuilder> {
  _$PropertyType? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _fdcId;
  int? get fdcId => _$this._fdcId;
  set fdcId(int? fdcId) => _$this._fdcId = fdcId;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _openDataSlug;
  String? get openDataSlug => _$this._openDataSlug;
  set openDataSlug(String? openDataSlug) => _$this._openDataSlug = openDataSlug;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  String? _unit;
  String? get unit => _$this._unit;
  set unit(String? unit) => _$this._unit = unit;

  PropertyTypeBuilder() {
    PropertyType._defaults(this);
  }

  PropertyTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _fdcId = $v.fdcId;
      _id = $v.id;
      _name = $v.name;
      _openDataSlug = $v.openDataSlug;
      _order = $v.order;
      _unit = $v.unit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PropertyType other) {
    _$v = other as _$PropertyType;
  }

  @override
  void update(void Function(PropertyTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PropertyType build() => _build();

  _$PropertyType _build() {
    final _$result =
        _$v ??
        _$PropertyType._(
          description: description,
          fdcId: fdcId,
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'PropertyType',
            'name',
          ),
          openDataSlug: openDataSlug,
          order: order,
          unit: unit,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
