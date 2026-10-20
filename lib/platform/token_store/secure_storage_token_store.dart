import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_store.dart';

/// [TokenStore] on `flutter_secure_storage`: Keychain on iOS, Keystore-backed
/// encryption on Android.
///
/// **On the web there is no secure storage.** flutter_secure_storage_web 2.1
/// keeps the values AES-GCM encrypted in `localStorage`, but the key sits in
/// the same `localStorage`, so any script running on our origin can read the
/// token. The PWA shares its origin with Tandoor, so a stored-XSS bug in
/// Tandoor's own UI could read it, just as it could already act with the
/// user's Tandoor session. This is accepted and explained in Settings › About
/// (see docs/ARCHITECTURE.md#authentication-and-session). WebCrypto also needs
/// a secure context: HTTPS or `localhost`.
class SecureStorageTokenStore implements TokenStore {
  SecureStorageTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage(webOptions: _webOptions);

  // Own key names so we don't share storage with other Flutter apps that may
  // be served from the same origin.
  static const _webOptions = WebOptions(
    dbName: 'yumdoor',
    publicKey: 'yumdoor',
  );

  static const _serverUrlKey = 'server_url';
  static const _tokenKey = 'token';
  static const _tokenIdKey = 'token_id';

  final FlutterSecureStorage _storage;

  @override
  Future<Uri?> readServerUrl() async {
    final value = await _storage.read(key: _serverUrlKey);
    return value == null ? null : Uri.tryParse(value);
  }

  @override
  Future<void> writeServerUrl(Uri url) =>
      _storage.write(key: _serverUrlKey, value: url.toString());

  @override
  Future<StoredToken?> readToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return null;
    final id = await _storage.read(key: _tokenIdKey);
    return StoredToken(token, id: id == null ? null : int.tryParse(id));
  }

  @override
  Future<void> writeToken(StoredToken token) async {
    // Remove a stale id first, so a crash between the writes never pairs the
    // new token with the old id.
    await _storage.delete(key: _tokenIdKey);
    await _storage.write(key: _tokenKey, value: token.token);
    if (token.id != null) {
      await _storage.write(key: _tokenIdKey, value: '${token.id}');
    }
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenIdKey);
  }

  @override
  Future<void> clear() async {
    await clearToken();
    await _storage.delete(key: _serverUrlKey);
  }
}
