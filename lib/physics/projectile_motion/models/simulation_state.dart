import 'trajectory_data.dart';

enum SimulationStatus { idle, running, paused, completed }

class SimulationState {
  final double angle; // degrees (0–90)
  final double initialSpeed; // m/s
  final double initialHeight; // m
  final double gravity; // m/s²
  final bool airResistance;
  final SimulationStatus status;
  final TrajectoryData? trajectory;
  final TrajectoryData? previousTrajectory;
  final String selectedObjectId;
  final String selectedGravityId;
  final bool slowMotion;
  final bool isChallengeMode;
  final double? targetDistance;
  final int score;
  final bool showForces;
  final bool showVelocity;
  final bool isPro;
  final bool showMathSolver;

  const SimulationState({
    required this.angle,
    required this.initialSpeed,
    required this.initialHeight,
    required this.gravity,
    required this.airResistance,
    required this.status,
    required this.selectedObjectId,
    required this.selectedGravityId,
    required this.slowMotion,
    this.isPro = false,
    this.isChallengeMode = false,
    this.targetDistance,
    this.score = 0,
    this.trajectory,
    this.previousTrajectory,
    this.showForces = true,
    this.showVelocity = false,
    this.showMathSolver = false,
  });

  factory SimulationState.initial() => const SimulationState(
        angle: 45.0,
        initialSpeed: 15.0,
        initialHeight: 0.0,
        gravity: 9.81,
        airResistance: true,
        status: SimulationStatus.idle,
        selectedObjectId: 'cannonball',
        selectedGravityId: 'earth',
        slowMotion: false,
        isChallengeMode: false,
        score: 0,
        isPro: false,
        showForces: true,
        showVelocity: false,
        showMathSolver: false,
      );

  SimulationState copyWith({
    double? angle,
    double? initialSpeed,
    double? initialHeight,
    double? gravity,
    bool? airResistance,
    SimulationStatus? status,
    TrajectoryData? trajectory,
    TrajectoryData? previousTrajectory,
    String? selectedObjectId,
    String? selectedGravityId,
    bool? slowMotion,
    bool? isPro,
    bool? isChallengeMode,
    double? targetDistance,
    int? score,
    bool? showForces,
    bool? showVelocity,
    bool? showMathSolver,
    bool clearTrajectory = false, // Clears current ONLY
    bool clearPrevious = false, // Clears previous ONLY
    bool clearTarget = false,
  }) {
    return SimulationState(
      angle: angle ?? this.angle,
      initialSpeed: initialSpeed ?? this.initialSpeed,
      initialHeight: initialHeight ?? this.initialHeight,
      gravity: gravity ?? this.gravity,
      airResistance: airResistance ?? this.airResistance,
      status: status ?? this.status,
      trajectory: clearTrajectory ? null : (trajectory ?? this.trajectory),
      previousTrajectory: clearPrevious
          ? null
          : (previousTrajectory ?? this.previousTrajectory),
      selectedObjectId: selectedObjectId ?? this.selectedObjectId,
      selectedGravityId: selectedGravityId ?? this.selectedGravityId,
      slowMotion: slowMotion ?? this.slowMotion,
      isPro: isPro ?? this.isPro,
      isChallengeMode: isChallengeMode ?? this.isChallengeMode,
      targetDistance:
          clearTarget ? null : (targetDistance ?? this.targetDistance),
      score: score ?? this.score,
      showForces: showForces ?? this.showForces,
      showVelocity: showVelocity ?? this.showVelocity,
      showMathSolver: showMathSolver ?? this.showMathSolver,
    );
  }

  bool get isIdle => status == SimulationStatus.idle;
  bool get isRunning => status == SimulationStatus.running;
  bool get isPaused => status == SimulationStatus.paused;
  bool get isCompleted => status == SimulationStatus.completed;
  bool get hasResults => trajectory != null;
}
