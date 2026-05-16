import 'dart:math';

class SpringEngine {
  static double restoreForce(double k, double x) => -k * x;

  static double angularFrequency(double k, double mass) => sqrt(k / mass);

  static double period(double mass, double k) => 2 * pi * sqrt(mass / k);

  static double kineticEnergy(double mass, double v) => 0.5 * mass * v * v;

  static double potentialEnergy(double k, double x) => 0.5 * k * x * x;

  static double totalEnergy(double k, double A) => 0.5 * k * A * A;
}
