import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../common/layout.dart';

/// The path of the week planner tab.
const planPath = '/plan';

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
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
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
                onDestinationSelected: shell.goBranch,
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
              // The rail keeps the side insets (notch) clear.
              child: MediaQuery.removePadding(
                context: context,
                removeLeft: ltr,
                removeRight: !ltr,
                child: shell,
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
          onDestinationSelected: shell.goBranch,
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

/// Stands in for a tab whose screen isn't built yet: its [title] and a line
/// saying it is coming.
class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(t.space5, t.space3, t.space5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(title, style: t.titleL.copyWith(color: t.ink)),
              ),
              SizedBox(height: t.space4),
              Text(
                context.l10n.navComingSoon,
                style: t.body.copyWith(color: t.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
