// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Property extends Property {
  @override
  final int? id;
  @override
  final double? propertyAmount;
  @override
  final PropertyType propertyType;

  factory _$Property([void Function(PropertyBuilder)? updates]) =>
      (PropertyBuilder()..update(updates))._build();

  _$Property._({this.id, this.propertyAmount, required this.propertyType})
    : super._();
  @override
  Property rebuild(void Function(PropertyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PropertyBuilder toBuilder() => PropertyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Property &&
        id == other.id &&
        propertyAmount == other.propertyAmount &&
        propertyType == other.propertyType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, propertyAmount.hashCode);
    _$hash = $jc(_$hash, propertyType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Property')
          ..add('id', id)
          ..add('propertyAmount', propertyAmount)
          ..add('propertyType', propertyType))
        .toString();
  }
}

class PropertyBuilder implements Builder<Property, PropertyBuilder> {
  _$Property? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  double? _propertyAmount;
  double? get propertyAmount => _$this._propertyAmount;
  set propertyAmount(double? propertyAmount) =>
      _$this._propertyAmount = propertyAmount;

  PropertyTypeBuilder? _propertyType;
  PropertyTypeBuilder get propertyType =>
      _$this._propertyType ??= PropertyTypeBuilder();
  set propertyType(PropertyTypeBuilder? propertyType) =>
      _$this._propertyType = propertyType;

  PropertyBuilder() {
    Property._defaults(this);
  }

  PropertyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _propertyAmount = $v.propertyAmount;
      _propertyType = $v.propertyType.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Property other) {
    _$v = other as _$Property;
  }

  @override
  void update(void Function(PropertyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Property build() => _build();

  _$Property _build() {
    _$Property _$result;
    try {
      _$result =
          _$v ??
          _$Property._(
            id: id,
            propertyAmount: propertyAmount,
            propertyType: propertyType.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'propertyType';
        propertyType.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Property',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
