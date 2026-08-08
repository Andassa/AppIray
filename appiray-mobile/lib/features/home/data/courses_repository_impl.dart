import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/home/data/courses_remote_datasource.dart';
import 'package:appiray/features/home/data/models/course_models.dart';
import 'package:appiray/features/home/domain/course_entities.dart';
import 'package:appiray/features/home/domain/courses_repository.dart';

part 'courses_repository_impl.g.dart';

@riverpod
CoursesRemoteDataSource coursesRemoteDataSource(
        CoursesRemoteDataSourceRef ref) =>
    CoursesRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
CoursesRepository coursesRepository(CoursesRepositoryRef ref) =>
    CoursesRepositoryImpl(ref.watch(coursesRemoteDataSourceProvider));

class CoursesRepositoryImpl implements CoursesRepository {
  CoursesRepositoryImpl(this._remote);
  final CoursesRemoteDataSource _remote;

  @override
  Future<Result<List<Course>>> listCourses() => _guard(() async {
        final dtos = await _remote.listCourses();
        return dtos
            .map((d) => Course(
                  id: d.id,
                  title: d.title,
                  description: d.description,
                ))
            .toList();
      });

  @override
  Future<Result<CourseDetail>> getCourseDetail(String courseId) =>
      _guard(() async {
        final d = await _remote.getCourseDetail(courseId);
        final units = (d.units.toList()
              ..sort((a, b) => a.order.compareTo(b.order)))
            .map(_mapUnit)
            .toList();
        return CourseDetail(
          id: d.id,
          title: d.title,
          description: d.description,
          units: units,
        );
      });

  CourseUnit _mapUnit(UnitDetailDto u) => CourseUnit(
        id: u.id,
        courseId: u.courseId,
        title: u.title,
        order: u.order,
        lessons: (u.lessons.toList()
              ..sort((a, b) => a.order.compareTo(b.order)))
            .map((l) => Lesson(
                  id: l.id,
                  unitId: l.unitId,
                  title: l.title,
                  order: l.order,
                  xpReward: l.xpReward,
                ))
            .toList(),
      );

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
