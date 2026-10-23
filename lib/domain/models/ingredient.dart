import 'package:freezed_annotation/freezed_annotation.dart';

import 'food.dart';
import 'unit.dart';

part 'ingredient.freezed.dart';

/// One line of a step's ingredient list, for the recipe's base servings.
@freezed
abstract class Ingredient with _$Ingredient {
  const factory Ingredient({
    required int id,
    Food? food,
    Unit? unit,

    /// For `Recipe.servings`; scale it for other servings. Meaningless if
    /// [noAmount] is set.
    @Default(0) double amount,

    /// "Salz und Pfeffer": shown without an amount, never scaled.
    @Default(false) bool noAmount,

    /// A heading inside the list ("Für den Teig"); its text is in [note].
    @Default(false) bool isHeader,
    @Default('') String note,

    /// The line as originally imported, if Tandoor parsed it from text.
    String? originalText,
    @Default(0) int order,
  }) = _Ingredient;
}
