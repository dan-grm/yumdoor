import 'package:flutter/material.dart';

import 'design.dart';

// Debug-only tooling (registered in debug builds only), so its labels are not
// localized: they are token names, which stay English in code and docs.

/// Every design token of the active theme: colors, text styles, spacing,
/// radii, sizes and shadows. Reached at `/debug/tokens` in debug builds.
class TokenGalleryScreen extends StatefulWidget {
  const TokenGalleryScreen({super.key});

  @override
  State<TokenGalleryScreen> createState() => _TokenGalleryScreenState();
}

class _TokenGalleryScreenState extends State<TokenGalleryScreen> {
  /// Overrides the app's brightness to compare both themes; `null` follows it.
  Brightness? _brightness;

  @override
  Widget build(BuildContext context) {
    final brightness = _brightness ?? Theme.of(context).brightness;
    final dark = brightness == Brightness.dark;
    return Theme(
      data: dark ? darkTheme : lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Design tokens'),
          actions: [
            Switch(
              value: dark,
              onChanged: (value) => setState(
                () => _brightness = value ? Brightness.dark : Brightness.light,
              ),
            ),
          ],
        ),
        body: const SingleChildScrollView(child: TokenGallery()),
      ),
    );
  }
}

/// The token gallery's content, without scaffold, for screens and goldens.
class TokenGallery extends StatelessWidget {
  const TokenGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Material(
      color: t.bg,
      child: Padding(
        padding: EdgeInsets.all(t.space5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Section('Colors'),
            Wrap(
              spacing: t.space3,
              runSpacing: t.space3,
              children: [
                for (final MapEntry(:key, :value) in t.colors.entries)
                  _Swatch(name: key, color: value),
              ],
            ),
            const _Section('Text styles'),
            for (final MapEntry(:key, :value) in t.textStyles.entries)
              Padding(
                padding: EdgeInsets.only(bottom: t.space3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(key, style: t.caption.copyWith(color: t.inkMuted)),
                    Text(
                      'Kreuzkümmel, gemahlen – 1,5 TL',
                      style: value.copyWith(color: t.ink),
                    ),
                  ],
                ),
              ),
            const _Section('Spacing'),
            for (final MapEntry(:key, :value) in t.spacing.entries)
              _LengthRow(
                name: key,
                value: value,
                child: Container(width: value, height: t.space4, color: t.sage),
              ),
            const _Section('Radii'),
            for (final MapEntry(:key, :value) in t.radii.entries)
              _LengthRow(
                name: key,
                value: value,
                child: Container(
                  width: t.sizeButton,
                  height: t.sizeButton,
                  decoration: BoxDecoration(
                    color: t.sageSoft,
                    border: Border.all(color: t.controlBorder),
                    borderRadius: BorderRadius.circular(value),
                  ),
                ),
              ),
            const _Section('Sizes'),
            for (final MapEntry(:key, :value) in t.sizes.entries)
              _LengthRow(
                name: key,
                value: value,
                child: Container(
                  width: value,
                  height: value,
                  decoration: BoxDecoration(
                    color: t.butter,
                    borderRadius: BorderRadius.circular(t.radiusS),
                  ),
                ),
              ),
            const _Section('Shadows'),
            for (final MapEntry(:key, :value) in t.shadows.entries)
              Container(
                height: t.sizeButton,
                margin: EdgeInsets.symmetric(vertical: t.space3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(t.radiusL),
                  boxShadow: value,
                ),
                child: Text(key, style: t.label.copyWith(color: t.ink)),
              ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.only(top: t.space6, bottom: t.space3),
      child: Text(
        title.toUpperCase(),
        style: t.overline.copyWith(color: t.sage),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    // Two per row at phone width, so names like surfaceSunken fit.
    final width = t.sizeButton * 2.5;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: t.sizeButton,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: t.line),
              borderRadius: BorderRadius.circular(t.radiusM),
            ),
          ),
          SizedBox(height: t.space1),
          Text(name, style: t.caption.copyWith(color: t.ink)),
          Text(_hex(color), style: t.caption.copyWith(color: t.inkMuted)),
        ],
      ),
    );
  }

  static String _hex(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}

class _LengthRow extends StatelessWidget {
  const _LengthRow({
    required this.name,
    required this.value,
    required this.child,
  });

  final String name;
  final double value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.only(bottom: t.space2),
      child: Row(
        children: [
          SizedBox(
            width: t.sizeButton * 2,
            child: Text(
              '$name ${value.round()}',
              style: t.caption.copyWith(color: t.ink),
            ),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
