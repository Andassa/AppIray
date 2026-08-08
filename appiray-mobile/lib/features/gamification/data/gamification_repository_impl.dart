import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/gamification/data/gamification_remote_datasource.dart';
import 'package:appiray/features/gamification/domain/gamification_entities.dart';
import 'package:appiray/features/gamification/domain/gamification_repository.dart';

part 'gamification_repository_impl.g.dart';

@riverpod
GamificationRemoteDataSource gamificationRemoteDataSource(
        GamificationRemoteDataSourceRef ref) =>
    GamificationRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
GamificationRepository gamificationRepository(
        GamificationRepositoryRef ref) =>
    GamificationRepositoryImpl(ref.watch(gamificationRemoteDataSourceProvider));

class GamificationRepositoryImpl implements GamificationRepository {
  GamificationRepositoryImpl(this._remote);
  final GamificationRemoteDataSource _remote;

  @override
  Future<Result<League>> myLeague() => _guard(() async {
        final d = await _remote.myLeague();
        return League(id: d.id, name: d.name, tier: d.tier);
      });

  @override
  Future<Result<List<LeaderboardEntry>>> leaderboard({int limit = 50}) =>
      _guard(() async {
        final list = await _remote.leaderboard(limit: limit);
        return list
            .map((d) => LeaderboardEntry(
                  userId: d.userId,
                  username: d.username,
                  xp: d.xpThisWeek,
                  rank: d.rank,
                ))
            .toList();
      });

  @override
  Future<Result<List<Badge>>> myBadges() => _guard(() async {
        final list = await _remote.myBadges();
        return list
            .map((d) => Badge(
                  id: d.badge.id,
                  name: d.badge.name,
                  description: d.badge.description,
                  iconUrl: d.badge.iconUrl,
                  earnedAt: d.earnedAt,
                ))
            .toList();
      });

  @override
  Future<Result<List<Quest>>> myQuests() => _guard(() async {
        final list = await _remote.myQuests();
        return list.map((d) {
          final target = (d.quest.criteria['target'] as num?)?.toInt() ?? 1;
          return Quest(
            id: d.id,
            title: d.quest.title,
            description: d.quest.description,
            xpReward: d.quest.xpReward,
            gemReward: d.quest.gemReward,
            progress: d.progress,
            target: target,
            completed: d.completedAt != null,
          );
        }).toList();
      });

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Result.success(await body());
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }
}
