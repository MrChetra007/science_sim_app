import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playDrop() async {
    try {
      await _player.play(AssetSource('audios/drop.wav'));
    } catch (e) {
      print('Audio playback error: $e');
    }
  }

  static Future<void> playBubble() async {
    try {
      await _player.play(AssetSource('audios/bubble.wav'));
    } catch (e) {
      print('Audio playback error: $e');
    }
  }

  static Future<void> playCorrect() async {
    try {
      await _player.play(AssetSource('audios/correct.wav'));
    } catch (e) {
      print('Audio playback error: $e');
    }
  }
}
