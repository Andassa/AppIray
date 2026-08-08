/// Entité domaine Utilisateur.
class User {
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.isEmailVerified,
    required this.xpTotal,
    required this.gems,
    required this.currentStreak,
    required this.longestStreak,
    required this.hearts,
    required this.dailyXpGoal,
    required this.level,
    this.avatarUrl,
    this.heartRefillAt,
  });

  final String id;
  final String email;
  final String username;
  final String role;
  final bool isEmailVerified;
  final int xpTotal;
  final int gems;
  final int currentStreak;
  final int longestStreak;
  final int hearts;
  final int dailyXpGoal;
  final int level;
  final String? avatarUrl;
  final DateTime? heartRefillAt;

  bool get isAdmin => role == 'admin';
}
