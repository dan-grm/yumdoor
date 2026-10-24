import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/offline.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';

/// Puts a banner above [child] while the app is offline, saying that opened
/// recipes still work.
///
/// Wraps the whole app (`MaterialApp.builder`), so it is on every screen.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(isOfflineProvider);
    if (!offline) return child;

    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: t.butter,
          child: SafeArea(
            bottom: false,
            child: Semantics(
              liveRegion: true,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: t.space5,
                  vertical: t.space2,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: t.space5,
                      color: t.onButter,
                    ),
                    SizedBox(width: t.space3),
                    Expanded(
                      child: Text(
                        context.l10n.offlineBanner,
                        style: t.caption.copyWith(color: t.onButter),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // The banner takes the status bar area; the screen below starts
        // underneath it.
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
