// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_ingredient.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportIngredient extends SourceImportIngredient {
  @override
  final double amount;
  @override
  final SourceImportFood food;
  @override
  final String? note;
  @override
  final int? order;
  @override
  final String originalText;
  @override
  final SourceImportUnit unit;

  factory _$SourceImportIngredient([
    void Function(SourceImportIngredientBuilder)? updates,
  ]) => (SourceImportIngredientBuilder()..update(updates))._build();

  _$SourceImportIngredient._({
    required this.amount,
    required this.food,
    this.note,
    this.order,
    required this.originalText,
    required this.unit,
  }) : super._();
  @override
  SourceImportIngredient rebuild(
    void Function(SourceImportIngredientBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SourceImportIngredientBuilder toBuilder() =>
      SourceImportIngredientBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportIngredient &&
        amount == other.amount &&
        food == other.food &&
        note == other.note &&
        order == other.order &&
        originalText == other.originalText &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, originalText.hashCode);
    _$hash = $jc(_$hash, unit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportIngredient')
          ..add('amount', amount)
          ..add('food', food)
          ..add('note', note)
          ..add('order', order)
          ..add('originalText', originalText)
          ..add('unit', unit))
        .toString();
  }
}

class SourceImportIngredientBuilder
    implements Builder<SourceImportIngredient, SourceImportIngredientBuilder> {
  _$SourceImportIngredient? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  SourceImportFoodBuilder? _food;
  SourceImportFoodBuilder get food =>
      _$this._food ??= SourceImportFoodBuilder();
  set food(SourceImportFoodBuilder? food) => _$this._food = food;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  String? _originalText;
  String? get originalText => _$this._originalText;
  set originalText(String? originalText) => _$this._originalText = originalText;

  SourceImportUnitBuilder? _unit;
  SourceImportUnitBuilder get unit =>
      _$this._unit ??= SourceImportUnitBuilder();
  set unit(SourceImportUnitBuilder? unit) => _$this._unit = unit;

  SourceImportIngredientBuilder() {
    SourceImportIngredient._defaults(this);
  }

  SourceImportIngredientBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _food = $v.food.toBuilder();
      _note = $v.note;
      _order = $v.order;
      _originalText = $v.originalText;
      _unit = $v.unit.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportIngredient other) {
    _$v = other as _$SourceImportIngredient;
  }

  @override
  void update(void Function(SourceImportIngredientBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportIngredient build() => _build();

  _$SourceImportIngredient _build() {
    _$SourceImportIngredient _$result;
    try {
      _$result =
          _$v ??
          _$SourceImportIngredient._(
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'SourceImportIngredient',
              'amount',
            ),
            food: food.build(),
            note: note,
            order: order,
            originalText: BuiltValueNullFieldError.checkNotNull(
              originalText,
              r'SourceImportIngredient',
              'originalText',
            ),
            unit: unit.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'food';
        food.build();

        _$failedField = 'unit';
        unit.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SourceImportIngredient',
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
