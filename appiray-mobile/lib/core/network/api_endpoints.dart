/// Constantes de tous les chemins d'API (relatifs à AppConfig.apiBaseUrl).
///
/// Centralisés ici pour éviter les chaînes magiques dispersées dans les
/// datasources.
class ApiEndpoints {
  const ApiEndpoints._();

  // --- auth ---
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmailRequest = '/auth/verify-email/request';
  static const String verifyEmailConfirm = '/auth/verify-email/confirm';

  // --- users ---
  static const String usersMe = '/users/me';
  static const String usersMeAvatar = '/users/me/avatar';
  static String userById(String id) => '/users/$id';

  // --- courses ---
  static const String courses = '/courses';
  static String course(String id) => '/courses/$id';
  static String lesson(String lessonId) => '/courses/lessons/$lessonId';
  static String placementTest(String courseId) =>
      '/courses/$courseId/placement-test';
  static String placementTestSubmit(String courseId) =>
      '/courses/$courseId/placement-test/submit';

  // --- progress ---
  static const String answer = '/progress/answer';
  static const String progressMe = '/progress/me';
  static const String progressXp = '/progress/me/xp';
  static const String hearts = '/progress/hearts';
  static const String heartsRefillWithGems = '/progress/hearts/refill-with-gems';
  static const String streakFreeze = '/progress/streak/freeze';
  static const String dailyGoal = '/progress/daily-goal';
  static const String practice = '/progress/practice';

  // --- gamification ---
  static const String leagueMe = '/gamification/league/me';
  static const String leaderboard = '/gamification/league/leaderboard';
  static const String badges = '/gamification/badges';
  static const String badgesMe = '/gamification/badges/me';
  static const String questsMe = '/gamification/quests/me';

  // --- social ---
  static const String userSearch = '/social/users/search';
  static const String friends = '/social/friends';
  static const String friendRequest = '/social/friends/request';
  static String friendAccept(String friendshipId) =>
      '/social/friends/$friendshipId/accept';
  static const String friendsLeaderboard = '/social/friends/leaderboard';

  // --- content ---
  static const String publications = '/content/publications';
  static String publication(String id) => '/content/publications/$id';
  static String publicationLike(String id) => '/content/publications/$id/like';
  static String publicationComments(String id) =>
      '/content/publications/$id/comments';
  static String publicationComment(String id, String commentId) =>
      '/content/publications/$id/comments/$commentId';

  // --- notifications ---
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String deviceToken = '/notifications/device-token';
}
