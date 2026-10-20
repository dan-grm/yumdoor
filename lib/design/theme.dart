import 'package:flutter/material.dart';

import 'tokens.g.dart';

/// The light app theme.
final lightTheme = themeFrom(YumdoorTokens.light, Brightness.light);

/// The dark app theme.
final darkTheme = themeFrom(YumdoorTokens.dark, Brightness.dark);

/// Material [ThemeData] built only from [tokens], so stock widgets match the
/// design. The tokens are attached as a [ThemeExtension] for `context.tokens`.
ThemeData themeFrom(YumdoorTokens tokens, Brightness brightness) {
  final t = tokens;
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: t.sage,
    onPrimary: t.onSage,
    primaryContainer: t.sageSoft,
    onPrimaryContainer: t.ink,
    secondary: t.sage,
    onSecondary: t.onSage,
    secondaryContainer: t.sageSoft,
    onSecondaryContainer: t.ink,
    tertiary: t.butter,
    onTertiary: t.onButter,
    tertiaryContainer: t.butter,
    onTertiaryContainer: t.onButter,
    error: t.danger,
    onError: t.onDanger,
    surface: t.surface,
    onSurface: t.ink,
    onSurfaceVariant: t.inkMuted,
    surfaceContainerLowest: t.surface,
    surfaceContainerLow: t.surface,
    surfaceContainer: t.surface,
    surfaceContainerHigh: t.surfaceSunken,
    surfaceContainerHighest: t.surfaceSunken,
    outline: t.controlBorder,
    outlineVariant: t.line,
    inverseSurface: t.ink,
    onInverseSurface: t.onInk,
    inversePrimary: t.sageSoft,
    // Borders, not shadows: no Material 3 elevation tint.
    surfaceTint: Colors.transparent,
  );
  final textTheme = TextTheme(
    headlineMedium: t.titleL,
    headlineSmall: t.titleM,
    titleLarge: t.titleM,
    titleMedium: t.titleS,
    titleSmall: t.label,
    bodyLarge: t.bodyL,
    bodyMedium: t.body,
    bodySmall: t.caption,
    labelLarge: t.label,
    labelMedium: t.caption,
    labelSmall: t.overline,
  ).apply(bodyColor: t.ink, displayColor: t.ink);

  return ThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: t.bg,
    canvasColor: t.bg,
    dividerColor: t.line,
    focusColor: t.focus,
    fontFamily: t.body.fontFamily,
    textTheme: textTheme,
    extensions: [t],
  );
}
