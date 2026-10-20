import 'package:flutter/material.dart';

import 'tokens.g.dart';

export 'theme.dart';
export 'tokens.g.dart';

extension YumdoorTokensContext on BuildContext {
  /// The design tokens of the active theme: `context.tokens.sage`.
  YumdoorTokens get tokens => Theme.of(this).extension<YumdoorTokens>()!;
}
