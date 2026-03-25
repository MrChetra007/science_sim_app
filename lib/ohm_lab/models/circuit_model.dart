
class CircuitModel {
  final double voltage;      // V  (1.0 – 120.0 Volts)
  final double resistance;   // R  (1.0 – 1000.0 Ohms)

  CircuitModel({
    required this.voltage,
    required this.resistance,
  });

  double get current => voltage / resistance;          // I = V / R
  double get power   => voltage * current;             // P = V * I
  bool   get isDangerous => current > 1.0;             // Safety threshold
  double get currentSpeed => (current / 2.0).clamp(0.1, 1.0); // For animations
}
