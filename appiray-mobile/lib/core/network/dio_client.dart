import 'package:dio/dio.dart';

import 'package:appiray/core/config/app_config.dart';
import 'package:appiray/core/network/api_endpoints.dart';
import 'package:appiray/core/storage/secure_storage_service.dart';

/// Callback déclenché quand la session ne peut plus être rafraîchie
/// (refresh token invalide) → l'app doit déconnecter proprement.
typedef OnSessionExpired = Future<void> Function();

/// Fabrique le [Dio] applicatif avec :
/// - attachement automatique du access token,
/// - refresh automatique sur 401 (retry de la requête d'origine),
/// - déconnexion propre si le refresh échoue,
/// - logging en debug.
Dio buildDio({
  required SecureStorageService storage,
  required OnSessionExpired onSessionExpired,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    _AuthRefreshInterceptor(
      dio: dio,
      storage: storage,
      onSessionExpired: onSessionExpired,
    ),
  );

  if (AppConfig.enableNetworkLogging) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}

class _AuthRefreshInterceptor extends Interceptor {
  _AuthRefreshInterceptor({
    required this.dio,
    required this.storage,
    required this.onSessionExpired,
  });

  final Dio dio;
  final SecureStorageService storage;
  final OnSessionExpired onSessionExpired;

  /// Marque les requêtes déjà rejouées pour éviter une boucle de refresh.
  static const _retriedKey = 'x-retried';

  /// Endpoints d'auth qui ne doivent JAMAIS déclencher de refresh.
  static const _authPaths = {
    ApiEndpoints.login,
    ApiEndpoints.register,
    ApiEndpoints.refresh,
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final requestOptions = err.requestOptions;

    final isUnauthorized = response?.statusCode == 401;
    final isAuthPath = _authPaths.contains(requestOptions.path);
    final alreadyRetried = requestOptions.extra[_retriedKey] == true;

    if (!isUnauthorized || isAuthPath || alreadyRetried) {
      return handler.next(err);
    }

    final refreshed = await _tryRefresh();
    if (!refreshed) {
      await onSessionExpired();
      return handler.next(err);
    }

    // Rejoue la requête d'origine avec le nouveau token.
    try {
      final newToken = await storage.readAccessToken();
      final retryOptions = requestOptions
        ..extra[_retriedKey] = true
        ..headers['Authorization'] = 'Bearer $newToken';
      final retryResponse = await dio.fetch<dynamic>(retryOptions);
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Tente de rafraîchir le token via un Dio "nu" (sans intercepteurs) pour
  /// éviter toute récursion. Retourne true si le refresh a réussi.
  Future<bool> _tryRefresh() async {
    final refreshToken = await storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final bareDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
    try {
      final resp = await bareDio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );
      final data = resp.data;
      final newAccess = data?['access_token'] as String?;
      final newRefresh = data?['refresh_token'] as String?;
      if (newAccess == null || newRefresh == null) return false;
      await storage.writeTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
