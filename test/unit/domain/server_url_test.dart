import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/domain/models/server_url.dart';

void main() {
  group('parseServerUrl', () {
    test('adds https when there is no scheme', () {
      expect(
        parseServerUrl(' rezepte.example.de '),
        Uri.parse('https://rezepte.example.de'),
      );
    });

    test('keeps http, the port and a subpath without trailing slashes', () {
      expect(
        parseServerUrl('http://localhost:8080/tandoor//'),
        Uri.parse('http://localhost:8080/tandoor'),
      );
    });

    test('drops query and fragment', () {
      expect(
        parseServerUrl('https://example.com/?next=/x#top'),
        Uri.parse('https://example.com'),
      );
    });

    test('rejects what cannot be a server', () {
      for (final input in [
        '',
        '   ',
        'ftp://example.com',
        'https://',
        'exa mple.com',
        'https://user:secret@example.com',
      ]) {
        expect(parseServerUrl(input), isNull, reason: input);
      }
    });
  });

  test('isSameOrigin compares scheme, host and port', () {
    final app = Uri.parse('https://example.com/app/');

    expect(isSameOrigin(Uri.parse('https://example.com'), app), isTrue);
    expect(isSameOrigin(Uri.parse('https://example.com:443/x'), app), isTrue);
    expect(isSameOrigin(Uri.parse('http://example.com'), app), isFalse);
    expect(isSameOrigin(Uri.parse('https://other.example.com'), app), isFalse);
    expect(isSameOrigin(Uri.parse('https://example.com:8443'), app), isFalse);
  });
}
