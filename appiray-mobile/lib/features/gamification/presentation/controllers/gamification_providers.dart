import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/gamification/data/gamification_repository_impl.dart';
import 'package:appiray/features/gamification/domain/gamification_entities.dart';

part 'gamification_providers.g.dart';

/// Déballe un [Result] en valeur, ou lève pour alimenter l'AsyncError.
T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      FailureResult<T>(:final failure) => throw Exception(failure.message),
    };

@riverpod
Future<League> myLeague(MyLeagueRef ref) async =>
    _unwrap(await ref.watch(gamificationRepositoryProvider).myLeague());

@riverpod
Future<List<LeaderboardEntry>> leaderboard(LeaderboardRef ref) async => _unwrap(
    await ref.watch(gamificationRepositoryProvider).leaderboard());

@riverpod
Future<List<Badge>> myBadges(MyBadgesRef ref) async =>
    _unwrap(await ref.watch(gamificationRepositoryProvider).myBadges());

@riverpod
Future<List<Quest>> myQuests(MyQuestsRef ref) async =>
    _unwrap(await ref.watch(gamificationRepositoryProvider).myQuests());
