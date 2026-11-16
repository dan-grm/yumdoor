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
///
/// Tandoor answers a line it can't parse with a 500, like any server error.
/// After the first 500 of a call, a request to another endpoint tells the
/// two apart: if that fails too, the call throws its failure.
class TandoorIngredientParser implements IngredientParser {
  TandoorIngredientParser(this._api);

  final api.ApiApi _api;

  /// The end of the last call. Calls run one after the other: Tandoor gets
  /// or creates foods and units without a lock, so parallel requests could
  /// create the same food twice.
  Future<void> _queue = Future.value();

  @override
  Future<ParsedIngredient> parse(String line) =>
      _serially(() async => (await _parseList([line])).single);

  @override
  Future<List<ParsedIngredient>> parseAll(Iterable<String> lines) {
    final nonBlank = [
      for (final line in lines)
        if (line.trim().isNotEmpty) line,
    ];
    return _serially(() => _parseList(nonBlank));
  }

  Future<T> _serially<T>(Future<T> Function() call) {
    final result = _queue.then((_) {
      _serverChecked = false;
      return call();
    });
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  /// [lines] parsed, with as few requests as possible: in one, or, if a line
  /// makes Tandoor fail the whole list, in halves until the line that fails
  /// is found.
  Future<List<ParsedIngredient>> _parseList(List<String> lines) async {
    final parseable = lines.where(_isParseable).toList();
    final parsed = parseable.isEmpty
        ? const <ParsedIngredient>[]
        : await _request(parseable);
    final results = parsed.iterator;
    return [
      for (final line in lines)
        if (_isParseable(line) && results.moveNext())
          results.current
        else
          ParsedIngredient.unparsed(line),
    ];
  }

  Future<List<ParsedIngredient>> _request(List<String> lines) async {
    try {
      final parsed = await guardRequest(() async {
        final response = await _api.apiIngredientParserPostCreate(
          ingredientParserRequest: api.IngredientParserRequest(
            (b) => b..ingredients = ListBuilder(lines),
          ),
        );
        final ingredients = requireBody(response.data).ingredients;
        // The server leaves out lines that are blank to Python's strip(),
        // which can be more than to Dart's trim(); then results can't be
        // matched to lines.
        if (ingredients.length != lines.length) return null;
        return [
          for (final (i, ingredient) in ingredients.indexed)
            ingredient.toParsed(lines[i]),
        ];
      });
      if (parsed != null) return parsed;
    } on ServerFailure catch (e) {
      if (!_isParserError(e)) rethrow;
      await _checkServer();
    }
    if (lines.length == 1) return [ParsedIngredient.unparsed(lines.single)];
    final half = lines.length ~/ 2;
    return [
      ...await _request(lines.sublist(0, half)),
      ...await _request(lines.sublist(half)),
    ];
  }

  /// Whether the server answered another request since the current call's
  /// first 500. Calls run one at a time, so one flag is enough.
  bool _serverChecked = false;

  /// Throws a [Failure] if the server fails other requests too, so a 500
  /// from the parser isn't about the line.
  Future<void> _checkServer() async {
    if (_serverChecked) return;
    await guardRequest(_api.apiServerSettingsCurrentRetrieve);
    _serverChecked = true;
  }

  /// Whether Tandoor's parser can get past the start of [line]: it strips
  /// leading symbols and fails with a 500 when nothing is left, and for lines
  /// longer than 512 characters (`cookbook/helper/ingredient_parser.py`;
  /// Python counts code points).
  static bool _isParseable(String line) {
    final trimmed = line.trim();
    return trimmed.runes.length <= 512 &&
        trimmed.replaceFirst(_leadingSymbols, '').trim().isNotEmpty;
  }

  static final _leadingSymbols = RegExp(r'^[,.\-_=+#*|\\/]+');

  /// The parser answers a line it can't parse with a 500 (an uncaught
  /// `ValueError` or `IndexError`).
  static bool _isParserError(ServerFailure failure) =>
      failure.statusCode == 500;
}
