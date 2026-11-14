import 'package:web/web.dart' as web;

import 'link_opener.dart';

/// Opens links in a new tab by clicking a temporary
/// `<a target="_blank" rel="noopener noreferrer">`: the page can't reach the
/// app through `window.opener` and doesn't learn its URL. Unlike
/// `window.open` with a features string, this never opens a popup window.
class PlatformLinkOpener implements LinkOpener {
  @override
  Future<bool> open(Uri url) async {
    checkOpenableLink(url);
    (web.document.createElement('a') as web.HTMLAnchorElement)
      ..href = url.toString()
      ..target = '_blank'
      ..rel = 'noopener noreferrer'
      ..click();
    return true;
  }
}
