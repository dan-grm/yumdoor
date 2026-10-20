// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_shopping_list_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedShoppingListList extends PaginatedShoppingListList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<ShoppingList> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedShoppingListList([
    void Function(PaginatedShoppingListListBuilder)? updates,
  ]) => (PaginatedShoppingListListBuilder()..update(updates))._build();

  _$PaginatedShoppingListList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedShoppingListList rebuild(
    void Function(PaginatedShoppingListListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedShoppingListListBuilder toBuilder() =>
      PaginatedShoppingListListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedShoppingListList &&
        count == other.count &&
        next == other.next &&
        previous == other.previous &&
        results == other.results &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jc(_$hash, results.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginatedShoppingListList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedShoppingListListBuilder
    implements
        Builder<PaginatedShoppingListList, PaginatedShoppingListListBuilder> {
  _$PaginatedShoppingListList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<ShoppingList>? _results;
  ListBuilder<ShoppingList> get results =>
      _$this._results ??= ListBuilder<ShoppingList>();
  set results(ListBuilder<ShoppingList>? results) => _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedShoppingListListBuilder() {
    PaginatedShoppingListList._defaults(this);
  }

  PaginatedShoppingListListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _next = $v.next;
      _previous = $v.previous;
      _results = $v.results.toBuilder();
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginatedShoppingListList other) {
    _$v = other as _$PaginatedShoppingListList;
  }

  @override
  void update(void Function(PaginatedShoppingListListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedShoppingListList build() => _build();

  _$PaginatedShoppingListList _build() {
    _$PaginatedShoppingListList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedShoppingListList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedShoppingListList',
              'count',
            ),
            next: next,
            previous: previous,
            results: results.build(),
            timestamp: timestamp,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PaginatedShoppingListList',
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
