import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/gamification/domain/gamification_entities.dart';

/// Contrat du repository de gamification (domaine).
abstract interface class GamificationRepository {
  Future<Result<League>> myLeague();
  Future<Result<List<LeaderboardEntry>>> leaderboard({int limit});
  Future<Result<List<Badge>>> myBadges();
  Future<Result<List<Quest>>> myQuests();
}
