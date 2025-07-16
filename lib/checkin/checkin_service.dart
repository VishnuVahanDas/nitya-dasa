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

  String _keyForDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${_prefix}${d.toIso8601String()}';
  }
}
