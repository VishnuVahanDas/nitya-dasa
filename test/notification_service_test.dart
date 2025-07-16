import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nitya_dasa/notifications/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final List<MethodCall> calls = <MethodCall>[];

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() {
    calls.clear();
    channel.setMockMethodCallHandler(null);
  });

  test('scheduleDailyReminders schedules two notifications', () async {
    await NotificationService.instance.init();
    await NotificationService.instance.scheduleDailyReminders(
      morning: const TimeOfDay(hour: 8, minute: 0),
      evening: const TimeOfDay(hour: 20, minute: 0),
    );

    final scheduled = calls.where((call) => call.method == 'zonedSchedule');
    expect(scheduled.length, 2);
  });
}
