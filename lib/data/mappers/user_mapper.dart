import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/user_ref.dart';
import 'mapping.dart';

extension UserMapper on api.User {
  UserRef toDomain() => UserRef(id: requireId(id, 'User'), name: _name);

  // Tandoor builds `display_name` from first and last name ("Anna " for an
  // empty last name) and sends `null` for some users.
  String get _name {
    final display = displayName?.trim() ?? '';
    return display.isNotEmpty ? display : username ?? '';
  }
}
