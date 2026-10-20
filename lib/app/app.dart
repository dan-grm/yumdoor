import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

/// Root widget: wires the router into [MaterialApp.router].
class YumdoorApp extends ConsumerWidget {
  const YumdoorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Yumdoor',
      routerConfig: ref.watch(routerProvider),
    );
  }
}
