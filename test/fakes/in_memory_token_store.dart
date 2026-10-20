import 'package:yumdoor/platform/token_store/token_store.dart';

/// [TokenStore] in memory, for tests.
class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore({this.serverUrl, this.token});

  Uri? serverUrl;
  StoredToken? token;

  @override
  Future<Uri?> readServerUrl() async => serverUrl;

  @override
  Future<void> writeServerUrl(Uri url) async => serverUrl = url;

  @override
  Future<StoredToken?> readToken() async => token;

  @override
  Future<void> writeToken(StoredToken token) async => this.token = token;

  @override
  Future<void> clearToken() async => token = null;

  @override
  Future<void> clear() async {
    serverUrl = null;
    token = null;
  }
}
