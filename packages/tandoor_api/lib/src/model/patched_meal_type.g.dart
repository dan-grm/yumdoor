// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_meal_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedMealType extends PatchedMealType {
  @override
  final String? color;
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final int? order;
  @override
  final String? time;

  factory _$PatchedMealType([void Function(PatchedMealTypeBuilder)? updates]) =>
      (PatchedMealTypeBuilder()..update(updates))._build();

  _$PatchedMealType._({
    this.color,
    this.createdBy,
    this.id,
    this.name,
    this.order,
    this.time,
  }) : super._();
  @override
  PatchedMealType rebuild(void Function(PatchedMealTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedMealTypeBuilder toBuilder() => PatchedMealTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedMealType &&
        color == other.color &&
        createdBy == other.createdBy &&
        id == other.id &&
        name == other.name &&
        order == other.order &&
        time == other.time;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedMealType')
          ..add('color', color)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('name', name)
          ..add('order', order)
          ..add('time', time))
        .toString();
  }
}

class PatchedMealTypeBuilder
    implements Builder<PatchedMealType, PatchedMealTypeBuilder> {
  _$PatchedMealType? _$v;

  String? _color;
  String? get color => _$this._color;
  set color(String? color) => _$this._color = color;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  String? _time;
  String? get time => _$this._time;
  set time(String? time) => _$this._time = time;

  PatchedMealTypeBuilder() {
    PatchedMealType._defaults(this);
  }

  PatchedMealTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _color = $v.color;
      _createdBy = $v.createdBy;
      _id = $v.id;
      _name = $v.name;
      _order = $v.order;
      _time = $v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedMealType other) {
    _$v = other as _$PatchedMealType;
  }

  @override
  void update(void Function(PatchedMealTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedMealType build() => _build();

  _$PatchedMealType _build() {
    final _$result =
        _$v ??
        _$PatchedMealType._(
          color: color,
          createdBy: createdBy,
          id: id,
          name: name,
          order: order,
          time: time,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
