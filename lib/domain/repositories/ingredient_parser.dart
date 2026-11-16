import '../../core/failures.dart';
import '../models/parsed_ingredient.dart';

/// Splits ingredient lines into amount, unit, food and note with Tandoor's
/// own ingredient parser, the way Tandoor's editor does.
///
/// Tandoor applies the space's automations (aliases, replacements) and
/// **creates the foods and units it doesn't know yet**, so the food and unit of
/// a result always have an id. Parse a line once the user has finished it
/// (on Enter or when the field loses focus), not while they type, or every
/// half-typed word ends up as a food. That also makes parsing a write: it
/// needs to be online.
///
/// A line Tandoor can't parse comes back as [ParsedIngredient.unparsed]
/// (no food, the text as note), never as a [Failure]. Methods throw a
/// [Failure] only when the request itself fails (offline, logged out, …).
abstract interface class IngredientParser {
  /// Parses one line. A blank line comes back unparsed, without a request.
  Future<ParsedIngredient> parse(String line);

  /// Parses each line that isn't blank, for pasted text, in one request
  /// unless Tandoor fails on a line. Returns one result per non-blank line of
  /// [lines], in their order.
  Future<List<ParsedIngredient>> parseAll(Iterable<String> lines);
}
