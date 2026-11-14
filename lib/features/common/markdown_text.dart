import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

import '../../app/platform_providers.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../../platform/link_opener/link_opener.dart';

/// Builds the spans for one run of plain text in [style].
///
/// Lets callers replace parts of the text, e.g. step templates or detected
/// durations. A run is all adjacent text with the same formatting, so a
/// template like `{{ ingredients[0] }}` arrives in one piece even though
/// Markdown parses its brackets separately. Link text is not passed through.
typedef MarkdownSpanBuilder = List<InlineSpan> Function(
  String text,
  TextStyle style,
);

/// Renders untrusted Markdown from the server as Flutter widgets.
///
/// The raw text is parsed to an AST and every node becomes a widget or a
/// span; nothing is ever rendered as HTML (CLAUDE.md rule 7). Supported:
/// paragraphs, emphasis, headings, ordered and unordered lists, `http(s)`
/// links and line breaks. Single newlines are kept, as Tandoor does. Raw
/// HTML, images (their alt text), code and tables show up as plain text.
/// Links open in a new tab after the user has seen their host.
class MarkdownText extends ConsumerStatefulWidget {
  const MarkdownText(
    this.data, {
    super.key,
    required this.style,
    this.spanBuilder,
  });

  /// The Markdown source, as written on the server.
  final String data;

  /// Style of running text; headings and emphasis derive from it.
  final TextStyle style;

  final MarkdownSpanBuilder? spanBuilder;

  @override
  ConsumerState<MarkdownText> createState() => _MarkdownTextState();
}

class _MarkdownTextState extends ConsumerState<MarkdownText> {
  late List<md.Node> _nodes;
  final _recognizers = <TapGestureRecognizer>[];
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _nodes = parseMarkdown(widget.data);
  }

  @override
  void didUpdateWidget(MarkdownText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) _nodes = parseMarkdown(widget.data);
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    // The mounted text still holds the previous recognizers until this build
    // replaces it, so they are disposed after the frame.
    if (_recognizers.isNotEmpty) {
      final previous = List.of(_recognizers);
      _recognizers.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final recognizer in previous) {
          recognizer.dispose();
        }
      });
    }
    return _blocks(_nodes, widget.style);
  }

  Widget _blocks(List<md.Node> nodes, TextStyle style) {
    final t = context.tokens;
    final children = <Widget>[];
    final inline = <md.Node>[];

    void flushInline() {
      if (inline.isEmpty) return;
      children.add(_paragraph(List.of(inline), style));
      inline.clear();
    }

    for (final node in nodes) {
      if (node is md.Element && _blockTags.contains(node.tag)) {
        flushInline();
        final block = _block(node, style);
        if (block != null) children.add(block);
      } else {
        inline.add(node);
      }
    }
    flushInline();

    if (children.length == 1) return children.single;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: t.space2,
      children: children,
    );
  }

  Widget? _block(md.Element element, TextStyle style) {
    final t = context.tokens;
    switch (element.tag) {
      case 'p':
        return _paragraph(element.children ?? const [], style);
      case 'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6':
        return Semantics(
          header: true,
          child: _paragraph(
            element.children ?? const [],
            _headingStyle(int.parse(element.tag.substring(1)), style),
          ),
        );
      case 'ul' || 'ol':
        return _list(element, style);
      case 'blockquote':
        return _blocks(element.children ?? const [], style);
      case 'hr':
        return Divider(height: t.space2, color: t.line);
      default:
        // Code blocks and anything unknown: the text as written, still
        // through the span builder, so templates resolve there too.
        final text = element.textContent.trimRight();
        if (text.isEmpty) return null;
        return Text.rich(
          TextSpan(
            children:
                widget.spanBuilder?.call(text, style) ?? [TextSpan(text: text)],
          ),
          style: style,
        );
    }
  }

  Widget _list(md.Element list, TextStyle style) {
    final t = context.tokens;
    final ordered = list.tag == 'ol';
    final start = int.tryParse(list.attributes['start'] ?? '') ?? 1;
    final items = [
      for (final node in list.children ?? const <md.Node>[])
        if (node is md.Element && node.tag == 'li') node,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: t.space1,
      children: [
        for (final (index, item) in items.indexed)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: t.space2,
            children: [
              ExcludeSemantics(
                excluding: !ordered,
                child: Text(ordered ? '${start + index}.' : '•', style: style),
              ),
              Expanded(child: _blocks(item.children ?? const [], style)),
            ],
          ),
      ],
    );
  }

  Widget _paragraph(List<md.Node> nodes, TextStyle style) =>
      Text.rich(TextSpan(children: _spans(nodes, style)), style: style);

  /// Headings use the token title styles, but never get smaller than the
  /// running text (cooking mode's step text is larger than `titleS`).
  TextStyle _headingStyle(int level, TextStyle style) {
    final t = context.tokens;
    final emphasized = style.copyWith(fontWeight: FontWeight.w800);
    final title = switch (level) {
      1 => t.titleM,
      2 => t.titleS,
      _ => null,
    };
    if (title == null ||
        (title.fontSize ?? 0) <= (style.fontSize ?? double.infinity)) {
      return emphasized;
    }
    return title.copyWith(color: style.color);
  }

  List<InlineSpan> _spans(List<md.Node> nodes, TextStyle style) {
    final runs = <_Run>[];
    _collectRuns(nodes, const _Format(), runs);
    final spans = <InlineSpan>[];
    for (final run in runs) {
      final runStyle = run.format.apply(style);
      final link = run.format.link;
      if (link != null) {
        final t = context.tokens;
        final recognizer = TapGestureRecognizer()
          ..onTap = () => _openLink(link);
        _recognizers.add(recognizer);
        spans.add(
          TextSpan(
            text: run.text,
            style: runStyle.copyWith(
              color: t.sage,
              decoration: TextDecoration.underline,
              decorationColor: t.sage,
            ),
            recognizer: recognizer,
            mouseCursor: SystemMouseCursors.click,
          ),
        );
      } else {
        spans.addAll(
          widget.spanBuilder?.call(run.text, runStyle) ??
              [TextSpan(text: run.text, style: runStyle)],
        );
      }
    }
    return spans;
  }

  Future<void> _openLink(Uri link) async {
    // A quick double tap would otherwise stack two dialogs.
    if (_dialogOpen) return;
    _dialogOpen = true;
    final open = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.markdownLinkTitle),
          content: Text(l10n.markdownLinkText(link.host)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.markdownLinkOpen),
            ),
          ],
        );
      },
    );
    _dialogOpen = false;
    if (open != true || !mounted) return;
    await ref.read(linkOpenerProvider).open(link);
  }
}

