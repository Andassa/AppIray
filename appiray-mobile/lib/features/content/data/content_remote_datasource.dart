import 'package:dio/dio.dart';

import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/features/content/data/models/content_models.dart';

/// Accès réseau brut pour le contenu.
class ContentRemoteDataSource {
  ContentRemoteDataSource(this._dio);
  final Dio _dio;

  Future<PaginatedPublicationsDto> listPublications({
    int page = 1,
    String? category,
  }) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.publications,
        queryParameters: {
          'page': page,
          'category': ?category,
        },
      );
      return PaginatedPublicationsDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PublicationDto> getPublication(String id) async {
    try {
      final resp = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.publication(id),
      );
      return PublicationDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> like(String id) async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.publicationLike(id));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> unlike(String id) async {
    try {
      await _dio.delete<dynamic>(ApiEndpoints.publicationLike(id));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<CommentDto>> listComments(String publicationId) async {
    try {
      final resp = await _dio.get<List<dynamic>>(
        ApiEndpoints.publicationComments(publicationId),
      );
      return (resp.data ?? [])
          .map((e) => CommentDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CommentDto> addComment(String publicationId, String body) async {
    try {
      final resp = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.publicationComments(publicationId),
        data: {'body': body},
      );
      return CommentDto.fromJson(resp.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
