import 'package:flutter/widgets.dart';

import '../../design/design.dart';

/// Whether the screen is wide enough for two columns (`size-wide`: tablets,
/// phones in landscape). Every screen decides on the window width, so they
/// switch together on the same device.
bool isWideLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= context.tokens.sizeWide;
