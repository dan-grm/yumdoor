// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_entry_bulk.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ShoppingListEntryBulk extends ShoppingListEntryBulk {
  @override
  final bool? checked;
  @override
  final BuiltList<JsonObject?> ids;
  @override
  final BuiltList<int>? shoppingListsAdd;
  @override
  final BuiltList<int>? shoppingListsRemove;
  @override
  final bool? shoppingListsRemoveAll;
  @override
  final BuiltList<int>? shoppingListsSet;
  @override
  final DateTime? timestamp;

  factory _$ShoppingListEntryBulk([
    void Function(ShoppingListEntryBulkBuilder)? updates,
  ]) => (ShoppingListEntryBulkBuilder()..update(updates))._build();

  _$ShoppingListEntryBulk._({
    this.checked,
    required this.ids,
    this.shoppingListsAdd,
    this.shoppingListsRemove,
    this.shoppingListsRemoveAll,
    this.shoppingListsSet,
    this.timestamp,
  }) : super._();
  @override
  ShoppingListEntryBulk rebuild(
    void Function(ShoppingListEntryBulkBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ShoppingListEntryBulkBuilder toBuilder() =>
      ShoppingListEntryBulkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShoppingListEntryBulk &&
        checked == other.checked &&
        ids == other.ids &&
        shoppingListsAdd == other.shoppingListsAdd &&
        shoppingListsRemove == other.shoppingListsRemove &&
        shoppingListsRemoveAll == other.shoppingListsRemoveAll &&
        shoppingListsSet == other.shoppingListsSet &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, checked.hashCode);
    _$hash = $jc(_$hash, ids.hashCode);
    _$hash = $jc(_$hash, shoppingListsAdd.hashCode);
    _$hash = $jc(_$hash, shoppingListsRemove.hashCode);
    _$hash = $jc(_$hash, shoppingListsRemoveAll.hashCode);
    _$hash = $jc(_$hash, shoppingListsSet.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShoppingListEntryBulk')
          ..add('checked', checked)
          ..add('ids', ids)
          ..add('shoppingListsAdd', shoppingListsAdd)
          ..add('shoppingListsRemove', shoppingListsRemove)
          ..add('shoppingListsRemoveAll', shoppingListsRemoveAll)
          ..add('shoppingListsSet', shoppingListsSet)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class ShoppingListEntryBulkBuilder
    implements Builder<ShoppingListEntryBulk, ShoppingListEntryBulkBuilder> {
  _$ShoppingListEntryBulk? _$v;

  bool? _checked;
  bool? get checked => _$this._checked;
  set checked(bool? checked) => _$this._checked = checked;

  ListBuilder<JsonObject?>? _ids;
  ListBuilder<JsonObject?> get ids =>
      _$this._ids ??= ListBuilder<JsonObject?>();
  set ids(ListBuilder<JsonObject?>? ids) => _$this._ids = ids;

  ListBuilder<int>? _shoppingListsAdd;
  ListBuilder<int> get shoppingListsAdd =>
      _$this._shoppingListsAdd ??= ListBuilder<int>();
  set shoppingListsAdd(ListBuilder<int>? shoppingListsAdd) =>
      _$this._shoppingListsAdd = shoppingListsAdd;

  ListBuilder<int>? _shoppingListsRemove;
  ListBuilder<int> get shoppingListsRemove =>
      _$this._shoppingListsRemove ??= ListBuilder<int>();
  set shoppingListsRemove(ListBuilder<int>? shoppingListsRemove) =>
      _$this._shoppingListsRemove = shoppingListsRemove;

  bool? _shoppingListsRemoveAll;
  bool? get shoppingListsRemoveAll => _$this._shoppingListsRemoveAll;
  set shoppingListsRemoveAll(bool? shoppingListsRemoveAll) =>
      _$this._shoppingListsRemoveAll = shoppingListsRemoveAll;

  ListBuilder<int>? _shoppingListsSet;
  ListBuilder<int> get shoppingListsSet =>
      _$this._shoppingListsSet ??= ListBuilder<int>();
  set shoppingListsSet(ListBuilder<int>? shoppingListsSet) =>
      _$this._shoppingListsSet = shoppingListsSet;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  ShoppingListEntryBulkBuilder() {
    ShoppingListEntryBulk._defaults(this);
  }

  ShoppingListEntryBulkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _checked = $v.checked;
      _ids = $v.ids.toBuilder();
      _shoppingListsAdd = $v.shoppingListsAdd?.toBuilder();
      _shoppingListsRemove = $v.shoppingListsRemove?.toBuilder();
      _shoppingListsRemoveAll = $v.shoppingListsRemoveAll;
      _shoppingListsSet = $v.shoppingListsSet?.toBuilder();
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShoppingListEntryBulk other) {
    _$v = other as _$ShoppingListEntryBulk;
  }

  @override
  void update(void Function(ShoppingListEntryBulkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShoppingListEntryBulk build() => _build();

  _$ShoppingListEntryBulk _build() {
    _$ShoppingListEntryBulk _$result;
    try {
      _$result =
          _$v ??
          _$ShoppingListEntryBulk._(
            checked: checked,
            ids: ids.build(),
            shoppingListsAdd: _shoppingListsAdd?.build(),
            shoppingListsRemove: _shoppingListsRemove?.build(),
            shoppingListsRemoveAll: shoppingListsRemoveAll,
            shoppingListsSet: _shoppingListsSet?.build(),
            timestamp: timestamp,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ids';
        ids.build();
        _$failedField = 'shoppingListsAdd';
        _shoppingListsAdd?.build();
        _$failedField = 'shoppingListsRemove';
        _shoppingListsRemove?.build();

        _$failedField = 'shoppingListsSet';
        _shoppingListsSet?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ShoppingListEntryBulk',
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
