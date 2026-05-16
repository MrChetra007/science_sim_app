import 'dart:math';

class SHMEngine {
  static double position(double A, double omega, double t, double phi) {
    return A * cos(omega * t + phi);
  }

  static double velocity(double A, double omega, double t, double phi) {
    return -A * omega * sin(omega * t + phi);
  }

  static double acceleration(double omega, double x) {
    return -omega * omega * x;
  }

  static double period(double omega) => 2 * pi / omega;

  static double maxVelocity(double A, double omega) => A * omega;

  static double maxAcceleration(double A, double omega) => A * omega * omega;

  static double angularFrequencyFromPeriod(double T) => 2 * pi / T;
}
