// Entités domaine du parcours (cours / unités / leçons).

class Course {
  const Course({
    required this.id,
    required this.title,
    this.description,
  });

  final String id;
  final String title;
  final String? description;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.unitId,
    required this.title,
    required this.order,
    required this.xpReward,
  });

  final String id;
  final String unitId;
  final String title;
  final int order;
  final int xpReward;
}

class CourseUnit {
  const CourseUnit({
    required this.id,
    required this.courseId,
    required this.title,
    required this.order,
    required this.lessons,
  });

  final String id;
  final String courseId;
  final String title;
  final int order;
  final List<Lesson> lessons;
}

class CourseDetail {
  const CourseDetail({
    required this.id,
    required this.title,
    this.description,
    required this.units,
  });

  final String id;
  final String title;
  final String? description;
  final List<CourseUnit> units;
}

/// Statut d'affichage d'une leçon dans l'accueil.
enum LessonUiStatus { locked, available, inProgress, completed }
