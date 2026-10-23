import 'package:yumdoor/core/failures.dart';
import 'package:yumdoor/domain/models/server_info.dart';
import 'package:yumdoor/domain/repositories/server_repository.dart';

/// [ServerRepository] that answers every URL with [version], or throws
/// [failure] if set.
class FakeServerRepository implements ServerRepository {
  FakeServerRepository({this.version = '2.6.15', this.failure});

  String version;
  Failure? failure;
  final requested = <Uri>[];

  @override
  Future<ServerInfo> fetchServerInfo(Uri serverUrl) async {
    requested.add(serverUrl);
    if (failure case final failure?) throw failure;
    return ServerInfo(version: version);
  }
}
