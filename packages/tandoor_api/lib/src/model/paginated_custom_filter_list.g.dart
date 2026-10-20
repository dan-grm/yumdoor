// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_custom_filter_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedCustomFilterList extends PaginatedCustomFilterList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<CustomFilter> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedCustomFilterList([
    void Function(PaginatedCustomFilterListBuilder)? updates,
  ]) => (PaginatedCustomFilterListBuilder()..update(updates))._build();

  _$PaginatedCustomFilterList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedCustomFilterList rebuild(
    void Function(PaginatedCustomFilterListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedCustomFilterListBuilder toBuilder() =>
      PaginatedCustomFilterListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedCustomFilterList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedCustomFilterList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedCustomFilterListBuilder
    implements
        Builder<PaginatedCustomFilterList, PaginatedCustomFilterListBuilder> {
  _$PaginatedCustomFilterList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<CustomFilter>? _results;
  ListBuilder<CustomFilter> get results =>
      _$this._results ??= ListBuilder<CustomFilter>();
  set results(ListBuilder<CustomFilter>? results) => _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedCustomFilterListBuilder() {
    PaginatedCustomFilterList._defaults(this);
  }

  PaginatedCustomFilterListBuilder get _$this {
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
  void replace(PaginatedCustomFilterList other) {
    _$v = other as _$PaginatedCustomFilterList;
  }

  @override
  void update(void Function(PaginatedCustomFilterListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedCustomFilterList build() => _build();

  _$PaginatedCustomFilterList _build() {
    _$PaginatedCustomFilterList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedCustomFilterList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedCustomFilterList',
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
          r'PaginatedCustomFilterList',
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
