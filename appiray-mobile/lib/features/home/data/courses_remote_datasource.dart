import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/home/data/models/course_models.dart';

/// Accès réseau brut pour les cours.
class CoursesRemoteDataSource {
  CoursesRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<CourseDto>> listCourses() async {
    try {
      final resp = await _dio.get<List<dynamic>>(ApiEndpoints.courses);
      return (resp.data ?? [])
          .map((e) => CourseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CourseDetailDto> getCourseDetail(String courseId) async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>(ApiEndpoints.course(courseId));
      return CourseDetailDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
