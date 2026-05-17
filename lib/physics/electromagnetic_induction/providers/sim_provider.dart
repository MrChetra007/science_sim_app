import 'dart:math';
import 'package:riverpod/riverpod.dart';
import '../game/physics/faraday_engine.dart';

enum SimControlMode { auto, manual }

class SimState {
  final double magnetY;
  final double velocity;
  final double flux;
  final double emf;
  final double dFlux;
  final double deltaT;
  final double speed;
  final double fieldStrength;
  final int turns;
  final bool isRunning;
  final SimControlMode controlMode;
  final double manualMagnetY;
  final List<double> oscHistory;
  final List<double> fluxHistory;
  final double phaseTime;

  const SimState({
    required this.magnetY,
    required this.velocity,
    required this.flux,
    required this.emf,
    required this.dFlux,
    required this.deltaT,
    required this.speed,
    required this.fieldStrength,
    required this.turns,
    required this.isRunning,
    required this.controlMode,
    required this.manualMagnetY,
    required this.oscHistory,
    required this.fluxHistory,
    required this.phaseTime,
  });

  SimState.init()
      : magnetY = -1.0,
        velocity = 0.0,
        flux = 0.0,
        emf = 0.0,
        dFlux = 0.0,
        deltaT = 0.016,
        speed = 1.0,
        fieldStrength = 1.0,
        turns = 10,
        isRunning = true,
        controlMode = SimControlMode.auto,
        manualMagnetY = -1.0,
        oscHistory = [],
        fluxHistory = [],
        phaseTime = -1.5708;

  SimState copyWith({
    double? magnetY,
    double? velocity,
    double? flux,
    double? emf,
    double? dFlux,
    double? deltaT,
    double? speed,
    double? fieldStrength,
    int? turns,
    bool? isRunning,
    SimControlMode? controlMode,
    double? manualMagnetY,
    List<double>? oscHistory,
    List<double>? fluxHistory,
    double? phaseTime,
  }) {
    return SimState(
      magnetY: magnetY ?? this.magnetY,
      velocity: velocity ?? this.velocity,
      flux: flux ?? this.flux,
      emf: emf ?? this.emf,
      dFlux: dFlux ?? this.dFlux,
      deltaT: deltaT ?? this.deltaT,
      speed: speed ?? this.speed,
      fieldStrength: fieldStrength ?? this.fieldStrength,
      turns: turns ?? this.turns,
      isRunning: isRunning ?? this.isRunning,
      controlMode: controlMode ?? this.controlMode,
      manualMagnetY: manualMagnetY ?? this.manualMagnetY,
      oscHistory: oscHistory ?? this.oscHistory,
      fluxHistory: fluxHistory ?? this.fluxHistory,
      phaseTime: phaseTime ?? this.phaseTime,
    );
  }
}

class SimNotifier extends StateNotifier<SimState> {
  SimNotifier() : super(SimState.init());

  void tick(double dt) {
    if (!state.isRunning) return;

    if (state.controlMode == SimControlMode.manual) {
      final newVel = (state.manualMagnetY - state.magnetY) / dt;
      final newFlux = FaradayEngine.computeFlux(
        state.manualMagnetY,
        state.fieldStrength,
        FaradayEngine.coilArea,
      );
      final dFlux = newFlux - state.flux;
      final newEmf = FaradayEngine.computeEMF(dFlux, dt, state.turns);

      final oscHistory = List<double>.from(state.oscHistory);
      oscHistory.add(newEmf);
      if (oscHistory.length > 300) oscHistory.removeAt(0);

      final fluxHistory = List<double>.from(state.fluxHistory);
      fluxHistory.add(newFlux);
      if (fluxHistory.length > 300) fluxHistory.removeAt(0);

      state = state.copyWith(
        magnetY: state.manualMagnetY,
        velocity: newVel,
        flux: newFlux,
        emf: newEmf,
        dFlux: dFlux,
        deltaT: dt,
        oscHistory: oscHistory,
        fluxHistory: fluxHistory,
      );
      return;
    }

    final newPhase = state.phaseTime + dt * state.speed;
    final newY = FaradayEngine.computePosition(newPhase);
    final newVel = FaradayEngine.computeVelocity(newPhase, state.speed);
    final newFlux = FaradayEngine.computeFlux(
      newY,
      state.fieldStrength,
      FaradayEngine.coilArea,
    );

    final dFlux = newFlux - state.flux;
    final newEmf = FaradayEngine.computeEMF(dFlux, dt, state.turns);

    final oscHistory = List<double>.from(state.oscHistory);
    oscHistory.add(newEmf);
    if (oscHistory.length > 300) oscHistory.removeAt(0);

    final fluxHistory = List<double>.from(state.fluxHistory);
    fluxHistory.add(newFlux);
    if (fluxHistory.length > 300) fluxHistory.removeAt(0);

    state = state.copyWith(
      magnetY: newY,
      velocity: newVel,
      flux: newFlux,
      emf: newEmf,
      dFlux: dFlux,
      deltaT: dt,
      phaseTime: newPhase,
      oscHistory: oscHistory,
      fluxHistory: fluxHistory,
    );
  }

  void startManual() {
    state = state.copyWith(controlMode: SimControlMode.manual);
  }

  void setManualPosition(double magnetY) {
    state = state.copyWith(
      manualMagnetY: magnetY.clamp(-1.2, 1.2),
      controlMode: SimControlMode.manual,
    );
  }

  void resumeAuto() {
    final clamped = state.magnetY.clamp(-1.0, 1.0);
    final newPhase = asin(clamped);
    state = state.copyWith(
      controlMode: SimControlMode.auto,
      phaseTime: newPhase,
    );
  }

  void setSpeed(double v) => state = state.copyWith(speed: v);
  void setFieldStrength(double v) => state = state.copyWith(fieldStrength: v);
  void setTurns(int n) => state = state.copyWith(turns: n);
  void togglePause() => state = state.copyWith(isRunning: !state.isRunning);

  void reset() {
    state = SimState.init();
  }
}

final simProvider = StateNotifierProvider<SimNotifier, SimState>((ref) {
  return SimNotifier();
});
