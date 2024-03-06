import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SharedPreference {
  static const String _vibrationPrefKey = 'vibrationPreference';
  static const String _languagePrefKey = 'languagePreference';
  static const String _premiumPrefKey = 'premiumPreference';

  static Future<bool> getVibrationPreference() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != null && hasVibrator) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_vibrationPrefKey) ?? true;
    }
    return false;
  }

  static Future<void> setVibrationPreference(bool value) async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != null && hasVibrator) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_vibrationPrefKey, value);
    }
  }

  static Future<String> getLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languagePrefKey) ?? "";
  }

  static Future<void> setLanguagePreference(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePrefKey, value);
  }

  static Future<bool> getPremiumPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumPrefKey) ?? false;
  }

  static Future<void> setPremiumPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumPrefKey, value);
  }
}
