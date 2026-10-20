// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Step extends Step {
  @override
  final UserFileView? file;
  @override
  final int? id;
  @override
  final BuiltList<Ingredient> ingredients;
  @override
  final String? instruction;
  @override
  final String? instructionsMarkdown;
  @override
  final String? name;
  @override
  final int? numrecipe;
  @override
  final int? order;
  @override
  final bool? showAsHeader;
  @override
  final bool? showIngredientsTable;
  @override
  final int? stepRecipe;
  @override
  final JsonObject? stepRecipeData;
  @override
  final int? time;

  factory _$Step([void Function(StepBuilder)? updates]) =>
      (StepBuilder()..update(updates))._build();

  _$Step._({
    this.file,
    this.id,
    required this.ingredients,
    this.instruction,
    this.instructionsMarkdown,
    this.name,
    this.numrecipe,
    this.order,
    this.showAsHeader,
    this.showIngredientsTable,
    this.stepRecipe,
    this.stepRecipeData,
    this.time,
  }) : super._();
  @override
  Step rebuild(void Function(StepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StepBuilder toBuilder() => StepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Step &&
        file == other.file &&
        id == other.id &&
        ingredients == other.ingredients &&
        instruction == other.instruction &&
        instructionsMarkdown == other.instructionsMarkdown &&
        name == other.name &&
        numrecipe == other.numrecipe &&
        order == other.order &&
        showAsHeader == other.showAsHeader &&
        showIngredientsTable == other.showIngredientsTable &&
        stepRecipe == other.stepRecipe &&
        stepRecipeData == other.stepRecipeData &&
        time == other.time;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, file.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ingredients.hashCode);
    _$hash = $jc(_$hash, instruction.hashCode);
    _$hash = $jc(_$hash, instructionsMarkdown.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, numrecipe.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, showAsHeader.hashCode);
    _$hash = $jc(_$hash, showIngredientsTable.hashCode);
    _$hash = $jc(_$hash, stepRecipe.hashCode);
    _$hash = $jc(_$hash, stepRecipeData.hashCode);
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Step')
          ..add('file', file)
          ..add('id', id)
          ..add('ingredients', ingredients)
          ..add('instruction', instruction)
          ..add('instructionsMarkdown', instructionsMarkdown)
          ..add('name', name)
          ..add('numrecipe', numrecipe)
          ..add('order', order)
          ..add('showAsHeader', showAsHeader)
          ..add('showIngredientsTable', showIngredientsTable)
          ..add('stepRecipe', stepRecipe)
          ..add('stepRecipeData', stepRecipeData)
          ..add('time', time))
        .toString();
  }
}

class StepBuilder implements Builder<Step, StepBuilder> {
  _$Step? _$v;

  UserFileViewBuilder? _file;
  UserFileViewBuilder get file => _$this._file ??= UserFileViewBuilder();
  set file(UserFileViewBuilder? file) => _$this._file = file;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ListBuilder<Ingredient>? _ingredients;
  ListBuilder<Ingredient> get ingredients =>
      _$this._ingredients ??= ListBuilder<Ingredient>();
  set ingredients(ListBuilder<Ingredient>? ingredients) =>
      _$this._ingredients = ingredients;

  String? _instruction;
  String? get instruction => _$this._instruction;
  set instruction(String? instruction) => _$this._instruction = instruction;

  String? _instructionsMarkdown;
  String? get instructionsMarkdown => _$this._instructionsMarkdown;
  set instructionsMarkdown(String? instructionsMarkdown) =>
      _$this._instructionsMarkdown = instructionsMarkdown;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _numrecipe;
  int? get numrecipe => _$this._numrecipe;
  set numrecipe(int? numrecipe) => _$this._numrecipe = numrecipe;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  bool? _showAsHeader;
  bool? get showAsHeader => _$this._showAsHeader;
  set showAsHeader(bool? showAsHeader) => _$this._showAsHeader = showAsHeader;

  bool? _showIngredientsTable;
  bool? get showIngredientsTable => _$this._showIngredientsTable;
  set showIngredientsTable(bool? showIngredientsTable) =>
      _$this._showIngredientsTable = showIngredientsTable;

  int? _stepRecipe;
  int? get stepRecipe => _$this._stepRecipe;
  set stepRecipe(int? stepRecipe) => _$this._stepRecipe = stepRecipe;

  JsonObject? _stepRecipeData;
  JsonObject? get stepRecipeData => _$this._stepRecipeData;
  set stepRecipeData(JsonObject? stepRecipeData) =>
      _$this._stepRecipeData = stepRecipeData;

  int? _time;
  int? get time => _$this._time;
  set time(int? time) => _$this._time = time;

  StepBuilder() {
    Step._defaults(this);
  }

  StepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _file = $v.file?.toBuilder();
      _id = $v.id;
      _ingredients = $v.ingredients.toBuilder();
      _instruction = $v.instruction;
      _instructionsMarkdown = $v.instructionsMarkdown;
      _name = $v.name;
      _numrecipe = $v.numrecipe;
      _order = $v.order;
      _showAsHeader = $v.showAsHeader;
      _showIngredientsTable = $v.showIngredientsTable;
      _stepRecipe = $v.stepRecipe;
      _stepRecipeData = $v.stepRecipeData;
      _time = $v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Step other) {
    _$v = other as _$Step;
  }

  @override
  void update(void Function(StepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Step build() => _build();

  _$Step _build() {
    _$Step _$result;
    try {
      _$result =
          _$v ??
          _$Step._(
            file: _file?.build(),
            id: id,
            ingredients: ingredients.build(),
            instruction: instruction,
            instructionsMarkdown: instructionsMarkdown,
            name: name,
            numrecipe: numrecipe,
            order: order,
            showAsHeader: showAsHeader,
            showIngredientsTable: showIngredientsTable,
            stepRecipe: stepRecipe,
            stepRecipeData: stepRecipeData,
            time: time,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'file';
        _file?.build();

        _$failedField = 'ingredients';
        ingredients.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Step', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
