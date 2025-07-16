import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

import 'package:nitya_dasa/emergency/emergency_page.dart';

class MockAudioPlayer extends AudioPlayer {
  bool played = false;

  @override
  Future<Duration?> setAsset(String path, {AudioLoadConfiguration? preload}) async {
    return Duration.zero;
  }

  @override
  Future<void> play() async {
    played = true;
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Emergency button starts playback', (tester) async {
    final player = MockAudioPlayer();
    await tester.pumpWidget(MaterialApp(home: EmergencyPage(player: player)));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Play Mantra'));
    await tester.pump();

    expect(player.played, isTrue);
  });
}
