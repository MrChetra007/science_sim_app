import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/physics/lorentz_engine.dart';

class LengthContractionState {
  final double beta;
  final double gamma;
  final double restLength;
  final double contractedLength;
  final double shipX;
  final bool isRunning;

  LengthContractionState({
    required this.beta,
    required this.gamma,
    required this.restLength,
    required this.contractedLength,
    required this.shipX,
    required this.isRunning,
  });

  LengthContractionState copyWith({
    double? beta,
    double? gamma,
    double? restLength,
    double? contractedLength,
    double? shipX,
    bool? isRunning,
  }) {
    return LengthContractionState(
      beta: beta ?? this.beta,
      gamma: gamma ?? this.gamma,
      restLength: restLength ?? this.restLength,
      contractedLength: contractedLength ?? this.contractedLength,
      shipX: shipX ?? this.shipX,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class LengthContractionNotifier extends StateNotifier<LengthContractionState> {
  LengthContractionNotifier()
      : super(LengthContractionState(
          beta: 0.0,
          gamma: 1.0,
          restLength: 100.0,
          contractedLength: 100.0,
          shipX: -100.0,
          isRunning: true,
        ));

  void tick(double dt, double screenWidth) {
    if (!state.isRunning) return;

    final speed = (state.beta * 400.0) + 100.0;
    double newX = state.shipX + speed * dt;

    final maxRight = screenWidth + 150.0;
    if (newX > maxRight) {
      newX = -150.0;
    }

    state = state.copyWith(shipX: newX);
  }

  void setBeta(double b) {
    final g = LorentzEngine.gamma(b);
    state = state.copyWith(
      beta: b,
      gamma: g,
      contractedLength: LorentzEngine.contractedLength(state.restLength, b),
    );
  }

  void togglePause() {
    state = state.copyWith(isRunning: !state.isRunning);
  }

  void reset() {
    state = LengthContractionState(
      beta: state.beta,
      gamma: state.gamma,
      restLength: state.restLength,
      contractedLength: state.contractedLength,
      shipX: -150.0,
      isRunning: state.isRunning,
    );
  }
}

final lengthContractionProvider =
    StateNotifierProvider<LengthContractionNotifier, LengthContractionState>((ref) {
  return LengthContractionNotifier();
});
