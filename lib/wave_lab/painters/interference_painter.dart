import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class InterferencePainter extends CustomPainter {
  final WaveState state;

  InterferencePainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint GHOST waves if enabled
    if (state.showGhost && state.ghostState != null) {
      _paintInterference(canvas, size, state.ghostState!, isGhost: true);
    }

    // 2. Paint PRIMARY waves
    _paintInterference(canvas, size, state, isGhost: false);
  }

  void _paintInterference(
    Canvas canvas,
    Size size,
    WaveState targetState, {
    required bool isGhost,
  }) {
    final centerY = size.height / 2;
    final alpha = isGhost ? 0.1 : 0.4;
    final resAlpha = isGhost ? 0.2 : 1.0;

    final paint1 = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isGhost ? 1.5 : 3.0;

    final paint2 = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isGhost ? 1.5 : 3.0;

    final resultantPaint = Paint()
      ..color = Colors.white.withValues(alpha: resAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isGhost ? 2.5 : 5.0;

    if (!isGhost) {
      final resGlowPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      final glowPath = Path();
      for (double x = 0; x <= size.width; x += 4) {
        final d1 = WaveSolver.calculateDisplacement(
          amplitude: targetState.amplitude * 50,
          frequency: targetState.frequency,
          waveSpeed: targetState.waveSpeed,
          x: x / 20,
          t: targetState.currentTime,
        );
        final d2 = WaveSolver.calculateDisplacement(
          amplitude: targetState.secondaryAmplitude * 50,
          frequency: targetState.secondaryFrequency,
          waveSpeed: targetState.waveSpeed,
          x: x / 20,
          t: targetState.currentTime,
          phi: targetState.phaseDifference,
        );
        if (x == 0) {
          glowPath.moveTo(x, centerY + d1 + d2);
        } else {
          glowPath.lineTo(x, centerY + d1 + d2);
        }
      }
      canvas.drawPath(glowPath, resGlowPaint);
    }

    final path1 = Path();
    final path2 = Path();
    final resultantPath = Path();

    for (double x = 0; x <= size.width; x += 2) {
      final d1 = WaveSolver.calculateDisplacement(
        amplitude: targetState.amplitude * 50,
        frequency: targetState.frequency,
        waveSpeed: targetState.waveSpeed,
        x: x / 20,
        t: targetState.currentTime,
      );

      final d2 = WaveSolver.calculateDisplacement(
        amplitude: targetState.secondaryAmplitude * 50,
        frequency: targetState.secondaryFrequency,
        waveSpeed: targetState.waveSpeed,
        x: x / 20,
        t: targetState.currentTime,
        phi: targetState.phaseDifference,
      );

      if (x == 0) {
        path1.moveTo(x, centerY + d1);
        path2.moveTo(x, centerY + d2);
        resultantPath.moveTo(x, centerY + d1 + d2);
      } else {
        path1.lineTo(x, centerY + d1);
        path2.lineTo(x, centerY + d2);
        resultantPath.lineTo(x, centerY + d1 + d2);
      }
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(resultantPath, resultantPaint);
  }

  @override
  bool shouldRepaint(covariant InterferencePainter oldDelegate) {
    return oldDelegate.state.currentTime != state.currentTime ||
        oldDelegate.state.amplitude != state.amplitude ||
        oldDelegate.state.secondaryAmplitude != state.secondaryAmplitude ||
        oldDelegate.state.frequency != state.frequency ||
        oldDelegate.state.secondaryFrequency != state.secondaryFrequency ||
        oldDelegate.state.phaseDifference != state.phaseDifference ||
        oldDelegate.state.showGhost != state.showGhost;
  }
}
