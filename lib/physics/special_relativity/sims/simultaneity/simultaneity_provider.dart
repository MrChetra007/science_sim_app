import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimultaneityState {
  final double beta;
  final double speed;
  final double trainX;
  final bool strikeTriggered;
  final double wavefrontARadius;
  final double wavefrontBRadius;
  final double elapsed;
  final double? platformTimeA;
  final double? platformTimeB;
  final double? trainTimeA;
  final double? trainTimeB;

  SimultaneityState({
    required this.beta,
    required this.speed,
    required this.trainX,
    required this.strikeTriggered,
    required this.wavefrontARadius,
    required this.wavefrontBRadius,
    required this.elapsed,
    this.platformTimeA,
    this.platformTimeB,
    this.trainTimeA,
    this.trainTimeB,
  });

  SimultaneityState copyWith({
    double? beta,
    double? speed,
    double? trainX,
    bool? strikeTriggered,
    double? wavefrontARadius,
    double? wavefrontBRadius,
    double? elapsed,
    double? platformTimeA,
    double? platformTimeB,
    double? trainTimeA,
    double? trainTimeB,
  }) {
    return SimultaneityState(
      beta: beta ?? this.beta,
      speed: speed ?? this.speed,
      trainX: trainX ?? this.trainX,
      strikeTriggered: strikeTriggered ?? this.strikeTriggered,
      wavefrontARadius: wavefrontARadius ?? this.wavefrontARadius,
      wavefrontBRadius: wavefrontBRadius ?? this.wavefrontBRadius,
      elapsed: elapsed ?? this.elapsed,
      platformTimeA: platformTimeA ?? this.platformTimeA,
      platformTimeB: platformTimeB ?? this.platformTimeB,
      trainTimeA: trainTimeA ?? this.trainTimeA,
      trainTimeB: trainTimeB ?? this.trainTimeB,
    );
  }
}

class SimultaneityNotifier extends StateNotifier<SimultaneityState> {
  SimultaneityNotifier()
      : super(SimultaneityState(
          beta: 0.5,
          speed: 1.0,
          trainX: 0.0,
          strikeTriggered: false,
          wavefrontARadius: 0.0,
          wavefrontBRadius: 0.0,
          elapsed: 0.0,
        ));

  void tick(double dt, double width) {
    if (!state.strikeTriggered) return;

    final effectiveDt = dt * state.speed;
    final newElapsed = state.elapsed + effectiveDt;

    // Scale of light speed c in pixels per second.
    const double cSpeed = 220.0;
    final double vSpeed = cSpeed * state.beta;

    // Train moves to the right.
    // Center alignment point is width / 2.
    final double center = width / 2;
    final double newTrainX = center + vSpeed * newElapsed;

    // Wavefronts expand at c.
    final newRadiusA = cSpeed * newElapsed;
    final newRadiusB = cSpeed * newElapsed;

    // Lightning strike sources (rest frame positions)
    final double strikeDist = width * 0.25;
    final double strikeA_X = center - strikeDist;
    final double strikeB_X = center + strikeDist;

    // Check wavefront arrival at platform observer (at center)
    double? platTimeA = state.platformTimeA;
    double? platTimeB = state.platformTimeB;
    if (platTimeA == null && newRadiusA >= strikeDist) {
      platTimeA = newElapsed;
    }
    if (platTimeB == null && newRadiusB >= strikeDist) {
      platTimeB = newElapsed;
    }

    // Check wavefront arrival at train observer (at trainX)
    double? tTimeA = state.trainTimeA;
    double? tTimeB = state.trainTimeB;

    // Train observer is at newTrainX.
    // Distance from strike sources:
    final double distToA = (newTrainX - strikeA_X).abs();
    final double distToB = (newTrainX - strikeB_X).abs();

    if (tTimeA == null && newRadiusA >= distToA) {
      tTimeA = newElapsed;
    }
    if (tTimeB == null && newRadiusB >= distToB) {
      tTimeB = newElapsed;
    }

    state = state.copyWith(
      elapsed: newElapsed,
      trainX: newTrainX,
      wavefrontARadius: newRadiusA,
      wavefrontBRadius: newRadiusB,
      platformTimeA: platTimeA,
      platformTimeB: platTimeB,
      trainTimeA: tTimeA,
      trainTimeB: tTimeB,
    );
  }

  void triggerLightning(double width) {
    if (state.strikeTriggered) return;
    state = state.copyWith(
      strikeTriggered: true,
      trainX: width / 2,
      elapsed: 0.0,
      wavefrontARadius: 0.0,
      wavefrontBRadius: 0.0,
      platformTimeA: null,
      platformTimeB: null,
      trainTimeA: null,
      trainTimeB: null,
    );
  }

  void setBeta(double b) {
    if (state.strikeTriggered) return;
    state = state.copyWith(beta: b);
  }

  void setSpeed(double s) {
    state = state.copyWith(speed: s.clamp(0.1, 3.0));
  }

  void reset() {
    state = SimultaneityState(
      beta: state.beta,
      speed: state.speed,
      trainX: 0.0,
      strikeTriggered: false,
      wavefrontARadius: 0.0,
      wavefrontBRadius: 0.0,
      elapsed: 0.0,
    );
  }
}

final simultaneityProvider =
    StateNotifierProvider<SimultaneityNotifier, SimultaneityState>((ref) {
  return SimultaneityNotifier();
});