/// Parses [data] without any HTML extension: inline HTML stays text, and
/// `encodeHtml: false` keeps text nodes as written, because they are rendered
/// as text and never as HTML.
List<md.Node> parseMarkdown(String data) => md.Document(
  extensionSet: md.ExtensionSet.none,
  inlineSyntaxes: [md.AutolinkExtensionSyntax()],
  encodeHtml: false,
).parse(data.replaceAll('\r\n', '\n'));

/// The runs of plain text in [data] that [MarkdownText] passes to its span
/// builder, in order; link text isn't one. Lets a caller know up front what
/// the builder will see, e.g. which durations a step highlights.
List<String> markdownTextRuns(String data) {
  final runs = <String>[];

  void inline(List<md.Node> nodes) {
    final collected = <_Run>[];
    _collectRuns(nodes, const _Format(), collected);
    for (final run in collected) {
      if (run.format.link == null) runs.add(run.text);
    }
  }

  // Mirrors _MarkdownTextState._blocks, _block and _list.
  void blocks(List<md.Node> nodes) {
    final pending = <md.Node>[];
    void flush() {
      if (pending.isEmpty) return;
      inline(List.of(pending));
      pending.clear();
    }

    for (final node in nodes) {
      if (node is! md.Element || !_blockTags.contains(node.tag)) {
        pending.add(node);
        continue;
      }
      flush();
      switch (node.tag) {
        case 'p' || 'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6':
          inline(node.children ?? const []);
        case 'ul' || 'ol':
          for (final item in node.children ?? const <md.Node>[]) {
            if (item is md.Element && item.tag == 'li') {
              blocks(item.children ?? const []);
            }
          }
        case 'blockquote':
          blocks(node.children ?? const []);
        case 'hr':
          break;
        default:
          final text = node.textContent.trimRight();
          if (text.isNotEmpty) runs.add(text);
      }
    }
    flush();
  }

  blocks(parseMarkdown(data));
  return runs;
}

const _blockTags = {
  'p',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'ul',
  'ol',
  'blockquote',
  'pre',
  'hr',
};

/// Inline formatting of a run of text.
class _Format {
  const _Format({this.bold = false, this.italic = false, this.link});

  final bool bold;
  final bool italic;
  final Uri? link;

  _Format copyWith({bool? bold, bool? italic, Uri? link}) => _Format(
    bold: bold ?? this.bold,
    italic: italic ?? this.italic,
    link: link ?? this.link,
  );

  TextStyle apply(TextStyle style) => style.copyWith(
    fontWeight: bold ? FontWeight.w800 : null,
    fontStyle: italic ? FontStyle.italic : null,
  );

  @override
  bool operator ==(Object other) =>
      other is _Format &&
      other.bold == bold &&
      other.italic == italic &&
      other.link == link;

  @override
  int get hashCode => Object.hash(bold, italic, link);
}

class _Run {
  _Run(this.text, this.format);

  String text;
  final _Format format;
}

/// Flattens inline nodes into runs, merging neighbors with equal formatting.
void _collectRuns(List<md.Node> nodes, _Format format, List<_Run> runs) {
  void add(String text, _Format format) {
    if (text.isEmpty) return;
    if (runs.isNotEmpty && runs.last.format == format) {
      runs.last.text += text;
    } else {
      runs.add(_Run(text, format));
    }
  }

  for (final node in nodes) {
    switch (node) {
      case md.Text():
        add(node.text, format);
      case md.Element(tag: 'strong'):
        _collectRuns(
          node.children ?? const [],
          format.copyWith(bold: true),
          runs,
        );
      case md.Element(tag: 'em'):
        _collectRuns(
          node.children ?? const [],
          format.copyWith(italic: true),
          runs,
        );
      case md.Element(tag: 'br'):
        add('\n', format);
      case md.Element(tag: 'a'):
        final link = format.link == null
            ? parseOpenableLink(node.attributes['href'] ?? '')
            : null;
        _collectRuns(
          node.children ?? const [],
          link == null ? format : format.copyWith(link: link),
          runs,
        );
      case md.Element(tag: 'img'):
        add(node.attributes['alt'] ?? '', format);
      case md.Element():
        // Inline code and anything unknown: the text as written.
        if (node.children == null) {
          add(node.textContent, format);
        } else {
          _collectRuns(node.children!, format, runs);
        }
      default:
        add(node.textContent, format);
    }
  }
}
