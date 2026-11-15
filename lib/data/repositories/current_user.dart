import 'package:tandoor_api/tandoor_api.dart' as api;

import '../mappers/mapping.dart';

/// The current user's id, read once per session and shared by the
/// repositories that need it.
class CurrentUser {
  CurrentUser(this._api);

  final api.ApiApi _api;
  Future<int>? _id;

  /// Shared by concurrent calls, and asked again after a failure. Its
  /// errors count as handled, so a caller can throw another failure first.
  /// Not guarded: call it inside `guardRequest`.
  Future<int> id() {
    if (_id case final id?) return id;
    final id = _id = _read();
    id.then<void>((_) {}, onError: (Object _) => _id = null).ignore();
    id.ignore();
    return id;
  }

  // `/api/user-preference/` lists only the caller's own preferences, for
  // every user; there is no "current user" endpoint.
  Future<int> _read() async {
    final response = await _api.apiUserPreferenceList();
    final user = requireBody(response.data).firstOrNull?.user;
    return requireId(user?.id, 'User');
  }
}
