// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_book.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeBook extends RecipeBook {
  @override
  final User? createdBy;
  @override
  final String? description;
  @override
  final CustomFilter? filter;
  @override
  final int? id;
  @override
  final String name;
  @override
  final int? order;
  @override
  final BuiltList<User> shared;

  factory _$RecipeBook([void Function(RecipeBookBuilder)? updates]) =>
      (RecipeBookBuilder()..update(updates))._build();

  _$RecipeBook._({
    this.createdBy,
    this.description,
    this.filter,
    this.id,
    required this.name,
    this.order,
    required this.shared,
  }) : super._();
  @override
  RecipeBook rebuild(void Function(RecipeBookBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeBookBuilder toBuilder() => RecipeBookBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeBook &&
        createdBy == other.createdBy &&
        description == other.description &&
        filter == other.filter &&
        id == other.id &&
        name == other.name &&
        order == other.order &&
        shared == other.shared;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, shared.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeBook')
          ..add('createdBy', createdBy)
          ..add('description', description)
          ..add('filter', filter)
          ..add('id', id)
          ..add('name', name)
          ..add('order', order)
          ..add('shared', shared))
        .toString();
  }
}

class RecipeBookBuilder implements Builder<RecipeBook, RecipeBookBuilder> {
  _$RecipeBook? _$v;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  CustomFilterBuilder? _filter;
  CustomFilterBuilder get filter => _$this._filter ??= CustomFilterBuilder();
  set filter(CustomFilterBuilder? filter) => _$this._filter = filter;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  ListBuilder<User>? _shared;
  ListBuilder<User> get shared => _$this._shared ??= ListBuilder<User>();
  set shared(ListBuilder<User>? shared) => _$this._shared = shared;

  RecipeBookBuilder() {
    RecipeBook._defaults(this);
  }

  RecipeBookBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdBy = $v.createdBy?.toBuilder();
      _description = $v.description;
      _filter = $v.filter?.toBuilder();
      _id = $v.id;
      _name = $v.name;
      _order = $v.order;
      _shared = $v.shared.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeBook other) {
    _$v = other as _$RecipeBook;
  }

  @override
  void update(void Function(RecipeBookBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeBook build() => _build();

  _$RecipeBook _build() {
    _$RecipeBook _$result;
    try {
      _$result =
          _$v ??
          _$RecipeBook._(
            createdBy: _createdBy?.build(),
            description: description,
            filter: _filter?.build(),
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'RecipeBook',
              'name',
            ),
            order: order,
            shared: shared.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        _createdBy?.build();

        _$failedField = 'filter';
        _filter?.build();

        _$failedField = 'shared';
        shared.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecipeBook',
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
