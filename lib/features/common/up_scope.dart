import 'package:flutter/widgets.dart';

/// Back on a screen with nothing below it, because it was opened from a link
/// or the page was reloaded, calls [onUp] (e.g. opens search) instead of
/// leaving the app. Above another screen, back closes it as usual.
///
/// While [canPop] is false, back does nothing, like [PopScope.canPop].
class UpScope extends StatelessWidget {
  const UpScope({
    super.key,
    required this.onUp,
    this.canPop = true,
    required this.child,
  });

  final VoidCallback onUp;
  final bool canPop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final first = ModalRoute.isFirstOf(context) ?? false;
    return PopScope(
      canPop: canPop && !first,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && canPop && first) onUp();
      },
      child: child,
    );
  }
}
