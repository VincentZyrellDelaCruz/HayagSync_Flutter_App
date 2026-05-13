class AppRoute {
  // Auth
  static const String login = '/login'; // Initial location if not logged in
  
  static const registerEmail = '/register/email';
  static const registerOtp = '/register/otp';
  static const registerInfo = '/register/info';
  static const registerRelation = '/register/relation';
  static const registerProofs = '/register/proofs';
  static const registerSuccess = '/register/success';

  // Navigation Bar Routes
  static const String dashboard = '/'; // Initial location if logged in
  static const String bulletin = '/bulletin';
  static const String inbox = '/inbox';
  static const String incidents = '/incidents';

  static const String userHub = '/user';

  // Subpaths
  static const String reportIncident = '/incidents/report';
  static const String incidentDetail = ':id';
  static const String inboxDetail = ':id';
  static const String profile = 'profile';
  static const String notification = 'notification';

  static const String myChildren = '/myChildren';

  static String initialLocation({String? token}) {
    return token == null ? login : dashboard;
  }

  static const List<String> navbarRoutes = [
    dashboard,
    bulletin,
    inbox,
    incidents,
  ];
}
