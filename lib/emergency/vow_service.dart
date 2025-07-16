import 'package:shared_preferences/shared_preferences.dart';

class VowService {
  static const _key = 'user_vow';
  static const _defaultVow =
      'I vow to chant 16 rounds of the Hare Krishna mantra daily.';

  Future<String> getVow() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? _defaultVow;
  }

  Future<void> setVow(String vow) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, vow);
  }
}
