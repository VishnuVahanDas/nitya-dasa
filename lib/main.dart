import 'package:flutter/material.dart';
import 'checkin/checkin_page.dart';
import 'dashboard/dashboard_page.dart';
import 'journal/journal_page.dart';
import 'settings/settings_page.dart';
import 'settings/settings_service.dart';
import 'notifications/notification_service.dart';
import 'emergency/emergency_page.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsService();
  final morning = await settings.getMorningTime();
  final evening = await settings.getEveningTime();
  await NotificationService.instance.init();
  await NotificationService.instance.scheduleDailyReminders(
    morning: morning,
    evening: evening,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _pages = [
    const CheckinPage(),
    const DashboardPage(),
    const JournalPage(),
    EmergencyPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Check-in'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Emergency'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
