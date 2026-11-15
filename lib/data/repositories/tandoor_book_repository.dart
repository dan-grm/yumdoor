import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/recipe_book.dart';
import '../../domain/repositories/book_repository.dart';
import '../api/api_failures.dart';
import '../mappers/book_mapper.dart';
import '../mappers/mapping.dart';

/// Books per request; the most Tandoor's default pagination allows.
const _pageSize = 100;

class TandoorBookRepository implements BookRepository {
  TandoorBookRepository(this._api);

  final api.ApiApi _api;

  @override
  Future<List<RecipeBook>> books() => guardRequest(() async {
    final books = <RecipeBook>[];
    for (var page = 1; ; page++) {
      final response = await _api.apiRecipeBookList(
        page: page,
        pageSize: _pageSize,
      );
      final body = requireBody(response.data);
      books.addAll([for (final book in body.results) book.toDomain()]);
      if (body.next == null) return books;
    }
  });
}
