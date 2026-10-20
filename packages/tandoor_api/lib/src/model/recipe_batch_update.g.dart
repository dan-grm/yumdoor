// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_batch_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeBatchUpdate extends RecipeBatchUpdate {
  @override
  final bool? clearDescription;
  @override
  final BuiltList<int> keywordsAdd;
  @override
  final BuiltList<int> keywordsRemove;
  @override
  final bool? keywordsRemoveAll;
  @override
  final BuiltList<int> keywordsSet;
  @override
  final bool? private;
  @override
  final BuiltList<int> recipes;
  @override
  final int? servings;
  @override
  final String? servingsText;
  @override
  final BuiltList<int> sharedAdd;
  @override
  final BuiltList<int> sharedRemove;
  @override
  final bool? sharedRemoveAll;
  @override
  final BuiltList<int> sharedSet;
  @override
  final bool? showIngredientOverview;
  @override
  final int? waitingTime;
  @override
  final int? workingTime;

  factory _$RecipeBatchUpdate([
    void Function(RecipeBatchUpdateBuilder)? updates,
  ]) => (RecipeBatchUpdateBuilder()..update(updates))._build();

  _$RecipeBatchUpdate._({
    this.clearDescription,
    required this.keywordsAdd,
    required this.keywordsRemove,
    this.keywordsRemoveAll,
    required this.keywordsSet,
    this.private,
    required this.recipes,
    this.servings,
    this.servingsText,
    required this.sharedAdd,
    required this.sharedRemove,
    this.sharedRemoveAll,
    required this.sharedSet,
    this.showIngredientOverview,
    this.waitingTime,
    this.workingTime,
  }) : super._();
  @override
  RecipeBatchUpdate rebuild(void Function(RecipeBatchUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeBatchUpdateBuilder toBuilder() =>
      RecipeBatchUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeBatchUpdate &&
        clearDescription == other.clearDescription &&
        keywordsAdd == other.keywordsAdd &&
        keywordsRemove == other.keywordsRemove &&
        keywordsRemoveAll == other.keywordsRemoveAll &&
        keywordsSet == other.keywordsSet &&
        private == other.private &&
        recipes == other.recipes &&
        servings == other.servings &&
        servingsText == other.servingsText &&
        sharedAdd == other.sharedAdd &&
        sharedRemove == other.sharedRemove &&
        sharedRemoveAll == other.sharedRemoveAll &&
        sharedSet == other.sharedSet &&
        showIngredientOverview == other.showIngredientOverview &&
        waitingTime == other.waitingTime &&
        workingTime == other.workingTime;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clearDescription.hashCode);
    _$hash = $jc(_$hash, keywordsAdd.hashCode);
    _$hash = $jc(_$hash, keywordsRemove.hashCode);
    _$hash = $jc(_$hash, keywordsRemoveAll.hashCode);
    _$hash = $jc(_$hash, keywordsSet.hashCode);
    _$hash = $jc(_$hash, private.hashCode);
    _$hash = $jc(_$hash, recipes.hashCode);
    _$hash = $jc(_$hash, servings.hashCode);
    _$hash = $jc(_$hash, servingsText.hashCode);
    _$hash = $jc(_$hash, sharedAdd.hashCode);
    _$hash = $jc(_$hash, sharedRemove.hashCode);
    _$hash = $jc(_$hash, sharedRemoveAll.hashCode);
    _$hash = $jc(_$hash, sharedSet.hashCode);
    _$hash = $jc(_$hash, showIngredientOverview.hashCode);
    _$hash = $jc(_$hash, waitingTime.hashCode);
    _$hash = $jc(_$hash, workingTime.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeBatchUpdate')
          ..add('clearDescription', clearDescription)
          ..add('keywordsAdd', keywordsAdd)
          ..add('keywordsRemove', keywordsRemove)
          ..add('keywordsRemoveAll', keywordsRemoveAll)
          ..add('keywordsSet', keywordsSet)
          ..add('private', private)
          ..add('recipes', recipes)
          ..add('servings', servings)
          ..add('servingsText', servingsText)
          ..add('sharedAdd', sharedAdd)
          ..add('sharedRemove', sharedRemove)
          ..add('sharedRemoveAll', sharedRemoveAll)
          ..add('sharedSet', sharedSet)
          ..add('showIngredientOverview', showIngredientOverview)
          ..add('waitingTime', waitingTime)
          ..add('workingTime', workingTime))
        .toString();
  }
}

