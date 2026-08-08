import 'package:dio/dio.dart';

/// Exception typée pour les erreurs d'API.
///
/// Convertit une [DioException] en une erreur exploitable (message lisible +
/// code HTTP). Les repositories la catchent pour produire un `Failure`.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final dynamic data;

  factory ApiException.fromDioException(DioException e) {
    final response = e.response;
    final statusCode = response?.statusCode;

    // Le backend FastAPI renvoie généralement {"detail": "..."}.
    String message;
    final data = response?.data;
    if (data is Map && data['detail'] != null) {
      final detail = data['detail'];
      message = detail is String ? detail : detail.toString();
    } else {
      message = switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          'Délai de connexion dépassé. Vérifie ta connexion.',
        DioExceptionType.connectionError =>
          'Impossible de joindre le serveur.',
        DioExceptionType.badCertificate => 'Certificat serveur invalide.',
        DioExceptionType.cancel => 'Requête annulée.',
        _ => 'Erreur réseau inattendue.',
      };
    }

    return ApiException(message, statusCode: statusCode, data: data);
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
