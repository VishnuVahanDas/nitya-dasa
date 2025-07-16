import 'package:flutter/material.dart';
class CheckinData {
  final TimeOfDay wakeUpTime;
  final int rounds;
  final bool exercised;
  final bool read;
  final int urgeIntensity;
  final bool didFall;

  CheckinData({
    required this.wakeUpTime,
    required this.rounds,
    required this.exercised,
    required this.read,
    required this.urgeIntensity,
    required this.didFall,
  });

  Map<String, dynamic> toJson() => {
        'wakeUpHour': wakeUpTime.hour,
        'wakeUpMinute': wakeUpTime.minute,
        'rounds': rounds,
        'exercised': exercised,
        'read': read,
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
      exercised: json['exercised'] as bool,
      read: json['read'] as bool,
      urgeIntensity: json['urgeIntensity'] as int,
      didFall: json['didFall'] as bool,
    );
  }
}
