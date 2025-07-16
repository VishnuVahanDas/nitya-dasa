import 'package:flutter/material.dart';

class JournalEntry {
  final DateTime timestamp;
  final String helped;
  final String triggered;

  JournalEntry({
    required this.timestamp,
    required this.helped,
    required this.triggered,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'helped': helped,
        'triggered': triggered,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      helped: json['helped'] as String,
      triggered: json['triggered'] as String,
    );
  }
}
