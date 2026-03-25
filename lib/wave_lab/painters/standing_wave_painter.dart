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
    // 1. Paint GHOST wave if enabled
    if (state.showGhost && state.ghostState != null) {
      final ghostPaint = Paint()
        ..color = waveColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      _paintStandingCurve(canvas, size, ghostPaint, state.ghostState!);
    }

    // 2. Paint PRIMARY wave
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    final glowPaint = Paint()
      ..color = waveColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    _paintStandingCurve(canvas, size, glowPaint, state);
    _paintStandingCurve(canvas, size, paint, state);

    // 3. Paint VECTORS if enabled
    if (state.showVectors) {
      _paintVectors(canvas, size, state);
    }

    // Draw nodes markers for PRIMARY wave
    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    const double xPadding = 40.0;
    final double simulationWidth = size.width - (2 * xPadding);
    final wavelength = (2 * simulationWidth) / state.harmonic;
    final centerY = size.height / 2;

    for (int i = 0; i <= state.harmonic; i++) {
      final nodeX = xPadding + (i * wavelength / 2);
      canvas.drawCircle(Offset(nodeX, centerY), 4, nodePaint);
    }
  }

  void _paintVectors(Canvas canvas, Size size, WaveState targetState) {
    final centerY = size.height / 2;
    const double xPadding = 40.0;
    final double simulationWidth = size.width - (2 * xPadding);

    // Draw vectors every N pixels along the simulation width
    const double step = 60.0;
    for (double x = 30; x < simulationWidth; x += step) {
      final displacement = WaveSolver.calculateStandingWaveDisplacement(
        amplitude: targetState.amplitude * 70,
        frequency: targetState.frequency,
        length: simulationWidth,
        harmonic: targetState.harmonic,
        x: x,
        t: targetState.currentTime,
      );

      final velocity = WaveSolver.calculateStandingWaveVelocity(
        amplitude: targetState.amplitude * 70,
        frequency: targetState.frequency,
        length: simulationWidth,
        harmonic: targetState.harmonic,
        x: x,
        t: targetState.currentTime,
      );

      final acceleration = WaveSolver.calculateStandingWaveAcceleration(
        amplitude: targetState.amplitude * 70,
        frequency: targetState.frequency,
        length: simulationWidth,
        harmonic: targetState.harmonic,
        x: x,
        t: targetState.currentTime,
      );

      final origin = Offset(x + xPadding, centerY + displacement);

      // Velocity Vector (Green) - scaled for visibility
      _drawArrow(canvas, origin, -velocity * 0.1, Colors.greenAccent, 2.0);

      // Acceleration Vector (Red) - scaled for visibility
      _drawArrow(canvas, origin, -acceleration * 0.01, Colors.redAccent, 2.0);
    }
  }

  void _drawArrow(
    Canvas canvas,
    Offset origin,
    double lengthDisplacement,
    Color color,
    double width,
  ) {
    if (lengthDisplacement.abs() < 2) return; // Don't draw tiny arrows

    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = width;

    final end = Offset(origin.dx, origin.dy - lengthDisplacement);
    canvas.drawLine(origin, end, arrowPaint);

    // Arrow head
    final double headSize = 5.0;
    final double dir = lengthDisplacement > 0 ? 1 : -1;

    canvas.drawLine(
      end,
      Offset(end.dx - headSize, end.dy + dir * headSize),
      arrowPaint,
    );
    canvas.drawLine(
      end,
      Offset(end.dx + headSize, end.dy + dir * headSize),
      arrowPaint,
    );
  }

  void _paintStandingCurve(
    Canvas canvas,
    Size size,
    Paint paint,
    WaveState targetState,
  ) {
    final path = Path();
    final centerY = size.height / 2;
    const double xPadding = 40.0;
    final double simulationWidth = size.width - (2 * xPadding);

    for (double x = 0; x <= simulationWidth; x += 2) {
      final displacement = WaveSolver.calculateStandingWaveDisplacement(
        amplitude: targetState.amplitude * 70,
        frequency: targetState.frequency,
        length: simulationWidth,
        harmonic: targetState.harmonic,
        x: x,
        t: targetState.currentTime,
      );

      final screenX = x + xPadding;
      final screenY = centerY + displacement;

      if (x == 0) {
        path.moveTo(screenX, screenY);
      } else {
        path.lineTo(screenX, screenY);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StandingWavePainter oldDelegate) {
    return oldDelegate.state.currentTime != state.currentTime ||
        oldDelegate.state.harmonic != state.harmonic ||
        oldDelegate.state.amplitude != state.amplitude ||
        oldDelegate.state.showGhost != state.showGhost ||
        oldDelegate.state.showVectors != state.showVectors;
  }
}
