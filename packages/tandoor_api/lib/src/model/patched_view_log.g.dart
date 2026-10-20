// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_view_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedViewLog extends PatchedViewLog {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final int? recipe;

  factory _$PatchedViewLog([void Function(PatchedViewLogBuilder)? updates]) =>
      (PatchedViewLogBuilder()..update(updates))._build();

  _$PatchedViewLog._({this.createdAt, this.createdBy, this.id, this.recipe})
    : super._();
  @override
  PatchedViewLog rebuild(void Function(PatchedViewLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedViewLogBuilder toBuilder() => PatchedViewLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedViewLog &&
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
    return (newBuiltValueToStringHelper(r'PatchedViewLog')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('recipe', recipe))
        .toString();
  }
}

class PatchedViewLogBuilder
    implements Builder<PatchedViewLog, PatchedViewLogBuilder> {
  _$PatchedViewLog? _$v;

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

  PatchedViewLogBuilder() {
    PatchedViewLog._defaults(this);
  }

  PatchedViewLogBuilder get _$this {
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
  void replace(PatchedViewLog other) {
    _$v = other as _$PatchedViewLog;
  }

  @override
  void update(void Function(PatchedViewLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedViewLog build() => _build();

  _$PatchedViewLog _build() {
    final _$result =
        _$v ??
        _$PatchedViewLog._(
          createdAt: createdAt,
          createdBy: createdBy,
          id: id,
          recipe: recipe,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
