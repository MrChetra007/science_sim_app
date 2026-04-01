import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AudioService {
  static bool _initialized = false;
  static bool _enabled = true;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      FlameAudio.audioCache.prefix = 'assets/audios/';
      // Use a strict timeout to prevent app hangs if the audio bridge fails
      await FlameAudio.audioCache.loadAll(['launch.wav', 'impact.wav']).timeout(
          const Duration(seconds: 2));
      _initialized = true;
    } on MissingPluginException {
      _enabled = false;
      debugPrint('AudioService: MissingPluginException - disabling audio');
    } catch (e) {
      _enabled = false;
      debugPrint('AudioService: Initialization failed (timeout or error): $e');
    }
  }

  static void playLaunch() {
    if (!_enabled) return;
    try {
      // No 'assets/audio/' prefix needed here, just the filename
      FlameAudio.play('launch.wav', volume: 0.6)
          .timeout(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('AudioService: playLaunch error (timeout or failure): $e');
    }
  }

  static void playImpact() {
    if (!_enabled) return;
    try {
      FlameAudio.play('impact.wav', volume: 0.7)
          .timeout(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('AudioService: playImpact error (timeout or failure): $e');
    }
  }
}
