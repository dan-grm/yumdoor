// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_open_data_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImportOpenDataResponse extends ImportOpenDataResponse {
  @override
  final ImportOpenDataResponseDetail? category;
  @override
  final ImportOpenDataResponseDetail? conversion;
  @override
  final ImportOpenDataResponseDetail? food;
  @override
  final ImportOpenDataResponseDetail? property;
  @override
  final ImportOpenDataResponseDetail? store;
  @override
  final ImportOpenDataResponseDetail? unit;

  factory _$ImportOpenDataResponse([
    void Function(ImportOpenDataResponseBuilder)? updates,
  ]) => (ImportOpenDataResponseBuilder()..update(updates))._build();

  _$ImportOpenDataResponse._({
    this.category,
    this.conversion,
    this.food,
    this.property,
    this.store,
    this.unit,
  }) : super._();
  @override
  ImportOpenDataResponse rebuild(
    void Function(ImportOpenDataResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ImportOpenDataResponseBuilder toBuilder() =>
      ImportOpenDataResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImportOpenDataResponse &&
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
    return (newBuiltValueToStringHelper(r'ImportOpenDataResponse')
          ..add('category', category)
          ..add('conversion', conversion)
          ..add('food', food)
          ..add('property', property)
          ..add('store', store)
          ..add('unit', unit))
        .toString();
  }
}

class ImportOpenDataResponseBuilder
    implements Builder<ImportOpenDataResponse, ImportOpenDataResponseBuilder> {
  _$ImportOpenDataResponse? _$v;

  ImportOpenDataResponseDetailBuilder? _category;
  ImportOpenDataResponseDetailBuilder get category =>
      _$this._category ??= ImportOpenDataResponseDetailBuilder();
  set category(ImportOpenDataResponseDetailBuilder? category) =>
      _$this._category = category;

  ImportOpenDataResponseDetailBuilder? _conversion;
  ImportOpenDataResponseDetailBuilder get conversion =>
      _$this._conversion ??= ImportOpenDataResponseDetailBuilder();
  set conversion(ImportOpenDataResponseDetailBuilder? conversion) =>
      _$this._conversion = conversion;

  ImportOpenDataResponseDetailBuilder? _food;
  ImportOpenDataResponseDetailBuilder get food =>
      _$this._food ??= ImportOpenDataResponseDetailBuilder();
  set food(ImportOpenDataResponseDetailBuilder? food) => _$this._food = food;

  ImportOpenDataResponseDetailBuilder? _property;
  ImportOpenDataResponseDetailBuilder get property =>
      _$this._property ??= ImportOpenDataResponseDetailBuilder();
  set property(ImportOpenDataResponseDetailBuilder? property) =>
      _$this._property = property;

  ImportOpenDataResponseDetailBuilder? _store;
  ImportOpenDataResponseDetailBuilder get store =>
      _$this._store ??= ImportOpenDataResponseDetailBuilder();
  set store(ImportOpenDataResponseDetailBuilder? store) =>
      _$this._store = store;

  ImportOpenDataResponseDetailBuilder? _unit;
  ImportOpenDataResponseDetailBuilder get unit =>
      _$this._unit ??= ImportOpenDataResponseDetailBuilder();
  set unit(ImportOpenDataResponseDetailBuilder? unit) => _$this._unit = unit;

  ImportOpenDataResponseBuilder() {
    ImportOpenDataResponse._defaults(this);
  }

  ImportOpenDataResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category?.toBuilder();
      _conversion = $v.conversion?.toBuilder();
      _food = $v.food?.toBuilder();
      _property = $v.property?.toBuilder();
      _store = $v.store?.toBuilder();
      _unit = $v.unit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImportOpenDataResponse other) {
    _$v = other as _$ImportOpenDataResponse;
  }

  @override
  void update(void Function(ImportOpenDataResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImportOpenDataResponse build() => _build();

  _$ImportOpenDataResponse _build() {
    _$ImportOpenDataResponse _$result;
    try {
      _$result =
          _$v ??
          _$ImportOpenDataResponse._(
            category: _category?.build(),
            conversion: _conversion?.build(),
            food: _food?.build(),
            property: _property?.build(),
            store: _store?.build(),
            unit: _unit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        _category?.build();
        _$failedField = 'conversion';
        _conversion?.build();
        _$failedField = 'food';
        _food?.build();
        _$failedField = 'property';
        _property?.build();
        _$failedField = 'store';
        _store?.build();
        _$failedField = 'unit';
        _unit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ImportOpenDataResponse',
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
