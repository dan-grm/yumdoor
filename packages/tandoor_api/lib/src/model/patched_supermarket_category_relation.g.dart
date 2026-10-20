// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_supermarket_category_relation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedSupermarketCategoryRelation
    extends PatchedSupermarketCategoryRelation {
  @override
  final SupermarketCategory? category;
  @override
  final int? id;
  @override
  final int? order;
  @override
  final int? supermarket;

  factory _$PatchedSupermarketCategoryRelation([
    void Function(PatchedSupermarketCategoryRelationBuilder)? updates,
  ]) => (PatchedSupermarketCategoryRelationBuilder()..update(updates))._build();

  _$PatchedSupermarketCategoryRelation._({
    this.category,
    this.id,
    this.order,
    this.supermarket,
  }) : super._();
  @override
  PatchedSupermarketCategoryRelation rebuild(
    void Function(PatchedSupermarketCategoryRelationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedSupermarketCategoryRelationBuilder toBuilder() =>
      PatchedSupermarketCategoryRelationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedSupermarketCategoryRelation &&
        category == other.category &&
        id == other.id &&
        order == other.order &&
        supermarket == other.supermarket;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, supermarket.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedSupermarketCategoryRelation')
          ..add('category', category)
          ..add('id', id)
          ..add('order', order)
          ..add('supermarket', supermarket))
        .toString();
  }
}

class PatchedSupermarketCategoryRelationBuilder
    implements
        Builder<
          PatchedSupermarketCategoryRelation,
          PatchedSupermarketCategoryRelationBuilder
        > {
  _$PatchedSupermarketCategoryRelation? _$v;

  SupermarketCategoryBuilder? _category;
  SupermarketCategoryBuilder get category =>
      _$this._category ??= SupermarketCategoryBuilder();
  set category(SupermarketCategoryBuilder? category) =>
      _$this._category = category;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  int? _supermarket;
  int? get supermarket => _$this._supermarket;
  set supermarket(int? supermarket) => _$this._supermarket = supermarket;

  PatchedSupermarketCategoryRelationBuilder() {
    PatchedSupermarketCategoryRelation._defaults(this);
  }

  PatchedSupermarketCategoryRelationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category?.toBuilder();
      _id = $v.id;
      _order = $v.order;
      _supermarket = $v.supermarket;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedSupermarketCategoryRelation other) {
    _$v = other as _$PatchedSupermarketCategoryRelation;
  }

  @override
  void update(
    void Function(PatchedSupermarketCategoryRelationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  PatchedSupermarketCategoryRelation build() => _build();

  _$PatchedSupermarketCategoryRelation _build() {
    _$PatchedSupermarketCategoryRelation _$result;
    try {
      _$result =
          _$v ??
          _$PatchedSupermarketCategoryRelation._(
            category: _category?.build(),
            id: id,
            order: order,
            supermarket: supermarket,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        _category?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedSupermarketCategoryRelation',
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
