// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_entry_bulk_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ShoppingListEntryBulkCreate extends ShoppingListEntryBulkCreate {
  @override
  final BuiltList<ShoppingListEntrySimpleCreate> entries;
  @override
  final BuiltList<int>? shoppingListsIds;

  factory _$ShoppingListEntryBulkCreate([
    void Function(ShoppingListEntryBulkCreateBuilder)? updates,
  ]) => (ShoppingListEntryBulkCreateBuilder()..update(updates))._build();

  _$ShoppingListEntryBulkCreate._({
    required this.entries,
    this.shoppingListsIds,
  }) : super._();
  @override
  ShoppingListEntryBulkCreate rebuild(
    void Function(ShoppingListEntryBulkCreateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ShoppingListEntryBulkCreateBuilder toBuilder() =>
      ShoppingListEntryBulkCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShoppingListEntryBulkCreate &&
        entries == other.entries &&
        shoppingListsIds == other.shoppingListsIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jc(_$hash, shoppingListsIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShoppingListEntryBulkCreate')
          ..add('entries', entries)
          ..add('shoppingListsIds', shoppingListsIds))
        .toString();
  }
}

class ShoppingListEntryBulkCreateBuilder
    implements
        Builder<
          ShoppingListEntryBulkCreate,
          ShoppingListEntryBulkCreateBuilder
        > {
  _$ShoppingListEntryBulkCreate? _$v;

  ListBuilder<ShoppingListEntrySimpleCreate>? _entries;
  ListBuilder<ShoppingListEntrySimpleCreate> get entries =>
      _$this._entries ??= ListBuilder<ShoppingListEntrySimpleCreate>();
  set entries(ListBuilder<ShoppingListEntrySimpleCreate>? entries) =>
      _$this._entries = entries;

  ListBuilder<int>? _shoppingListsIds;
  ListBuilder<int> get shoppingListsIds =>
      _$this._shoppingListsIds ??= ListBuilder<int>();
  set shoppingListsIds(ListBuilder<int>? shoppingListsIds) =>
      _$this._shoppingListsIds = shoppingListsIds;

  ShoppingListEntryBulkCreateBuilder() {
    ShoppingListEntryBulkCreate._defaults(this);
  }

  ShoppingListEntryBulkCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _shoppingListsIds = $v.shoppingListsIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShoppingListEntryBulkCreate other) {
    _$v = other as _$ShoppingListEntryBulkCreate;
  }

  @override
  void update(void Function(ShoppingListEntryBulkCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShoppingListEntryBulkCreate build() => _build();

  _$ShoppingListEntryBulkCreate _build() {
    _$ShoppingListEntryBulkCreate _$result;
    try {
      _$result =
          _$v ??
          _$ShoppingListEntryBulkCreate._(
            entries: entries.build(),
            shoppingListsIds: _shoppingListsIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
        _$failedField = 'shoppingListsIds';
        _shoppingListsIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ShoppingListEntryBulkCreate',
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
