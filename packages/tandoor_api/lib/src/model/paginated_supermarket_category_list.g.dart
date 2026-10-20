// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_supermarket_category_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedSupermarketCategoryList
    extends PaginatedSupermarketCategoryList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<SupermarketCategory> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedSupermarketCategoryList([
    void Function(PaginatedSupermarketCategoryListBuilder)? updates,
  ]) => (PaginatedSupermarketCategoryListBuilder()..update(updates))._build();

  _$PaginatedSupermarketCategoryList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedSupermarketCategoryList rebuild(
    void Function(PaginatedSupermarketCategoryListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedSupermarketCategoryListBuilder toBuilder() =>
      PaginatedSupermarketCategoryListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedSupermarketCategoryList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedSupermarketCategoryList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedSupermarketCategoryListBuilder
    implements
        Builder<
          PaginatedSupermarketCategoryList,
          PaginatedSupermarketCategoryListBuilder
        > {
  _$PaginatedSupermarketCategoryList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<SupermarketCategory>? _results;
  ListBuilder<SupermarketCategory> get results =>
      _$this._results ??= ListBuilder<SupermarketCategory>();
  set results(ListBuilder<SupermarketCategory>? results) =>
      _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedSupermarketCategoryListBuilder() {
    PaginatedSupermarketCategoryList._defaults(this);
  }

  PaginatedSupermarketCategoryListBuilder get _$this {
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
  void replace(PaginatedSupermarketCategoryList other) {
    _$v = other as _$PaginatedSupermarketCategoryList;
  }

  @override
  void update(void Function(PaginatedSupermarketCategoryListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedSupermarketCategoryList build() => _build();

  _$PaginatedSupermarketCategoryList _build() {
    _$PaginatedSupermarketCategoryList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedSupermarketCategoryList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedSupermarketCategoryList',
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
          r'PaginatedSupermarketCategoryList',
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
