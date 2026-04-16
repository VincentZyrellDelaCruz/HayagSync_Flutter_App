import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hayagsync_app/core/constants/app_route.dart';
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
import 'package:hayagsync_app/providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter(AuthState authState) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: authState.token != null
        ? AppRoute.dashboard
        : AppRoute.login,
    redirect: (context, state) {
      final isLoggedIn = authState.token != null;
      final isLoggingIn = state.matchedLocation == AppRoute.login;

      if (!isLoggedIn && !isLoggingIn) return AppRoute.login;
      if (isLoggedIn && isLoggingIn) return AppRoute.dashboard;
      return null;
    },
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
                  return InboxDetailPage(id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.incidents,
            builder: (context, state) => const IncidentPage(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoute.reportIncident,
        builder: (context, state) => const ReportIncidentPage(),
      ),
    ],
  );
}
