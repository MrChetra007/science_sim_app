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
        state = state.copyWith(currentTime: state.currentTime + 0.016);
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final waveProvider = StateNotifierProvider<WaveNotifier, WaveState>((ref) {
  return WaveNotifier();
});
