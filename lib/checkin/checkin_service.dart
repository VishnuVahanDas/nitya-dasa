import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'checkin_data.dart';

class CheckinService {
  static const _prefix = 'checkin_';

  Future<void> saveCheckin(DateTime date, CheckinData data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(date);
    await prefs.setString(key, jsonEncode(data.toJson()));
  }

  Future<CheckinData?> getCheckin(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(date);
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return CheckinData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<Map<DateTime, CheckinData>> getAllCheckins() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <DateTime, CheckinData>{};
    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_prefix)) continue;
      final raw = prefs.getString(key);
      if (raw == null) continue;
      final dateString = key.substring(_prefix.length);
      try {
        final date = DateTime.parse(dateString);
        result[DateTime(date.year, date.month, date.day)] =
            CheckinData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        continue;
      }
    }
    return result;
  }

  String _keyForDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${_prefix}${d.toIso8601String()}';
  }
}
