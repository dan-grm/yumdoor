// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supermarket_category_relation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupermarketCategoryRelation extends SupermarketCategoryRelation {
  @override
  final SupermarketCategory category;
  @override
  final int? id;
  @override
  final int? order;
  @override
  final int supermarket;

  factory _$SupermarketCategoryRelation([
    void Function(SupermarketCategoryRelationBuilder)? updates,
  ]) => (SupermarketCategoryRelationBuilder()..update(updates))._build();

  _$SupermarketCategoryRelation._({
    required this.category,
    this.id,
    this.order,
    required this.supermarket,
  }) : super._();
  @override
  SupermarketCategoryRelation rebuild(
    void Function(SupermarketCategoryRelationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SupermarketCategoryRelationBuilder toBuilder() =>
      SupermarketCategoryRelationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupermarketCategoryRelation &&
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
    return (newBuiltValueToStringHelper(r'SupermarketCategoryRelation')
          ..add('category', category)
          ..add('id', id)
          ..add('order', order)
          ..add('supermarket', supermarket))
        .toString();
  }
}

class SupermarketCategoryRelationBuilder
    implements
        Builder<
          SupermarketCategoryRelation,
          SupermarketCategoryRelationBuilder
        > {
  _$SupermarketCategoryRelation? _$v;

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

  SupermarketCategoryRelationBuilder() {
    SupermarketCategoryRelation._defaults(this);
  }

  SupermarketCategoryRelationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category.toBuilder();
      _id = $v.id;
      _order = $v.order;
      _supermarket = $v.supermarket;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupermarketCategoryRelation other) {
    _$v = other as _$SupermarketCategoryRelation;
  }

  @override
  void update(void Function(SupermarketCategoryRelationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupermarketCategoryRelation build() => _build();

  _$SupermarketCategoryRelation _build() {
    _$SupermarketCategoryRelation _$result;
    try {
      _$result =
          _$v ??
          _$SupermarketCategoryRelation._(
            category: category.build(),
            id: id,
            order: order,
            supermarket: BuiltValueNullFieldError.checkNotNull(
              supermarket,
              r'SupermarketCategoryRelation',
              'supermarket',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        category.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SupermarketCategoryRelation',
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
