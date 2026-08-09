import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

/// Contrat du repository de progression (domaine).
///
/// Volontairement partagé : lesson_player (jouer une leçon), home (statuts des
/// leçons), progress (stats), practice (révision) s'appuient tous dessus.
abstract interface class ProgressRepository {
  /// Charge une leçon et ses exercices (GET /courses/lessons/{id}).
  Future<Result<LessonContent>> getLesson(String lessonId);

  /// Soumet une réponse. [practice] = true ne consomme pas de cœur.
  Future<Result<AnswerOutcome>> submitAnswer({
    required String exerciseId,
    required String answer,
    bool practice,
  });

  /// Progression par leçon de l'utilisateur (GET /progress/me).
  Future<Result<List<LessonProgress>>> listProgress();

  /// État courant des cœurs / gemmes (GET /progress/hearts).
  Future<Result<HeartsStatus>> getHearts();

  /// Recharge les cœurs avec des gemmes.
  Future<Result<HeartsStatus>> refillHeartsWithGems();

  /// Achète un streak freeze avec des gemmes.
  Future<Result<void>> buyStreakFreeze();

  /// Met à jour l'objectif quotidien d'XP. Retourne la nouvelle valeur.
  Future<Result<int>> updateDailyGoal(int dailyXpGoal);

  /// Exercices de révision (GET /progress/practice).
  Future<Result<List<Exercise>>> getPracticeExercises();
}
