import 'package:flutter/material.dart';

/// Placeholder start screen until search (#11) replaces it.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Product name only; real strings go through AppLocalizations (#7).
    return const Scaffold(body: Center(child: Text('Yumdoor')));
  }
}
