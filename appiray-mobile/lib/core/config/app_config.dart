/// Configuration d'environnement minimale (MVP).
///
/// Pas de package externe : un simple objet statique suffit. L'URL de base peut
/// être surchargée à la compilation via `--dart-define=API_BASE_URL=...`,
/// sinon on retombe sur le backend local par défaut.
///
/// Exemple :
///   flutter run --dart-define=API_BASE_URL=https://api.appiray.mg/api/v1
class AppConfig {
  const AppConfig._();

  /// URL de base de l'API backend (inclut le préfixe /api/v1).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );

  /// Active les logs réseau détaillés (uniquement utile en dev).
  static const bool enableNetworkLogging = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGGING',
    defaultValue: true,
  );

  /// Timeouts réseau (ms).
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 20000;
}
