import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../checkin/checkin_data.dart';
import '../checkin/checkin_service.dart';
import 'victory_quote_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _checkinService = CheckinService();
  final _quoteService = VictoryQuoteService();

  Map<DateTime, CheckinData> _data = {};
  String _quote = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _checkinService.getAllCheckins();
    final quote = await _quoteService.getQuote();
    setState(() {
      _data = data;
      _quote = quote;
    });
  }

  int get _streak {
    final dates = _data.keys.toList()..sort();
    int streak = 0;
    DateTime? last;
    for (final date in dates.reversed) {
      if (last != null && last.difference(date).inDays > 1) break;
      final info = _data[date]!;
      if (info.didFall) break;
      streak++;
      last = date;
    }
    return streak;
  }

  List<FlSpot> get _roundSpots {
    final dates = _data.keys.toList()..sort();
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.rounds.toDouble()));
    }
    return spots;
  }

  List<FlSpot> get _urgeSpots {
    final dates = _data.keys.toList()..sort();
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.urgeIntensity.toDouble()));
    }
    return spots;
  }

  Future<void> _editQuote() async {
    final controller = TextEditingController(text: _quote);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit victory quote'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Quote'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await _quoteService.setQuote(result);
      setState(() => _quote = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(_quote),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editQuote,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Current streak: $_streak days',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _roundSpots,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Total rounds over time'),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _urgeSpots,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Urge intensity over time'),
        ],
      ),
    );
  }
}
