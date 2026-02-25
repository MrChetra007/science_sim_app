import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';

class DopplerPainter extends CustomPainter {
  final WaveState state;

  DopplerPainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Source position moves based on time and sourceVelocity
    // Wrap around for continuous animation
    final double range = size.width * 0.6;
    final double timeScale = state.currentTime % 5.0; // 5 second loop
    double sourceX =
        centerX - (range / 2) + (state.sourceVelocity * timeScale * 10);

    // Bounds check/Wrap
    sourceX =
        ((sourceX - (centerX - range / 2)) % range) + (centerX - range / 2);

    final sourcePaint = Paint()
      ..color =
          const Color(0xFFFFEB3B) // Yellow for source
      ..style = PaintingStyle.fill;

    final pulsePaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Emit pulses periodically
    const double pulseInterval = 0.5; // Emit every 0.5s
    for (double t = 0; t < 5.0; t += pulseInterval) {
      final double age = (state.currentTime - t) % 5.0;
      if (age < 0) continue;

      // Where was the source when this pulse was emitted?
      double emitTime = state.currentTime - age;
      double emittedX =
          centerX -
          (range / 2) +
          (state.sourceVelocity * (emitTime % 5.0) * 10);
      emittedX =
          ((emittedX - (centerX - range / 2)) % range) + (centerX - range / 2);

      // Pulse radius grows based on waveSpeed
      final double radius = age * (state.waveSpeed / 10);

      if (radius < size.width) {
        // Draw the pulse (expanding circle)
        // Correct Doppler effect: the circles represent wavefronts
        canvas.drawCircle(Offset(emittedX, centerY), radius, pulsePaint);
      }
    }

    // Draw Source
    canvas.drawCircle(Offset(sourceX, centerY), 15, sourcePaint);

    // Direction Indicator
    if (state.sourceVelocity.abs() > 0) {
      final arrowPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2;
      double dir = state.sourceVelocity > 0 ? 1 : -1;
      canvas.drawLine(
        Offset(sourceX, centerY),
        Offset(sourceX + (20 * dir), centerY),
        arrowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DopplerPainter oldDelegate) => true;
}
