import '../../core/failures.dart';
import '../models/server_info.dart';

/// Talks to a Tandoor server before login.
abstract interface class ServerRepository {
  /// Asks the server at [serverUrl] for its version. Needs no token.
  ///
  /// Throws [IncompatibleServerFailure] if [serverUrl] is not a Tandoor 2.x
  /// server, or another [Failure].
  Future<ServerInfo> fetchServerInfo(Uri serverUrl);
}
