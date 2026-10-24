import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
import '../../l10n/l10n.dart';

/// An action that changes data on the server. Offline it stays visible but
/// disabled, and a tooltip says why; no write is queued for later.
class OfflineDisabled extends ConsumerWidget {
  const OfflineDisabled({super.key, required this.builder});

  /// Builds the action; it must be disabled unless `enabled`.
  final Widget Function(BuildContext context, bool enabled) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(isOfflineProvider);
    final action = builder(context, !offline);
    if (!offline) return action;
    return Tooltip(
      message: context.l10n.offlineWriteDisabled,
      triggerMode: TooltipTriggerMode.tap,
      child: action,
    );
  }
}
