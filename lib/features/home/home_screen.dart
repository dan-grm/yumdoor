import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session.dart';
import '../../l10n/l10n.dart';

/// Placeholder start screen until search (#11) replaces it.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Moves to the settings screen once it exists.
          IconButton(
            tooltip: context.l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(sessionControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(child: Text(context.l10n.appTitle)),
    );
  }
}
