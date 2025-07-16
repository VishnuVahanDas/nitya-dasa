import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'journal_entry.dart';

class JournalService {
  static const _key = 'journal_entries';

  Future<List<JournalEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .cast<Map<String, dynamic>>()
        .map(JournalEntry.fromJson)
        .toList();
  }

  Future<void> addEntry(JournalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getEntries();
    entries.add(entry);
    final raw = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
