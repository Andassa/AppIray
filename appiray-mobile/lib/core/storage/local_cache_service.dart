import 'package:shared_preferences/shared_preferences.dart';

/// Cache local léger pour préférences non sensibles (jamais de tokens ici).
///
/// Ex : dernier user id connu, flag d'onboarding vu, dernier onglet.
class LocalCacheService {
  LocalCacheService(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboardingSeen = 'onboarding_seen';
  static const _kPlacementTestSeen = 'placement_test_seen';
  static const _kLastUserId = 'last_user_id';

  bool get onboardingSeen => _prefs.getBool(_kOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen(bool value) =>
      _prefs.setBool(_kOnboardingSeen, value);

  /// True si l'utilisateur a fait ou passé le test de positionnement.
  bool get placementTestSeen =>
      _prefs.getBool(_kPlacementTestSeen) ?? false;
  Future<void> setPlacementTestSeen(bool value) =>
      _prefs.setBool(_kPlacementTestSeen, value);

  String? get lastUserId => _prefs.getString(_kLastUserId);
  Future<void> setLastUserId(String? value) async {
    if (value == null) {
      await _prefs.remove(_kLastUserId);
    } else {
      await _prefs.setString(_kLastUserId, value);
    }
  }
}
