import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hayagsync_app/core/constants/app_route.dart';

import 'package:hayagsync_app/presentation/auth/login_page.dart';

import 'package:hayagsync_app/presentation/auth/register/register_email_page.dart';
import 'package:hayagsync_app/presentation/auth/register/register_info_page.dart';
import 'package:hayagsync_app/presentation/auth/register/register_otp_page.dart';
import 'package:hayagsync_app/presentation/auth/register/register_proofs_page.dart';
import 'package:hayagsync_app/presentation/auth/register/register_relation_page.dart';
import 'package:hayagsync_app/presentation/auth/register/register_success_page.dart';

import 'package:hayagsync_app/presentation/dashboard_page.dart';

import 'package:hayagsync_app/presentation/inbox/inbox_detail_page.dart';
import 'package:hayagsync_app/presentation/inbox/inbox_page.dart';

import 'package:hayagsync_app/presentation/incidents/incident_detail_page.dart';
import 'package:hayagsync_app/presentation/incidents/incident_page.dart';
import 'package:hayagsync_app/presentation/incidents/report_incident_page.dart';

import 'package:hayagsync_app/presentation/posts/post_page.dart';

import 'package:hayagsync_app/presentation/profile/my_children_page.dart';
import 'package:hayagsync_app/presentation/profile_page.dart';

import 'package:hayagsync_app/presentation/widget_scaffold.dart';

import 'package:hayagsync_app/providers/auth_provider.dart';

final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter(AuthState authState) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,

    initialLocation: AppRoute.initialLocation(
      token: authState.token,
    ),

    redirect: (context, state) {
      final isLoggedIn = authState.token != null;

      final authRoutes = [
        AppRoute.login,
        AppRoute.registerEmail,
        AppRoute.registerOtp,
        AppRoute.registerInfo,
        AppRoute.registerRelation,
        AppRoute.registerProofs,
        AppRoute.registerSuccess,
      ];

      final isAuthRoute =
          authRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoute.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoute.dashboard;
      }

      return null;
    },

    routes: [

      GoRoute(
        path: AppRoute.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoute.registerEmail,
        builder: (context, state) =>
            const RegisterEmailPage(),
      ),

      GoRoute(
        path: AppRoute.registerOtp,
        builder: (context, state) =>
            const RegisterOtpPage(),
      ),

      GoRoute(
        path: AppRoute.registerInfo,
        builder: (context, state) =>
            const RegisterInfoPage(),
      ),

      GoRoute(
        path: AppRoute.registerRelation,
        builder: (context, state) =>
            const RegisterRelationPage(),
      ),

      GoRoute(
        path: AppRoute.registerProofs,
        builder: (context, state) =>
            const RegisterProofsPage(),
      ),

      GoRoute(
        path: AppRoute.registerSuccess,
        builder: (context, state) =>
            const RegisterSuccessPage(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return WidgetScaffold(child: child);
        },

        routes: [
          GoRoute(
            path: AppRoute.dashboard,
            builder: (context, state) =>
                const DashboardPage(),

            routes: [
              GoRoute(
                path: AppRoute.profile,
                builder: (context, state) =>
                    const ProfilePage(),
              ),
            ],
          ),

          GoRoute(
            path: AppRoute.bulletin,
            builder: (context, state) =>
                const PostPage(),
          ),

          GoRoute(
            path: AppRoute.inbox,
            builder: (context, state) =>
                const InboxPage(),

            routes: [
              GoRoute(
                path: AppRoute.inboxDetail,
                builder: (context, state) {
                  final id =
                      state.pathParameters['id']!;

                  return InboxDetailPage(id: id);
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoute.incidents,
            builder: (context, state) =>
                const IncidentPage(),
          ),
        ],
      ),


      GoRoute(
        path: AppRoute.myChildren,
        builder: (context, state) =>
            const MyChildrenPage(),
      ),


      GoRoute(
        path: AppRoute.reportIncident,
        builder: (context, state) =>
            const ReportIncidentPage(),
      ),


      GoRoute(
        path: '${AppRoute.incidents}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;

          return IncidentDetailPage(
            incidentId: id,
          );
        },
      ),
    ],
  );
}