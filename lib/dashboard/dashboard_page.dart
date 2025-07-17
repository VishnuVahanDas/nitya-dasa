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

  List<DateTime> get _sortedDates => _data.keys.toList()..sort();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _checkinService.getAllCheckins();
    final quote = await _quoteService.getQuote();
    if (!mounted) return;
    setState(() {
      _data = data;
      _quote = quote;
    });
  }

  int get _streak {
    final dates = _sortedDates;
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
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.rounds.toDouble()));
    }
    return spots;
  }

  List<FlSpot> get _wakeUpSpots {
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      final time = info.wakeUpTime;
      final value = time.hour + time.minute / 60.0;
      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

  List<FlSpot> get _urgeSpots {
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.urgeIntensity.toDouble()));
    }
    return spots;
  }

  List<FlSpot> get _exerciseSpots {
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.exerciseMinutes.toDouble()));
    }
    return spots;
  }

  List<FlSpot> get _readingSpots {
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.readingMinutes.toDouble()));
    }
    return spots;
  }

  List<FlSpot> get _hearingSpots {
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      spots.add(FlSpot(i.toDouble(), info.hearingMinutes.toDouble()));
    }
    return spots;
  }

  List<FlSpot> get _bedTimeSpots {
    final dates = _sortedDates;
    final List<FlSpot> spots = [];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      final info = _data[d]!;
      final time = info.bedTime;
      spots.add(FlSpot(i.toDouble(), time.hour + time.minute / 60.0));
    }
    return spots;
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= _sortedDates.length) {
      return const SizedBox.shrink();
    }
    final date = _sortedDates[index];
    final text = '${date.month}/${date.day}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

  FlTitlesData _chartTitles({String? yUnit}) {
    final leftTitles = yUnit == null
        ? const SideTitles(showTitles: false)
        : SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => Text(
              '${value.toInt()}${yUnit ?? ''}',
              style: const TextStyle(fontSize: 10),
            ),
          );
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: _bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(sideTitles: leftTitles),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
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
          DashboardChartCard(
            title: 'Wake-up time over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _wakeUpSpots,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: 'h'),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartCard(
            title: 'Total rounds over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _roundSpots,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: ''),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartCard(
            title: 'Exercise minutes over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _exerciseSpots,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: 'm'),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartCard(
            title: 'Reading minutes over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _readingSpots,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: 'm'),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartCard(
            title: 'Hearing minutes over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _hearingSpots,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: 'm'),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartCard(
            title: 'Bedtime over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _bedTimeSpots,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: 'h'),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartCard(
            title: 'Urge intensity over time',
            chart: AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _urgeSpots,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                  titlesData: _chartTitles(yUnit: ''),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardChartCard extends StatelessWidget {
  final String title;
  final Widget chart;

  const DashboardChartCard({super.key, required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            chart,
          ],
        ),
      ),
    );
  }
}
