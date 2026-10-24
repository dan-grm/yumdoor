import 'package:flutter/material.dart';

import '../design.dart';

/// Side of the square image (docs/design/components/RecipeCard.md).
const _imageSize = 72.0;

/// A recipe in a list (docs/design/components/RecipeCard.md): image, title,
/// a meta line and, in search results, a `sage-soft` pill echoing the matched
/// filter. The whole card is one button.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.title,
    required this.onTap,
    this.image,
    this.meta,
    this.match,
  });

  final String title;
  final VoidCallback onTap;

  /// Only `http` and `https` images load; others show the placeholder.
  final Uri? image;

  /// The `caption` line under the title: time, rating, last cooked.
  final Widget? meta;

  /// Why the recipe matched: "enthält Karotten".
  final String? match;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.radiusL),
      side: BorderSide(color: t.line),
    );
    return Material(
      color: t.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: EdgeInsets.all(t.space3),
          child: Row(
            children: [
              _Thumbnail(image: image),
              SizedBox(width: t.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleS.copyWith(color: t.ink),
                    ),
                    if (meta case final meta?) ...[
                      SizedBox(height: t.space1),
                      DefaultTextStyle.merge(
                        style: t.caption.copyWith(color: t.inkMuted),
                        child: meta,
                      ),
                    ],
                    if (match case final match?) ...[
                      SizedBox(height: t.space2),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: t.sageSoft,
                          borderRadius: BorderRadius.circular(t.radiusFull),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: t.space3,
                            vertical: t.space1,
                          ),
                          child: Text(
                            match,
                            style: t.caption.copyWith(
                              color: t.ink,
                              fontWeight: t.label.fontWeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.image});

  final Uri? image;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final image = this.image;
    final placeholder = Center(
      child: Icon(
        Icons.soup_kitchen_outlined,
        size: t.titleL.fontSize,
        color: t.sage,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(t.radiusM),
      child: SizedBox.square(
        dimension: _imageSize,
        child: ColoredBox(
          color: t.sageSoft,
          child:
              image != null &&
                  (image.isScheme('https') || image.isScheme('http'))
              ? Image.network(
                  image.toString(),
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => placeholder,
                )
              : placeholder,
        ),
      ),
    );
  }
}
