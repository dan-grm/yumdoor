// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_cook_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedCookLog extends PatchedCookLog {
  @override
  final String? comment;
  @override
  final DateTime? createdAt;
  @override
  final User? createdBy;
  @override
  final int? id;
  @override
  final int? rating;
  @override
  final int? recipe;
  @override
  final int? servings;
  @override
  final DateTime? updatedAt;

  factory _$PatchedCookLog([void Function(PatchedCookLogBuilder)? updates]) =>
      (PatchedCookLogBuilder()..update(updates))._build();

  _$PatchedCookLog._({
    this.comment,
    this.createdAt,
    this.createdBy,
    this.id,
    this.rating,
    this.recipe,
    this.servings,
    this.updatedAt,
  }) : super._();
  @override
  PatchedCookLog rebuild(void Function(PatchedCookLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedCookLogBuilder toBuilder() => PatchedCookLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedCookLog &&
        comment == other.comment &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        id == other.id &&
        rating == other.rating &&
        recipe == other.recipe &&
        servings == other.servings &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedCookLog')
          ..add('comment', comment)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('rating', rating)
          ..add('recipe', recipe)
          ..add('servings', servings)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PatchedCookLogBuilder
    implements Builder<PatchedCookLog, PatchedCookLogBuilder> {
  _$PatchedCookLog? _$v;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  int? _recipe;
  int? get recipe => _$this._recipe;
  set recipe(int? recipe) => _$this._recipe = recipe;

  int? _servings;
  int? get servings => _$this._servings;
  set servings(int? servings) => _$this._servings = servings;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PatchedCookLogBuilder() {
    PatchedCookLog._defaults(this);
  }

  PatchedCookLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _comment = $v.comment;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy?.toBuilder();
      _id = $v.id;
      _rating = $v.rating;
      _recipe = $v.recipe;
      _servings = $v.servings;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedCookLog other) {
    _$v = other as _$PatchedCookLog;
  }

  @override
  void update(void Function(PatchedCookLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedCookLog build() => _build();

  _$PatchedCookLog _build() {
    _$PatchedCookLog _$result;
    try {
      _$result =
          _$v ??
          _$PatchedCookLog._(
            comment: comment,
            createdAt: createdAt,
            createdBy: _createdBy?.build(),
            id: id,
            rating: rating,
            recipe: recipe,
            servings: servings,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        _createdBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedCookLog',
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
