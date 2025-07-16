import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _morningKey = 'morning_time';
  static const _eveningKey = 'evening_time';

  Future<TimeOfDay> getMorningTime() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_morningKey);
    if (raw == null) return const TimeOfDay(hour: 7, minute: 0);
    final parts = raw.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<TimeOfDay> getEveningTime() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_eveningKey);
    if (raw == null) return const TimeOfDay(hour: 19, minute: 0);
    final parts = raw.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> setMorningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_morningKey, '${time.hour}:${time.minute}');
  }

  Future<void> setEveningTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_eveningKey, '${time.hour}:${time.minute}');
  }
}
