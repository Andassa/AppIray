import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/session/session_controller.dart';
import 'package:appiray/core/storage/secure_storage_service.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/auth/data/auth_repository_impl.dart';
import 'package:appiray/features/auth/domain/auth_repository.dart';
import 'package:appiray/features/auth/presentation/controllers/auth_controller.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockAuthRepository repo;
  late MockSecureStorageService storage;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageServiceProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repo = MockAuthRepository();
    storage = MockSecureStorageService();
    when(() => storage.writeTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        )).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
  });

  test('login succès -> session authentifiée', () async {
    when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Result.success(
              AuthTokens(accessToken: 'a', refreshToken: 'r'),
            ));

    final container = makeContainer();
    final ok = await container
        .read(authControllerProvider.notifier)
        .login(email: 'x@y.z', password: 'secret123');

    expect(ok, isTrue);
    expect(container.read(sessionControllerProvider), AuthStatus.authenticated);
    expect(container.read(authControllerProvider).hasError, isFalse);
  });

  test('login échec -> état en erreur, session inchangée', () async {
    when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async =>
            const Result.failure(Failure('Identifiants invalides')));

    final container = makeContainer();
    final ok = await container
        .read(authControllerProvider.notifier)
        .login(email: 'x@y.z', password: 'bad');

    expect(ok, isFalse);
    expect(container.read(authControllerProvider).hasError, isTrue);
    expect(
      container.read(sessionControllerProvider),
      isNot(AuthStatus.authenticated),
    );
  });
}
