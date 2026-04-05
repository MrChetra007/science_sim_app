import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntropySettings {
  final bool wallRemoved;
  final double particleSpeedFactor;
  final double resetCounter;

  const EntropySettings({
    this.wallRemoved = false,
    this.particleSpeedFactor = 1.0,
    this.resetCounter = 0,
  });

  EntropySettings copyWith({
    bool? wallRemoved,
    double? particleSpeedFactor,
    double? resetCounter,
  }) {
    return EntropySettings(
      wallRemoved: wallRemoved ?? this.wallRemoved,
      particleSpeedFactor: particleSpeedFactor ?? this.particleSpeedFactor,
      resetCounter: resetCounter ?? this.resetCounter,
    );
  }
}

class EntropyNotifier extends StateNotifier<EntropySettings> {
  EntropyNotifier() : super(const EntropySettings());

  void removeWall() => state = state.copyWith(wallRemoved: true);
  
  void setSpeed(double s) => state = state.copyWith(particleSpeedFactor: s);

  void reset() => state = EntropySettings(
    resetCounter: state.resetCounter + 1,
    particleSpeedFactor: state.particleSpeedFactor,
  );
}

final entropyProvider = StateNotifierProvider<EntropyNotifier, EntropySettings>(
  (ref) => EntropyNotifier(),
);
