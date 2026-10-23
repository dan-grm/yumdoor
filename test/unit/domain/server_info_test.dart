import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/server_info.dart';

void main() {
  test('supports Tandoor 2.x', () {
    expect(const ServerInfo(version: '2.6.15').isSupported, isTrue);
    expect(const ServerInfo(version: '2.0.0-alpha').isSupported, isTrue);
  });

  test('does not support other major versions', () {
    expect(const ServerInfo(version: '1.5.24').isSupported, isFalse);
    expect(const ServerInfo(version: '3.0.0').isSupported, isFalse);
  });

  test('does not support an unparseable version', () {
    const info = ServerInfo(version: 'develop');

    expect(info.majorVersion, isNull);
    expect(info.isSupported, isFalse);
  });
}
