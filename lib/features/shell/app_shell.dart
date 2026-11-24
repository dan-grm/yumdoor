import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/design.dart';
import '../../domain/models/calendar_day.dart';
import '../../l10n/l10n.dart';
import '../common/layout.dart';
import '../shopping/shopping_providers.dart';

/// The path of the week planner tab.
const planPath = '/plan';

/// The week planner at the week of [day].
String planLocation(CalendarDay day) =>
    Uri(path: planPath, queryParameters: {'day': '$day'}).toString();

/// The path of the shopping list tab.
const shoppingPath = '/shopping';

/// One tab of the main navigation.
typedef _Tab = ({IconData icon, IconData selectedIcon, String label});

/// The main navigation around the tabs (Suchen, Planer, Einkauf): a bar at
/// the bottom on phones, a rail at the side on wide layouts.
///
/// [shell] holds one navigator per tab, so each tab keeps its own stack and
/// scroll position. Its branches are in the order of the destinations here.
/// Screens that take the whole screen (recipe, cooking mode, editor) are
/// routes above the shell, so the navigation is hidden there.
///
/// It also sends shopping check-offs left unsent by an earlier start of the
/// app, whichever tab is open ([shoppingQueueReplayProvider]).
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  /// Opens tab [index] where the user left it; tapping the open tab again
  /// goes back to its start.
  void _select(int index) =>
      shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(shoppingQueueReplayProvider);
    return PopScope(
      // Back (Android) on another tab returns to search before leaving the
      // app.
      canPop: shell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) shell.goBranch(0);
      },
      child: _navigation(context),
    );
  }

  Widget _navigation(BuildContext context) {
    final t = context.tokens;
    final l10n = context.l10n;
    final List<_Tab> tabs = [
      (
        icon: Icons.search_rounded,
        selectedIcon: Icons.search_rounded,
        label: l10n.navSearch,
      ),
      (
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month_rounded,
        label: l10n.navPlan,
      ),
      (
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart_rounded,
        label: l10n.navShopping,
      ),
    ];
    final border = BorderSide(color: t.line);

    if (isWideLayout(context)) {
      final ltr = Directionality.of(context) == TextDirection.ltr;
      return Scaffold(
        body: Row(
          children: [
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: ltr ? Border(right: border) : Border(left: border),
              ),
              child: NavigationRail(
                selectedIndex: shell.currentIndex,
                onDestinationSelected: _select,
                destinations: [
                  for (final tab in tabs)
                    NavigationRailDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.selectedIcon),
                      label: Text(tab.label),
                    ),
                ],
              ),
            ),
            Expanded(
              // The rail keeps the side insets (notch) clear. From the
              // body's context, which the Scaffold has taken the keyboard
              // out of.
              child: Builder(
                builder: (context) => MediaQuery.removePadding(
                  context: context,
                  removeLeft: ltr,
                  removeRight: !ltr,
                  child: shell,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(border: Border(top: border)),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: _select,
          destinations: [
            for (final tab in tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}

/// The tabs' navigators, only [currentIndex] shown. The others keep their
/// state but don't animate, and can't hold the keyboard focus: typing into a
/// hidden search field would change a tab the user can't see.
class TabStack extends StatelessWidget {
  const TabStack({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => IndexedStack(
    index: currentIndex,
    children: [
      for (final (index, child) in children.indexed)
        Offstage(
          offstage: index != currentIndex,
          child: TickerMode(
            enabled: index == currentIndex,
            child: ExcludeFocus(excluding: index != currentIndex, child: child),
          ),
        ),
    ],
  );
}
