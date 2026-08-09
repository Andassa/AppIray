import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/data/models/lesson_models.dart';
import 'package:appiray/features/lesson_player/data/progress_remote_datasource.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/domain/progress_repository.dart';

part 'progress_repository_impl.g.dart';

@riverpod
ProgressRemoteDataSource progressRemoteDataSource(
        ProgressRemoteDataSourceRef ref) =>
    ProgressRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
ProgressRepository progressRepository(ProgressRepositoryRef ref) =>
    ProgressRepositoryImpl(ref.watch(progressRemoteDataSourceProvider));

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._remote);
  final ProgressRemoteDataSource _remote;

  Exercise _exerciseFromDto(ExerciseDto d) => Exercise(
        id: d.id,
        lessonId: d.lessonId,
        type: ExerciseType.fromApi(d.type),
        content: d.content,
        audioAssetId: d.audioAssetId,
      );

  @override
  Future<Result<LessonContent>> getLesson(String lessonId) =>
      _guard(() async {
        final dto = await _remote.getLesson(lessonId);
        final exercises = (dto.exercises.toList()
              ..sort((a, b) => a.order.compareTo(b.order)))
            .map(_exerciseFromDto)
            .toList();
        return LessonContent(
          lessonId: dto.id,
          title: dto.title,
          xpReward: dto.xpReward,
          exercises: exercises,
        );
      });

  @override
  Future<Result<AnswerOutcome>> submitAnswer({
    required String exerciseId,
    required String answer,
    bool practice = false,
  }) =>
      _guard(() async {
        final d = await _remote.submitAnswer(
          exerciseId: exerciseId,
          answer: answer,
          practice: practice,
        );
        return AnswerOutcome(
          isCorrect: d.isCorrect,
          xpGained: d.xpGained,
          gemsGained: d.gemsGained,
          hearts: d.hearts,
          xpTotal: d.xpTotal,
          gems: d.gems,
          currentStreak: d.currentStreak,
          level: d.level,
          lessonCompleted: d.lessonCompleted,
          dailyGoalReached: d.dailyGoalReached,
        );
      });

  @override
  Future<Result<List<LessonProgress>>> listProgress() => _guard(() async {
        final list = await _remote.listProgress();
        return list
            .map((d) => LessonProgress(
                  lessonId: d.lessonId,
                  status: ProgressStatus.fromApi(d.status),
                  score: d.score,
                ))
            .toList();
      });

  @override
  Future<Result<HeartsStatus>> getHearts() =>
      _guard(() async => _heartsFromDto(await _remote.getHearts()));

  @override
  Future<Result<HeartsStatus>> refillHeartsWithGems() => _guard(
      () async => _heartsFromDto(await _remote.refillHeartsWithGems()));

  @override
  Future<Result<void>> buyStreakFreeze() =>
      _guard(() async => _remote.buyStreakFreeze());

  @override
  Future<Result<int>> updateDailyGoal(int dailyXpGoal) =>
      _guard(() async => _remote.updateDailyGoal(dailyXpGoal));

  @override
  Future<Result<List<Exercise>>> getPracticeExercises() => _guard(() async {
        final list = await _remote.getPracticeExercises();
        return list.map(_exerciseFromDto).toList();
      });

  HeartsStatus _heartsFromDto(HeartsStatusDto d) => HeartsStatus(
        hearts: d.hearts,
        maxHearts: d.maxHearts,
        gems: d.gems,
        heartRefillAt: d.heartRefillAt,
      );

  /// Enveloppe un appel réseau en `Result`, en normalisant les erreurs.
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
