// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_recipe_overview_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedRecipeOverviewList extends PaginatedRecipeOverviewList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<RecipeOverview> results;

  factory _$PaginatedRecipeOverviewList([
    void Function(PaginatedRecipeOverviewListBuilder)? updates,
  ]) => (PaginatedRecipeOverviewListBuilder()..update(updates))._build();

  _$PaginatedRecipeOverviewList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  }) : super._();
  @override
  PaginatedRecipeOverviewList rebuild(
    void Function(PaginatedRecipeOverviewListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedRecipeOverviewListBuilder toBuilder() =>
      PaginatedRecipeOverviewListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedRecipeOverviewList &&
        count == other.count &&
        next == other.next &&
        previous == other.previous &&
        results == other.results;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jc(_$hash, results.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaginatedRecipeOverviewList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results))
        .toString();
  }
}

class PaginatedRecipeOverviewListBuilder
    implements
        Builder<
          PaginatedRecipeOverviewList,
          PaginatedRecipeOverviewListBuilder
        > {
  _$PaginatedRecipeOverviewList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<RecipeOverview>? _results;
  ListBuilder<RecipeOverview> get results =>
      _$this._results ??= ListBuilder<RecipeOverview>();
  set results(ListBuilder<RecipeOverview>? results) =>
      _$this._results = results;

  PaginatedRecipeOverviewListBuilder() {
    PaginatedRecipeOverviewList._defaults(this);
  }

  PaginatedRecipeOverviewListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _next = $v.next;
      _previous = $v.previous;
      _results = $v.results.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaginatedRecipeOverviewList other) {
    _$v = other as _$PaginatedRecipeOverviewList;
  }

  @override
  void update(void Function(PaginatedRecipeOverviewListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedRecipeOverviewList build() => _build();

  _$PaginatedRecipeOverviewList _build() {
    _$PaginatedRecipeOverviewList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedRecipeOverviewList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedRecipeOverviewList',
              'count',
            ),
            next: next,
            previous: previous,
            results: results.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PaginatedRecipeOverviewList',
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
