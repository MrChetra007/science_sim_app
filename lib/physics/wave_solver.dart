import 'dart:math';

class WaveSolver {
  /// Calculate displacement y at position x and time t for a transverse wave:
  /// y(x, t) = A * sin(k*x - omega*t + phi)
  static double calculateDisplacement({
    required double amplitude,
    required double frequency,
    required double waveSpeed,
    required double x,
    required double t,
    double phi = 0,
  }) {
    // Wave number k = 2 * pi / wavelength
    // v = f * wavelength => wavelength = v / f
    final double wavelength = waveSpeed / frequency;
    final double k = 2 * pi / wavelength;

    // Angular frequency omega = 2 * pi * f
    final double omega = 2 * pi * frequency;

    return amplitude * sin(k * x - omega * t + phi);
  }

  /// Calculate wavelength from speed and frequency: lambda = v / f
  static double calculateWavelength(double waveSpeed, double frequency) {
    if (frequency == 0) {
      return 0;
    }
    return waveSpeed / frequency;
  }

  /// Calculate period: T = 1 / f
  static double calculatePeriod(double frequency) {
    if (frequency == 0) {
      return 0;
    }
    return 1 / frequency;
  }

  /// Calculate standing wave displacement for the n-th harmonic
  /// y(x, t) = 2 * A * sin(k*x) * cos(omega*t)
  static double calculateStandingWaveDisplacement({
    required double amplitude,
    required double frequency,
    required double length,
    required int harmonic, // n
    required double x,
    required double t,
  }) {
    // For a string of length L, wavelength lambda_n = 2L / n
    final double wavelength = (2 * length) / harmonic;
    final double k = 2 * pi / wavelength;
    final double omega = 2 * pi * frequency;

    return 2 * amplitude * sin(k * x) * cos(omega * t);
  }

  /// Calculate Doppler frequency shift: f' = f * (v / (v - vs))
  /// vs > 0 means source moving towards observer
  static double calculateDopplerFrequency({
    required double sourceFrequency,
    required double waveSpeed,
    required double sourceVelocity,
  }) {
    if (waveSpeed == sourceVelocity) {
      return sourceFrequency * 10; // Avoid infinity
    }
    return sourceFrequency * (waveSpeed / (waveSpeed - sourceVelocity));
  }
}
