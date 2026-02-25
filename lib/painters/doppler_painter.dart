import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';

class DopplerPainter extends CustomPainter {
  final WaveState state;

  DopplerPainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint GHOST scene if enabled
    if (state.showGhost && state.ghostState != null) {
      _paintDopplerScene(canvas, size, state.ghostState!, isGhost: true);
    }

    // 2. Paint PRIMARY scene
    _paintDopplerScene(canvas, size, state, isGhost: false);
  }

  void _paintDopplerScene(
    Canvas canvas,
    Size size,
    WaveState targetState, {
    required bool isGhost,
  }) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final double range = size.width * 0.6;

    // For Ghost, use its specific currentTime
    final double timeScale = targetState.currentTime % 5.0;
    double sourceX =
        centerX - (range / 2) + (targetState.sourceVelocity * timeScale * 10);
    sourceX =
        ((sourceX - (centerX - range / 2)) % range) + (centerX - range / 2);

    final sourcePaint = Paint()
      ..color = const Color(0xFFFFEB3B).withValues(alpha: isGhost ? 0.2 : 1.0)
      ..style = PaintingStyle.fill;

    final pulsePaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: isGhost ? 0.1 : 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isGhost ? 2.0 : 4.0;

    // Pulse Emission logic
    const double pulseInterval = 0.5;
    for (double t = 0; t < 5.0; t += pulseInterval) {
      final double age = (targetState.currentTime - t) % 5.0;
      if (age < 0) continue;

      double emitTime = targetState.currentTime - age;
      double emittedX =
          centerX -
          (range / 2) +
          (targetState.sourceVelocity * (emitTime % 5.0) * 10);
      emittedX =
          ((emittedX - (centerX - range / 2)) % range) + (centerX - range / 2);

      final double radius = age * (targetState.waveSpeed / 10);
      if (radius < size.width) {
        canvas.drawCircle(Offset(emittedX, centerY), radius, pulsePaint);
      }
    }

    // Source
    canvas.drawCircle(Offset(sourceX, centerY), isGhost ? 10 : 15, sourcePaint);

    // Direction Indicator (Primary only)
    if (!isGhost && targetState.sourceVelocity.abs() > 0) {
      final arrowPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2;
      double dir = targetState.sourceVelocity > 0 ? 1 : -1;
      canvas.drawLine(
        Offset(sourceX, centerY),
        Offset(sourceX + (20 * dir), centerY),
        arrowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DopplerPainter oldDelegate) {
    return oldDelegate.state.currentTime != state.currentTime ||
        oldDelegate.state.sourceVelocity != state.sourceVelocity ||
        oldDelegate.state.waveSpeed != state.waveSpeed ||
        oldDelegate.state.showGhost != state.showGhost;
  }
}
