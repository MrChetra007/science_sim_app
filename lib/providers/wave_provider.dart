import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

enum WaveType { transverse, longitudinal }

enum WaveMode { simulation, standing, interference, doppler }

class WaveState {
  final double amplitude;
  final double frequency;
  final double waveSpeed;
  final double phaseDifference;
  final bool isDampingEnabled;
  final WaveType waveType;
  final double currentTime;
  final bool isPaused;

  // Phase 3 additions
  final WaveMode mode;
  final int harmonic; // for standing waves
  final double secondaryAmplitude; // for interference
  final double secondaryFrequency; // for interference
  final double sourceVelocity; // for doppler

  // Phase 4/6 Education features
  final WaveState? ghostState;
  final bool showGhost;
  final bool showVectors;
  final bool showOscilloscope;
  final double timeScale;
  final bool isAudioEnabled;

  WaveState({
    this.amplitude = 1.0,
    this.frequency = 1.0,
    this.waveSpeed = 343.0,
    this.phaseDifference = 0.0,
    this.isDampingEnabled = false,
    this.waveType = WaveType.transverse,
    this.currentTime = 0.0,
    this.isPaused = false,
    this.mode = WaveMode.simulation,
    this.harmonic = 1,
    this.secondaryAmplitude = 1.0,
    this.secondaryFrequency = 1.0,
    this.sourceVelocity = 0.0,
    this.ghostState,
    this.showGhost = false,
    this.showVectors = false,
    this.showOscilloscope = false,
    this.timeScale = 1.0,
    this.isAudioEnabled = false,
  });

  WaveState copyWith({
    double? amplitude,
    double? frequency,
    double? waveSpeed,
    double? phaseDifference,
    bool? isDampingEnabled,
    WaveType? waveType,
    double? currentTime,
    bool? isPaused,
    WaveMode? mode,
    int? harmonic,
    double? secondaryAmplitude,
    double? secondaryFrequency,
    double? sourceVelocity,
    WaveState? ghostState,
    bool? showGhost,
    bool? showVectors,
    bool? showOscilloscope,
    double? timeScale,
    bool? isAudioEnabled,
  }) {
    return WaveState(
      amplitude: amplitude ?? this.amplitude,
      frequency: frequency ?? this.frequency,
      waveSpeed: waveSpeed ?? this.waveSpeed,
      phaseDifference: phaseDifference ?? this.phaseDifference,
      isDampingEnabled: isDampingEnabled ?? this.isDampingEnabled,
      waveType: waveType ?? this.waveType,
      currentTime: currentTime ?? this.currentTime,
      isPaused: isPaused ?? this.isPaused,
      mode: mode ?? this.mode,
      harmonic: harmonic ?? this.harmonic,
      secondaryAmplitude: secondaryAmplitude ?? this.secondaryAmplitude,
      secondaryFrequency: secondaryFrequency ?? this.secondaryFrequency,
      sourceVelocity: sourceVelocity ?? this.sourceVelocity,
      ghostState: ghostState ?? this.ghostState,
      showGhost: showGhost ?? this.showGhost,
      showVectors: showVectors ?? this.showVectors,
      showOscilloscope: showOscilloscope ?? this.showOscilloscope,
      timeScale: timeScale ?? this.timeScale,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
    );
  }

  // Helper to null out ghostState
  WaveState clearGhost() {
    return WaveState(
      amplitude: amplitude,
      frequency: frequency,
      waveSpeed: waveSpeed,
      phaseDifference: phaseDifference,
      isDampingEnabled: isDampingEnabled,
      waveType: waveType,
      currentTime: currentTime,
      isPaused: isPaused,
      mode: mode,
      harmonic: harmonic,
      secondaryAmplitude: secondaryAmplitude,
      secondaryFrequency: secondaryFrequency,
      sourceVelocity: sourceVelocity,
      ghostState: null,
      showGhost: false,
      showVectors: showVectors,
      showOscilloscope: showOscilloscope,
      timeScale: timeScale,
      isAudioEnabled: isAudioEnabled,
    );
  }
}

class WaveNotifier extends StateNotifier<WaveState> {
  Timer? _timer;

  WaveNotifier() : super(WaveState()) {
    _startAnimation();
  }

  void _startAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!state.isPaused) {
        state = state.copyWith(
          currentTime: state.currentTime + (0.016 * state.timeScale),
        );
      }
    });
  }

  void setAmplitude(double value) => state = state.copyWith(amplitude: value);
  void setFrequency(double value) => state = state.copyWith(frequency: value);
  void setWaveSpeed(double value) => state = state.copyWith(waveSpeed: value);
  void setPhaseDifference(double value) =>
      state = state.copyWith(phaseDifference: value);
  void toggleDamping(bool value) =>
      state = state.copyWith(isDampingEnabled: value);
  void setWaveType(WaveType type) => state = state.copyWith(waveType: type);
  void togglePause() => state = state.copyWith(isPaused: !state.isPaused);
  void resetTime() => state = state.copyWith(currentTime: 0.0);

  // Phase 3 actions
  void setMode(WaveMode mode) => state = state.copyWith(mode: mode);
  void setHarmonic(int value) => state = state.copyWith(harmonic: value);
  void setSecondaryAmplitude(double value) =>
      state = state.copyWith(secondaryAmplitude: value);
  void setSecondaryFrequency(double value) =>
      state = state.copyWith(secondaryFrequency: value);
  void setSourceVelocity(double value) =>
      state = state.copyWith(sourceVelocity: value);

  // Phase 4/6 actions
  void captureGhost() =>
      state = state.copyWith(ghostState: state, showGhost: true);
  void resetGhost() => state = state.clearGhost();
  void toggleVectors() =>
      state = state.copyWith(showVectors: !state.showVectors);
  void toggleShowGhost() => state = state.copyWith(showGhost: !state.showGhost);
  void toggleOscilloscope() =>
      state = state.copyWith(showOscilloscope: !state.showOscilloscope);

  // Phase 5 actions
  void setTimeScale(double value) => state = state.copyWith(timeScale: value);
  void toggleAudio() =>
      state = state.copyWith(isAudioEnabled: !state.isAudioEnabled);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final waveProvider = StateNotifierProvider<WaveNotifier, WaveState>((ref) {
  return WaveNotifier();
});
