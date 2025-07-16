import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nitya_dasa/main.dart';

void main() {
  testWidgets('Home page shows navigation items', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.show_chart), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
    expect(find.byIcon(Icons.warning), findsOneWidget);
  });
}
