import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/parsed_ingredient.dart';
import 'package:yumdoor/domain/repositories/ingredient_parser.dart';

/// [IngredientParser] for tests: answers each line from [results] (by the
/// trimmed line) and every other line as [ParsedIngredient.unparsed], like
/// Tandoor does for a line it can't parse. Set [failure] to make it throw.
class FakeIngredientParser implements IngredientParser {
  FakeIngredientParser([Map<String, ParsedIngredient> results = const {}])
    : results = {...results};

  final Map<String, ParsedIngredient> results;

  /// Every line sent to the parser, in order; blank ones aren't sent.
  final parsed = <String>[];
  Failure? failure;

  @override
  Future<ParsedIngredient> parse(String line) async {
    if (line.trim().isEmpty) return ParsedIngredient.unparsed(line);
    if (failure case final failure?) throw failure;
    parsed.add(line);
    return switch (results[line.trim()]) {
      final result? => result.copyWith(originalText: line),
      null => ParsedIngredient.unparsed(line),
    };
  }

  @override
  Future<List<ParsedIngredient>> parseAll(Iterable<String> lines) async {
    return [
      for (final line in lines)
        if (line.trim().isNotEmpty) await parse(line),
    ];
  }
}
