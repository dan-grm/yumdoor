// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_ingredient_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedIngredientList extends PaginatedIngredientList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<Ingredient> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedIngredientList([
    void Function(PaginatedIngredientListBuilder)? updates,
  ]) => (PaginatedIngredientListBuilder()..update(updates))._build();

  _$PaginatedIngredientList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedIngredientList rebuild(
    void Function(PaginatedIngredientListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedIngredientListBuilder toBuilder() =>
      PaginatedIngredientListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedIngredientList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedIngredientList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedIngredientListBuilder
    implements
        Builder<PaginatedIngredientList, PaginatedIngredientListBuilder> {
  _$PaginatedIngredientList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<Ingredient>? _results;
  ListBuilder<Ingredient> get results =>
      _$this._results ??= ListBuilder<Ingredient>();
  set results(ListBuilder<Ingredient>? results) => _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedIngredientListBuilder() {
    PaginatedIngredientList._defaults(this);
  }

  PaginatedIngredientListBuilder get _$this {
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
  void replace(PaginatedIngredientList other) {
    _$v = other as _$PaginatedIngredientList;
  }

  @override
  void update(void Function(PaginatedIngredientListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedIngredientList build() => _build();

  _$PaginatedIngredientList _build() {
    _$PaginatedIngredientList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedIngredientList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedIngredientList',
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
          r'PaginatedIngredientList',
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
