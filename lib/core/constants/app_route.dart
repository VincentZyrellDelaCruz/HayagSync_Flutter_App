class AppRoute {
  // Auth
  static const String login = '/login'; // Initial location if not logged in
  static const String register = '/register';

  // Navigation Bar Routes
  static const String dashboard = '/dashboard'; // Initial location if logged in
  static const String disciplinaryPosts = '/disciplinary_posts';
  static const String inbox = '/inbox';
  static const String incidents = '/incidents';

  // Subpaths
  static const String reportIncident = 'report';
  static const String incidentDetail = ':id';
  static const String inboxDetail = ':id';
  static const String profile = 'profile';
  static const String notification = 'notification';

  static String initialLocation({String? token}) {
    return token == null ? login : dashboard;
  }

  static const List<String> navbarRoutes = [
    dashboard,
    disciplinaryPosts,
    inbox,
    incidents,
  ];
}
