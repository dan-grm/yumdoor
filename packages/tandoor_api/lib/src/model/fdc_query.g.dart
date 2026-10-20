// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fdc_query.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FdcQuery extends FdcQuery {
  @override
  final int currentPage;
  @override
  final BuiltList<FdcQueryFoods> foods;
  @override
  final int totalHits;
  @override
  final int totalPages;

  factory _$FdcQuery([void Function(FdcQueryBuilder)? updates]) =>
      (FdcQueryBuilder()..update(updates))._build();

  _$FdcQuery._({
    required this.currentPage,
    required this.foods,
    required this.totalHits,
    required this.totalPages,
  }) : super._();
  @override
  FdcQuery rebuild(void Function(FdcQueryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FdcQueryBuilder toBuilder() => FdcQueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FdcQuery &&
        currentPage == other.currentPage &&
        foods == other.foods &&
        totalHits == other.totalHits &&
        totalPages == other.totalPages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPage.hashCode);
    _$hash = $jc(_$hash, foods.hashCode);
    _$hash = $jc(_$hash, totalHits.hashCode);
    _$hash = $jc(_$hash, totalPages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FdcQuery')
          ..add('currentPage', currentPage)
          ..add('foods', foods)
          ..add('totalHits', totalHits)
          ..add('totalPages', totalPages))
        .toString();
  }
}

class FdcQueryBuilder implements Builder<FdcQuery, FdcQueryBuilder> {
  _$FdcQuery? _$v;

  int? _currentPage;
  int? get currentPage => _$this._currentPage;
  set currentPage(int? currentPage) => _$this._currentPage = currentPage;

  ListBuilder<FdcQueryFoods>? _foods;
  ListBuilder<FdcQueryFoods> get foods =>
      _$this._foods ??= ListBuilder<FdcQueryFoods>();
  set foods(ListBuilder<FdcQueryFoods>? foods) => _$this._foods = foods;

  int? _totalHits;
  int? get totalHits => _$this._totalHits;
  set totalHits(int? totalHits) => _$this._totalHits = totalHits;

  int? _totalPages;
  int? get totalPages => _$this._totalPages;
  set totalPages(int? totalPages) => _$this._totalPages = totalPages;

  FdcQueryBuilder() {
    FdcQuery._defaults(this);
  }

  FdcQueryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPage = $v.currentPage;
      _foods = $v.foods.toBuilder();
      _totalHits = $v.totalHits;
      _totalPages = $v.totalPages;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FdcQuery other) {
    _$v = other as _$FdcQuery;
  }

  @override
  void update(void Function(FdcQueryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FdcQuery build() => _build();

  _$FdcQuery _build() {
    _$FdcQuery _$result;
    try {
      _$result =
          _$v ??
          _$FdcQuery._(
            currentPage: BuiltValueNullFieldError.checkNotNull(
              currentPage,
              r'FdcQuery',
              'currentPage',
            ),
            foods: foods.build(),
            totalHits: BuiltValueNullFieldError.checkNotNull(
              totalHits,
              r'FdcQuery',
              'totalHits',
            ),
            totalPages: BuiltValueNullFieldError.checkNotNull(
              totalPages,
              r'FdcQuery',
              'totalPages',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'foods';
        foods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FdcQuery',
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
