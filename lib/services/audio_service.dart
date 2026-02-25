import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:async';

class AudioService {
  AudioSource? _waveSource;
  SoundHandle? _handle;
  bool _isPlaying = false;

  Future<void> init() async {
    if (!SoLoud.instance.isInitialized) {
      await SoLoud.instance.init();
    }
  }

  Future<void> startTone(double frequency) async {
    if (_isPlaying) return;

    try {
      _waveSource = await SoLoud.instance.loadWaveform(
        WaveForm.sin,
        false,
        1.0,
        0.0,
      );

      if (_waveSource != null) {
        _handle = await SoLoud.instance.play(_waveSource!);
        // Set a base audible frequency (e.g. 440Hz base if frequency factor is 1.0)
        // But the simulation frequency is 1-20 Hz.
        // We'll scale it so it's pleasant and audible.
        updateFrequency(frequency);
        _isPlaying = true;
      }
    } catch (e) {
      print('Error starting tone: $e');
    }
  }

  void stopTone() {
    if (_handle != null) {
      SoLoud.instance.stop(_handle!);
      _handle = null;
    }
    if (_waveSource != null) {
      SoLoud.instance.disposeSource(_waveSource!);
      _waveSource = null;
    }
    _isPlaying = false;
  }

  void updateFrequency(double frequency) {
    if (_handle == null) return;

    // Scaling simulation frequency (0.1 - 20) to audible range.
    // Let's use 100Hz + (freq * 50) => 100Hz to 1100Hz.
    // However, setRelativePlaySpeed might be better if the base is fixed.
    // Or we just use setSamplerate if available.

    // For simplicity, we'll just set the volume or pitch.
    // SoLoud waveform default is roughly 440Hz? No, it's usually 1Hz if generated.
    // We'll use setRelativePlaySpeed to scale it.

    double pitch = (frequency * 10).clamp(0.1, 100.0);
    SoLoud.instance.setRelativePlaySpeed(_handle!, pitch);
  }
}

final audioService = AudioService();
