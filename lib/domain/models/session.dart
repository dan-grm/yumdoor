/// A login to a Tandoor server.
class Session {
  const Session({
    required this.serverUrl,
    required this.token,
    this.deviceTokenId,
  });

  /// Where Tandoor is, possibly with a path (`https://example.com/tandoor`).
  final Uri serverUrl;

  /// The API token every request is sent with.
  final String token;

  /// The id of the device token Yumdoor created after a password login, so
  /// logout can delete it. `null` for a pasted token, which Yumdoor never
  /// deletes.
  final int? deviceTokenId;

  /// Whether Yumdoor created [token] and deletes it on logout.
  bool get ownsToken => deviceTokenId != null;

  @override
  bool operator ==(Object other) =>
      other is Session &&
      other.serverUrl == serverUrl &&
      other.token == token &&
      other.deviceTokenId == deviceTokenId;

  @override
  int get hashCode => Object.hash(serverUrl, token, deviceTokenId);

  // Never print the token itself.
  @override
  String toString() => 'Session($serverUrl, deviceTokenId: $deviceTokenId)';
}
