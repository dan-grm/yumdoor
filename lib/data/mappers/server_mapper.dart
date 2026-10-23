import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../domain/models/server_info.dart';

extension ServerSettingsMapper on api.ServerSettings {
  ServerInfo toDomain() => ServerInfo(version: version);
}
