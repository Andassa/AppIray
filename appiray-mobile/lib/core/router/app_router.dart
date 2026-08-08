import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/core/session/session_controller.dart';
import 'package:appiray/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:appiray/features/auth/presentation/screens/login_screen.dart';
import 'package:appiray/features/auth/presentation/screens/register_screen.dart';
import 'package:appiray/features/content/presentation/screens/feed_screen.dart';
import 'package:appiray/features/content/presentation/screens/publication_detail_screen.dart';
import 'package:appiray/features/gamification/presentation/screens/badges_screen.dart';
import 'package:appiray/features/gamification/presentation/screens/leaderboard_screen.dart';
import 'package:appiray/features/gamification/presentation/screens/quests_screen.dart';
import 'package:appiray/features/home/presentation/screens/home_screen.dart';
import 'package:appiray/features/lesson_player/presentation/screens/lesson_player_screen.dart';
import 'package:appiray/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:appiray/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:appiray/features/practice/presentation/screens/practice_screen.dart';
import 'package:appiray/features/profile/presentation/screens/profile_screen.dart';
import 'package:appiray/features/progress/presentation/screens/progress_screen.dart';
import 'package:appiray/features/social/presentation/screens/friends_leaderboard_screen.dart';
import 'package:appiray/features/social/presentation/screens/friends_screen.dart';
import 'package:appiray/features/social/presentation/screens/user_search_screen.dart';

part 'app_router.g.dart';

/// Routes publiques accessibles sans authentification.
const _publicRoutes = <String>{
  RoutePaths.welcome,
  RoutePaths.login,
  RoutePaths.register,
  RoutePaths.forgotPassword,
};

/// Router applicatif. Écoute [SessionController] pour rediriger de façon
/// réactive (déconnexion à tout moment → retour au welcome/login).
@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  // Pont Riverpod -> Listenable pour `refreshListenable`.
  final refresh = _RouterRefresh();
  ref.listen(sessionControllerProvider, (_, _) => refresh.notify());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final status = ref.read(sessionControllerProvider);
      final loc = state.matchedLocation;
      final isPublic = _publicRoutes.contains(loc);

      // Tant que l'état n'est pas déterminé, on ne redirige pas.
      if (status == AuthStatus.unknown) return null;

      final authenticated = status == AuthStatus.authenticated;
      if (!authenticated && !isPublic) return RoutePaths.welcome;
      if (authenticated && isPublic) return RoutePaths.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.lessonPlayer,
        builder: (_, state) => LessonPlayerScreen(
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.progress,
        builder: (_, _) => const ProgressScreen(),
      ),
      GoRoute(
        path: RoutePaths.practice,
        builder: (_, _) => const PracticeScreen(),
      ),
      GoRoute(
        path: RoutePaths.leaderboard,
        builder: (_, _) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: RoutePaths.badges,
        builder: (_, _) => const BadgesScreen(),
      ),
      GoRoute(
        path: RoutePaths.quests,
        builder: (_, _) => const QuestsScreen(),
      ),
      GoRoute(
        path: RoutePaths.friends,
        builder: (_, _) => const FriendsScreen(),
      ),
      GoRoute(
        path: RoutePaths.userSearch,
        builder: (_, _) => const UserSearchScreen(),
      ),
      GoRoute(
        path: RoutePaths.friendsLeaderboard,
        builder: (_, _) => const FriendsLeaderboardScreen(),
      ),
      GoRoute(
        path: RoutePaths.feed,
        builder: (_, _) => const FeedScreen(),
      ),
      GoRoute(
        path: RoutePaths.publicationDetail,
        builder: (_, state) => PublicationDetailScreen(
          publicationId: state.pathParameters['publicationId']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
    ],
  );
}

/// Petit [ChangeNotifier] servant de pont pour `refreshListenable`.
class _RouterRefresh extends ChangeNotifier {
  void notify() => notifyListeners();
}
