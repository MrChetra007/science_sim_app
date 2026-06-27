import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/physics/lorentz_engine.dart';

class MassEnergyState {
  final double massKg; // input mass scaled (e.g. 1.0 to 5.0 in units of 1e-27 kg)
  final double beta;
  final double gamma;
  final double restEnergy;
  final double kineticEnergy;
  final double totalEnergy;
  final bool reactionTriggered;
  final double burstProgress;
  final bool isRunning;

  MassEnergyState({
    required this.massKg,
    required this.beta,
    required this.gamma,
    required this.restEnergy,
    required this.kineticEnergy,
    required this.totalEnergy,
    required this.reactionTriggered,
    required this.burstProgress,
    required this.isRunning,
  });

  MassEnergyState copyWith({
    double? massKg,
    double? beta,
    double? gamma,
    double? restEnergy,
    double? kineticEnergy,
    double? totalEnergy,
    bool? reactionTriggered,
    double? burstProgress,
    bool? isRunning,
  }) {
    return MassEnergyState(
      massKg: massKg ?? this.massKg,
      beta: beta ?? this.beta,
      gamma: gamma ?? this.gamma,
      restEnergy: restEnergy ?? this.restEnergy,
      kineticEnergy: kineticEnergy ?? this.kineticEnergy,
      totalEnergy: totalEnergy ?? this.totalEnergy,
      reactionTriggered: reactionTriggered ?? this.reactionTriggered,
      burstProgress: burstProgress ?? this.burstProgress,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class MassEnergyNotifier extends StateNotifier<MassEnergyState> {
  MassEnergyNotifier()
      : super(MassEnergyState(
          massKg: 2.5,
          beta: 0.0,
          gamma: 1.0,
          restEnergy: LorentzEngine.restEnergy(2.5 * 1e-27),
          kineticEnergy: 0.0,
          totalEnergy: LorentzEngine.restEnergy(2.5 * 1e-27),
          reactionTriggered: false,
          burstProgress: 0.0,
          isRunning: true,
        ));

  void tick(double dt) {
    if (!state.isRunning) return;

    if (state.reactionTriggered && state.burstProgress < 1.0) {
      final newProgress = (state.burstProgress + dt * 1.5).clamp(0.0, 1.0);
      state = state.copyWith(burstProgress: newProgress);
    }
  }

  void setMass(double m) {
    final double actualMass = m * 1e-27;
    state = state.copyWith(
      massKg: m,
      restEnergy: LorentzEngine.restEnergy(actualMass),
      kineticEnergy: LorentzEngine.kineticEnergy(actualMass, state.beta),
      totalEnergy: LorentzEngine.totalEnergy(actualMass, state.beta),
    );
  }

  void setBeta(double b) {
    final double actualMass = state.massKg * 1e-27;
    final g = LorentzEngine.gamma(b);
    state = state.copyWith(
      beta: b,
      gamma: g,
      kineticEnergy: LorentzEngine.kineticEnergy(actualMass, b),
      totalEnergy: LorentzEngine.totalEnergy(actualMass, b),
    );
  }

  void triggerFission() {
    state = state.copyWith(
      reactionTriggered: true,
      burstProgress: 0.0,
    );
  }

  void reset() {
    final double actualMass = state.massKg * 1e-27;
    state = state.copyWith(
      reactionTriggered: false,
      burstProgress: 0.0,
      kineticEnergy: LorentzEngine.kineticEnergy(actualMass, state.beta),
      totalEnergy: LorentzEngine.totalEnergy(actualMass, state.beta),
    );
  }

  void togglePause() {
    state = state.copyWith(isRunning: !state.isRunning);
  }
}

final massEnergyProvider =
    StateNotifierProvider<MassEnergyNotifier, MassEnergyState>((ref) {
  return MassEnergyNotifier();
});
