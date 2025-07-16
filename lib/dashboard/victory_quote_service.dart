import 'package:shared_preferences/shared_preferences.dart';

class VictoryQuoteService {
  static const _key = 'victory_quote';
  static const _defaultQuotes = [
    'Victory belongs to the most persevering.',
    'Every day is a chance to rise higher.',
    'Steady practice leads to certain success.',
  ];

  Future<String> getQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final custom = prefs.getString(_key);
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    final index = DateTime.now().day % _defaultQuotes.length;
    return _defaultQuotes[index];
  }

  Future<void> setQuote(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, quote);
  }

  Future<void> resetQuote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
