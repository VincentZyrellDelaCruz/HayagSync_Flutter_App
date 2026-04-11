import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
import 'package:hayagsync_app/core/storage/token_storage.dart';
import 'package:hayagsync_app/presentation/auth/login_page.dart';
import 'package:hayagsync_app/presentation/auth/register_page.dart';
import 'package:hayagsync_app/presentation/dashboard_page.dart';
import 'package:hayagsync_app/presentation/inbox/inbox_detail_page.dart';
import 'package:hayagsync_app/presentation/inbox/inbox_page.dart';
import 'package:hayagsync_app/presentation/incidents/incident_page.dart';
import 'package:hayagsync_app/presentation/incidents/report_incident_page.dart';
import 'package:hayagsync_app/presentation/posts/post_page.dart';
import 'package:hayagsync_app/presentation/profile_page.dart';
import 'package:hayagsync_app/presentation/widget_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

Future<GoRouter> createRouter() async {
  final token = await TokenStorage.getToken();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.initialLocation(
      token: token,
    ),
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.register,
        builder: (context, state) => const RegisterPage(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return WidgetScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.dashboard,
            builder: (context, state) => const DashboardPage(),
            routes: [
              GoRoute(
                path: AppRoute.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.disciplinaryPosts,
            builder: (context, state) => const PostPage(),
          ),
          GoRoute(
            path: AppRoute.inbox,
            builder: (context, state) => const InboxPage(),
            routes: [
              GoRoute(
                path: AppRoute.inboxDetail,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return InboxDetailPage(id: id,);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.incidents,
            builder: (context, state) => const IncidentPage(),
            routes: [
              GoRoute(
                path: AppRoute.reportIncident,
                builder: (context, state) => const ReportIncidentPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
