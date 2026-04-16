import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/presentation/widgets/app_drawer.dart';
import 'package:hayagsync_app/presentation/widgets/navbar.dart';
import 'package:hayagsync_app/providers/auth_provider.dart';

class WidgetScaffold extends ConsumerWidget {
  const WidgetScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('HAYAGSYNC')),
      body: child,
      bottomNavigationBar: const Navbar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${AppRoute.reportIncident}'),
        child: const Icon(Icons.add),
      ),
      drawer: AppDrawer(),
    );
  }
}
