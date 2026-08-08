import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/home/domain/course_entities.dart';

/// Contrat du repository des cours (domaine).
abstract interface class CoursesRepository {
  Future<Result<List<Course>>> listCourses();
  Future<Result<CourseDetail>> getCourseDetail(String courseId);
}
