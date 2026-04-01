import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playDrop() async {
    // Note: ensure sounds/drop.wav exists in assets
    try {
      await _player.play(AssetSource('sounds/drop.wav'));
    } catch (e) {
      // Audio playback errors are caught to prevent app crashes
      print('Audio playback error: $e');
    }
  }

  static Future<void> playNeutralize() async {
    try {
      await _player.play(AssetSource('sounds/bubble.wav'));
    } catch (e) {
      print('Audio playback error: $e');
    }
  }

  static Future<void> playCorrect() async {
    try {
      await _player.play(AssetSource('sounds/correct.wav'));
    } catch (e) {
      print('Audio playback error: $e');
    }
  }
}
