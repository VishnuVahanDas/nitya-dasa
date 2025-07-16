import 'package:flutter/material.dart';

import 'checkin_data.dart';
import 'checkin_service.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final _service = CheckinService();

  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 5, minute: 0);
  final _roundsController = TextEditingController();
  bool _exercised = false;
  bool _read = false;
  double _urgeIntensity = 1;
  bool _didFall = false;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    final data = await _service.getCheckin(DateTime.now());
    if (!mounted) return;
    if (data != null) {
      setState(() {
        _wakeUpTime = data.wakeUpTime;
        _roundsController.text = data.rounds.toString();
        _exercised = data.exercised;
        _read = data.read;
        _urgeIntensity = data.urgeIntensity.toDouble();
        _didFall = data.didFall;
      });
    }
  }

  Future<void> _save() async {
    final data = CheckinData(
      wakeUpTime: _wakeUpTime,
      rounds: int.tryParse(_roundsController.text) ?? 0,
      exercised: _exercised,
      read: _read,
      urgeIntensity: _urgeIntensity.toInt(),
      didFall: _didFall,
    );
    await _service.saveCheckin(DateTime.now(), data);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in saved')),);
    }
  }

  @override
  void dispose() {
    _roundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Wake-up time'),
            subtitle: Text(_wakeUpTime.format(context)),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _wakeUpTime,
              );
              if (time != null) {
                setState(() => _wakeUpTime = time);
              }
            },
          ),
          TextField(
            controller: _roundsController,
            decoration: const InputDecoration(labelText: 'Rounds'),
            keyboardType: TextInputType.number,
          ),
          SwitchListTile(
            title: const Text('Exercised'),
            value: _exercised,
            onChanged: (v) => setState(() => _exercised = v),
          ),
          SwitchListTile(
            title: const Text('Read scripture'),
            value: _read,
            onChanged: (v) => setState(() => _read = v),
          ),
          ListTile(
            title: const Text('Urge intensity'),
            subtitle: Slider(
              value: _urgeIntensity,
              min: 1,
              max: 10,
              divisions: 9,
              label: _urgeIntensity.round().toString(),
              onChanged: (v) => setState(() => _urgeIntensity = v),
            ),
          ),
          SwitchListTile(
            title: const Text('Fell from practice'),
            value: _didFall,
            onChanged: (v) => setState(() => _didFall = v),
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
