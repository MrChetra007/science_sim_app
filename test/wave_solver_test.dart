import 'package:flutter_test/flutter_test.dart';
import 'package:physics_shot/physics/wave_solver.dart';
import 'dart:math';

void main() {
  group('WaveSolver Tests', () {
    test('calculateWavelength should return v/f', () {
      expect(WaveSolver.calculateWavelength(343, 10), 34.3);
      expect(WaveSolver.calculateWavelength(1500, 50), 30.0);
    });

    test('calculatePeriod should return 1/f', () {
      expect(WaveSolver.calculatePeriod(10), 0.1);
      expect(WaveSolver.calculatePeriod(2), 0.5);
    });

    test('calculateDisplacement should return correct value at t=0, x=0', () {
      // y(0, 0) = A * sin(0) = 0
      final displacement = WaveSolver.calculateDisplacement(
        amplitude: 5,
        frequency: 10,
        waveSpeed: 343,
        x: 0,
        t: 0,
      );
      expect(displacement, closeTo(0, 1e-10));
    });

    test('calculateDisplacement should return A at certain phase', () {
      // y(x, t) = A * sin(k*x - omega*t + pi/2) at x=0, t=0 should be A
      final displacement = WaveSolver.calculateDisplacement(
        amplitude: 5,
        frequency: 10,
        waveSpeed: 343,
        x: 0,
        t: 0,
        phi: pi / 2,
      );
      expect(displacement, closeTo(5, 1e-10));
    });

    test('calculateStandingWaveDisplacement should have nodes at L', () {
      // For n=1, L=10, wavelength=20, k=2pi/20 = pi/10. sin(k*10) = sin(pi) = 0.
      final displacement = WaveSolver.calculateStandingWaveDisplacement(
        amplitude: 1,
        frequency: 1,
        length: 10,
        harmonic: 1,
        x: 10,
        t: 0,
      );
      expect(displacement, closeTo(0, 1e-10));
    });
  });
}
