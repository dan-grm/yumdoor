// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_view_log_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedViewLogList extends PaginatedViewLogList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<ViewLog> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedViewLogList([
    void Function(PaginatedViewLogListBuilder)? updates,
  ]) => (PaginatedViewLogListBuilder()..update(updates))._build();

  _$PaginatedViewLogList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedViewLogList rebuild(
    void Function(PaginatedViewLogListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedViewLogListBuilder toBuilder() =>
      PaginatedViewLogListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedViewLogList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedViewLogList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedViewLogListBuilder
    implements Builder<PaginatedViewLogList, PaginatedViewLogListBuilder> {
  _$PaginatedViewLogList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<ViewLog>? _results;
  ListBuilder<ViewLog> get results =>
      _$this._results ??= ListBuilder<ViewLog>();
  set results(ListBuilder<ViewLog>? results) => _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedViewLogListBuilder() {
    PaginatedViewLogList._defaults(this);
  }

  PaginatedViewLogListBuilder get _$this {
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
  void replace(PaginatedViewLogList other) {
    _$v = other as _$PaginatedViewLogList;
  }

  @override
  void update(void Function(PaginatedViewLogListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedViewLogList build() => _build();

  _$PaginatedViewLogList _build() {
    _$PaginatedViewLogList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedViewLogList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedViewLogList',
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
          r'PaginatedViewLogList',
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
