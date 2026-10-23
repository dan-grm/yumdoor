import 'package:flutter/material.dart';

import '../../design/design.dart';
import '../../l10n/formatting.dart';
import '../../l10n/l10n.dart';

/// "35 Min · 4,5 ★ · zuletzt gekocht 20. Okt. 2026", read aloud with words
/// for the star. Draws nothing when there is nothing to say.
///
/// Uses the ambient text style, so the caller picks the color and size.
class RecipeMetaLine extends StatelessWidget {
  const RecipeMetaLine({
    super.key,
    required this.time,
    this.rating,
    this.lastCooked,
  });

  /// Working plus waiting time.
  final Duration time;
  final double? rating;
  final DateTime? lastCooked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = LocaleFormat.of(context);
    final style = DefaultTextStyle.of(context).style;
    final minutes = time.inMinutes;
    final rating = switch (this.rating) {
      final rating? => format.amount((rating * 10).round() / 10),
      null => null,
    };
    // (shown, read aloud); the star is an icon because Nunito has no ★.
    final meta = <(List<InlineSpan>, String)>[
      if (minutes > 0)
        (
          [TextSpan(text: l10n.recipeMinutes(minutes))],
          l10n.recipeMinutes(minutes),
        ),
      if (rating != null)
        (
          [
            TextSpan(text: '$rating '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.star_rounded,
                size: style.fontSize,
                color: style.color ?? context.tokens.inkMuted,
              ),
            ),
          ],
          l10n.recipeRating(rating),
        ),
      if (lastCooked case final date?)
        (
          [TextSpan(text: l10n.recipeLastCooked(format.date(date.toLocal())))],
          l10n.recipeLastCooked(format.date(date.toLocal())),
        ),
    ];
    if (meta.isEmpty) return const SizedBox.shrink();

    return Text.rich(
      TextSpan(
        children: [
          for (final (index, (spans, _)) in meta.indexed) ...[
            if (index > 0) const TextSpan(text: ' · '),
            ...spans,
          ],
        ],
      ),
      semanticsLabel: meta.map((part) => part.$2).join(', '),
    );
  }
}
