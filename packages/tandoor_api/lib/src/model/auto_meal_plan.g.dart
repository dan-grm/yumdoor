// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_meal_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AutoMealPlan extends AutoMealPlan {
  @override
  final bool addshopping;
  @override
  final DateTime endDate;
  @override
  final KeywordModeEnum? keywordMode;
  @override
  final BuiltList<int>? keywords;
  @override
  final int mealTypeId;
  @override
  final double servings;
  @override
  final BuiltList<User>? shared;
  @override
  final DateTime startDate;

  factory _$AutoMealPlan([void Function(AutoMealPlanBuilder)? updates]) =>
      (AutoMealPlanBuilder()..update(updates))._build();

  _$AutoMealPlan._({
    required this.addshopping,
    required this.endDate,
    this.keywordMode,
    this.keywords,
    required this.mealTypeId,
    required this.servings,
    this.shared,
    required this.startDate,
  }) : super._();
  @override
  AutoMealPlan rebuild(void Function(AutoMealPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoMealPlanBuilder toBuilder() => AutoMealPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoMealPlan &&
        addshopping == other.addshopping &&
        endDate == other.endDate &&
        keywordMode == other.keywordMode &&
        keywords == other.keywords &&
        mealTypeId == other.mealTypeId &&
        servings == other.servings &&
        shared == other.shared &&
        startDate == other.startDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, addshopping.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, keywordMode.hashCode);
    _$hash = $jc(_$hash, keywords.hashCode);
    _$hash = $jc(_$hash, mealTypeId.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, shared.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoMealPlan')
          ..add('addshopping', addshopping)
          ..add('endDate', endDate)
          ..add('keywordMode', keywordMode)
          ..add('keywords', keywords)
          ..add('mealTypeId', mealTypeId)
          ..add('servings', servings)
          ..add('shared', shared)
          ..add('startDate', startDate))
        .toString();
  }
}

class AutoMealPlanBuilder
    implements Builder<AutoMealPlan, AutoMealPlanBuilder> {
  _$AutoMealPlan? _$v;

  bool? _addshopping;
  bool? get addshopping => _$this._addshopping;
  set addshopping(bool? addshopping) => _$this._addshopping = addshopping;

  DateTime? _endDate;
  DateTime? get endDate => _$this._endDate;
  set endDate(DateTime? endDate) => _$this._endDate = endDate;

  KeywordModeEnum? _keywordMode;
  KeywordModeEnum? get keywordMode => _$this._keywordMode;
  set keywordMode(KeywordModeEnum? keywordMode) =>
      _$this._keywordMode = keywordMode;

  ListBuilder<int>? _keywords;
  ListBuilder<int> get keywords => _$this._keywords ??= ListBuilder<int>();
  set keywords(ListBuilder<int>? keywords) => _$this._keywords = keywords;

  int? _mealTypeId;
  int? get mealTypeId => _$this._mealTypeId;
  set mealTypeId(int? mealTypeId) => _$this._mealTypeId = mealTypeId;

  double? _servings;
  double? get servings => _$this._servings;
  set servings(double? servings) => _$this._servings = servings;

  ListBuilder<User>? _shared;
  ListBuilder<User> get shared => _$this._shared ??= ListBuilder<User>();
  set shared(ListBuilder<User>? shared) => _$this._shared = shared;

  DateTime? _startDate;
  DateTime? get startDate => _$this._startDate;
  set startDate(DateTime? startDate) => _$this._startDate = startDate;

  AutoMealPlanBuilder() {
    AutoMealPlan._defaults(this);
  }

  AutoMealPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _addshopping = $v.addshopping;
      _endDate = $v.endDate;
      _keywordMode = $v.keywordMode;
      _keywords = $v.keywords?.toBuilder();
      _mealTypeId = $v.mealTypeId;
      _servings = $v.servings;
      _shared = $v.shared?.toBuilder();
      _startDate = $v.startDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoMealPlan other) {
    _$v = other as _$AutoMealPlan;
  }

  @override
  void update(void Function(AutoMealPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoMealPlan build() => _build();

  _$AutoMealPlan _build() {
    _$AutoMealPlan _$result;
    try {
      _$result =
          _$v ??
          _$AutoMealPlan._(
            addshopping: BuiltValueNullFieldError.checkNotNull(
              addshopping,
              r'AutoMealPlan',
              'addshopping',
            ),
            endDate: BuiltValueNullFieldError.checkNotNull(
              endDate,
              r'AutoMealPlan',
              'endDate',
            ),
            keywordMode: keywordMode,
            keywords: _keywords?.build(),
            mealTypeId: BuiltValueNullFieldError.checkNotNull(
              mealTypeId,
              r'AutoMealPlan',
              'mealTypeId',
            ),
            servings: BuiltValueNullFieldError.checkNotNull(
              servings,
              r'AutoMealPlan',
              'servings',
            ),
            shared: _shared?.build(),
            startDate: BuiltValueNullFieldError.checkNotNull(
              startDate,
              r'AutoMealPlan',
              'startDate',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keywords';
        _keywords?.build();

        _$failedField = 'shared';
        _shared?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AutoMealPlan',
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
