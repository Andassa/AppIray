import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/auth/data/auth_remote_datasource.dart';
import 'package:appiray/features/auth/data/models/auth_models.dart';
import 'package:appiray/features/auth/domain/auth_repository.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) =>
    AuthRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);
  final AuthRemoteDataSource _remote;

  AuthTokens _toEntity(AuthTokensDto dto) =>
      AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken);

  @override
  Future<Result<AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _remote.login(
        LoginRequest(email: email, password: password),
      );
      return Result.success(_toEntity(dto));
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }

  @override
  Future<Result<AuthTokens>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final dto = await _remote.register(
        RegisterRequest(email: email, username: username, password: password),
      );
      return Result.success(_toEntity(dto));
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword(ForgotPasswordRequest(email: email));
      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remote.resetPassword(
        ResetPasswordRequest(token: token, newPassword: newPassword),
      );
      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }

  @override
  Future<Result<void>> requestEmailVerification() async {
    try {
      await _remote.requestEmailVerification();
      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }

  @override
  Future<Result<void>> logout(String refreshToken) async {
    try {
      await _remote.logout(refreshToken);
      return const Result.success(null);
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }
}
