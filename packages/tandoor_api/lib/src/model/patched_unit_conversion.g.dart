// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_unit_conversion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedUnitConversion extends PatchedUnitConversion {
  @override
  final double? baseAmount;
  @override
  final Unit? baseUnit;
  @override
  final double? convertedAmount;
  @override
  final Unit? convertedUnit;
  @override
  final Food? food;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? openDataSlug;

  factory _$PatchedUnitConversion([
    void Function(PatchedUnitConversionBuilder)? updates,
  ]) => (PatchedUnitConversionBuilder()..update(updates))._build();

  _$PatchedUnitConversion._({
    this.baseAmount,
    this.baseUnit,
    this.convertedAmount,
    this.convertedUnit,
    this.food,
    this.id,
    this.name,
    this.openDataSlug,
  }) : super._();
  @override
  PatchedUnitConversion rebuild(
    void Function(PatchedUnitConversionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedUnitConversionBuilder toBuilder() =>
      PatchedUnitConversionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedUnitConversion &&
        baseAmount == other.baseAmount &&
        baseUnit == other.baseUnit &&
        convertedAmount == other.convertedAmount &&
        convertedUnit == other.convertedUnit &&
        food == other.food &&
        id == other.id &&
        name == other.name &&
        openDataSlug == other.openDataSlug;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseAmount.hashCode);
    _$hash = $jc(_$hash, baseUnit.hashCode);
    _$hash = $jc(_$hash, convertedAmount.hashCode);
    _$hash = $jc(_$hash, convertedUnit.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, openDataSlug.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedUnitConversion')
          ..add('baseAmount', baseAmount)
          ..add('baseUnit', baseUnit)
          ..add('convertedAmount', convertedAmount)
          ..add('convertedUnit', convertedUnit)
          ..add('food', food)
          ..add('id', id)
          ..add('name', name)
          ..add('openDataSlug', openDataSlug))
        .toString();
  }
}

class PatchedUnitConversionBuilder
    implements Builder<PatchedUnitConversion, PatchedUnitConversionBuilder> {
  _$PatchedUnitConversion? _$v;

  double? _baseAmount;
  double? get baseAmount => _$this._baseAmount;
  set baseAmount(double? baseAmount) => _$this._baseAmount = baseAmount;

  UnitBuilder? _baseUnit;
  UnitBuilder get baseUnit => _$this._baseUnit ??= UnitBuilder();
  set baseUnit(UnitBuilder? baseUnit) => _$this._baseUnit = baseUnit;

  double? _convertedAmount;
  double? get convertedAmount => _$this._convertedAmount;
  set convertedAmount(double? convertedAmount) =>
      _$this._convertedAmount = convertedAmount;

  UnitBuilder? _convertedUnit;
  UnitBuilder get convertedUnit => _$this._convertedUnit ??= UnitBuilder();
  set convertedUnit(UnitBuilder? convertedUnit) =>
      _$this._convertedUnit = convertedUnit;

  FoodBuilder? _food;
  FoodBuilder get food => _$this._food ??= FoodBuilder();
  set food(FoodBuilder? food) => _$this._food = food;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _openDataSlug;
  String? get openDataSlug => _$this._openDataSlug;
  set openDataSlug(String? openDataSlug) => _$this._openDataSlug = openDataSlug;

  PatchedUnitConversionBuilder() {
    PatchedUnitConversion._defaults(this);
  }

  PatchedUnitConversionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseAmount = $v.baseAmount;
      _baseUnit = $v.baseUnit?.toBuilder();
      _convertedAmount = $v.convertedAmount;
      _convertedUnit = $v.convertedUnit?.toBuilder();
      _food = $v.food?.toBuilder();
      _id = $v.id;
      _name = $v.name;
      _openDataSlug = $v.openDataSlug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedUnitConversion other) {
    _$v = other as _$PatchedUnitConversion;
  }

  @override
  void update(void Function(PatchedUnitConversionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedUnitConversion build() => _build();

  _$PatchedUnitConversion _build() {
    _$PatchedUnitConversion _$result;
    try {
      _$result =
          _$v ??
          _$PatchedUnitConversion._(
            baseAmount: baseAmount,
            baseUnit: _baseUnit?.build(),
            convertedAmount: convertedAmount,
            convertedUnit: _convertedUnit?.build(),
            food: _food?.build(),
            id: id,
            name: name,
            openDataSlug: openDataSlug,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'baseUnit';
        _baseUnit?.build();

        _$failedField = 'convertedUnit';
        _convertedUnit?.build();
        _$failedField = 'food';
        _food?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedUnitConversion',
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
