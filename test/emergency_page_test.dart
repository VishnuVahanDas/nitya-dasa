import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

import 'package:nitya_dasa/emergency/emergency_page.dart';

class MockAudioPlayer extends AudioPlayer {
  int playCount = 0;
  int seekCount = 0;

  @override
  Future<Duration?> setAsset(String path, {AudioLoadConfiguration? preload}) async {
    return Duration.zero;
  }

  @override
  Future<void> play() async {
    playCount++;
  }

  @override
  Future<void> seek(Duration? position, {int? index}) async {
    seekCount++;
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Emergency button plays mantra each time tapped', (tester) async {
    final player = MockAudioPlayer();
    await tester.pumpWidget(MaterialApp(home: EmergencyPage(player: player)));
    await tester.pumpAndSettle();

    final button = find.widgetWithText(ElevatedButton, 'Play Mantra');

    await tester.tap(button);
    await tester.pump();

    await tester.tap(button);
    await tester.pump();

    expect(player.playCount, 2);
    expect(player.seekCount, 2);
  });
}
