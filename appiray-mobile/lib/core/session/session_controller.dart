import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/providers/core_providers.dart';

part 'session_controller.g.dart';

/// État d'authentification global de l'app.
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Source de vérité unique de l'état d'auth.
///
/// - Le router `go_router` écoute ce provider pour rediriger automatiquement.
/// - L'intercepteur Dio appelle [markExpired] quand le refresh token échoue.
/// - Le contrôleur d'auth (feature) appelle [onAuthenticated] / [logout].
///
/// Volontairement indépendant de Dio et des repositories pour éviter tout cycle
/// de dépendances.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  AuthStatus build() => AuthStatus.unknown;

  /// Détermine l'état initial au démarrage à partir des tokens stockés.
  Future<void> bootstrap() async {
    final token = await ref.read(secureStorageServiceProvider).readAccessToken();
    state = (token != null && token.isNotEmpty)
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  /// Marque la session authentifiée et persiste les tokens.
  Future<void> onAuthenticated({
    required String accessToken,
    required String refreshToken,
  }) async {
    await ref.read(secureStorageServiceProvider).writeTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
    state = AuthStatus.authenticated;
  }

  /// Déconnexion propre : purge les tokens et repasse en non-authentifié.
  Future<void> logout() async {
    await ref.read(secureStorageServiceProvider).clear();
    state = AuthStatus.unauthenticated;
  }

  /// Appelé par l'intercepteur Dio quand le refresh échoue → déconnexion.
  Future<void> markExpired() => logout();
}
