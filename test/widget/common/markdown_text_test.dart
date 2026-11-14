import 'dart:ui' show SemanticsAction;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:yumdoor/app/platform_providers.dart';
import 'package:yumdoor/design/design.dart';
import 'package:yumdoor/features/common/markdown_text.dart';

import '../../fakes/fake_link_opener.dart';
import '../harness.dart';

void main() {
  late FakeLinkOpener links;

  setUp(() => links = FakeLinkOpener());

  Future<void> pumpMarkdown(
    WidgetTester tester,
    String data, {
    MarkdownSpanBuilder? spanBuilder,
  }) => pumpRoutes(
    tester,
    location: '/',
    overrides: [linkOpenerProvider.overrideWithValue(links)],
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: SingleChildScrollView(
            child: MarkdownText(
              data,
              style: context.tokens.body,
              spanBuilder: spanBuilder,
            ),
          ),
        ),
      ),
    ],
  );

  /// The span of [text] in the rendered rich text.
  TextSpan spanOf(WidgetTester tester, String text) {
    final rich = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText().contains(text),
      ),
    );
    TextSpan? found;
    rich.text.visitChildren((span) {
      if (span is TextSpan && span.text == text) {
        found = span;
        return false;
      }
      return true;
    });
    expect(found, isNotNull, reason: 'no span with text "$text"');
    return found!;
  }

  Finder plain(String text) => find.text(text, findRichText: true);

  testWidgets('paragraphs become separate texts', (tester) async {
    await pumpMarkdown(tester, 'Erster Absatz.\n\nZweiter Absatz.');

    expect(plain('Erster Absatz.'), findsOneWidget);
    expect(plain('Zweiter Absatz.'), findsOneWidget);
  });

  testWidgets('single newlines and hard breaks are line breaks', (
    tester,
  ) async {
    await pumpMarkdown(tester, 'Zeile eins\nZeile zwei  \nZeile drei');

    expect(plain('Zeile eins\nZeile zwei\nZeile drei'), findsOneWidget);
  });

  testWidgets('emphasis is italic and strong is bold', (tester) async {
    await pumpMarkdown(tester, 'Ganz *langsam* und **kräftig** rühren.');

    expect(plain('Ganz langsam und kräftig rühren.'), findsOneWidget);
    expect(spanOf(tester, 'langsam').style!.fontStyle, FontStyle.italic);
    expect(spanOf(tester, 'kräftig').style!.fontWeight, FontWeight.w800);
    expect(spanOf(tester, 'Ganz ').style!.fontWeight, FontWeight.w400);
  });

  testWidgets('headings use the title tokens and are headers', (tester) async {
    await pumpMarkdown(tester, '# Teig\n\n## Füllung\n\n### Deko\n\nText');
    const t = YumdoorTokens.light;

    expect(spanOf(tester, 'Teig').style!.fontSize, t.titleM.fontSize);
    expect(spanOf(tester, 'Füllung').style!.fontSize, t.titleS.fontSize);
    expect(spanOf(tester, 'Deko').style!.fontSize, t.body.fontSize);
    expect(spanOf(tester, 'Deko').style!.fontWeight, FontWeight.w800);
    expect(tester.getSemantics(plain('Teig')), isSemantics(isHeader: true));
  });

  testWidgets('headings never get smaller than large running text', (
    tester,
  ) async {
    await pumpRoutes(
      tester,
      location: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              MarkdownText('## Füllung', style: context.tokens.step),
        ),
      ],
    );

    expect(
      spanOf(tester, 'Füllung').style!.fontSize,
      YumdoorTokens.light.step.fontSize,
    );
  });

  testWidgets('unordered lists get bullets, ordered lists numbers', (
    tester,
  ) async {
    await pumpMarkdown(
      tester,
      '- Mehl\n- Zucker\n  - braun\n\n3. Rühren\n4. Backen',
    );

    expect(plain('•'), findsNWidgets(3));
    expect(plain('Mehl'), findsOneWidget);
    expect(plain('braun'), findsOneWidget);
    expect(plain('3.'), findsOneWidget);
    expect(plain('4.'), findsOneWidget);
    expect(plain('Backen'), findsOneWidget);
    // The nested item is indented further than its parent.
    expect(
      tester.getTopLeft(plain('braun')).dx,
      greaterThan(tester.getTopLeft(plain('Zucker')).dx),
    );
  });

  group('links', () {
    testWidgets('http(s) links open after showing their host', (tester) async {
      await pumpMarkdown(
        tester,
        'Siehe [das Original](https://www.example.com/rezept?id=1).',
      );
      final span = spanOf(tester, 'das Original');
      expect(span.recognizer, isNotNull);

      await tester.tapOnText(find.textRange.ofSubstring('das Original'));
      await tester.pumpAndSettle();
      expect(find.text('Link öffnen?'), findsOneWidget);
      expect(find.textContaining('www.example.com'), findsOneWidget);

      await tester.tap(find.text('Öffnen'));
      await tester.pumpAndSettle();
      expect(links.opened, [Uri.parse('https://www.example.com/rezept?id=1')]);
    });

    testWidgets('a double tap shows one dialog', (tester) async {
      await pumpMarkdown(tester, '[Quelle](https://example.com)');

      // Two taps before the dialog's first frame, when its barrier can't
      // catch the second one yet.
      final onTap =
          (spanOf(tester, 'Quelle').recognizer! as TapGestureRecognizer).onTap!;
      onTap();
      onTap();
      await tester.pumpAndSettle();

      expect(find.text('Link öffnen?'), findsOneWidget);
    });

    testWidgets('links are announced as links', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpMarkdown(tester, 'Siehe [Quelle](https://example.com).');

      expect(
        find.semantics.byPredicate(
          (node) =>
              node.label == 'Quelle' &&
              node.flagsCollection.isLink &&
              node.getSemanticsData().hasAction(SemanticsAction.tap),
        ),
        findsOne,
      );
      semantics.dispose();
    });

    testWidgets('cancelling the dialog opens nothing', (tester) async {
      await pumpMarkdown(tester, '[Quelle](http://example.com)');

      await tester.tapOnText(find.textRange.ofSubstring('Quelle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abbrechen'));
      await tester.pumpAndSettle();

      expect(find.text('Link öffnen?'), findsNothing);
      expect(links.opened, isEmpty);
    });

    testWidgets('bare and angle-bracket URLs are links', (tester) async {
      await pumpMarkdown(
        tester,
        'Von https://example.com/a und <https://example.org/b>',
      );

      expect(spanOf(tester, 'https://example.com/a').recognizer, isNotNull);
      expect(spanOf(tester, 'https://example.org/b').recognizer, isNotNull);
    });

    for (final href in [
      'javascript:alert(1)',
      'JavaScript:alert(1)',
      'data:text/html,<script>alert(1)</script>',
      'file:///etc/passwd',
      '/relative/path',
      'mailto:koch@example.com',
    ]) {
      testWidgets('$href is plain text', (tester) async {
        await pumpMarkdown(tester, '[Klick mich]($href)');

        expect(plain('Klick mich'), findsOneWidget);
        expect(spanOf(tester, 'Klick mich').recognizer, isNull);
      });
    }

    testWidgets('a javascript: autolink is plain text', (tester) async {
      await pumpMarkdown(tester, '<javascript:alert(1)>');

      expect(plain('javascript:alert(1)'), findsOneWidget);
      expect(spanOf(tester, 'javascript:alert(1)').recognizer, isNull);
    });
  });

  group('everything else is inert text', () {
    for (final (name, source, shown) in [
      (
        'a script block',
        '<script>alert(1)</script>',
        '<script>alert(1)</script>',
      ),
      (
        'inline HTML',
        'Vorsicht <img src=x onerror=alert(1)> heiß',
        'Vorsicht <img src=x onerror=alert(1)> heiß',
      ),
      (
        'an HTML block',
        '<div onclick="alert(1)">\nKlick\n</div>',
        '<div onclick="alert(1)">\nKlick\n</div>',
      ),
      (
        'an image, as its alt text',
        '![Foto vom Kuchen](x.png)',
        'Foto vom Kuchen',
      ),
      ('inline code', 'Mit `{{ scale(100) }}` g', 'Mit {{ scale(100) }} g'),
      ('a code block', '    Einrückung\n    bleibt', 'Einrückung\nbleibt'),
      (
        'a table',
        '| a | b |\n|---|---|\n| 1 | 2 |',
        '| a | b |\n|---|---|\n| 1 | 2 |',
      ),
    ]) {
      testWidgets(name, (tester) async {
        await pumpMarkdown(tester, source);

        expect(plain(shown), findsOneWidget);
        expect(find.byType(Image), findsNothing);
      });
    }
  });

  testWidgets('the span builder gets whole runs, templates included', (
    tester,
  ) async {
    final runs = <String>[];
    await pumpMarkdown(
      tester,
      'Teig ({{ ingredients[0] }}) **kneten**',
      spanBuilder: (text, style) {
        runs.add(text);
        return [TextSpan(text: text.toUpperCase(), style: style)];
      },
    );

    expect(runs, ['Teig ({{ ingredients[0] }}) ', 'kneten']);
    expect(plain('TEIG ({{ INGREDIENTS[0] }}) KNETEN'), findsOneWidget);
  });

  testWidgets('code blocks go through the span builder too', (tester) async {
    await pumpMarkdown(
      tester,
      'Absatz\n\n    eingerückt',
      spanBuilder: (text, style) => [
        TextSpan(text: text.toUpperCase(), style: style),
      ],
    );

    expect(plain('ABSATZ'), findsOneWidget);
    expect(plain('EINGERÜCKT'), findsOneWidget);
  });

  testWidgets('long German text fits at 390 px', (tester) async {
    await pumpMarkdown(
      tester,
      '## Rindfleischetikettierungsüberwachungsaufgaben\n\n'
      '- Donaudampfschifffahrtsgesellschaftskapitänsmütze '
      'vorsichtig in Grundnahrungsmittelverarbeitungsmaschine geben\n'
      '1. **Kraftfahrzeughaftpflichtversicherung** prüfen '
      'https://www.example.com/ein/sehr/langer/pfad/zum/originalrezept',
    );

    expect(tester.takeException(), isNull);
  });
}
