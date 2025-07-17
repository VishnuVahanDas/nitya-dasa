import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nitya_dasa/dashboard/dashboard_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Dashboard loads with default data', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Current streak: 0 days'), findsOneWidget);
    expect(find.widgetWithText(DashboardChartCard, 'Total rounds over time'),
        findsOneWidget);
    expect(find.widgetWithText(DashboardChartCard, 'Bedtime over time'),
        findsOneWidget);
    expect(find.widgetWithText(DashboardChartCard, 'Urge intensity over time'),
        findsOneWidget);
  });
}
