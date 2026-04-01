import '../../../core/constants/electrolytes.dart';

class ElectrolysisState {
  final Electrolyte electrolyte;
  final double appliedVoltage;
  final bool isPowerOn;
  final double anodeGasVolume;
  final double cathodeGasVolume;
  final double currentAmps;

  const ElectrolysisState({
    required this.electrolyte,
    this.appliedVoltage = 0.0,
    this.isPowerOn = false,
    this.anodeGasVolume = 0.0,
    this.cathodeGasVolume = 0.0,
    this.currentAmps = 0.0,
  });

  bool get isReacting => isPowerOn && appliedVoltage >= electrolyte.thresholdVoltage;

  ElectrolysisState copyWith({
    Electrolyte? electrolyte,
    double? appliedVoltage,
    bool? isPowerOn,
    double? anodeGasVolume,
    double? cathodeGasVolume,
    double? currentAmps,
  }) {
    return ElectrolysisState(
      electrolyte: electrolyte ?? this.electrolyte,
      appliedVoltage: appliedVoltage ?? this.appliedVoltage,
      isPowerOn: isPowerOn ?? this.isPowerOn,
      anodeGasVolume: anodeGasVolume ?? this.anodeGasVolume,
      cathodeGasVolume: cathodeGasVolume ?? this.cathodeGasVolume,
      currentAmps: currentAmps ?? this.currentAmps,
    );
  }
}
