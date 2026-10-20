// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_meal_plan_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedMealPlanList extends PaginatedMealPlanList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<MealPlan> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedMealPlanList([
    void Function(PaginatedMealPlanListBuilder)? updates,
  ]) => (PaginatedMealPlanListBuilder()..update(updates))._build();

  _$PaginatedMealPlanList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedMealPlanList rebuild(
    void Function(PaginatedMealPlanListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedMealPlanListBuilder toBuilder() =>
      PaginatedMealPlanListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedMealPlanList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedMealPlanList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedMealPlanListBuilder
    implements Builder<PaginatedMealPlanList, PaginatedMealPlanListBuilder> {
  _$PaginatedMealPlanList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<MealPlan>? _results;
  ListBuilder<MealPlan> get results =>
      _$this._results ??= ListBuilder<MealPlan>();
  set results(ListBuilder<MealPlan>? results) => _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedMealPlanListBuilder() {
    PaginatedMealPlanList._defaults(this);
  }

  PaginatedMealPlanListBuilder get _$this {
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
  void replace(PaginatedMealPlanList other) {
    _$v = other as _$PaginatedMealPlanList;
  }

  @override
  void update(void Function(PaginatedMealPlanListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedMealPlanList build() => _build();

  _$PaginatedMealPlanList _build() {
    _$PaginatedMealPlanList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedMealPlanList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedMealPlanList',
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
          r'PaginatedMealPlanList',
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
