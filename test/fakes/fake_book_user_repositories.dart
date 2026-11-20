import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/recipe_book.dart';
import 'package:yumdoor/domain/models/user_ref.dart';
import 'package:yumdoor/domain/repositories/book_repository.dart';
import 'package:yumdoor/domain/repositories/user_repository.dart';

/// [BookRepository] for tests. Set [failure] to make it throw.
class FakeBookRepository implements BookRepository {
  FakeBookRepository([this.list = const []]);

  final List<RecipeBook> list;
  Failure? failure;

  @override
  Future<List<RecipeBook>> books() async {
    if (failure case final failure?) throw failure;
    return list;
  }
}

/// [UserRepository] for tests. Set [failure] to make it throw.
class FakeUserRepository implements UserRepository {
  FakeUserRepository([this.list = const [], this.currentId = 1]);

  final List<UserRef> list;
  final int currentId;
  Failure? failure;

  @override
  Future<List<UserRef>> users() async {
    if (failure case final failure?) throw failure;
    return list;
  }

  @override
  Future<int> currentUserId() async {
    if (failure case final failure?) throw failure;
    return currentId;
  }
}
