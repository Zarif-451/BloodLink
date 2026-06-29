import 'package:shared_preferences/shared_preferences.dart';

/// Local flags — onboarding, future theme persistence.
class AppPreferences {
  AppPreferences(this._prefs);

  static const _onboardingCompleteKey = 'onboarding_complete';

  final SharedPreferences _prefs;

  static Future<AppPreferences> create() async {
    return AppPreferences(await SharedPreferences.getInstance());
  }

  bool get isOnboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_onboardingCompleteKey, value);
  }
}
