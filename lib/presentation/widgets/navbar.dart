import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onItemTapped(index, context),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.article), label: 'Posts'),
        NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
        NavigationDestination(icon: Icon(Icons.report), label: 'Incidents'),
      ],
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoute.dashboard)) return 0;
    if (location.startsWith(AppRoute.bulletin)) return 1;
    if (location.startsWith(AppRoute.inbox)) return 2;
    if (location.startsWith(AppRoute.incidents)) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoute.dashboard);
        break;
      case 1:
        context.go(AppRoute.bulletin);
        break;
      case 2:
        context.go(AppRoute.inbox);
        break;
      case 3:
        context.go(AppRoute.incidents);
        break;
    }
  }
}
