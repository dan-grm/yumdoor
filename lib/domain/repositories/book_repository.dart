import '../../core/failures.dart';
import '../models/recipe_book.dart';

/// Recipe books of the current user. Methods throw a [Failure].
abstract interface class BookRepository {
  /// Every book the user owns or that is shared with them, in the order the
  /// user gave them on Tandoor.
  Future<List<RecipeBook>> books();
}
