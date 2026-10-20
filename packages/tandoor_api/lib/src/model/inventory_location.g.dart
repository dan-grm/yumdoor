// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryLocation extends InventoryLocation {
  @override
  final Household household;
  @override
  final int? id;
  @override
  final bool? isFreezer;
  @override
  final String name;

  factory _$InventoryLocation([
    void Function(InventoryLocationBuilder)? updates,
  ]) => (InventoryLocationBuilder()..update(updates))._build();

  _$InventoryLocation._({
    required this.household,
    this.id,
    this.isFreezer,
    required this.name,
  }) : super._();
  @override
  InventoryLocation rebuild(void Function(InventoryLocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLocationBuilder toBuilder() =>
      InventoryLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLocation &&
        household == other.household &&
        id == other.id &&
        isFreezer == other.isFreezer &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, household.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isFreezer.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryLocation')
          ..add('household', household)
          ..add('id', id)
          ..add('isFreezer', isFreezer)
          ..add('name', name))
        .toString();
  }
}

class InventoryLocationBuilder
    implements Builder<InventoryLocation, InventoryLocationBuilder> {
  _$InventoryLocation? _$v;

  HouseholdBuilder? _household;
  HouseholdBuilder get household => _$this._household ??= HouseholdBuilder();
  set household(HouseholdBuilder? household) => _$this._household = household;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _isFreezer;
  bool? get isFreezer => _$this._isFreezer;
  set isFreezer(bool? isFreezer) => _$this._isFreezer = isFreezer;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  InventoryLocationBuilder() {
    InventoryLocation._defaults(this);
  }

  InventoryLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _household = $v.household.toBuilder();
      _id = $v.id;
      _isFreezer = $v.isFreezer;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryLocation other) {
    _$v = other as _$InventoryLocation;
  }

  @override
  void update(void Function(InventoryLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLocation build() => _build();

  _$InventoryLocation _build() {
    _$InventoryLocation _$result;
    try {
      _$result =
          _$v ??
          _$InventoryLocation._(
            household: household.build(),
            id: id,
            isFreezer: isFreezer,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'InventoryLocation',
              'name',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'household';
        household.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'InventoryLocation',
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
