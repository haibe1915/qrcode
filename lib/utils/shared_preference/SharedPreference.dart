import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SharedPreference {
  static const String _vibrationPrefKey = 'vibrationPreference';

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
}
