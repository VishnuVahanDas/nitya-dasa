import 'package:flutter/material.dart';
class CheckinData {
  final TimeOfDay wakeUpTime;
  final int rounds;
  final int exerciseMinutes;
  final int readingMinutes;
  final int hearingMinutes;
  final TimeOfDay bedTime;
  final int urgeIntensity;
  final bool didFall;

  CheckinData({
    required this.wakeUpTime,
    required this.rounds,
    required this.exerciseMinutes,
    required this.readingMinutes,
    required this.hearingMinutes,
    required this.bedTime,
    required this.urgeIntensity,
    required this.didFall,
  });

  Map<String, dynamic> toJson() => {
        'wakeUpHour': wakeUpTime.hour,
        'wakeUpMinute': wakeUpTime.minute,
        'rounds': rounds,
        'exerciseMinutes': exerciseMinutes,
        'readingMinutes': readingMinutes,
        'hearingMinutes': hearingMinutes,
        'bedHour': bedTime.hour,
        'bedMinute': bedTime.minute,
        'urgeIntensity': urgeIntensity,
        'didFall': didFall,
      };

  factory CheckinData.fromJson(Map<String, dynamic> json) {
    return CheckinData(
      wakeUpTime: TimeOfDay(
        hour: json['wakeUpHour'] as int,
        minute: json['wakeUpMinute'] as int,
      ),
      rounds: json['rounds'] as int,
      exerciseMinutes: (json['exerciseMinutes'] ?? 0) as int,
      readingMinutes: (json['readingMinutes'] ?? 0) as int,
      hearingMinutes: (json['hearingMinutes'] ?? 0) as int,
      bedTime: TimeOfDay(
        hour: json['bedHour'] as int? ?? 22,
        minute: json['bedMinute'] as int? ?? 0,
      ),
      urgeIntensity: json['urgeIntensity'] as int,
      didFall: json['didFall'] as bool,
    );
  }
}
