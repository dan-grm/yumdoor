import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

/// Placeholder start screen until search (#11) replaces it.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(context.l10n.appTitle)));
  }
}
