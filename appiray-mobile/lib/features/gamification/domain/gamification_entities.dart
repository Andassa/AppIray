// Entités domaine de la gamification.

class League {
  const League({required this.id, required this.name, required this.tier});
  final String id;
  final String name;
  final int tier;
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.xp,
    required this.rank,
  });
  final String userId;
  final String username;
  final int xp;
  final int rank;
}

class Badge {
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.earnedAt,
  });
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final DateTime? earnedAt;

  bool get earned => earnedAt != null;
}

class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.gemReward,
    required this.progress,
    required this.target,
    required this.completed,
  });
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final int gemReward;
  final int progress;
  final int target;
  final bool completed;
}
