import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
import '../../app/repository_providers.dart';
import '../../app/session.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../shopping/shopping_providers.dart';

/// Logs out. If shopping check-offs made offline aren't sent yet, it tries
/// to send them, and if that doesn't work, asks first, since logging out
/// drops them.
Future<void> confirmAndLogout(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final session = ref.read(sessionControllerProvider.notifier);
  final list = ref.exists(shoppingListProvider)
      ? ref.read(shoppingListProvider.notifier)
      : null;
  final queue = ref.read(shoppingCheckQueueProvider);
  if (list != null && !ref.read(isOfflineProvider)) {
    try {
      // The server may take them now; then there is nothing to lose.
      await list.sendQueued();
    } on Object {
      // Asked about below.
    }
  }
  var pending = false;
  try {
    pending =
        (await list?.hasPending() ?? false) || (await queue.read()).isNotEmpty;
  } on Object {
    // Nothing to tell about, then.
  }
  if (pending) {
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final t = context.tokens;
        return AlertDialog(
          title: Text(l10n.logoutPendingTitle),
          content: Text(l10n.logoutPendingBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.logoutPendingKeep),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: t.danger),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.logoutPendingConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
  }
  await session.logout();
}
