/// The server URL the user typed, cleaned up: `https://` added when there is
/// no scheme, query, fragment and trailing slashes removed.
///
/// Returns `null` for input that can't be a server address.
Uri? parseServerUrl(String input) {
  var text = input.trim();
  if (text.isEmpty || text.contains(RegExp(r'\s'))) return null;
  if (!text.contains('://')) text = 'https://$text';
  final uri = Uri.tryParse(text);
  if (uri == null ||
      !(uri.isScheme('http') || uri.isScheme('https')) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    return null;
  }
  return Uri(
    scheme: uri.scheme,
    host: uri.host,
    port: uri.hasPort ? uri.port : null,
    path: uri.path.replaceFirst(RegExp(r'/+$'), ''),
  );
}

/// Whether [a] and [b] have the same scheme, host and port.
bool isSameOrigin(Uri a, Uri b) =>
    a.scheme == b.scheme && a.host == b.host && a.port == b.port;
