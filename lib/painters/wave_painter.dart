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

    if (state.waveType == WaveType.transverse) {
      _paintTransverse(canvas, size, paint);
    } else {
      _paintLongitudinal(canvas, size, paint);
    }
  }

  void _paintTransverse(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final centerY = size.height / 2;

    // Scale amplitude to fit screen (A=1.0 is ~80 pixels)
    final double visualAmplitude = state.amplitude * 80;

    for (double x = 0; x <= size.width; x++) {
      // In physics, x is distance. We need to map screen pixels to meters.
      // Let's say screen width = 10 meters.
      final double physicalX = (x / size.width) * 10;

      final yDisplacement = WaveSolver.calculateDisplacement(
        amplitude: visualAmplitude,
        frequency: state.frequency,
        waveSpeed:
            state.waveSpeed / 10, // Adjusting wave speed for visual scale
        x: physicalX,
        t: state.currentTime,
      );

      if (x == 0) {
        path.moveTo(x, centerY - yDisplacement);
      } else {
        path.lineTo(x, centerY - yDisplacement);
      }
    }

    // Add glow effect
    canvas.drawPath(
      path,
      paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0),
    );
    canvas.drawPath(path, paint..maskFilter = null);
  }

  void _paintLongitudinal(Canvas canvas, Size size, Paint paint) {
    final centerY = size.height / 2;
    final numDots = (size.width / 10).round();

    for (int i = 0; i < numDots; i++) {
      final double x = i * 10.0;
      final double physicalX = (x / size.width) * 10;

      final xDisplacement = WaveSolver.calculateDisplacement(
        amplitude: state.amplitude * 40, // Bigger displacement
        frequency: state.frequency,
        waveSpeed: state.waveSpeed / 10,
        x: physicalX,
        t: state.currentTime,
      );

      canvas.drawCircle(
        Offset(
          x + xDisplacement,
          centerY +
              (Random(i).nextDouble() - 0.5) * 60, // Wider vertical spread
        ),
        3.0, // Bigger dot
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
        oldDelegate.state.waveType != state.waveType;
  }
}
