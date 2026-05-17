import 'dart:math';

class FaradayEngine {
  static const double coilArea = 0.01;

  static double computeFlux(double magnetY, double B, double area) {
    final y = magnetY.clamp(-1.0, 1.0);
    return B * area * (1.0 - y * y);
  }

  static double computeEMF(double dFlux, double dt, int turns) {
    if (dt <= 0) return 0;
    return -turns * (dFlux / dt);
  }

  static double computePosition(double phase) => sin(phase);

  static double computeVelocity(double phase, double speed) =>
      cos(phase) * speed;
}
