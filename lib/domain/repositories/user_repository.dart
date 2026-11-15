import '../../core/failures.dart';
import '../models/user_ref.dart';

/// Users of the current space. Methods throw a [Failure].
abstract interface class UserRepository {
  /// Every member of the space, the current user included.
  Future<List<UserRef>> users();
}
