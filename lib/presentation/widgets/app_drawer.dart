import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/models/user.dart';
import 'package:hayagsync_app/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    String _formatFullName(User user) {
      final sb = StringBuffer();

      sb.write(user.firstName);
      if (user.middleName != null && user.middleName!.isNotEmpty) {
        sb.write(' ${user.middleName}');
      }
      if (user.suffix != null && user.suffix!.isNotEmpty) {
        sb.write(' ${user.suffix}');
      }
      sb.write(' ${user.lastName}');

      return sb.toString();
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _formatFullName(user!),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user.email),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person_2_rounded, size: 40),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.child_care_rounded),
            title: const Text('Related Students List'),
            onTap: () => context.push(AppRoute.myChildren),
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () async {
              Navigator.of(context).pop();

              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
