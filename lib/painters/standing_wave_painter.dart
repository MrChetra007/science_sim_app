import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class StandingWavePainter extends CustomPainter {
  final WaveState state;
  final Color waveColor;

  StandingWavePainter({
    required this.state,
    this.waveColor = const Color(0xFF00E5FF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    final glowPaint = Paint()
      ..color = waveColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = Path();
    final glowPath = Path();

    final centerY = size.height / 2;
    const double xPadding = 40.0;
    final double simulationWidth = size.width - (2 * xPadding);

    for (double x = 0; x <= simulationWidth; x += 1) {
      final displacement = WaveSolver.calculateStandingWaveDisplacement(
        amplitude: state.amplitude * 70, // Bigger waves
        frequency: state.frequency,
        length: simulationWidth,
        harmonic: state.harmonic,
        x: x,
        t: state.currentTime,
      );

      final screenX = x + xPadding;
      final screenY = centerY + displacement;

      if (x == 0) {
        path.moveTo(screenX, screenY);
        glowPath.moveTo(screenX, screenY);
      } else {
        path.lineTo(screenX, screenY);
        glowPath.lineTo(screenX, screenY);
      }
    }

    // Draw nodes markers
    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final wavelength = (2 * simulationWidth) / state.harmonic;
    for (int i = 0; i <= state.harmonic; i++) {
      final nodeX = xPadding + (i * wavelength / 2);
      canvas.drawCircle(Offset(nodeX, centerY), 4, nodePaint);
    }

    canvas.drawPath(glowPath, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StandingWavePainter oldDelegate) {
    return oldDelegate.state.currentTime != state.currentTime ||
        oldDelegate.state.harmonic != state.harmonic ||
        oldDelegate.state.amplitude != state.amplitude;
  }
}