class RecipeBatchUpdateBuilder
    implements Builder<RecipeBatchUpdate, RecipeBatchUpdateBuilder> {
  _$RecipeBatchUpdate? _$v;

  bool? _clearDescription;
  bool? get clearDescription => _$this._clearDescription;
  set clearDescription(bool? clearDescription) =>
      _$this._clearDescription = clearDescription;

  ListBuilder<int>? _keywordsAdd;
  ListBuilder<int> get keywordsAdd =>
      _$this._keywordsAdd ??= ListBuilder<int>();
  set keywordsAdd(ListBuilder<int>? keywordsAdd) =>
      _$this._keywordsAdd = keywordsAdd;

  ListBuilder<int>? _keywordsRemove;
  ListBuilder<int> get keywordsRemove =>
      _$this._keywordsRemove ??= ListBuilder<int>();
  set keywordsRemove(ListBuilder<int>? keywordsRemove) =>
      _$this._keywordsRemove = keywordsRemove;

  bool? _keywordsRemoveAll;
  bool? get keywordsRemoveAll => _$this._keywordsRemoveAll;
  set keywordsRemoveAll(bool? keywordsRemoveAll) =>
      _$this._keywordsRemoveAll = keywordsRemoveAll;

  ListBuilder<int>? _keywordsSet;
  ListBuilder<int> get keywordsSet =>
      _$this._keywordsSet ??= ListBuilder<int>();
  set keywordsSet(ListBuilder<int>? keywordsSet) =>
      _$this._keywordsSet = keywordsSet;

  bool? _private;
  bool? get private => _$this._private;
  set private(bool? private) => _$this._private = private;

  ListBuilder<int>? _recipes;
  ListBuilder<int> get recipes => _$this._recipes ??= ListBuilder<int>();
  set recipes(ListBuilder<int>? recipes) => _$this._recipes = recipes;

  int? _servings;
  int? get servings => _$this._servings;
  set servings(int? servings) => _$this._servings = servings;

  String? _servingsText;
  String? get servingsText => _$this._servingsText;
  set servingsText(String? servingsText) => _$this._servingsText = servingsText;

  ListBuilder<int>? _sharedAdd;
  ListBuilder<int> get sharedAdd => _$this._sharedAdd ??= ListBuilder<int>();
  set sharedAdd(ListBuilder<int>? sharedAdd) => _$this._sharedAdd = sharedAdd;

  ListBuilder<int>? _sharedRemove;
  ListBuilder<int> get sharedRemove =>
      _$this._sharedRemove ??= ListBuilder<int>();
  set sharedRemove(ListBuilder<int>? sharedRemove) =>
      _$this._sharedRemove = sharedRemove;

  bool? _sharedRemoveAll;
  bool? get sharedRemoveAll => _$this._sharedRemoveAll;
  set sharedRemoveAll(bool? sharedRemoveAll) =>
      _$this._sharedRemoveAll = sharedRemoveAll;

  ListBuilder<int>? _sharedSet;
  ListBuilder<int> get sharedSet => _$this._sharedSet ??= ListBuilder<int>();
  set sharedSet(ListBuilder<int>? sharedSet) => _$this._sharedSet = sharedSet;

  bool? _showIngredientOverview;
  bool? get showIngredientOverview => _$this._showIngredientOverview;
  set showIngredientOverview(bool? showIngredientOverview) =>
      _$this._showIngredientOverview = showIngredientOverview;

  int? _waitingTime;
  int? get waitingTime => _$this._waitingTime;
  set waitingTime(int? waitingTime) => _$this._waitingTime = waitingTime;

  int? _workingTime;
  int? get workingTime => _$this._workingTime;
  set workingTime(int? workingTime) => _$this._workingTime = workingTime;

  RecipeBatchUpdateBuilder() {
    RecipeBatchUpdate._defaults(this);
  }

  RecipeBatchUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clearDescription = $v.clearDescription;
      _keywordsAdd = $v.keywordsAdd.toBuilder();
      _keywordsRemove = $v.keywordsRemove.toBuilder();
      _keywordsRemoveAll = $v.keywordsRemoveAll;
      _keywordsSet = $v.keywordsSet.toBuilder();
      _private = $v.private;
      _recipes = $v.recipes.toBuilder();
      _servings = $v.servings;
      _servingsText = $v.servingsText;
      _sharedAdd = $v.sharedAdd.toBuilder();
      _sharedRemove = $v.sharedRemove.toBuilder();
      _sharedRemoveAll = $v.sharedRemoveAll;
      _sharedSet = $v.sharedSet.toBuilder();
      _showIngredientOverview = $v.showIngredientOverview;
      _waitingTime = $v.waitingTime;
      _workingTime = $v.workingTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeBatchUpdate other) {
    _$v = other as _$RecipeBatchUpdate;
  }

  @override
  void update(void Function(RecipeBatchUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeBatchUpdate build() => _build();

  _$RecipeBatchUpdate _build() {
    _$RecipeBatchUpdate _$result;
    try {
      _$result =
          _$v ??
          _$RecipeBatchUpdate._(
            clearDescription: clearDescription,
            keywordsAdd: keywordsAdd.build(),
            keywordsRemove: keywordsRemove.build(),
            keywordsRemoveAll: keywordsRemoveAll,
            keywordsSet: keywordsSet.build(),
            private: private,
            recipes: recipes.build(),
            servings: servings,
            servingsText: servingsText,
            sharedAdd: sharedAdd.build(),
            sharedRemove: sharedRemove.build(),
            sharedRemoveAll: sharedRemoveAll,
            sharedSet: sharedSet.build(),
            showIngredientOverview: showIngredientOverview,
            waitingTime: waitingTime,
            workingTime: workingTime,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keywordsAdd';
        keywordsAdd.build();
        _$failedField = 'keywordsRemove';
        keywordsRemove.build();

        _$failedField = 'keywordsSet';
        keywordsSet.build();

        _$failedField = 'recipes';
        recipes.build();

        _$failedField = 'sharedAdd';
        sharedAdd.build();
        _$failedField = 'sharedRemove';
        sharedRemove.build();

        _$failedField = 'sharedSet';
        sharedSet.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecipeBatchUpdate',
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
