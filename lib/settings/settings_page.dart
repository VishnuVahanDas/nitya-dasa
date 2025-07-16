import 'package:flutter/material.dart';

import '../notifications/notification_service.dart';
import 'settings_service.dart';
import '../emergency/emergency_media_service.dart';
import '../dashboard/victory_quote_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _service = SettingsService();
  final _mediaService = EmergencyMediaService();
  final _quoteService = VictoryQuoteService();
  TimeOfDay _morning = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _evening = const TimeOfDay(hour: 19, minute: 0);
  final _imageController = TextEditingController();
  final _audioController = TextEditingController();
  final _quoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final morning = await _service.getMorningTime();
    final evening = await _service.getEveningTime();
    final image = await _mediaService.getImagePath();
    final audio = await _mediaService.getAudioPath();
    final quote = await _quoteService.getQuote();
    if (!mounted) return;
    setState(() {
      _morning = morning;
      _evening = evening;
      _imageController.text = image;
      _audioController.text = audio;
      _quoteController.text = quote;
    });
  }

  Future<void> _save() async {
    await _service.setMorningTime(_morning);
    await _service.setEveningTime(_evening);
    await _mediaService.setImagePath(_imageController.text);
    await _mediaService.setAudioPath(_audioController.text);
    await _quoteService.setQuote(_quoteController.text);
    await NotificationService.instance.scheduleDailyReminders(
      morning: _morning,
      evening: _evening,
    );
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Settings saved')));
    }
  }

  Future<void> _reset() async {
    await _mediaService.reset();
    await _quoteService.resetQuote();
    final image = await _mediaService.getImagePath();
    final audio = await _mediaService.getAudioPath();
    final quote = await _quoteService.getQuote();
    if (!mounted) return;
    setState(() {
      _imageController.text = image;
      _audioController.text = audio;
      _quoteController.text = quote;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Defaults restored')));
  }

  @override
  void dispose() {
    _imageController.dispose();
    _audioController.dispose();
    _quoteController.dispose();
    super.dispose();
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
          TextField(
            controller: _imageController,
            decoration:
                const InputDecoration(labelText: 'Emergency image path'),
          ),
          TextField(
            controller: _audioController,
            decoration:
                const InputDecoration(labelText: 'Emergency mantra path'),
          ),
          TextField(
            controller: _quoteController,
            decoration: const InputDecoration(labelText: 'Victory quote'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _reset,
            child: const Text('Reset Defaults'),
          ),
        ],
      ),
    );
  }
}
