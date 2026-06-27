import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/physics/lorentz_engine.dart';

class TimeDilationState {
  final double beta;
  final double gamma;
  final double properTime;
  final double dilatedTime;
  final double photonPhase; // 0.0 to 2.0 (0.0 to 1.0 is down, 1.0 to 2.0 is up)
  final int restBounces;
  final int movingBounces;
  final bool isRunning;

  TimeDilationState({
    required this.beta,
    required this.gamma,
    required this.properTime,
    required this.dilatedTime,
    required this.photonPhase,
    required this.restBounces,
    required this.movingBounces,
    required this.isRunning,
  });

  TimeDilationState copyWith({
    double? beta,
    double? gamma,
    double? properTime,
    double? dilatedTime,
    double? photonPhase,
    int? restBounces,
    int? movingBounces,
    bool? isRunning,
  }) {
    return TimeDilationState(
      beta: beta ?? this.beta,
      gamma: gamma ?? this.gamma,
      properTime: properTime ?? this.properTime,
      dilatedTime: dilatedTime ?? this.dilatedTime,
      photonPhase: photonPhase ?? this.photonPhase,
      restBounces: restBounces ?? this.restBounces,
      movingBounces: movingBounces ?? this.movingBounces,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class TimeDilationNotifier extends StateNotifier<TimeDilationState> {
  TimeDilationNotifier()
      : super(TimeDilationState(
          beta: 0.0,
          gamma: 1.0,
          properTime: 0.0,
          dilatedTime: 0.0,
          photonPhase: 0.0,
          restBounces: 0,
          movingBounces: 0,
          isRunning: true,
        ));

  void tick(double dt) {
    if (!state.isRunning) return;

    final g = state.gamma;
    // Observer (rest) is the reference clock, always ticks at real time.
    final newDilatedTime = state.dilatedTime + dt;
    // Spaceship clock ticks slower by factor 1/γ.
    final newProperTime = state.properTime + (dt / g);

    // Bouncing phase: 0.0 to 2.0, based on proper (spaceship) time.
    final phase = (newProperTime * 2.0) % 2.0;

    state = state.copyWith(
      properTime: newProperTime,
      dilatedTime: newDilatedTime,
      photonPhase: phase,
      restBounces: (newDilatedTime * 2.0).floor(),
      movingBounces: (newProperTime * 2.0).floor(),
    );
  }

  void setBeta(double b) {
    final g = LorentzEngine.gamma(b);
    state = state.copyWith(
      beta: b,
      gamma: g,
    );
  }

  void togglePause() {
    state = state.copyWith(isRunning: !state.isRunning);
  }

  void reset() {
    state = TimeDilationState(
      beta: 0.0,
      gamma: 1.0,
      properTime: 0.0,
      dilatedTime: 0.0,
      photonPhase: 0.0,
      restBounces: 0,
      movingBounces: 0,
      isRunning: false,
    );
  }
}

final timeDilationProvider =
    StateNotifierProvider<TimeDilationNotifier, TimeDilationState>((ref) {
  return TimeDilationNotifier();
});
