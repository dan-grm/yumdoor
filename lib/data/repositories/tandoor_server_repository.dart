import 'package:dio/dio.dart';
import 'package:tandoor_api/tandoor_api.dart' as api;

import '../../core/failures.dart';
import '../../domain/models/server_info.dart';
import '../../domain/repositories/server_repository.dart';
import '../api/api_failures.dart';
import '../api/tandoor_dio.dart';
import '../mappers/mapping.dart';
import '../mappers/server_mapper.dart';

class TandoorServerRepository implements ServerRepository {
  TandoorServerRepository({this._dioFor = createTandoorDio});

  final Dio Function(Uri serverUrl) _dioFor;

  @override
  Future<ServerInfo> fetchServerInfo(Uri serverUrl) async {
    final dio = _dioFor(serverUrl);
    final client = api.TandoorApi(dio: dio, interceptors: const []);
    try {
      return await guardRequest(() async {
        final response = await client
            .getApiApi()
            .apiServerSettingsCurrentRetrieve();
        return requireBody(response.data).toDomain();
      });
    } on NotFoundFailure {
      throw const IncompatibleServerFailure();
    } on ServerFailure catch (e) {
      // Something answered, but not with Tandoor's server settings: another
      // web app, or Tandoor's login page after a redirect.
      final status = e.statusCode;
      if (status != null && status >= 200 && status < 300) {
        throw const IncompatibleServerFailure();
      }
      rethrow;
    } finally {
      dio.close();
    }
  }
}
