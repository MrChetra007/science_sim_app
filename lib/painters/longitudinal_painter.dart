import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class LongitudinalPainter extends CustomPainter {
  final WaveState state;
  LongitudinalPainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    // Number of particles vertically and horizontally
    const int rows = 5;
    const double rowSpacing = 40.0;
    const double particleSpacing = 10.0;

    // Calculate visual amplitude to fit screen elegantly
    final double visualAmplitude = state.amplitude * 20.0;

    for (int r = 0; r < rows; r++) {
      final yPos = centerY + (r - (rows - 1) / 2) * rowSpacing;

      for (double x = 0; x < size.width; x += particleSpacing) {
        // In longitudinal waves, particles oscillate HORIZONTALLY (in the direction of propagation)
        // x_displacement = A * sin(kx - wt)
        final double xOffset = WaveSolver.calculateDisplacement(
          amplitude: visualAmplitude,
          frequency: state.frequency,
          waveSpeed: state.waveSpeed / 10, // match transverse visual speed
          x: x,
          t: state.currentTime,
          isDampingEnabled: state.isDampingEnabled,
        );

        // Draw the particle
        canvas.drawCircle(Offset(x + xOffset, yPos), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant LongitudinalPainter oldDelegate) => true;
}
