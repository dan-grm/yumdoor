import 'package:flutter/material.dart';

import '../../core/failures.dart';
import '../../design/components/buttons.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';

/// Explains a failed request and offers to repeat it.
class FailureView extends StatelessWidget {
  const FailureView({
    super.key,
    required this.error,
    required this.onRetry,
    this.notFoundMessage,
  });

  final Object error;
  final VoidCallback onRetry;

  /// What a [NotFoundFailure] means here ("Dieses Rezept gibt es nicht").
  final String? notFoundMessage;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final message = switch (error) {
      OfflineFailure() => l10n.errorOffline,
      UnauthorizedFailure() => l10n.errorUnauthorized,
      ThrottledFailure() => l10n.errorThrottled,
      NotFoundFailure() when notFoundMessage != null => notFoundMessage!,
      _ => l10n.errorServer,
    };
    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.space5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: t.body.copyWith(color: t.ink),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: t.space4),
            PillButton(
              label: l10n.retry,
              onPressed: onRetry,
              kind: PillButtonKind.secondary,
              compact: true,
            ),
          ],
        ),
      ),
    );
  }
}
