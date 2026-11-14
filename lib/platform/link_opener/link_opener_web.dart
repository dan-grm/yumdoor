import 'package:web/web.dart' as web;

import 'link_opener.dart';

/// Opens links in a new tab with `noopener,noreferrer`, so the page can't
/// reach the app through `window.opener` and doesn't learn its URL.
class PlatformLinkOpener implements LinkOpener {
  @override
  Future<bool> open(Uri url) async {
    if (!isOpenableLink(url)) {
      throw ArgumentError.value(url, 'url', 'not an http(s) link');
    }
    // With `noopener`, window.open returns null even when the tab opened.
    web.window.open(url.toString(), '_blank', 'noopener,noreferrer');
    return true;
  }
}
