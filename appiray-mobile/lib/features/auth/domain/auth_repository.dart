import 'package:appiray/core/utils/result.dart';

/// Entité domaine des tokens (indépendante des DTOs réseau).
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;
}

/// Contrat du repository d'authentification (domaine).
///
/// Le domaine ne connaît ni Dio ni les DTOs : uniquement des entités et des
/// `Result<T>`.
abstract interface class AuthRepository {
  Future<Result<AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthTokens>> register({
    required String email,
    required String username,
    required String password,
  });

  Future<Result<void>> forgotPassword(String email);

  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Result<void>> requestEmailVerification();

  Future<Result<void>> logout(String refreshToken);
}
