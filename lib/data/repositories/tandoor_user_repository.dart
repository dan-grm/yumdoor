import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/user_ref.dart';
import '../../domain/repositories/user_repository.dart';
import '../api/api_failures.dart';
import '../mappers/mapping.dart';
import '../mappers/user_mapper.dart';
import 'current_user.dart';

class TandoorUserRepository implements UserRepository {
  TandoorUserRepository(this._api, {CurrentUser? currentUser})
    : _currentUser = currentUser ?? CurrentUser(_api);

  final api.ApiApi _api;
  final CurrentUser _currentUser;

  @override
  Future<int> currentUserId() => guardRequest(_currentUser.id);

  @override
  Future<List<UserRef>> users() => guardRequest(() async {
    // Not paginated: every member of the space at once.
    final response = await _api.apiUserList();
    return [for (final user in requireBody(response.data)) user.toDomain()];
  });
}
