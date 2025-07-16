import 'package:shared_preferences/shared_preferences.dart';

class EmergencyMediaService {
  static const _imageKey = 'emergency_image';
  static const _audioKey = 'emergency_audio';

  static const defaultImage = 'assets/images/emergency.jpg';
  static const defaultAudio = 'assets/audio/mantra.mp3';

  Future<String> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageKey) ?? defaultImage;
  }

  Future<String> getAudioPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_audioKey) ?? defaultAudio;
  }

  Future<void> setImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, path);
  }

  Future<void> setAudioPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_audioKey, path);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_imageKey);
    await prefs.remove(_audioKey);
  }
}
