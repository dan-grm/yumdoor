import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_draft.dart';

part 'parsed_ingredient.freezed.dart';

/// An ingredient line such as "200 g Karotten, geschält" split into amount,
/// unit, food and note by `IngredientParser`.
@freezed
abstract class ParsedIngredient with _$ParsedIngredient {
  const ParsedIngredient._();

  const factory ParsedIngredient({
    /// The line as typed.
    required String originalText,

    /// The food, `null` for a line that couldn't be parsed; its text is then
    /// in [note].
    NamedRef? food,

    /// `null` for a line without a unit ("2 Eier").
    NamedRef? unit,

    /// 0 for a line without an amount ("Salz, nach Geschmack").
    @Default(0) double amount,

    /// What follows the food after a comma or in brackets ("geschält").
    @Default('') String note,
  }) = _ParsedIngredient;

  /// A line that couldn't be parsed: no food, the trimmed [text] as note.
  factory ParsedIngredient.unparsed(String text) =>
      ParsedIngredient(originalText: text, note: text.trim());

  /// A new ingredient of a recipe draft with these values.
  IngredientDraft toDraft() => IngredientDraft(
    food: food,
    unit: unit,
    amount: amount,
    note: note,
    originalText: originalText,
  );
}
