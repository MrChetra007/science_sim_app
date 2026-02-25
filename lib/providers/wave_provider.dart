import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaveState {
  final double amplitude;
  final double frequency;
  final double waveSpeed;
  final double phaseDifference;
  final bool isDampingEnabled;

  WaveState({
    this.amplitude = 1.0,
    this.frequency = 1.0,
    this.waveSpeed = 343.0, // Speed of sound in air (m/s)
    this.phaseDifference = 0.0,
    this.isDampingEnabled = false,
  });

  WaveState copyWith({
    double? amplitude,
    double? frequency,
    double? waveSpeed,
    double? phaseDifference,
    bool? isDampingEnabled,
  }) {
    return WaveState(
      amplitude: amplitude ?? this.amplitude,
      frequency: frequency ?? this.frequency,
      waveSpeed: waveSpeed ?? this.waveSpeed,
      phaseDifference: phaseDifference ?? this.phaseDifference,
      isDampingEnabled: isDampingEnabled ?? this.isDampingEnabled,
    );
  }
}

class WaveNotifier extends StateNotifier<WaveState> {
  WaveNotifier() : super(WaveState());

  void setAmplitude(double value) => state = state.copyWith(amplitude: value);
  void setFrequency(double value) => state = state.copyWith(frequency: value);
  void setWaveSpeed(double value) => state = state.copyWith(waveSpeed: value);
  void setPhaseDifference(double value) =>
      state = state.copyWith(phaseDifference: value);
  void toggleDamping(bool value) =>
      state = state.copyWith(isDampingEnabled: value);
}

final waveProvider = StateNotifierProvider<WaveNotifier, WaveState>((ref) {
  return WaveNotifier();
});
