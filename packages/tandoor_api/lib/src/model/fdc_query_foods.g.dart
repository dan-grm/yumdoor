// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fdc_query_foods.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FdcQueryFoods extends FdcQueryFoods {
  @override
  final String dataType;
  @override
  final String description;
  @override
  final int fdcId;

  factory _$FdcQueryFoods([void Function(FdcQueryFoodsBuilder)? updates]) =>
      (FdcQueryFoodsBuilder()..update(updates))._build();

  _$FdcQueryFoods._({
    required this.dataType,
    required this.description,
    required this.fdcId,
  }) : super._();
  @override
  FdcQueryFoods rebuild(void Function(FdcQueryFoodsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FdcQueryFoodsBuilder toBuilder() => FdcQueryFoodsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FdcQueryFoods &&
        dataType == other.dataType &&
        description == other.description &&
        fdcId == other.fdcId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dataType.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, fdcId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FdcQueryFoods')
          ..add('dataType', dataType)
          ..add('description', description)
          ..add('fdcId', fdcId))
        .toString();
  }
}

class FdcQueryFoodsBuilder
    implements Builder<FdcQueryFoods, FdcQueryFoodsBuilder> {
  _$FdcQueryFoods? _$v;

  String? _dataType;
  String? get dataType => _$this._dataType;
  set dataType(String? dataType) => _$this._dataType = dataType;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _fdcId;
  int? get fdcId => _$this._fdcId;
  set fdcId(int? fdcId) => _$this._fdcId = fdcId;

  FdcQueryFoodsBuilder() {
    FdcQueryFoods._defaults(this);
  }

  FdcQueryFoodsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dataType = $v.dataType;
      _description = $v.description;
      _fdcId = $v.fdcId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FdcQueryFoods other) {
    _$v = other as _$FdcQueryFoods;
  }

  @override
  void update(void Function(FdcQueryFoodsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FdcQueryFoods build() => _build();

  _$FdcQueryFoods _build() {
    final _$result =
        _$v ??
        _$FdcQueryFoods._(
          dataType: BuiltValueNullFieldError.checkNotNull(
            dataType,
            r'FdcQueryFoods',
            'dataType',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'FdcQueryFoods',
            'description',
          ),
          fdcId: BuiltValueNullFieldError.checkNotNull(
            fdcId,
            r'FdcQueryFoods',
            'fdcId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
