import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/placement_test/domain/placement_entities.dart';

/// Contrat du repository de test de positionnement.
abstract interface class PlacementRepository {
  /// GET /courses/{courseId}/placement-test → liste d'exercices (même forme ExerciseRead).
  Future<Result<List<Exercise>>> getExercises(String courseId);

  /// POST /courses/{courseId}/placement-test/submit
  Future<Result<PlacementResult>> submit({
    required String courseId,
    required Map<String, String> answers,
  });
}
