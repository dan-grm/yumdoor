// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_inventory_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedInventoryEntry extends PatchedInventoryEntry {
  @override
  final double? amount;
  @override
  final String? code;
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final Date? expires;
  @override
  final Food? food;
  @override
  final int? id;
  @override
  final InventoryLocation? inventoryLocation;
  @override
  final String? label;
  @override
  final String? note;
  @override
  final String? subLocation;
  @override
  final Unit? unit;

  factory _$PatchedInventoryEntry([
    void Function(PatchedInventoryEntryBuilder)? updates,
  ]) => (PatchedInventoryEntryBuilder()..update(updates))._build();

  _$PatchedInventoryEntry._({
    this.amount,
    this.code,
    this.createdAt,
    this.createdBy,
    this.expires,
    this.food,
    this.id,
    this.inventoryLocation,
    this.label,
    this.note,
    this.subLocation,
    this.unit,
  }) : super._();
  @override
  PatchedInventoryEntry rebuild(
    void Function(PatchedInventoryEntryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedInventoryEntryBuilder toBuilder() =>
      PatchedInventoryEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedInventoryEntry &&
        amount == other.amount &&
        code == other.code &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        expires == other.expires &&
        food == other.food &&
        id == other.id &&
        inventoryLocation == other.inventoryLocation &&
        label == other.label &&
        note == other.note &&
        subLocation == other.subLocation &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, expires.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, inventoryLocation.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, subLocation.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedInventoryEntry')
          ..add('amount', amount)
          ..add('code', code)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('expires', expires)
          ..add('food', food)
          ..add('id', id)
          ..add('inventoryLocation', inventoryLocation)
          ..add('label', label)
          ..add('note', note)
          ..add('subLocation', subLocation)
          ..add('unit', unit))
        .toString();
  }
}

class PatchedInventoryEntryBuilder
    implements Builder<PatchedInventoryEntry, PatchedInventoryEntryBuilder> {
  _$PatchedInventoryEntry? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  Date? _expires;
  Date? get expires => _$this._expires;
  set expires(Date? expires) => _$this._expires = expires;

  FoodBuilder? _food;
  FoodBuilder get food => _$this._food ??= FoodBuilder();
  set food(FoodBuilder? food) => _$this._food = food;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  InventoryLocationBuilder? _inventoryLocation;
  InventoryLocationBuilder get inventoryLocation =>
      _$this._inventoryLocation ??= InventoryLocationBuilder();
  set inventoryLocation(InventoryLocationBuilder? inventoryLocation) =>
      _$this._inventoryLocation = inventoryLocation;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _subLocation;
  String? get subLocation => _$this._subLocation;
  set subLocation(String? subLocation) => _$this._subLocation = subLocation;

  UnitBuilder? _unit;
  UnitBuilder get unit => _$this._unit ??= UnitBuilder();
  set unit(UnitBuilder? unit) => _$this._unit = unit;

  PatchedInventoryEntryBuilder() {
    PatchedInventoryEntry._defaults(this);
  }

  PatchedInventoryEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _code = $v.code;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _expires = $v.expires;
      _food = $v.food?.toBuilder();
      _id = $v.id;
      _inventoryLocation = $v.inventoryLocation?.toBuilder();
      _label = $v.label;
      _note = $v.note;
      _subLocation = $v.subLocation;
      _unit = $v.unit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedInventoryEntry other) {
    _$v = other as _$PatchedInventoryEntry;
  }

  @override
  void update(void Function(PatchedInventoryEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedInventoryEntry build() => _build();

  _$PatchedInventoryEntry _build() {
    _$PatchedInventoryEntry _$result;
    try {
      _$result =
          _$v ??
          _$PatchedInventoryEntry._(
            amount: amount,
            code: code,
            createdAt: createdAt,
            createdBy: createdBy,
            expires: expires,
            food: _food?.build(),
            id: id,
            inventoryLocation: _inventoryLocation?.build(),
            label: label,
            note: note,
            subLocation: subLocation,
            unit: _unit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'food';
        _food?.build();

        _$failedField = 'inventoryLocation';
        _inventoryLocation?.build();

        _$failedField = 'unit';
        _unit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedInventoryEntry',
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
