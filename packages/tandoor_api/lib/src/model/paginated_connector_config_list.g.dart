// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_connector_config_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedConnectorConfigList extends PaginatedConnectorConfigList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<ConnectorConfig> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedConnectorConfigList([
    void Function(PaginatedConnectorConfigListBuilder)? updates,
  ]) => (PaginatedConnectorConfigListBuilder()..update(updates))._build();

  _$PaginatedConnectorConfigList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedConnectorConfigList rebuild(
    void Function(PaginatedConnectorConfigListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedConnectorConfigListBuilder toBuilder() =>
      PaginatedConnectorConfigListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedConnectorConfigList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedConnectorConfigList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedConnectorConfigListBuilder
    implements
        Builder<
          PaginatedConnectorConfigList,
          PaginatedConnectorConfigListBuilder
        > {
  _$PaginatedConnectorConfigList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<ConnectorConfig>? _results;
  ListBuilder<ConnectorConfig> get results =>
      _$this._results ??= ListBuilder<ConnectorConfig>();
  set results(ListBuilder<ConnectorConfig>? results) =>
      _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedConnectorConfigListBuilder() {
    PaginatedConnectorConfigList._defaults(this);
  }

  PaginatedConnectorConfigListBuilder get _$this {
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
  void replace(PaginatedConnectorConfigList other) {
    _$v = other as _$PaginatedConnectorConfigList;
  }

  @override
  void update(void Function(PaginatedConnectorConfigListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedConnectorConfigList build() => _build();

  _$PaginatedConnectorConfigList _build() {
    _$PaginatedConnectorConfigList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedConnectorConfigList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedConnectorConfigList',
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
          r'PaginatedConnectorConfigList',
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
