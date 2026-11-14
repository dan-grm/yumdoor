import 'package:yumdoor/platform/link_opener/link_opener.dart';

/// [LinkOpener] for tests: records what would have been opened.
class FakeLinkOpener implements LinkOpener {
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri url) async {
    checkOpenableLink(url);
    opened.add(url);
    return true;
  }
}
