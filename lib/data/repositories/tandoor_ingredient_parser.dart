import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/failures.dart';
import '../../domain/models/parsed_ingredient.dart';
import '../../domain/repositories/ingredient_parser.dart';
import '../api/api_failures.dart';
import '../mappers/ingredient_parser_mapper.dart';
import '../mappers/mapping.dart';

/// [IngredientParser] with `POST /api/ingredient-parser/post/`
/// (docs/TANDOOR_API.md#ingredient-parser).
class TandoorIngredientParser implements IngredientParser {
  TandoorIngredientParser(this._api);

  final api.ApiApi _api;

  @override
  Future<ParsedIngredient> parse(String line) async {
    if (!_isParseable(line)) return ParsedIngredient.unparsed(line);
    try {
      return await guardRequest(() async {
        final response = await _api.apiIngredientParserPostCreate(
          ingredientParserRequest: api.IngredientParserRequest(
            (b) => b..ingredient = line,
          ),
        );
        // `null` for a line that is blank to Python but not to Dart.
        final parsed = requireBody(response.data).ingredient;
        return parsed?.toParsed(line) ?? ParsedIngredient.unparsed(line);
      });
    } on ServerFailure catch (e) {
      if (!_isParserError(e)) rethrow;
      return ParsedIngredient.unparsed(line);
    }
  }

  @override
  Future<List<ParsedIngredient>> parseAll(Iterable<String> lines) async {
    final nonBlank = [
      for (final line in lines)
        if (line.trim().isNotEmpty) line,
    ];
    final parseable = nonBlank.where(_isParseable).toList();
    final parsed = await _parseList(parseable);
    final results = parsed.iterator;
    return [
      for (final line in nonBlank)
        if (_isParseable(line) && results.moveNext())
          results.current
        else
          ParsedIngredient.unparsed(line),
    ];
  }

  /// [lines] parsed in one request, or one by one if a line in it makes the
  /// parser fail (it fails the whole list then).
  Future<List<ParsedIngredient>> _parseList(List<String> lines) async {
    if (lines.isEmpty) return const [];
    try {
      final parsed = await guardRequest(() async {
        final response = await _api.apiIngredientParserPostCreate(
          ingredientParserRequest: api.IngredientParserRequest(
            (b) => b..ingredients = ListBuilder(lines),
          ),
        );
        return requireBody(response.data).ingredients.toList();
      });
      // The server leaves out lines that are blank to Python's strip(),
      // which can be more than to Dart's trim(); then results can't be
      // matched to lines.
      if (parsed.length == lines.length) {
        return [
          for (final (i, ingredient) in parsed.indexed)
            ingredient.toParsed(lines[i]),
        ];
      }
    } on ServerFailure catch (e) {
      // Otherwise fall through to parsing line by line.
      if (!_isParserError(e)) rethrow;
    }
    // One after the other: Tandoor gets or creates foods without a lock, so
    // parallel requests could create the same food twice.
    return [for (final line in lines) await parse(line)];
  }

  /// Whether Tandoor's parser can get past the start of [line]: it strips
  /// leading symbols and fails with a 500 when nothing is left, and for lines
  /// longer than 512 characters (`cookbook/helper/ingredient_parser.py`).
  static bool _isParseable(String line) {
    final trimmed = line.trim();
    return trimmed.length <= 512 &&
        trimmed.replaceFirst(_leadingSymbols, '').trim().isNotEmpty;
  }

  static final _leadingSymbols = RegExp(r'^[,.\-_=+#*|\\/]+');

  /// The parser answers a line it can't parse with a 500 (an uncaught
  /// `ValueError` or `IndexError`) and a blank one with a 400.
  static bool _isParserError(ServerFailure failure) =>
      failure.statusCode == 400 || failure.statusCode == 500;
}
