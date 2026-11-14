import 'package:flutter/widgets.dart';

import '../../design/design.dart';

/// Whether the screen is wide enough for two columns (`size-wide`: tablets,
/// phones in landscape). Every screen decides on the window width inside the
/// safe area (notches, rounded corners), so they switch together on the same
/// device.
///
/// The insets come from the [View]: a [SafeArea] above removes them from the
/// [MediaQuery] its children see.
bool isWideLayout(BuildContext context) {
  final view = View.of(context);
  final insets =
      (view.padding.left + view.padding.right) / view.devicePixelRatio;
  return MediaQuery.sizeOf(context).width - insets >= context.tokens.sizeWide;
}
