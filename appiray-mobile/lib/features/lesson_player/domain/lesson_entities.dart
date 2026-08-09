// Entités domaine partagées par lesson_player / home / progress / practice.

/// Type d'exercice (aligné sur l'enum backend ExerciseType).
enum ExerciseType {
  mcq,
  translate,
  listen,
  speak,
  unknown;

  static ExerciseType fromApi(String raw) => switch (raw) {
        'mcq' => ExerciseType.mcq,
        'translate' => ExerciseType.translate,
        'listen' => ExerciseType.listen,
        'speak' => ExerciseType.speak,
        _ => ExerciseType.unknown,
      };
}

/// État d'une leçon pour l'utilisateur courant (aligné sur ProgressStatus).
enum ProgressStatus {
  locked,
  inProgress,
  completed;

  static ProgressStatus fromApi(String raw) => switch (raw) {
        'completed' => ProgressStatus.completed,
        'in_progress' => ProgressStatus.inProgress,
        _ => ProgressStatus.locked,
      };
}

/// Un exercice jouable. `content` est volontairement un Map libre : la forme
/// exacte dépend du type et est interprétée par le widget correspondant.
class Exercise {
  const Exercise({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.content,
    this.audioAssetId,
  });

  final String id;
  final String lessonId;
  final ExerciseType type;
  final Map<String, dynamic> content;
  final String? audioAssetId;

  /// Helpers défensifs (on ne présume pas d'un schéma rigide côté backend).
  String get prompt =>
      (content['prompt'] ?? content['question'] ?? content['text'] ?? '')
          .toString();

  List<String> get options {
    final raw = content['options'] ?? content['choices'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const [];
  }

  String? get audioUrl =>
      (content['audio_url'] ?? content['audioUrl'])?.toString();
}

/// Contenu complet d'une leçon (métadonnées + exercices).
class LessonContent {
  const LessonContent({
    required this.lessonId,
    required this.title,
    required this.xpReward,
    required this.exercises,
  });

  final String lessonId;
  final String title;
  final int xpReward;
  final List<Exercise> exercises;
}

/// Progression sur une leçon donnée.
class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.status,
    required this.score,
  });

  final String lessonId;
  final ProgressStatus status;
  final int score;
}

/// Résultat de la soumission d'une réponse.
class AnswerOutcome {
  const AnswerOutcome({
    required this.isCorrect,
    required this.xpGained,
    required this.gemsGained,
    required this.hearts,
    required this.xpTotal,
    required this.gems,
    required this.currentStreak,
    required this.level,
    required this.lessonCompleted,
    required this.dailyGoalReached,
  });

  final bool isCorrect;
  final int xpGained;
  final int gemsGained;
  final int hearts;
  final int xpTotal;
  final int gems;
  final int currentStreak;
  final int level;
  final bool lessonCompleted;
  final bool dailyGoalReached;
}

/// État des cœurs / gemmes.
class HeartsStatus {
  const HeartsStatus({
    required this.hearts,
    required this.maxHearts,
    required this.gems,
    this.heartRefillAt,
  });

  final int hearts;
  final int maxHearts;
  final int gems;
  final DateTime? heartRefillAt;
}
