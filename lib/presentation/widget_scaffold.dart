import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/presentation/widgets/navbar.dart';

class WidgetScaffold extends StatelessWidget {
  const WidgetScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Navbar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.go('${AppRoute.incidents}/${AppRoute.reportIncident}'),
        child: Icon(Icons.add),
      ),
    );
  }
}
