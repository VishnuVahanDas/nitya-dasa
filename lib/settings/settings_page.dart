import 'package:flutter/material.dart';

import '../notifications/notification_service.dart';
import 'settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _service = SettingsService();
  TimeOfDay _morning = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _evening = const TimeOfDay(hour: 19, minute: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final morning = await _service.getMorningTime();
    final evening = await _service.getEveningTime();
    setState(() {
      _morning = morning;
      _evening = evening;
    });
  }

  Future<void> _save() async {
    await _service.setMorningTime(_morning);
    await _service.setEveningTime(_evening);
    await NotificationService.instance.scheduleDailyReminders(
      morning: _morning,
      evening: _evening,
    );
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Settings saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Morning reminder time'),
            subtitle: Text(_morning.format(context)),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _morning,
              );
              if (time != null) {
                setState(() => _morning = time);
              }
            },
          ),
          ListTile(
            title: const Text('Evening reminder time'),
            subtitle: Text(_evening.format(context)),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _evening,
              );
              if (time != null) {
                setState(() => _evening = time);
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
