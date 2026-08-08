import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage sécurisé des tokens JWT (access + refresh).
class SecureStorageService {
  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  Future<String?> readAccessToken() => _storage.read(key: _kAccessToken);

  Future<String?> readRefreshToken() => _storage.read(key: _kRefreshToken);

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    await _storage.write(key: _kRefreshToken, value: refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
  }
}
