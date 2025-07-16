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
}
