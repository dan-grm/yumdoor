import 'package:yumdoor/platform/link_opener/link_opener.dart';

/// [LinkOpener] for tests: records what would have been opened.
class FakeLinkOpener implements LinkOpener {
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri url) async {
    if (!isOpenableLink(url)) {
      throw ArgumentError.value(url, 'url', 'not an http(s) link');
    }
    opened.add(url);
    return true;
  }
}
