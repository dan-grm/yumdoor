// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Household extends Household {
  @override
  final DateTime? createdAt;
  @override
  final int? id;
  @override
  final String name;
  @override
  final DateTime? updatedAt;

  factory _$Household([void Function(HouseholdBuilder)? updates]) =>
      (HouseholdBuilder()..update(updates))._build();

  _$Household._({this.createdAt, this.id, required this.name, this.updatedAt})
    : super._();
  @override
  Household rebuild(void Function(HouseholdBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HouseholdBuilder toBuilder() => HouseholdBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Household &&
        createdAt == other.createdAt &&
        id == other.id &&
        name == other.name &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Household')
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('name', name)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class HouseholdBuilder implements Builder<Household, HouseholdBuilder> {
  _$Household? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  HouseholdBuilder() {
    Household._defaults(this);
  }

  HouseholdBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _id = $v.id;
      _name = $v.name;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Household other) {
    _$v = other as _$Household;
  }

  @override
  void update(void Function(HouseholdBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Household build() => _build();

  _$Household _build() {
    final _$result =
        _$v ??
        _$Household._(
          createdAt: createdAt,
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'Household',
            'name',
          ),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
