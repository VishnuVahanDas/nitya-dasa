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

  late DateTime _selectedDate;
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 5, minute: 0);
  final _roundsController = TextEditingController();
  final _exerciseController = TextEditingController();
  final _readingController = TextEditingController();
  final _hearingController = TextEditingController();
  double _urgeIntensity = 1;
  bool _didFall = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadForSelectedDate();
  }

  Future<void> _loadForSelectedDate() async {
    final data = await _service.getCheckin(_selectedDate);
    if (!mounted) return;
    if (data != null) {
      setState(() {
        _wakeUpTime = data.wakeUpTime;
        _roundsController.text = data.rounds.toString();
        _exerciseController.text = data.exerciseMinutes.toString();
        _readingController.text = data.readingMinutes.toString();
        _hearingController.text = data.hearingMinutes.toString();
        _urgeIntensity = data.urgeIntensity.toDouble();
        _didFall = data.didFall;
      });
    } else {
      setState(() {
        _wakeUpTime = const TimeOfDay(hour: 5, minute: 0);
        _roundsController.clear();
        _exerciseController.clear();
        _readingController.clear();
        _hearingController.clear();
        _urgeIntensity = 1;
        _didFall = false;
      });
    }
  }

  Future<void> _save() async {
    final data = CheckinData(
      wakeUpTime: _wakeUpTime,
      rounds: int.tryParse(_roundsController.text) ?? 0,
      exerciseMinutes: int.tryParse(_exerciseController.text) ?? 0,
      readingMinutes: int.tryParse(_readingController.text) ?? 0,
      hearingMinutes: int.tryParse(_hearingController.text) ?? 0,
      urgeIntensity: _urgeIntensity.toInt(),
      didFall: _didFall,
    );
    await _service.saveCheckin(_selectedDate, data);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in saved')),
      );
    }
  }

  @override
  void dispose() {
    _roundsController.dispose();
    _exerciseController.dispose();
    _readingController.dispose();
    _hearingController.dispose();
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
            title: const Text('Date'),
            subtitle: Text(
              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
            ),
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: now.subtract(const Duration(days: 6)),
                lastDate: now,
              );
              if (picked != null && picked != _selectedDate) {
                setState(() => _selectedDate = picked);
                await _loadForSelectedDate();
              }
            },
          ),
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
          TextField(
            controller: _exerciseController,
            decoration:
                const InputDecoration(labelText: 'Exercise minutes'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _readingController,
            decoration:
                const InputDecoration(labelText: 'Reading minutes'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _hearingController,
            decoration:
                const InputDecoration(labelText: 'Hearing minutes'),
            keyboardType: TextInputType.number,
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
