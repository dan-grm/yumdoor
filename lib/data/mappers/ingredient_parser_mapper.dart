import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/parsed_ingredient.dart';
import '../../domain/models/recipe_draft.dart';
import 'food_mapper.dart';
import 'mapping.dart';

extension ParsedIngredientMapper on api.IngredientSimple {
  /// The parser's result for [line], the text sent. Tandoor gets or creates the food and
  /// unit while parsing, so both come with an id.
  ParsedIngredient toParsed(String line) => ParsedIngredient(
    // The server trims it.
    originalText: line,
    food: switch (food) {
      final food? => NamedRef(id: requireId(food.id, 'Food'), name: food.name),
      null => null,
    },
    unit: switch (unit) {
      final unit? => NamedRef.unit(unit.toDomain()),
      null => null,
    },
    amount: amount,
    note: note?.trim() ?? '',
  );
}
