import 'package:flutter/material.dart';

import 'journal_entry.dart';
import 'journal_service.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _service = JournalService();

  final _helpedController = TextEditingController();
  final _triggerController = TextEditingController();

  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await _service.getEntries();
    setState(() => _entries = entries.reversed.toList());
  }

  Future<void> _save() async {
    final helped = _helpedController.text.trim();
    final triggered = _triggerController.text.trim();
    if (helped.isEmpty && triggered.isEmpty) return;
    final entry = JournalEntry(
      timestamp: DateTime.now(),
      helped: helped,
      triggered: triggered,
    );
    await _service.addEntry(entry);
    _helpedController.clear();
    _triggerController.clear();
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal entry saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _helpedController,
            decoration: const InputDecoration(
              labelText: 'What helped you stay strong?',
            ),
            minLines: 2,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _triggerController,
            decoration: const InputDecoration(
              labelText: 'What triggered weakness?',
            ),
            minLines: 2,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
          const SizedBox(height: 24),
          ..._entries.map((e) => Card(
                child: ListTile(
                  title: Text(
                    '${e.timestamp.year}-${e.timestamp.month.toString().padLeft(2, '0')}-${e.timestamp.day.toString().padLeft(2, '0')}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (e.helped.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('Helped: ${e.helped}'),
                        ),
                      if (e.triggered.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('Triggered: ${e.triggered}'),
                        ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
