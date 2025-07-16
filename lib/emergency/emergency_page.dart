import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'emergency_media_service.dart';
import 'vow_service.dart';

class EmergencyPage extends StatefulWidget {
  EmergencyPage({super.key, AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final _vowService = VowService();
  final _mediaService = EmergencyMediaService();
  String _vow = '';
  String _imagePath = EmergencyMediaService.defaultImage;
  String _audioPath = EmergencyMediaService.defaultAudio;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vow = await _vowService.getVow();
    final image = await _mediaService.getImagePath();
    final audio = await _mediaService.getAudioPath();
    if (!mounted) return;
    setState(() {
      _vow = vow;
      _imagePath = image;
      _audioPath = audio;
    });
    await widget._player.setAsset(audio);
  }

  @override
  void dispose() {
    widget._player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset(_imagePath, height: 200),
          const SizedBox(height: 16),
          Text(_vow, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await widget._player.seek(Duration.zero);
              await widget._player.play();
            },
            child: const Text('Play Mantra'),
          ),
        ],
      ),
    );
  }
}
