// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportStep extends SourceImportStep {
  @override
  final BuiltList<SourceImportIngredient> ingredients;
  @override
  final String instruction;
  @override
  final bool? showIngredientsTable;

  factory _$SourceImportStep([
    void Function(SourceImportStepBuilder)? updates,
  ]) => (SourceImportStepBuilder()..update(updates))._build();

  _$SourceImportStep._({
    required this.ingredients,
    required this.instruction,
    this.showIngredientsTable,
  }) : super._();
  @override
  SourceImportStep rebuild(void Function(SourceImportStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SourceImportStepBuilder toBuilder() =>
      SourceImportStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportStep &&
        ingredients == other.ingredients &&
        instruction == other.instruction &&
        showIngredientsTable == other.showIngredientsTable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ingredients.hashCode);
    _$hash = $jc(_$hash, instruction.hashCode);
    _$hash = $jc(_$hash, showIngredientsTable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportStep')
          ..add('ingredients', ingredients)
          ..add('instruction', instruction)
          ..add('showIngredientsTable', showIngredientsTable))
        .toString();
  }
}

class SourceImportStepBuilder
    implements Builder<SourceImportStep, SourceImportStepBuilder> {
  _$SourceImportStep? _$v;

  ListBuilder<SourceImportIngredient>? _ingredients;
  ListBuilder<SourceImportIngredient> get ingredients =>
      _$this._ingredients ??= ListBuilder<SourceImportIngredient>();
  set ingredients(ListBuilder<SourceImportIngredient>? ingredients) =>
      _$this._ingredients = ingredients;

  String? _instruction;
  String? get instruction => _$this._instruction;
  set instruction(String? instruction) => _$this._instruction = instruction;

  bool? _showIngredientsTable;
  bool? get showIngredientsTable => _$this._showIngredientsTable;
  set showIngredientsTable(bool? showIngredientsTable) =>
      _$this._showIngredientsTable = showIngredientsTable;

  SourceImportStepBuilder() {
    SourceImportStep._defaults(this);
  }

  SourceImportStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ingredients = $v.ingredients.toBuilder();
      _instruction = $v.instruction;
      _showIngredientsTable = $v.showIngredientsTable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportStep other) {
    _$v = other as _$SourceImportStep;
  }

  @override
  void update(void Function(SourceImportStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportStep build() => _build();

  _$SourceImportStep _build() {
    _$SourceImportStep _$result;
    try {
      _$result =
          _$v ??
          _$SourceImportStep._(
            ingredients: ingredients.build(),
            instruction: BuiltValueNullFieldError.checkNotNull(
              instruction,
              r'SourceImportStep',
              'instruction',
            ),
            showIngredientsTable: showIngredientsTable,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ingredients';
        ingredients.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SourceImportStep',
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
