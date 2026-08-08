import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/session/session_controller.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/auth/data/auth_repository_impl.dart';
import 'package:appiray/features/auth/domain/auth_repository.dart';

part 'auth_controller.g.dart';

/// Contrôleur des formulaires d'auth.
///
/// L'état [AsyncValue] reflète l'avancement d'une soumission (idle/loading/
/// error). Le changement d'état d'AUTH (authenticated/unauthenticated) est,
/// lui, porté par [SessionController] — écouté par le router pour rediriger.
@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await _repo.login(email: email, password: password);
    return _handleAuthResult(result);
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await _repo.register(
      email: email,
      username: username,
      password: password,
    );
    return _handleAuthResult(result);
  }

  Future<bool> forgotPassword(String email) async {
    state = const AsyncLoading();
    final result = await _repo.forgotPassword(email);
    return _handleVoidResult(result);
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final result =
        await _repo.resetPassword(token: token, newPassword: newPassword);
    return _handleVoidResult(result);
  }

  Future<void> logout() async {
    final refreshToken =
        await ref.read(secureStorageServiceProvider).readRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      // Best-effort : on invalide côté serveur, mais on déconnecte quoi qu'il arrive.
      await _repo.logout(refreshToken);
    }
    await ref.read(sessionControllerProvider.notifier).logout();
    state = const AsyncData(null);
  }

  Future<bool> _handleAuthResult(Result<AuthTokens> result) async {
    return switch (result) {
      Success<AuthTokens>(:final value) => await _onTokens(value),
      FailureResult<AuthTokens>(:final failure) => _fail(failure),
    };
  }

  Future<bool> _onTokens(AuthTokens tokens) async {
    await ref.read(sessionControllerProvider.notifier).onAuthenticated(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
    state = const AsyncData(null);
    return true;
  }

  bool _handleVoidResult(Result<void> result) {
    return switch (result) {
      Success<void>() => _ok(),
      FailureResult<void>(:final failure) => _fail(failure),
    };
  }

  bool _ok() {
    state = const AsyncData(null);
    return true;
  }

  bool _fail(Failure failure) {
    state = AsyncError(failure, StackTrace.current);
    return false;
  }
}
