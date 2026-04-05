import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GasLaw { boyle, charles, gayLussac }

class GasState {
  final GasLaw law;
  final double pressure;    // atm (0.1 - 10.0)
  final double volume;      // L   (0.1 - 5.0)
  final double temperature; // K   (50 - 1000)

  const GasState({
    required this.law,
    this.pressure = 1.0,
    this.volume = 1.0,
    this.temperature = 300.0,
  });

  // Ideal Gas Law: PV = nRT (assuming nR = 1 for simplicity)
  // Constants for clamping
  static const double minP = 0.1;
  static const double maxP = 10.0;
  static const double minV = 0.1;
  static const double maxV = 5.0;
  static const double minT = 50.0;
  static const double maxT = 1000.0;

  GasState copyWith({
    GasLaw? law,
    double? pressure,
    double? volume,
    double? temperature,
  }) {
    return GasState(
      law: law ?? this.law,
      pressure: (pressure ?? this.pressure).clamp(minP, maxP),
      volume: (volume ?? this.volume).clamp(minV, maxV),
      temperature: (temperature ?? this.temperature).clamp(minT, maxT),
    );
  }

  GasState updatePressure(double p) {
    p = p.clamp(minP, maxP);
    switch (law) {
      case GasLaw.boyle:
        return copyWith(pressure: p, volume: (pressure * volume) / p);
      case GasLaw.gayLussac:
        return copyWith(pressure: p, temperature: (temperature * p) / pressure);
      default:
        return copyWith(pressure: p);
    }
  }

  GasState updateVolume(double v) {
    v = v.clamp(minV, maxV);
    switch (law) {
      case GasLaw.boyle:
        return copyWith(volume: v, pressure: (pressure * volume) / v);
      case GasLaw.charles:
        return copyWith(volume: v, temperature: (temperature * v) / volume);
      default:
        return copyWith(volume: v);
    }
  }

  GasState updateTemperature(double t) {
    t = t.clamp(minT, maxT);
    switch (law) {
      case GasLaw.charles:
        return copyWith(temperature: t, volume: (volume * t) / temperature);
      case GasLaw.gayLussac:
        return copyWith(temperature: t, pressure: (pressure * t) / temperature);
      default:
        return copyWith(temperature: t);
    }
  }
}

class GasNotifier extends StateNotifier<GasState> {
  GasNotifier() : super(const GasState(law: GasLaw.boyle));

  void setLaw(GasLaw law) {
    state = GasState(law: law);
  }

  void setPressure(double p) => state = state.updatePressure(p);
  void setVolume(double v) => state = state.updateVolume(v);
  void setTemperature(double t) => state = state.updateTemperature(t);
}

final gasProvider = StateNotifierProvider<GasNotifier, GasState>(
  (ref) => GasNotifier(),
);
