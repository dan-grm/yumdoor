// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ViewLog extends ViewLog {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final int recipe;

  factory _$ViewLog([void Function(ViewLogBuilder)? updates]) =>
      (ViewLogBuilder()..update(updates))._build();

  _$ViewLog._({this.createdAt, this.createdBy, this.id, required this.recipe})
    : super._();
  @override
  ViewLog rebuild(void Function(ViewLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ViewLogBuilder toBuilder() => ViewLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ViewLog &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        id == other.id &&
        recipe == other.recipe;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ViewLog')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('recipe', recipe))
        .toString();
  }
}

class ViewLogBuilder implements Builder<ViewLog, ViewLogBuilder> {
  _$ViewLog? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _recipe;
  int? get recipe => _$this._recipe;
  set recipe(int? recipe) => _$this._recipe = recipe;

  ViewLogBuilder() {
    ViewLog._defaults(this);
  }

  ViewLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _id = $v.id;
      _recipe = $v.recipe;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ViewLog other) {
    _$v = other as _$ViewLog;
  }

  @override
  void update(void Function(ViewLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ViewLog build() => _build();

  _$ViewLog _build() {
    final _$result =
        _$v ??
        _$ViewLog._(
          createdAt: createdAt,
          createdBy: createdBy,
          id: id,
          recipe: BuiltValueNullFieldError.checkNotNull(
            recipe,
            r'ViewLog',
            'recipe',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
