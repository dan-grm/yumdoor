// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MealPlan extends MealPlan {
  @override
  final bool? addshopping;
  @override
  final int? createdBy;
  @override
  final DateTime fromDate;
  @override
  final int? id;
  @override
  final MealType mealType;
  @override
  final String? mealTypeName;
  @override
  final String? note;
  @override
  final String? noteMarkdown;
  @override
  final RecipeOverview? recipe;
  @override
  final String? recipeName;
  @override
  final double servings;
  @override
  final bool? shopping;
  @override
  final String? title;
  @override
  final DateTime? toDate;

  factory _$MealPlan([void Function(MealPlanBuilder)? updates]) =>
      (MealPlanBuilder()..update(updates))._build();

  _$MealPlan._({
    this.addshopping,
    this.createdBy,
    required this.fromDate,
    this.id,
    required this.mealType,
    this.mealTypeName,
    this.note,
    this.noteMarkdown,
    this.recipe,
    this.recipeName,
    required this.servings,
    this.shopping,
    this.title,
    this.toDate,
  }) : super._();
  @override
  MealPlan rebuild(void Function(MealPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MealPlanBuilder toBuilder() => MealPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MealPlan &&
        addshopping == other.addshopping &&
        createdBy == other.createdBy &&
        fromDate == other.fromDate &&
        id == other.id &&
        mealType == other.mealType &&
        mealTypeName == other.mealTypeName &&
        note == other.note &&
        noteMarkdown == other.noteMarkdown &&
        recipe == other.recipe &&
        recipeName == other.recipeName &&
        servings == other.servings &&
        shopping == other.shopping &&
        title == other.title &&
        toDate == other.toDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, addshopping.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, fromDate.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mealType.hashCode);
    _$hash = $jc(_$hash, mealTypeName.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, noteMarkdown.hashCode);
    _$hash = $jc(_$hash, recipe.hashCode);
    _$hash = $jc(_$hash, recipeName.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, shopping.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, toDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MealPlan')
          ..add('addshopping', addshopping)
          ..add('createdBy', createdBy)
          ..add('fromDate', fromDate)
          ..add('id', id)
          ..add('mealType', mealType)
          ..add('mealTypeName', mealTypeName)
          ..add('note', note)
          ..add('noteMarkdown', noteMarkdown)
          ..add('recipe', recipe)
          ..add('recipeName', recipeName)
          ..add('servings', servings)
          ..add('shopping', shopping)
          ..add('title', title)
          ..add('toDate', toDate))
        .toString();
  }
}

class MealPlanBuilder implements Builder<MealPlan, MealPlanBuilder> {
  _$MealPlan? _$v;

  bool? _addshopping;
  bool? get addshopping => _$this._addshopping;
  set addshopping(bool? addshopping) => _$this._addshopping = addshopping;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  DateTime? _fromDate;
  DateTime? get fromDate => _$this._fromDate;
  set fromDate(DateTime? fromDate) => _$this._fromDate = fromDate;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  MealTypeBuilder? _mealType;
  MealTypeBuilder get mealType => _$this._mealType ??= MealTypeBuilder();
  set mealType(MealTypeBuilder? mealType) => _$this._mealType = mealType;

  String? _mealTypeName;
  String? get mealTypeName => _$this._mealTypeName;
  set mealTypeName(String? mealTypeName) => _$this._mealTypeName = mealTypeName;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _noteMarkdown;
  String? get noteMarkdown => _$this._noteMarkdown;
  set noteMarkdown(String? noteMarkdown) => _$this._noteMarkdown = noteMarkdown;

  RecipeOverviewBuilder? _recipe;
  RecipeOverviewBuilder get recipe =>
      _$this._recipe ??= RecipeOverviewBuilder();
  set recipe(RecipeOverviewBuilder? recipe) => _$this._recipe = recipe;

  String? _recipeName;
  String? get recipeName => _$this._recipeName;
  set recipeName(String? recipeName) => _$this._recipeName = recipeName;

  double? _servings;
  double? get servings => _$this._servings;
  set servings(double? servings) => _$this._servings = servings;

  bool? _shopping;
  bool? get shopping => _$this._shopping;
  set shopping(bool? shopping) => _$this._shopping = shopping;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _toDate;
  DateTime? get toDate => _$this._toDate;
  set toDate(DateTime? toDate) => _$this._toDate = toDate;

  MealPlanBuilder() {
    MealPlan._defaults(this);
  }

  MealPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _addshopping = $v.addshopping;
      _createdBy = $v.createdBy;
      _fromDate = $v.fromDate;
      _id = $v.id;
      _mealType = $v.mealType.toBuilder();
      _mealTypeName = $v.mealTypeName;
      _note = $v.note;
      _noteMarkdown = $v.noteMarkdown;
      _recipe = $v.recipe?.toBuilder();
      _recipeName = $v.recipeName;
      _servings = $v.servings;
      _shopping = $v.shopping;
      _title = $v.title;
      _toDate = $v.toDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MealPlan other) {
    _$v = other as _$MealPlan;
  }

  @override
  void update(void Function(MealPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MealPlan build() => _build();

  _$MealPlan _build() {
    _$MealPlan _$result;
    try {
      _$result =
          _$v ??
          _$MealPlan._(
            addshopping: addshopping,
            createdBy: createdBy,
            fromDate: BuiltValueNullFieldError.checkNotNull(
              fromDate,
              r'MealPlan',
              'fromDate',
            ),
            id: id,
            mealType: mealType.build(),
            mealTypeName: mealTypeName,
            note: note,
            noteMarkdown: noteMarkdown,
            recipe: _recipe?.build(),
            recipeName: recipeName,
            servings: BuiltValueNullFieldError.checkNotNull(
              servings,
              r'MealPlan',
              'servings',
            ),
            shopping: shopping,
            title: title,
            toDate: toDate,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mealType';
        mealType.build();

        _$failedField = 'recipe';
        _recipe?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MealPlan',
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
