import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CarnotStep {
  isothermalExpansion, // Stage 1: Heat in, Volume up
  adiabaticExpansion,  // Stage 2: Work out, Volume up, Temp down
  isothermalCompression, // Stage 3: Heat out, Volume down
  adiabaticCompression,  // Stage 4: Work in, Volume down, Temp up
}

class CarnotState {
  final double tempHot;  // Th (K)
  final double tempCold; // Tc (K)
  final bool isPaused;

  const CarnotState({
    this.tempHot = 500.0,
    this.tempCold = 300.0,
    this.isPaused = true,
  });

  double get efficiency => 1.0 - (tempCold / tempHot);

  CarnotState copyWith({
    double? tempHot,
    double? tempCold,
    bool? isPaused,
  }) {
    return CarnotState(
      tempHot: tempHot ?? this.tempHot,
      tempCold: tempCold ?? this.tempCold,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class CarnotNotifier extends StateNotifier<CarnotState> {
  CarnotNotifier() : super(const CarnotState());

  void togglePlay() => state = state.copyWith(isPaused: !state.isPaused);
  
  void setTempHot(double t) {
    if (t > state.tempCold) {
      state = state.copyWith(tempHot: t);
    }
  }

  void setTempCold(double t) {
    if (t < state.tempHot) {
      state = state.copyWith(tempCold: t);
    }
  }

  void reset() => state = const CarnotState();
}

final carnotProvider = StateNotifierProvider<CarnotNotifier, CarnotState>(
  (ref) => CarnotNotifier(),
);
