import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/shm_game.dart';

enum SimMode { spring, pendulum }

class SimState {
  final SimMode mode;
  final double springConstant;
  final double mass;
  final double amplitude;
  final double pendulumLength;
  final double gravity;
  final double initialAngle;
  final double position;
  final double velocity;
  final double accel;
  final double kineticEnergy;
  final double potentialEnergy;
  final double totalEnergy;
  final double period;
  final double omega;
  final bool isRunning;
  final bool showVectors;
  final double time;
  final List<double> posHistory;
  final List<double> velHistory;
  final List<double> accHistory;

  const SimState({
    this.mode = SimMode.spring,
    this.springConstant = 20.0,
    this.mass = 0.5,
    this.amplitude = 0.15,
    this.pendulumLength = 1.0,
    this.gravity = 9.8,
    this.initialAngle = 15.0,
    this.position = 0.15,
    this.velocity = 0.0,
    this.accel = 0.0,
    this.kineticEnergy = 0.0,
    this.potentialEnergy = 0.0,
    this.totalEnergy = 0.0,
    this.period = 0.0,
    this.omega = 0.0,
    this.isRunning = true,
    this.showVectors = true,
    this.time = 0.0,
    this.posHistory = const [],
    this.velHistory = const [],
    this.accHistory = const [],
  });

  SimState copyWith({
    SimMode? mode,
    double? springConstant,
    double? mass,
    double? amplitude,
    double? pendulumLength,
    double? gravity,
    double? initialAngle,
    double? position,
    double? velocity,
    double? accel,
    double? kineticEnergy,
    double? potentialEnergy,
    double? totalEnergy,
    double? period,
    double? omega,
    bool? isRunning,
    bool? showVectors,
    double? time,
    List<double>? posHistory,
    List<double>? velHistory,
    List<double>? accHistory,
  }) {
    return SimState(
      mode: mode ?? this.mode,
      springConstant: springConstant ?? this.springConstant,
      mass: mass ?? this.mass,
      amplitude: amplitude ?? this.amplitude,
      pendulumLength: pendulumLength ?? this.pendulumLength,
      gravity: gravity ?? this.gravity,
      initialAngle: initialAngle ?? this.initialAngle,
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      accel: accel ?? this.accel,
      kineticEnergy: kineticEnergy ?? this.kineticEnergy,
      potentialEnergy: potentialEnergy ?? this.potentialEnergy,
      totalEnergy: totalEnergy ?? this.totalEnergy,
      period: period ?? this.period,
      omega: omega ?? this.omega,
      isRunning: isRunning ?? this.isRunning,
      showVectors: showVectors ?? this.showVectors,
      time: time ?? this.time,
      posHistory: posHistory ?? this.posHistory,
      velHistory: velHistory ?? this.velHistory,
      accHistory: accHistory ?? this.accHistory,
    );
  }
}

class SimNotifier extends StateNotifier<SimState> {
  SimNotifier() : super(const SimState());

  void syncFromGame(GameState gs) {
    state = SimState(
      mode: gs.mode,
      springConstant: gs.springConstant,
      mass: gs.mass,
      amplitude: gs.amplitude,
      pendulumLength: gs.pendulumLength,
      gravity: gs.gravity,
      initialAngle: gs.initialAngle,
      position: gs.position,
      velocity: gs.velocity,
      accel: gs.accel,
      kineticEnergy: gs.kineticEnergy,
      potentialEnergy: gs.potentialEnergy,
      totalEnergy: gs.totalEnergy,
      period: gs.period,
      omega: gs.omega,
      isRunning: gs.isRunning,
      showVectors: gs.showVectors,
      time: gs.time,
      posHistory: List.from(gs.posHistory),
      velHistory: List.from(gs.velHistory),
      accHistory: List.from(gs.accHistory),
    );
  }

  void togglePause() {}
  void toggleVectors() {}
  void reset() {}
  void setSpringConstant(double k) {}
  void setMass(double m) {}
  void setAmplitude(double A) {}
  void setPendulumLength(double L) {}
  void setGravity(double g) {}
  void setInitialAngle(double deg) {}
  void setMode(SimMode mode) {}
  void startManual() {}
  void setManualDisplacement(double x) {}
  void resumeAuto() {}
  void tick(double dt) {}
}

final simProvider = StateNotifierProvider<SimNotifier, SimState>((ref) {
  return SimNotifier();
});
