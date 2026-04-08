import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioSource? _oscillator;
  SoundHandle? _handle;

  Future<void> startTone(double frequency) async {
    await updateTone(true, frequency);
  }

  Future<void> stopTone() async {
    await stop();
  }

  Future<void> updateFrequency(double frequency) async {
    await updateTone(true, frequency);
  }

  Future<void> updateTone(bool isEnabled, double frequency) async {
    if (!isEnabled) {
      await stop();
      return;
    }

    try {
      _oscillator ??= await SoLoud.instance.loadWaveform(
        WaveForm.sin,
        true,
        0.25,
        1.0,
      );

      _handle ??= SoLoud.instance.play(_oscillator!);

      // Update frequency
      // Map simulation frequency (0.1 - 20Hz) to audible range (e.g. 220 - 880Hz)
      // because 1-20Hz is infrasonic and won't be heard on mobile speakers.
      final audibleFreq = 220.0 + (frequency * 20.0);

      SoLoud.instance.setRelativePlaySpeed(_handle!, audibleFreq / 440.0);
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  Future<void> stop() async {
    if (_handle != null) {
      await SoLoud.instance.stop(_handle!);
      _handle = null;
    }
  }
}

final audioService = AudioService();
