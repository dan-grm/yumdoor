// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_open_data_version_meta_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportOpenDataVersionMetaData extends ImportOpenDataVersionMetaData {
  @override
  final int category;
  @override
  final int conversion;
  @override
  final int food;
  @override
  final int property;
  @override
  final int store;
  @override
  final int unit;

  factory _$ImportOpenDataVersionMetaData([
    void Function(ImportOpenDataVersionMetaDataBuilder)? updates,
  ]) => (ImportOpenDataVersionMetaDataBuilder()..update(updates))._build();

  _$ImportOpenDataVersionMetaData._({
    required this.category,
    required this.conversion,
    required this.food,
    required this.property,
    required this.store,
    required this.unit,
  }) : super._();
  @override
  ImportOpenDataVersionMetaData rebuild(
    void Function(ImportOpenDataVersionMetaDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ImportOpenDataVersionMetaDataBuilder toBuilder() =>
      ImportOpenDataVersionMetaDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportOpenDataVersionMetaData &&
        category == other.category &&
        conversion == other.conversion &&
        food == other.food &&
        property == other.property &&
        store == other.store &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, conversion.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, property.hashCode);
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImportOpenDataVersionMetaData')
          ..add('category', category)
          ..add('conversion', conversion)
          ..add('food', food)
          ..add('property', property)
          ..add('store', store)
          ..add('unit', unit))
        .toString();
  }
}

class ImportOpenDataVersionMetaDataBuilder
    implements
        Builder<
          ImportOpenDataVersionMetaData,
          ImportOpenDataVersionMetaDataBuilder
        > {
  _$ImportOpenDataVersionMetaData? _$v;

  int? _category;
  int? get category => _$this._category;
  set category(int? category) => _$this._category = category;

  int? _conversion;
  int? get conversion => _$this._conversion;
  set conversion(int? conversion) => _$this._conversion = conversion;

  int? _food;
  int? get food => _$this._food;
  set food(int? food) => _$this._food = food;

  int? _property;
  int? get property => _$this._property;
  set property(int? property) => _$this._property = property;

  int? _store;
  int? get store => _$this._store;
  set store(int? store) => _$this._store = store;

  int? _unit;
  int? get unit => _$this._unit;
  set unit(int? unit) => _$this._unit = unit;

  ImportOpenDataVersionMetaDataBuilder() {
    ImportOpenDataVersionMetaData._defaults(this);
  }

  ImportOpenDataVersionMetaDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _conversion = $v.conversion;
      _food = $v.food;
      _property = $v.property;
      _store = $v.store;
      _unit = $v.unit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportOpenDataVersionMetaData other) {
    _$v = other as _$ImportOpenDataVersionMetaData;
  }

  @override
  void update(void Function(ImportOpenDataVersionMetaDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportOpenDataVersionMetaData build() => _build();

  _$ImportOpenDataVersionMetaData _build() {
    final _$result =
        _$v ??
        _$ImportOpenDataVersionMetaData._(
          category: BuiltValueNullFieldError.checkNotNull(
            category,
            r'ImportOpenDataVersionMetaData',
            'category',
          ),
          conversion: BuiltValueNullFieldError.checkNotNull(
            conversion,
            r'ImportOpenDataVersionMetaData',
            'conversion',
          ),
          food: BuiltValueNullFieldError.checkNotNull(
            food,
            r'ImportOpenDataVersionMetaData',
            'food',
          ),
          property: BuiltValueNullFieldError.checkNotNull(
            property,
            r'ImportOpenDataVersionMetaData',
            'property',
          ),
          store: BuiltValueNullFieldError.checkNotNull(
            store,
            r'ImportOpenDataVersionMetaData',
            'store',
          ),
          unit: BuiltValueNullFieldError.checkNotNull(
            unit,
            r'ImportOpenDataVersionMetaData',
            'unit',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
