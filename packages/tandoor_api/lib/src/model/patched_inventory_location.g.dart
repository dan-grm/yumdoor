// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_inventory_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedInventoryLocation extends PatchedInventoryLocation {
  @override
  final Household? household;
  @override
  final int? id;
  @override
  final bool? isFreezer;
  @override
  final String? name;

  factory _$PatchedInventoryLocation([
    void Function(PatchedInventoryLocationBuilder)? updates,
  ]) => (PatchedInventoryLocationBuilder()..update(updates))._build();

  _$PatchedInventoryLocation._({
    this.household,
    this.id,
    this.isFreezer,
    this.name,
  }) : super._();
  @override
  PatchedInventoryLocation rebuild(
    void Function(PatchedInventoryLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedInventoryLocationBuilder toBuilder() =>
      PatchedInventoryLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedInventoryLocation &&
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
    return (newBuiltValueToStringHelper(r'PatchedInventoryLocation')
          ..add('household', household)
          ..add('id', id)
          ..add('isFreezer', isFreezer)
          ..add('name', name))
        .toString();
  }
}

class PatchedInventoryLocationBuilder
    implements
        Builder<PatchedInventoryLocation, PatchedInventoryLocationBuilder> {
  _$PatchedInventoryLocation? _$v;

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

  PatchedInventoryLocationBuilder() {
    PatchedInventoryLocation._defaults(this);
  }

  PatchedInventoryLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _household = $v.household?.toBuilder();
      _id = $v.id;
      _isFreezer = $v.isFreezer;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedInventoryLocation other) {
    _$v = other as _$PatchedInventoryLocation;
  }

  @override
  void update(void Function(PatchedInventoryLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedInventoryLocation build() => _build();

  _$PatchedInventoryLocation _build() {
    _$PatchedInventoryLocation _$result;
    try {
      _$result =
          _$v ??
          _$PatchedInventoryLocation._(
            household: _household?.build(),
            id: id,
            isFreezer: isFreezer,
            name: name,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'household';
        _household?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedInventoryLocation',
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
