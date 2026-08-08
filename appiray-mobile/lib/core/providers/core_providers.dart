import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appiray/core/network/dio_client.dart';
import 'package:appiray/core/session/session_controller.dart';
import 'package:appiray/core/storage/local_cache_service.dart';
import 'package:appiray/core/storage/secure_storage_service.dart';

part 'core_providers.g.dart';

/// Instance de [SharedPreferences] — surchargée dans `main()` après init async.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider doit être surchargé dans main() '
    'via ProviderScope(overrides: [...]).',
  );
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(SecureStorageServiceRef ref) =>
    SecureStorageService();

@Riverpod(keepAlive: true)
LocalCacheService localCacheService(LocalCacheServiceRef ref) =>
    LocalCacheService(ref.watch(sharedPreferencesProvider));

/// Client HTTP applicatif (Dio) partagé.
///
/// Branche l'intercepteur d'auth/refresh sur le [SessionController] : la
/// dépendance n'est lue qu'au runtime (dans le callback), donc pas de cycle.
@Riverpod(keepAlive: true)
Dio dioClient(DioClientRef ref) {
  return buildDio(
    storage: ref.watch(secureStorageServiceProvider),
    onSessionExpired: () =>
        ref.read(sessionControllerProvider.notifier).markExpired(),
  );
}
