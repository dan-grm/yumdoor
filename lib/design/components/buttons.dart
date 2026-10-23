import 'package:flutter/material.dart';

import '../design.dart';

/// Outline width of secondary buttons (docs/design/components/Button.md).
const _outlineWidth = 2.0;

/// The roles of a [PillButton] (docs/design/components/Button.md).
enum PillButtonKind {
  /// `sage` fill: the one main action of a screen region.
  accent,

  /// `ink` fill: forward navigation.
  primary,

  /// Transparent with a `control-border` outline.
  secondary,
}

/// A pill-shaped button with a text label and optional icons.
///
/// Full size is `size-button` tall with the label at 17px; [compact] is
/// `size-touch` tall with the regular `label` style, for rows of actions.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = PillButtonKind.accent,
    this.icon,
    this.trailingIcon,
    this.compact = false,
  });

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final PillButtonKind kind;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (fill, onFill) = switch (kind) {
      PillButtonKind.accent => (t.sage, t.onSage),
      PillButtonKind.primary => (t.ink, t.onInk),
      PillButtonKind.secondary => (Colors.transparent, t.ink),
    };
    final secondary = kind == PillButtonKind.secondary;
    final height = compact ? t.sizeTouch : t.sizeButton;
    final textStyle = compact
        ? t.label
        : t.label.copyWith(fontSize: t.bodyL.fontSize);
    final iconSize = textStyle.fontSize! + t.space1;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(height, height)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: compact ? t.space2 : t.space5),
        ),
        textStyle: WidgetStatePropertyAll(textStyle),
        iconSize: WidgetStatePropertyAll(iconSize),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) && !secondary
              ? t.surfaceSunken
              : fill,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? t.inkMuted : onFill,
        ),
        iconColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? t.inkMuted : onFill,
        ),
        shape: WidgetStateProperty.resolveWith(
          (states) => StadiumBorder(
            side: secondary
                ? BorderSide(
                    color: states.contains(WidgetState.disabled)
                        ? t.line
                        : t.controlBorder,
                    width: _outlineWidth,
                  )
                : BorderSide.none,
          ),
        ),
      ),
      // One line; long labels in narrow slots shrink instead of wrapping.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              SizedBox(width: compact ? t.space1 : t.space2),
            ],
            Text(label),
            if (trailingIcon != null) ...[
              SizedBox(width: t.space2),
              Icon(trailingIcon),
            ],
          ],
        ),
      ),
    );
  }
}

/// A round icon-only button, `size-touch` unless [size] says otherwise.
///
/// Plain: `surface` with a `line` border. [outlined]: transparent with a
/// `control-border` ring, like the back button in cooking mode. [selected]
/// toggles it to `sage-soft` with a `sage` icon.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.size,
    this.outlined = false,
    this.selected,
  });

  final IconData icon;

  /// The accessible label, also shown as a tooltip.
  final String label;
  final VoidCallback? onPressed;
  final double? size;
  final bool outlined;

  /// Makes it a toggle button when not `null`.
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final on = selected ?? false;
    final side = switch ((outlined, on)) {
      (_, true) => BorderSide.none,
      (true, _) => BorderSide(color: t.controlBorder, width: _outlineWidth),
      (false, _) => BorderSide(color: t.line),
    };
    final extent = size ?? t.sizeTouch;

    return IconButton(
      onPressed: onPressed,
      tooltip: label,
      isSelected: selected,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        fixedSize: Size.square(extent),
        minimumSize: Size.square(extent),
        iconSize: t.titleS.fontSize! + t.space1,
        backgroundColor: on
            ? t.sageSoft
            : outlined
            ? Colors.transparent
            : t.surface,
        foregroundColor: on ? t.sage : t.ink,
        disabledForegroundColor: t.inkMuted,
        shape: CircleBorder(side: side),
      ),
    );
  }
}
