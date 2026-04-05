import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/substances.dart';

enum PhysicalState { solid, melting, liquid, boiling, gas }

class PhaseSettings {
  final PhaseSubstance substance;
  final double heatRateWatts;      // J/s (control variable)
  final bool isPaused;
  final double resetCounter; // increment to trigger a hard reset in the game

  const PhaseSettings({
    required this.substance,
    this.heatRateWatts = 200.0,
    this.isPaused = true,
    this.resetCounter = 0,
  });

  PhaseSettings copyWith({
    PhaseSubstance? substance,
    double? heatRateWatts,
    bool? isPaused,
    double? resetCounter,
  }) {
    return PhaseSettings(
      substance: substance ?? this.substance,
      heatRateWatts: heatRateWatts ?? this.heatRateWatts,
      isPaused: isPaused ?? this.isPaused,
      resetCounter: resetCounter ?? this.resetCounter,
    );
  }
}

class PhaseNotifier extends StateNotifier<PhaseSettings> {
  PhaseNotifier() : super(PhaseSettings(substance: kPhaseSubstances[0]));

  void togglePlay() => state = state.copyWith(isPaused: !state.isPaused);
  void setHeatRate(double r) => state = state.copyWith(heatRateWatts: r);
  void selectSubstance(PhaseSubstance s) {
    state = state.copyWith(
        substance: s, 
        resetCounter: state.resetCounter + 1,
        isPaused: true,
    );
  }

  void reset() => state = state.copyWith(resetCounter: state.resetCounter + 1, isPaused: true);
}

final phaseProvider = StateNotifierProvider<PhaseNotifier, PhaseSettings>(
  (ref) => PhaseNotifier(),
);
