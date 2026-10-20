// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_property.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportProperty extends SourceImportProperty {
  @override
  final double propertyAmount;
  @override
  final SourceImportPropertyType propertyType;

  factory _$SourceImportProperty([
    void Function(SourceImportPropertyBuilder)? updates,
  ]) => (SourceImportPropertyBuilder()..update(updates))._build();

  _$SourceImportProperty._({
    required this.propertyAmount,
    required this.propertyType,
  }) : super._();
  @override
  SourceImportProperty rebuild(
    void Function(SourceImportPropertyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SourceImportPropertyBuilder toBuilder() =>
      SourceImportPropertyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportProperty &&
        propertyAmount == other.propertyAmount &&
        propertyType == other.propertyType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, propertyAmount.hashCode);
    _$hash = $jc(_$hash, propertyType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportProperty')
          ..add('propertyAmount', propertyAmount)
          ..add('propertyType', propertyType))
        .toString();
  }
}

class SourceImportPropertyBuilder
    implements Builder<SourceImportProperty, SourceImportPropertyBuilder> {
  _$SourceImportProperty? _$v;

  double? _propertyAmount;
  double? get propertyAmount => _$this._propertyAmount;
  set propertyAmount(double? propertyAmount) =>
      _$this._propertyAmount = propertyAmount;

  SourceImportPropertyTypeBuilder? _propertyType;
  SourceImportPropertyTypeBuilder get propertyType =>
      _$this._propertyType ??= SourceImportPropertyTypeBuilder();
  set propertyType(SourceImportPropertyTypeBuilder? propertyType) =>
      _$this._propertyType = propertyType;

  SourceImportPropertyBuilder() {
    SourceImportProperty._defaults(this);
  }

  SourceImportPropertyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _propertyAmount = $v.propertyAmount;
      _propertyType = $v.propertyType.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportProperty other) {
    _$v = other as _$SourceImportProperty;
  }

  @override
  void update(void Function(SourceImportPropertyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportProperty build() => _build();

  _$SourceImportProperty _build() {
    _$SourceImportProperty _$result;
    try {
      _$result =
          _$v ??
          _$SourceImportProperty._(
            propertyAmount: BuiltValueNullFieldError.checkNotNull(
              propertyAmount,
              r'SourceImportProperty',
              'propertyAmount',
            ),
            propertyType: propertyType.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'propertyType';
        propertyType.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SourceImportProperty',
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
