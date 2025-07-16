import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nitya_dasa/journal/journal_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Journal page saves entry', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: JournalPage()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byWidgetPredicate((w) =>
            w is TextField &&
            w.decoration?.labelText == 'What helped you stay strong?'),
        'Chanting');
    await tester.enterText(
        find.byWidgetPredicate((w) =>
            w is TextField &&
            w.decoration?.labelText == 'What triggered weakness?'),
        'TV');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Journal entry saved'), findsOneWidget);
  });
}
