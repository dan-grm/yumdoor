import 'link_opener.dart';

/// Native placeholder until the native builds land: opens nothing.
class PlatformLinkOpener implements LinkOpener {
  @override
  Future<bool> open(Uri url) async {
    checkOpenableLink(url);
    return false;
  }
}
