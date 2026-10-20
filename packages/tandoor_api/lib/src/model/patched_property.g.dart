// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_property.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedProperty extends PatchedProperty {
  @override
  final int? id;
  @override
  final double? propertyAmount;
  @override
  final PropertyType? propertyType;

  factory _$PatchedProperty([void Function(PatchedPropertyBuilder)? updates]) =>
      (PatchedPropertyBuilder()..update(updates))._build();

  _$PatchedProperty._({this.id, this.propertyAmount, this.propertyType})
    : super._();
  @override
  PatchedProperty rebuild(void Function(PatchedPropertyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedPropertyBuilder toBuilder() => PatchedPropertyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedProperty &&
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
    return (newBuiltValueToStringHelper(r'PatchedProperty')
          ..add('id', id)
          ..add('propertyAmount', propertyAmount)
          ..add('propertyType', propertyType))
        .toString();
  }
}

class PatchedPropertyBuilder
    implements Builder<PatchedProperty, PatchedPropertyBuilder> {
  _$PatchedProperty? _$v;

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

  PatchedPropertyBuilder() {
    PatchedProperty._defaults(this);
  }

  PatchedPropertyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _propertyAmount = $v.propertyAmount;
      _propertyType = $v.propertyType?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedProperty other) {
    _$v = other as _$PatchedProperty;
  }

  @override
  void update(void Function(PatchedPropertyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedProperty build() => _build();

  _$PatchedProperty _build() {
    _$PatchedProperty _$result;
    try {
      _$result =
          _$v ??
          _$PatchedProperty._(
            id: id,
            propertyAmount: propertyAmount,
            propertyType: _propertyType?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'propertyType';
        _propertyType?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedProperty',
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
