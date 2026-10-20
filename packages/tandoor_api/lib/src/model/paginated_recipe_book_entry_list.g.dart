// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_recipe_book_entry_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaginatedRecipeBookEntryList extends PaginatedRecipeBookEntryList {
  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  @override
  final BuiltList<RecipeBookEntry> results;
  @override
  final DateTime? timestamp;

  factory _$PaginatedRecipeBookEntryList([
    void Function(PaginatedRecipeBookEntryListBuilder)? updates,
  ]) => (PaginatedRecipeBookEntryListBuilder()..update(updates))._build();

  _$PaginatedRecipeBookEntryList._({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.timestamp,
  }) : super._();
  @override
  PaginatedRecipeBookEntryList rebuild(
    void Function(PaginatedRecipeBookEntryListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PaginatedRecipeBookEntryListBuilder toBuilder() =>
      PaginatedRecipeBookEntryListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaginatedRecipeBookEntryList &&
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
    return (newBuiltValueToStringHelper(r'PaginatedRecipeBookEntryList')
          ..add('count', count)
          ..add('next', next)
          ..add('previous', previous)
          ..add('results', results)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class PaginatedRecipeBookEntryListBuilder
    implements
        Builder<
          PaginatedRecipeBookEntryList,
          PaginatedRecipeBookEntryListBuilder
        > {
  _$PaginatedRecipeBookEntryList? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  ListBuilder<RecipeBookEntry>? _results;
  ListBuilder<RecipeBookEntry> get results =>
      _$this._results ??= ListBuilder<RecipeBookEntry>();
  set results(ListBuilder<RecipeBookEntry>? results) =>
      _$this._results = results;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  PaginatedRecipeBookEntryListBuilder() {
    PaginatedRecipeBookEntryList._defaults(this);
  }

  PaginatedRecipeBookEntryListBuilder get _$this {
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
  void replace(PaginatedRecipeBookEntryList other) {
    _$v = other as _$PaginatedRecipeBookEntryList;
  }

  @override
  void update(void Function(PaginatedRecipeBookEntryListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaginatedRecipeBookEntryList build() => _build();

  _$PaginatedRecipeBookEntryList _build() {
    _$PaginatedRecipeBookEntryList _$result;
    try {
      _$result =
          _$v ??
          _$PaginatedRecipeBookEntryList._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'PaginatedRecipeBookEntryList',
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
          r'PaginatedRecipeBookEntryList',
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
