import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nitya_dasa/checkin/checkin_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Check-in page saves data', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CheckinPage()));

    expect(find.text('Daily Check-in'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Check-in saved'), findsOneWidget);
  });

  testWidgets('User can select past date and save check-in', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CheckinPage()));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    final past = now.subtract(const Duration(days: 2));

    await tester.tap(find.text('Date'));
    await tester.pumpAndSettle();

    if (past.month != now.month) {
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('${past.day}'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final key =
        'checkin_${DateTime(past.year, past.month, past.day).toIso8601String()}';
    expect(prefs.getString(key), isNotNull);
    expect(find.text('Check-in saved'), findsOneWidget);
  });
}
