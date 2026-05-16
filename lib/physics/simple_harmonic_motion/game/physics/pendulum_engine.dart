import 'dart:math';

class PendulumEngine {
  static double periodSmallAngle(double L, double g) => 2 * pi * sqrt(L / g);

  static double angularFrequency(double L, double g) => sqrt(g / L);

  static double angleSmallAngle(double theta0, double omega, double t) {
    return theta0 * cos(omega * t);
  }

  static double angularVelocity(double theta0, double omega, double t) {
    return -theta0 * omega * sin(omega * t);
  }

  static double arcLength(double L, double theta) => L * theta;

  static double kineticEnergy(double mass, double L, double dTheta) {
    return 0.5 * mass * L * L * dTheta * dTheta;
  }

  static double potentialEnergy(double mass, double g, double L, double theta) {
    return mass * g * L * (1 - cos(theta));
  }

  static double totalEnergy(double mass, double g, double L, double theta0) {
    return mass * g * L * (1 - cos(theta0));
  }
}
