import 'package:flutter/material.dart';
import 'dart:math';
import '../physics/wave_solver.dart';
import '../providers/wave_provider.dart';

class WavePainter extends CustomPainter {
  final WaveState state;
  final Color waveColor;

  WavePainter({required this.state, this.waveColor = const Color(0xFF00E5FF)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // 1. Paint GHOST wave if enabled
    if (state.showGhost && state.ghostState != null) {
      final ghostPaint = Paint()
        ..color = waveColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      if (state.ghostState!.waveType == WaveType.transverse) {
        _paintTransverse(canvas, size, ghostPaint, state.ghostState!);
      }
    }

    // 2. Paint PRIMARY wave
    if (state.waveType == WaveType.transverse) {
      _paintTransverse(canvas, size, paint, state);
      if (state.showVectors) {
        _paintVectors(canvas, size, state);
      }
    } else {
      _paintLongitudinal(canvas, size, paint);
    }
  }

  void _paintTransverse(
    Canvas canvas,
    Size size,
    Paint paint,
    WaveState targetState,
  ) {
    final path = Path();
    final centerY = size.height / 2;

    // Scale amplitude to fit screen (A=1.0 is ~80 pixels)
    final double visualAmplitude = targetState.amplitude * 80;

    for (double x = 0; x <= size.width; x += 2) {
      // Step 2 for performance
      final double physicalX = (x / size.width) * 10;

      final yDisplacement = WaveSolver.calculateDisplacement(
        amplitude: visualAmplitude,
        frequency: targetState.frequency,
        waveSpeed: targetState.waveSpeed / 10,
        x: physicalX,
        t: targetState.currentTime,
      );

      if (x == 0) {
        path.moveTo(x, centerY - yDisplacement);
      } else {
        path.lineTo(x, centerY - yDisplacement);
      }
    }

    // Add glow effect for primary wave only
    if (paint.strokeWidth > 3) {
      final glowPaint = Paint()
        ..color = paint.color
        ..style = paint.style
        ..strokeWidth = paint.strokeWidth
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawPath(path, glowPaint);
    }
    canvas.drawPath(path, paint..maskFilter = null);
  }

  void _paintVectors(Canvas canvas, Size size, WaveState targetState) {
    final centerY = size.height / 2;
    final double visualAmplitude = targetState.amplitude * 80;

    // Draw vectors every N pixels
    const double step = 60.0;
    for (double x = 30; x < size.width; x += step) {
      final double physicalX = (x / size.width) * 10;

      final yDisplacement = WaveSolver.calculateDisplacement(
        amplitude: visualAmplitude,
        frequency: targetState.frequency,
        waveSpeed: targetState.waveSpeed / 10,
        x: physicalX,
        t: targetState.currentTime,
      );

      final velocity = WaveSolver.calculateVelocity(
        amplitude: visualAmplitude,
        frequency: targetState.frequency,
        waveSpeed: targetState.waveSpeed / 10,
        x: physicalX,
        t: targetState.currentTime,
      );

      final acceleration = WaveSolver.calculateAcceleration(
        amplitude: visualAmplitude,
        frequency: targetState.frequency,
        waveSpeed: targetState.waveSpeed / 10,
        x: physicalX,
        t: targetState.currentTime,
      );

      final origin = Offset(x, centerY - yDisplacement);

      // Velocity Vector (Green) - scaled for visibility
      _drawArrow(canvas, origin, velocity * 0.1, Colors.greenAccent, 2.0);

      // Acceleration Vector (Red) - scaled for visibility
      _drawArrow(canvas, origin, acceleration * 0.01, Colors.redAccent, 2.0);
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

  void _paintLongitudinal(Canvas canvas, Size size, Paint paint) {
    final centerY = size.height / 2;
    final numDots = (size.width / 10).round();

    for (int i = 0; i < numDots; i++) {
      final double x = i * 10.0;
      final double physicalX = (x / size.width) * 10;

      final xDisplacement = WaveSolver.calculateDisplacement(
        amplitude: state.amplitude * 40,
        frequency: state.frequency,
        waveSpeed: state.waveSpeed / 10,
        x: physicalX,
        t: state.currentTime,
      );

      canvas.drawCircle(
        Offset(
          x + xDisplacement,
          centerY + (Random(i).nextDouble() - 0.5) * 60,
        ),
        3.0,
        paint..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.state.currentTime != state.currentTime ||
        oldDelegate.state.amplitude != state.amplitude ||
        oldDelegate.state.frequency != state.frequency ||
        oldDelegate.state.waveSpeed != state.waveSpeed ||
        oldDelegate.state.waveType != state.waveType ||
        oldDelegate.state.showGhost != state.showGhost ||
        oldDelegate.state.showVectors != state.showVectors;
  }
}
