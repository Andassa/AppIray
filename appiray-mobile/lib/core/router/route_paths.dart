/// Chemins de navigation centralisés (go_router).
class RoutePaths {
  const RoutePaths._();

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/';
  static const String lessonPlayer = '/lesson/:lessonId';
  static String lessonPlayerFor(String lessonId) => '/lesson/$lessonId';

  /// Test de positionnement (après inscription, avant home).
  static const String placementIntro = '/placement-test';
  static const String placementSession = '/placement-test/:courseId';
  static String placementSessionFor(String courseId) =>
      '/placement-test/$courseId';
  static const String placementResult = '/placement-test/:courseId/result';
  static String placementResultFor(String courseId) =>
      '/placement-test/$courseId/result';

  static const String progress = '/progress';
  static const String practice = '/practice';

  static const String leaderboard = '/leaderboard';
  static const String badges = '/badges';
  static const String quests = '/quests';

  static const String friends = '/friends';
  static const String userSearch = '/friends/search';
  static const String friendsLeaderboard = '/friends/leaderboard';

  static const String feed = '/feed';
  static const String publicationDetail = '/feed/:publicationId';
  static String publicationDetailFor(String id) => '/feed/$id';

  static const String notifications = '/notifications';
  static const String profile = '/profile';
}
