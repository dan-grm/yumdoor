/// Persists the server URL and the API token across app starts.
///
/// The server URL outlives the token: logout and a 401 clear only the token,
/// so login can prefill the server.
abstract interface class TokenStore {
  Future<Uri?> readServerUrl();
  Future<void> writeServerUrl(Uri url);

  Future<StoredToken?> readToken();
  Future<void> writeToken(StoredToken token);
  Future<void> clearToken();

  /// Removes everything, e.g. when switching servers.
  Future<void> clear();
}

/// An API token and, if Yumdoor created it, its id on the server.
class StoredToken {
  const StoredToken(this.token, {this.id});

  final String token;

  /// The id of the device token Yumdoor created after password login, needed
  /// to delete it on logout. `null` for tokens the user pasted: Yumdoor never
  /// deletes those.
  final int? id;

  @override
  bool operator ==(Object other) =>
      other is StoredToken && other.token == token && other.id == id;

  @override
  int get hashCode => Object.hash(token, id);

  // Never print the token itself.
  @override
  String toString() => 'StoredToken(id: $id)';
}
