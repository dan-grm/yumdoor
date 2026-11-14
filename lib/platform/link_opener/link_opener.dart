import 'link_opener_stub.dart'
    if (dart.library.js_interop) 'link_opener_web.dart';

/// Opens external links from recipe content: in a new browser tab on the web,
/// in the system browser in native apps.
abstract interface class LinkOpener {
  /// The link opener for the current platform.
  factory LinkOpener() = PlatformLinkOpener;

  /// Opens [url] without giving the new page access to the app (no opener, no
  /// referrer). Returns whether the platform opened it.
  ///
  /// Throws an [ArgumentError] unless [isOpenableLink] accepts [url].
  Future<bool> open(Uri url);
}

/// Whether [url] may be opened from server content: only absolute `http` and
/// `https` URLs with a host. Everything else (`javascript:`, `data:`,
/// relative paths) stays plain text.
bool isOpenableLink(Uri url) =>
    (url.scheme == 'http' || url.scheme == 'https') && url.host.isNotEmpty;

/// [isOpenableLink] for a raw string, as it appears in Markdown.
Uri? parseOpenableLink(String raw) {
  final url = Uri.tryParse(raw.trim());
  return url != null && isOpenableLink(url) ? url : null;
}
